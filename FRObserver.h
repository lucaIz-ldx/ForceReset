//
//  FRObserver.m
//  ForceReset
//
//  Created by User on 11/12/19.
//  Copyright © 2019 User. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LSApplicationProxy;

@interface FRObserver : NSObject
@property (class, readonly, nonatomic) FRObserver *sharedInstance;
// bundleId - set of service names
@property (readonly, strong, nonatomic) NSCache<NSString *, NSSet<NSString *> *> *permissionCache;
// bundleId - proxy
@property (readonly, strong, nonatomic) NSCache<NSString *, LSApplicationProxy *> *proxyCache;
@end

@interface NSCache (subscript)
- (void) setObject:(id) object forKeyedSubscript:(id) key;
- (id) objectForKeyedSubscript:(id)key;
@end
NS_ASSUME_NONNULL_END
