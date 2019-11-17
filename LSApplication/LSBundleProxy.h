#import "LSResourceProxy.h"
struct LSContext;
@interface LSBundleProxy : LSResourceProxy<NSSecureCoding> {
    NSString * _localizedShortName;
    unsigned long long _bundleFlags;
    unsigned int _plistContentFlags;
    unsigned char _iconFlags;
    bool _foundBackingBundle;
    bool _containerized;
    bool _profileValidated;
    bool _UPPValidated;
    NSString * _bundleType;
    NSURL * _bundleURL;
    NSString * _bundleExecutable;
    NSString * _bundleVersion;
    NSString * _sdkVersion;
    NSString * _signerIdentity;
    NSString * _signerOrganization;
    NSUUID * _cacheGUID;
    unsigned long long _sequenceNumber;
    NSArray * _machOUUIDs;
    unsigned long long _compatibilityState;
    _LSLazyPropertyList * __infoDictionary;
    _LSLazyPropertyList * __groupContainers;
    _LSLazyPropertyList * __entitlements;
    _LSLazyPropertyList * __environmentVariables;
    _LSBundleIDValidationToken * __validationToken;
}
@property (readonly,nonatomic) NSString * localizedShortName;
@property (copy,nonatomic,setter=_setInfoDictionary:) _LSLazyPropertyList * _infoDictionary;
@property (copy,nonatomic) NSArray * machOUUIDs;
@property (copy,nonatomic,setter=setSDKVersion:) NSString * sdkVersion;
@property (copy,nonatomic,setter=_setGroupContainers:) _LSLazyPropertyList * _groupContainers;
@property (copy,nonatomic,setter=_setEntitlements:) _LSLazyPropertyList * _entitlements;
@property (copy,nonatomic,setter=_setEnvironmentVariables:) _LSLazyPropertyList * _environmentVariables;
@property (retain,nonatomic,setter=_setValidationToken:) _LSBundleIDValidationToken * _validationToken;
@property (readonly,nonatomic) NSString * bundleIdentifier;
@property (readonly,nonatomic) NSString * bundleType;
@property (readonly,nonatomic) NSURL * bundleURL;
@property (readonly,nonatomic) NSString * bundleExecutable;
@property (readonly,nonatomic) NSString * canonicalExecutablePath;
@property (readonly,nonatomic) NSURL * containerURL;
@property (readonly,nonatomic) NSURL * dataContainerURL;
@property (readonly,nonatomic) NSURL * bundleContainerURL;
@property (readonly,nonatomic) NSURL * appStoreReceiptURL;
@property (readonly,nonatomic) NSString * bundleVersion;
@property (readonly,nonatomic) NSString * signerIdentity;
@property (readonly,nonatomic) NSDictionary * entitlements;
@property (readonly,nonatomic) NSDictionary * environmentVariables;
@property (readonly,nonatomic) NSDictionary * groupContainerURLs;
@property (readonly,nonatomic) bool foundBackingBundle;
@property (readonly,nonatomic,getter=isContainerized) bool containerized;
@property (readonly,nonatomic) bool profileValidated;
@property (readonly,nonatomic) bool UPPValidated;
@property (readonly,nonatomic) NSString * signerOrganization;
@property (readonly,nonatomic) NSUUID * cacheGUID;
@property (readonly,nonatomic) unsigned long long sequenceNumber;
@property (nonatomic,setter=_setCompatibilityState:) unsigned long long compatibilityState;
+ (id)bundleProxyForIdentifier:(id)v1;
+ (id)bundleProxyForURL:(id)v1;
+ (bool)bundleProxyForCurrentProcessNeedsUpdate:(id)v1;
+ (id)bundleProxyForCurrentProcess;
+ (bool)canInstantiateFromDatabase;
+ (bool)supportsSecureCoding;
- (id)localizedNameWithPreferredLocalizations:(id)v1 useShortNameOnly:(bool)v2;
- (id)localizedName;
- (id)_initWithBundleUnit:(unsigned int)v1 context:(struct LSContext *)v2 bundleType:(unsigned long long)v3 bundleID:(id)v4 localizedName:(id)v5 bundleContainerURL:(id)v6 dataContainerURL:(id)v7 resourcesDirectoryURL:(id)v8 iconsDictionary:(id)v9 iconFileNames:(id)v10 version:(id)v11;
- (void)dealloc;
- (id)initWithCoder:(id)v1;
- (void)encodeWithCoder:(id)v1;
- (id)uniqueIdentifier;
- (unsigned long long)_containerClassForLSBundleType:(id)v1;
- (id)_dataContainerURLFromContainerManager;
- (id)appStoreReceiptName;
- (id)_environmentVariablesFromContainerManager;
- (id)entitlementValuesForKeys:(id)v1;
- (id)entitlementValueForKey:(id)v1 ofClass:(Class)v2;
- (id)entitlementValueForKey:(id)v1 ofClass:(Class)v2 valuesOfClass:(Class)v3;
- (id)_groupContainerURLsFromContainerManager;
- (id)objectsForInfoDictionaryKeys:(id)v1;
- (id)objectForInfoDictionaryKey:(id)v1 ofClass:(Class)v2;
- (id)objectForInfoDictionaryKey:(id)v1 ofClass:(Class)v2 valuesOfClass:(Class)v3;
- (id)localizedValuesForKeys:(id)v1 fromTable:(id)v2;
- (id)_valueForEqualityTesting;
- (bool)isEqual:(id)v1;
- (unsigned long long)hash;
@end
