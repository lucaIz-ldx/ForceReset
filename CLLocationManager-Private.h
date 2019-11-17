//
//  CLLocationManager-Private.h
//  PermissionManager
//
//  Created by User on 11/9/19.
//  Copyright © 2019 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager ()
+ (void)setAuthorizationStatusByType:(CLAuthorizationStatus)arg2 forBundleIdentifier:(NSString *)arg3;
+ (CLAuthorizationStatus)_authorizationStatusForBundleIdentifier:(NSString *)arg2 bundle:(NSBundle *)arg3;
- (void)resetApps; // reset all applications.
@end
