
#import <substrate.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <notify.h>

#import "TCCFunctions.h"
#import "LSApplication/LSApplication.h"
#import "FRObserver.h"
#import "CLLocationManager-Private.h"

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *bundleIdentifierToLaunch;
@property (nonatomic, copy) NSString *type;
@end

@class SBUIAppIconForceTouchShortcutViewController;
@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
@property (nonatomic,readonly) NSString * applicationBundleIdentifier;
@end

#ifdef DEBUG
#define FR_Log(a...) NSLog(a)
#else
#define FR_Log(a...)
#endif

static inline LSApplicationProxy *getProxyFromIdentifier(NSString *bundleId) {
    LSApplicationProxy *proxy = FRObserver.sharedInstance.proxyCache[bundleId];
    if (!proxy) {
        proxy = [objc_getClass("LSApplicationProxy") applicationProxyForIdentifier:bundleId];
        // this should not fail but just in case.
        if (proxy) {
            FRObserver.sharedInstance.proxyCache[bundleId] = proxy;
            FR_Log(@"proxy cache miss");
        }
    }
    else {
        FR_Log(@"proxy cache hit");
    }
    return proxy;
}

static CF_RETURNS_RETAINED CFBundleRef CFBundleCreateFromIdentifier(NSString *bundleId) {
    LSApplicationProxy *proxy = getProxyFromIdentifier(bundleId);
    CFBundleRef bundle = NULL;
    if (proxy.bundleURL) {
        FR_Log(@"URL: %@", proxy.bundleURL);
        bundle = CFBundleCreate(kCFAllocatorDefault, (CFURLRef)proxy.bundleURL);
    }
    return bundle;
}

static NSString *const tweakIdentifier = @"com.debian.luca.tweak.forcereset.reset";
static int notificationToken;

%hook SBUIAppIconForceTouchController
- (void)appIconForceTouchShortcutViewController:(SBUIAppIconForceTouchShortcutViewController *)shortcutViewController activateApplicationShortcutItem:(SBSApplicationShortcutItem *)shortcutItem
{
    FR_Log(@"appIconForceTouchShortcutViewController:activateApplicationShortcutItem:, arg2: %@", shortcutItem);
    if ([shortcutItem.type isEqualToString:tweakIdentifier] && shortcutItem.bundleIdentifierToLaunch) {
        CFBundleRef bundle = CFBundleCreateFromIdentifier(shortcutItem.bundleIdentifierToLaunch);
        if (bundle) {
            if (!TCCAccessResetForBundle(kTCCServiceAll, bundle)) {
                FR_Log(@"Failed to reset permission for %@.", shortcutItem.bundleIdentifierToLaunch);
            }
            int check = 0;
            notify_check(notificationToken, &check);
            [FRObserver.sharedInstance.permissionCache removeObjectForKey:shortcutItem.bundleIdentifierToLaunch];
            [CLLocationManager setAuthorizationStatusByType:kCLAuthorizationStatusNotDetermined forBundleIdentifier:shortcutItem.bundleIdentifierToLaunch];
            if ([CLLocationManager _authorizationStatusForBundleIdentifier:shortcutItem.bundleIdentifierToLaunch bundle:nil] != kCLAuthorizationStatusNotDetermined) {
                FR_Log(@"Failed to reset location permission for %@.", shortcutItem.bundleIdentifierToLaunch);
            }
            CFRelease(bundle);
            // an intentional sleep to wait tccd to kill the app otherwise it looks like a crash.
            [NSThread sleepForTimeInterval:0.1];
        }
        else {
            FR_Log(@"Cannot create bundle for %@.", shortcutItem.bundleIdentifierToLaunch);
        }
    }
    else {
        FR_Log(@"Not reset permission type or bundleId is nil.");
    }
    %orig;
}
%end

%hook SBUIAppIconForceTouchControllerDataProvider
- (NSArray *)applicationShortcutItems {
    NSArray<SBSApplicationShortcutItem *> *originalShortcutItems = %orig;

    FR_Log(@"originalShortcutItems: %@", originalShortcutItems);
    NSString *bundleId = self.applicationBundleIdentifier;
    if (!bundleId) {
        FR_Log(@"cannot find applicationBundleId!! ");
        return originalShortcutItems;
    }
    FR_Log(@"BundleId: %@", bundleId);

    // comment out this part if you want to reset permission for system apps (not recommended).
    LSApplicationProxy *proxy = getProxyFromIdentifier(bundleId);
    if ([proxy.bundleType isEqualToString:@"System"]) {
        FR_Log(@"Do not reset permission for system apps.");
        return originalShortcutItems;
    }

    NSSet<NSString *> *permissionList = FRObserver.sharedInstance.permissionCache[bundleId];

    int check = 0;
    if (notify_check(notificationToken, &check) != NOTIFY_STATUS_OK) {
        check = 1;  // if notification fails for some reasons, then assume the status is changed.
        FR_Log(@"Get notification failed. Assume true.");
    }
    if (check) {
        // invalidate all caches if tcc status is changed.
        FR_Log(@"Invalidated caches.");
        permissionList = nil;
        [FRObserver.sharedInstance.permissionCache removeAllObjects];
    }

    if (!permissionList) {
        CFBundleRef bundle = CFBundleCreateFromIdentifier(bundleId);
        if (bundle) {
            NSArray *array = TCCAccessCopyInformationForBundle(bundle);
            if ([array isKindOfClass:[NSArray class]]) {
                NSMutableSet *mutableSet = [NSMutableSet setWithCapacity:array.count];
                for (NSDictionary *dict in array) {
                    if (![dict[kTCCInfoService] isKindOfClass:[NSString class]]) {
                        continue;
                    }
                    [mutableSet addObject:dict[kTCCInfoService]];
                }
                permissionList = mutableSet;
                FRObserver.sharedInstance.permissionCache[bundleId] = mutableSet;
            }
            else {
                FR_Log(@"Failed to retrieve TCC information for %@", bundleId);
            }
            CFRelease(bundle);
        }
        else {
            FR_Log(@"Cannot create bundle for %@.", bundle);
        }
    }
    else {
        FR_Log(@"Use list from caches.");
    }
    CLAuthorizationStatus status = [CLLocationManager _authorizationStatusForBundleIdentifier:bundleId bundle:nil];
    if (permissionList.count == 0 && (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted)) {
        FR_Log(@"No permissions requested! Do not show reset permission");
        return originalShortcutItems;
    }
    FR_Log(@"Requested: %@; locationStatus: %d.", permissionList, status);

    SBSApplicationShortcutItem *shortcutItem = [[objc_getClass("SBSApplicationShortcutItem") alloc] init];
    shortcutItem.type = tweakIdentifier;
    shortcutItem.localizedTitle = @"Reset permission";
    shortcutItem.bundleIdentifierToLaunch = bundleId;

    NSMutableArray *newShortcutItems = originalShortcutItems ? [originalShortcutItems mutableCopy] : [NSMutableArray arrayWithCapacity:1];
    [newShortcutItems addObject:shortcutItem];
    FR_Log(@"New shortcutItems: %@", newShortcutItems);
    return newShortcutItems;
}

%end

%ctor {
#ifdef DEBUG
    NSString *displayName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!displayName) {
        displayName = [NSBundle.mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
    }

    FR_Log(@"FR is injecting into %@.", displayName);
#endif
    int ret = (int)notify_register_check("com.apple.tcc.access.changed", &notificationToken);
    if (ret != NOTIFY_STATUS_OK) {
        FR_Log(@"Failed to register tcc notification. Ret: %d", ret);
    }
    // ignore first condition
    notify_check(notificationToken, &ret);
}
%dtor {
    notify_cancel(notificationToken);
}
