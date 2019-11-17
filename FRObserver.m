//
//  FRObserver.m
//  ForceReset
//
//  Created by User on 11/12/19.
//  Copyright © 2019 User. All rights reserved.
//

#import "FRObserver.h"
@import UIKit;

@interface FRObserver ()
@property (readwrite, strong, nonatomic) NSCache<NSString *, NSSet<NSString *> *> *permissionCache;
@property (readwrite, strong, nonatomic) NSCache<NSString *, LSApplicationProxy *> *proxyCache;

@end

@implementation FRObserver
+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    static FRObserver *observer;
    dispatch_once(&onceToken, ^{
        observer = [[FRObserver alloc] init];
    });
    return observer;
}
- (instancetype) init {
    self = [super init];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
- (void) clearCache {
    _proxyCache = nil;
    _permissionCache = nil;
}
- (NSCache<NSString *, NSSet<NSString *> *> *) permissionCache {
    if (!_permissionCache) {
        _permissionCache = [[NSCache alloc] init];
        _proxyCache.countLimit = 4;
    }
    return _permissionCache;
}
- (NSCache<NSString *, LSApplicationProxy *> *) proxyCache {
    if (!_proxyCache) {
        _proxyCache = [[NSCache alloc] init];
        _proxyCache.countLimit = 4;
    }
    return _proxyCache;
}
- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
@end

@implementation NSCache (subscript)

- (void) setObject:(id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}
- (id) objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}
@end
