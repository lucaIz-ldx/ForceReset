
#import <Foundation/Foundation.h>
@class _LSLazyPropertyList,_LSBundleIDValidationToken,LSBundleProxy;

@interface _LSQueryResult : NSObject<NSSecureCoding,NSCopying>
+ (bool)supportsSecureCoding;
- (id)_init;
- (id)init;
- (void)encodeWithCoder:(id)v1;
- (id)initWithCoder:(id)v1;
- (id)copyWithZone:(struct _NSZone *)v1;
@end

@interface LSResourceProxy : _LSQueryResult<NSCopying,NSSecureCoding> {
    bool _boundIconIsBadge;
    bool __privateDocumentIconAllowOverride;
    bool __boundIconIsPrerendered;
    NSString * _localizedName;
    NSString * __boundApplicationIdentifier;
    NSURL * __boundContainerURL;
    NSURL * __boundDataContainerURL;
    NSURL * __boundResourcesDirectoryURL;
    _LSLazyPropertyList * __boundIconsDictionary;
    NSString * __boundIconCacheKey;
    NSArray * __boundIconFileNames;
    LSBundleProxy * __typeIconOwner;
    NSArray * __privateDocumentIconNames;
    LSBundleProxy * __privateDocumentTypeIconOwner;
}
@property (copy,nonatomic,setter=_setLocalizedName:) NSString * localizedName;
@property (nonatomic,setter=_setBoundIconIsBadge:) bool boundIconIsBadge;
@property (copy,nonatomic,setter=_setBoundApplicationIdentifier:) NSString * _boundApplicationIdentifier;
@property (copy,nonatomic,setter=_setBoundContainerURL:) NSURL * _boundContainerURL;
@property (copy,nonatomic,setter=_setBoundDataContainerURL:) NSURL * _boundDataContainerURL;
@property (copy,nonatomic,setter=_setBoundResourcesDirectoryURL:) NSURL * _boundResourcesDirectoryURL;
@property (copy,nonatomic,setter=_setBoundIconsDictionary:) _LSLazyPropertyList * _boundIconsDictionary;
@property (copy,nonatomic,setter=_setBoundIconCacheKey:) NSString * _boundIconCacheKey;
@property (copy,nonatomic,setter=_setBoundIconFileNames:) NSArray * _boundIconFileNames;
@property (copy,nonatomic,setter=_setTypeIconOwner:) LSBundleProxy * _typeIconOwner;
@property (copy,nonatomic,setter=_setPrivateDocumentIconNames:) NSArray * _privateDocumentIconNames;
@property (copy,nonatomic,setter=_setPrivateDocumentTypeIconOwner:) LSBundleProxy * _privateDocumentTypeIconOwner;
@property (nonatomic,setter=_setPrivateDocumentIconAllowOverride:) bool _privateDocumentIconAllowOverride;
@property (nonatomic,setter=_setBoundIconIsPrerendered:) bool _boundIconIsPrerendered;
@property (readonly,nonatomic) NSDictionary * iconsDictionary;
@property (readonly,nonatomic) NSString * primaryIconName;
@property (nonatomic) unsigned long long propertyListCachingStrategy;
+ (bool)supportsSecureCoding;
- (id)_initWithLocalizedName:(id)v1 boundApplicationIdentifier:(id)v2 boundContainerURL:(id)v3 dataContainerURL:(id)v4 boundResourcesDirectoryURL:(id)v5 boundIconsDictionary:(id)v6 boundIconCacheKey:(id)v7 boundIconFileNames:(id)v8 typeIconOwner:(id)v9 boundIconIsPrerendered:(bool)v10 boundIconIsBadge:(bool)v11;
- (id)_initWithLocalizedName:(id)v1;
- (void)dealloc;
- (id)initWithCoder:(id)v1;
- (void)encodeWithCoder:(id)v1;
- (id)copyWithZone:(struct _NSZone *)v1;
- (id)uniqueIdentifier;
- (id)iconDataForStyle:(id)v1 width:(long long)v2 height:(long long)v3 options:(unsigned long long)v4;
- (id)iconDataForVariant:(int)v1;
- (id)_privateDocumentIconNamesAsCacheKey;
- (id)iconDataForVariant:(int)v1 withOptions:(int)v2;
@end
