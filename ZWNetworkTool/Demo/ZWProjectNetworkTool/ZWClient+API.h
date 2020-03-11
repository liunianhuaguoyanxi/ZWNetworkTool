//
//  ZWClient+API.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWClient (API)
//eg:
//获取appStore最新版本号
- (void)getTheLatestVersionFromAppStoreWithAppID:(NSString*)APPID;

//检测手写域名可用性
- (void)getDomainsWithAccount:(NSString*)account;
- (void)getDomainAvailabilityWithDomain:(NSString*)domain;

- (void)registerWithInfoID:(long long)infoID phone:(NSString*)phone code:(NSString*)code password:(NSString*)password industries:(NSArray*)industries providerName:(NSString*)providerName realName:(NSString*)realName username:(NSString*)username;


- (void)addLongconnectionSessionWithID:(NSString*)sessionID userID:(long long)userID;

- (void)deleteLongconnectionSessionWithID:(NSString*)sessionID;
@end

NS_ASSUME_NONNULL_END
