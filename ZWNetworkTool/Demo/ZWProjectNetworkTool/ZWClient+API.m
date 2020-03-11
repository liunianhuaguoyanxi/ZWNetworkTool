//
//  ZWClient+API.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWClient+API.h"

@implementation ZWClient (API)
#pragma mark - Basic & Authorisation
//生产环境
#define RequestDomainURL @"https://admin.xxx.com"
//获取appStore最新版本号
- (void)getTheLatestVersionFromAppStoreWithAppID:(NSString*)APPID
{
    _needLogin = NO;
    NSString * method = nil;
    method = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",APPID];
    [self getWithMethodName:method params:nil];
}
- (void)getDomainsWithAccount:(NSString*)account {
    _needLogin = NO;
    NSString * method = nil;
    method = RequestDomainURL;
    method = [method stringByAppendingString:@"/api_admin_list_provider.json"];
    [self getWithMethodName:method params:[NSMutableDictionary dictionaryWithObject:account forKey:@"email"]];
}

- (void)getDomainAvailabilityWithDomain:(NSString*)domain {
    _needLogin = NO;
    NSString * method = domain;
    method = [method stringByAppendingString:@"/api/v1/request_provider_logo.json"];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"2" forKey:@"app_id"];
    [self getWithMethodName:method params:params];
}

- (void)registerWithInfoID:(long long)infoID phone:(NSString*)phone code:(NSString*)code password:(NSString*)password industries:(NSArray*)industries providerName:(NSString*)providerName realName:(NSString*)realName username:(NSString*)username {
    _needLogin = NO;
    NSString * method = RequestDomainURL;
    method = [method stringByAppendingFormat:@"/api_admin_provider_register.json?code=%@", code];
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:7];
    if (infoID > 0) [params setObject:[NSNumber numberWithLongLong:infoID] forKey:@"id"];
    if (phone) [params setObject:phone forKey:@"mobilePhone"];
    if (password) [params setObject:password forKey:@"password"];
    if (industries.count > 0) [params setObject:industries forKey:@"providerIndustry"];
    if (providerName) [params setObject:providerName forKey:@"providerName"];
    if (realName) [params setObject:realName forKey:@"realname"];
    if (username) [params setObject:username forKey:@"username"];
    [self postWithMethodName:method params:params];
}

- (void)addLongconnectionSessionWithID:(NSString*)sessionID userID:(long long)userID {
    self.needAlert = NO;
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:3];
    if (sessionID) [params setObject:sessionID forKey:@"sessionId"];
    if (userID > 0) [params setObject:[NSNumber numberWithLongLong:userID] forKey:@"userId"];
    //#if TARGET_IPHONE_SIMULATOR
    //    [params setObject:@"web_console" forKey:@"channel"];
    //#else
    [params setObject:@"app_ios" forKey:@"channel"];
    //#endif
    [self postWithMethodName:@"v1/long_connections.json" params:params];
}

- (void)deleteLongconnectionSessionWithID:(NSString*)sessionID {
    self.needAlert = NO;
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:1];
    if (sessionID) [params setObject:sessionID forKey:@"sessionId"];
    [self jsonDeleteWithMethodName:@"v1/long_connections.json" params:params];
}
@end
