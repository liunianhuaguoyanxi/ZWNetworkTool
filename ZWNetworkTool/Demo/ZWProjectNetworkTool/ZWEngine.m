//
//  ZWEngine.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWEngine.h"
#import <AVFoundation/AVFoundation.h>

#define ZW_Cache_VersionNumber @"1000"

#define ZW_Cache @"ZW_Cache_Dic"

#define ZW_Cache_Version @"ZW_Cache_Version"


#define ZW_Value @"ZW_Login_Value"
#define ZW_APID @"ZW_Login_APIDomain"

#define ZW_PID @"ZW_Login_ProviderID"
#define ZW_PNAME @"ZW_Login_ProviderName"
#define ZW_PPhone @"ZW_Login_ProviderPhone"
#define ZW_PCName @"ZW_Login_ProviderContactName"
#define ZW_PCPhone @"ZW_Login_ProviderContactPhone"

#define ZW_EID @"ZW_Login_EngineerID"
#define ZW_UID @"ZW_Login_UserID"
#define ZW_ExpireDate @"ZW_Login_ExpirationDate"
#define ZW_QiniuToken @"ZW_Login_QiniuToken"
#define ZW_ShareLocation @"ZW_ShareLocation"
#define ZW_SessionCount @"ZW_SessionCount"
#define ZW_PhotoQuality @"ZW_PhotoQuality"
#define ZW_VideoRecordingQuality @"ZW_VideoRecordingQuality"

#define ZW_MessageNotification @"ZW_MessageNotification"
#define ZW_EmailNotification @"ZW_EmailNotification"
@implementation ZWEngine

+ (ZWEngine*)engine {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.loginKey = @"_token";
        self.httpPrefixName = @"https://";
        [self readFromFile];
    }
    return self;
}

- (BOOL)isSignedIn {
    return ([self.loginValue isKindOfClass:[NSString class]] && self.loginValue.length > 0);
}

- (BOOL)isNotExpired {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] + 3600;
    return _expirationInterval > timeInterval;
}

- (void)signout {
    self.loginValue = nil;
    self.apiDomain = nil;
    self.providerID = nil;
    self.providerName = nil;
    self.engineerID = nil;
    self.userID = nil;
    self.expirationInterval = 0;
    self.qiniuToken = nil;

    self.rootDomain = nil;
    self.eweiVeHost = nil;


    [self deleteFromFile];
    
    //还原设置中默认配置
    [self defaultSettingConfig];
}

- (void)readFromFile {

    
//    NSDictionary * info = [[ZWFileCache sharedCache] getDictionaryForKey:ZW_Cache];
//
//    if ([info isKindOfClass:[NSDictionary class]]) {
//        NSString * cacheVersion = [info getStringValueForKey:ZW_Cache_Version defaultValue:nil];
//        if ([cacheVersion integerValue] < [ZW_Cache_VersionNumber integerValue]) {
//            return;
//        }
//
//        self.loginValue = [info objectForKey:ZW_Value];
//        self.apiDomain = [info objectForKey:ZW_APID];
//        self.providerID = [info objectForKey:ZW_PID];
//        self.providerName = [info objectForKey:ZW_PNAME];
//        self.providerPhone = [info objectForKey:ZW_PPhone];
//        self.providerContact = [info objectForKey:ZW_PCName];
//        self.providerContactPhone = [info objectForKey:ZW_PCPhone];
//        self.engineerID = [info objectForKey:ZW_EID];
//        self.userID = [info objectForKey:ZW_UID];
//        self.expirationInterval = [info getDoubleValueForKey:ZW_ExpireDate defaultValue:0];
//        self.qiniuToken = [info getStringValueForKey:ZW_QiniuToken defaultValue:nil];
//        self.shouldShareLocation = [info getBOOLValueForKey:ZW_ShareLocation defaultValue:NO];
//        self.sessionCount = [info getIntegerValueForKey:ZW_SessionCount defaultValue:0];
//        self.photoQuality = [info getStringValueForKey:ZW_PhotoQuality defaultValue:@"高清"];
//        self.videoRecordingQuality = [info getStringValueForKey:ZW_VideoRecordingQuality defaultValue:@"高清"];
//
//
//        NSArray * cached_engineers = [[ZWFileCache sharedCache] getObjectsOfClass:[Engineer class] tag:0];
//        if (cached_engineers.count > 0) {
//            self.engineer = [cached_engineers firstObject];
//        }
//    }
}

- (void)insertToDic:(NSMutableDictionary*)toDic toKey:(NSString*)toKey fromDic:(NSDictionary*)fromDic fromKey:(NSString*)fromKey {
    id object = [fromDic objectForKey:fromKey];
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
        [toDic setObject:object forKey:toKey];
    }
}

- (void)saveToFile {
    if (!self.isSignedIn) return;
//    NSUserDefaults * dic = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    [info setObject:[NSString stringWithFormat:@"%@", ZW_Cache_VersionNumber] forKey:ZW_Cache_Version];
    [info setObject:self.loginValue forKey:ZW_Value];
    [info setObject:self.apiDomain forKey:ZW_APID];

    
//    [[ZWFileCache sharedCache] saveWithKey:ZW_Cache dictionary:info life:0];
//
//    [[ZWFileCache sharedCache] saveObject:self.engineer life:0 tag:0];
}






- (void)deleteFromFile {

    
//    [[ZWFileCache sharedCache] cleanUpCacheForKey:ZW_Cache];
//
//    [[ZWFileCache sharedCache] cleanUpObjectsOfClass:[Engineer class] tag:0];
    
}

//还原设置中默认配置
- (void)defaultSettingConfig
{

}
@end

