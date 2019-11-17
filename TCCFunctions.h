//
//  PrivateFunctionInit.h
//  PermissionManager
//
//  Created by User on 11/7/19.
//  Copyright © 2019 User. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// all functions with "Bundle" suffix (not "BundleId") only work when the app is not restricted in sandbox; use "BundleId" functions in sandboxed apps if possible.

FOUNDATION_EXTERN NSString *const kTCCServiceAll;
FOUNDATION_EXTERN NSString *const kTCCServicePhotos;
FOUNDATION_EXTERN NSString *const kTCCServiceCamera;
FOUNDATION_EXTERN NSString *const kTCCServiceBluetoothPeripheral;

// TODO: more symbols in TCC framework

// request permission for current app
FOUNDATION_EXTERN void TCCAccessRequest(NSString *service, NSDictionary * _Nullable options, void (^callback) (BOOL granted));
// get status of service for current app
FOUNDATION_EXTERN int TCCAccessPreflight(NSString *service, NSDictionary * _Nullable options);

FOUNDATION_EXTERN int TCCAccessReset(NSString *service);    // reset permission for all applications
FOUNDATION_EXTERN int TCCAccessResetForPath(NSString *service, NSString *path);
FOUNDATION_EXTERN int TCCAccessResetForBundle(NSString *service, CFBundleRef bundle);
FOUNDATION_EXTERN int TCCAccessResetForBundleId(NSString *service, NSString *bundleIdentifier) NS_AVAILABLE_IOS(12.0);

FOUNDATION_EXTERN NSString *const kTCCInfoGranted;
FOUNDATION_EXTERN NSString *const kTCCInfoService;

FOUNDATION_EXTERN NSArray<NSDictionary *> *TCCAccessCopyInformation(NSString *service);
FOUNDATION_EXTERN NSArray<NSDictionary *> *TCCAccessCopyInformationForBundle(CFBundleRef bundle);

FOUNDATION_EXTERN int TCCAccessSetForBundle(NSString *service, CFBundleRef bundle, BOOL granted);
FOUNDATION_EXTERN int TCCAccessSetForBundleId(NSString *service, NSString *bundleId, BOOL granted) NS_AVAILABLE_IOS(11.0);

NS_ASSUME_NONNULL_END
