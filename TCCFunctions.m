//
//  PrivateFunctionInit.m
//  PermissionManager
//
//  Created by User on 11/7/19.
//  Copyright © 2019 User. All rights reserved.
//

#import "TCCFunctions.h"
#import <dlfcn.h>

NSString *const kTCCServiceAll = @"kTCCServiceAll";
NSString *const kTCCServicePhotos = @"kTCCServicePhotos";
NSString *const kTCCServiceCamera = @"kTCCServiceCamera";
NSString *const kTCCServiceBluetoothPeripheral = @"kTCCServiceBluetoothPeripheral";

static void (*TCCAccessRequest_Ptr) (NSString *, NSDictionary *, void (^) (BOOL));
static int (*TCCAccessPreflight_Ptr) (NSString *, NSDictionary *);

// reset
static int (*TCCAccessReset_Ptr) (NSString *);
static int (*TCCAccessResetForPath_Ptr) (NSString *, NSString *);
static int (*TCCAccessResetForBundle_Ptr) (NSString *, CFBundleRef);
static int (*TCCAccessResetForBundleId_Ptr) (NSString *, NSString *);

// get info
NSString *const kTCCInfoGranted = @"kTCCInfoGranted";
NSString *const kTCCInfoService = @"kTCCInfoService";

static CFArrayRef (*TCCAccessCopyInformation_Ptr) (NSString *);
static CFArrayRef (*TCCAccessCopyInformationForBundle_Ptr)(CFBundleRef);

// set
static int (*TCCAccessSetForBundle_Ptr) (NSString *, CFBundleRef, BOOL);
static int (*TCCAccessSetForBundleId_Ptr) (NSString *, NSString *, BOOL);

__attribute__((constructor))
static void initializeFunctions() {
#if TARGET_IPHONE_SIMULATOR
    void *handler = dlopen("/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/TCC.framework/TCC", RTLD_LAZY);
//    void *handler = dlopen("/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/TCC.framework/TCC", RTLD_LAZY);

    // use this line if you are running on old simulator
//    void *handler = dlopen("/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 10.0.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/TCC.framework/TCC", RTLD_LAZY);
    if (!handler) {
        [NSException raise:NSInternalInconsistencyException format:@"Handler is null. Failed to open TCC framework. Make sure the above path for TCC framework is correct."];
    }
#else
    void *handler = dlopen("/System/Library/PrivateFrameworks/TCC.framework/TCC", RTLD_LAZY);
#endif

    TCCAccessRequest_Ptr = dlsym(handler, "TCCAccessRequest");
    TCCAccessPreflight_Ptr = dlsym(handler, "TCCAccessPreflight");

    TCCAccessReset_Ptr = dlsym(handler, "TCCAccessReset");
    TCCAccessResetForPath_Ptr = dlsym(handler, "TCCAccessResetForPath");
    TCCAccessResetForBundle_Ptr = dlsym(handler, "TCCAccessResetForBundle");
    TCCAccessResetForBundleId_Ptr = dlsym(handler, "TCCAccessResetForBundleId");

    TCCAccessCopyInformation_Ptr = dlsym(handler, "TCCAccessCopyInformation");
    TCCAccessCopyInformationForBundle_Ptr = dlsym(handler, "TCCAccessCopyInformationForBundle");

    TCCAccessSetForBundle_Ptr = dlsym(handler, "TCCAccessSetForBundle");
    TCCAccessSetForBundleId_Ptr = dlsym(handler, "TCCAccessSetForBundleId");
//    TCCAccessSetForBundleIdWithOptions = dlsym(handler, "TCCAccessSetForBundleIdWithOptions");

    dlclose(handler);

}

void TCCAccessRequest(NSString *service, NSDictionary *options, void (^callback) (BOOL granted)) {
    TCCAccessRequest_Ptr(service, options, callback);
}
int TCCAccessPreflight(NSString *service, NSDictionary *options) {
    return TCCAccessPreflight_Ptr(service, options);
}
int TCCAccessReset(NSString *service) {
    return TCCAccessReset_Ptr(service);
}
int TCCAccessResetForPath(NSString *service, NSString *path) {
    return TCCAccessResetForPath_Ptr(service, path);
}
int TCCAccessResetForBundle(NSString *service, CFBundleRef bundle) {
    return TCCAccessResetForBundle_Ptr(service, bundle);
}
int TCCAccessResetForBundleId(NSString *service, NSString *bundleIdentifier) {
    return TCCAccessResetForBundleId_Ptr(service, bundleIdentifier);
}

NSArray<NSDictionary *> *TCCAccessCopyInformation(NSString *service) {
    CFArrayRef array = TCCAccessCopyInformation_Ptr(service);
    NSArray *objcArray = (__bridge_transfer NSArray *)array;
    return [objcArray copy];
}

NSArray<NSDictionary *> *TCCAccessCopyInformationForBundle(CFBundleRef bundle) {
    CFArrayRef array = TCCAccessCopyInformationForBundle_Ptr(bundle);
    NSArray *objcArray = (__bridge_transfer NSArray *)array;
    return [objcArray copy];
}

int TCCAccessSetForBundle(NSString *service, CFBundleRef bundle, BOOL granted)
{
    return TCCAccessSetForBundle_Ptr(service, bundle, granted);
}
int TCCAccessSetForBundleId(NSString *service, NSString *bundleId, BOOL granted)
{
    return TCCAccessSetForBundleId_Ptr(service, bundleId, granted);
}
