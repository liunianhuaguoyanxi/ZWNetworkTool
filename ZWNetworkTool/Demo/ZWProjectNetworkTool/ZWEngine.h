//
//  ZWEngine.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZWEngine : NSObject

//获取token的key @"_token"
@property (copy, nonatomic) NSString * loginKey;
//获取到的token 如“496e2873c8a9499c8ccaa5e10f4788fc”
@property (copy, nonatomic) NSString * loginValue;
//根域名 如@“itkeeping.com”
@property (copy, nonatomic) NSString * rootDomain;
//整个域名 如@“0702.itkeeping.com”
@property (copy, nonatomic) NSString * apiDomain;
//http前缀
@property (copy, nonatomic) NSString * httpPrefixName;
//VE域名
@property (copy, nonatomic) NSString * eweiVeHost;
//域名 如https://admin.ewei.com
@property (copy, nonatomic) NSString * apiDomainURL;
//服务商ID
@property (copy, nonatomic) NSString * providerID;
//企业名称
@property (copy, nonatomic) NSString * providerName;
//企业电话
@property (copy, nonatomic) NSString * providerPhone;
//企业联系人
@property (copy, nonatomic) NSString * providerContact;
//企业联系人手机号
@property (copy, nonatomic) NSString * providerContactPhone;
//当前客服ID（当前用户为客服，它的客服ID）
@property (copy, nonatomic) NSString * engineerID;
//当前用户ID（最基本的ID）
@property (copy, nonatomic) NSString * userID;
//token过期时间(废弃没有用)
@property (assign, nonatomic) NSTimeInterval expirationInterval;
@property (copy, nonatomic) NSString * qiniuToken;
@property (copy, nonatomic) NSString * apnsToken;


@property (readonly) BOOL isSignedIn;

//老逻辑，关于token过期判断，以后都以后端接口的校验为准，过期后端会返回error提示
@property (readonly) BOOL isNotExpired;


// return a shared static object
+ (ZWEngine*)engine;

- (void)signout;

/**
 *    Copyright © 2013 CC Inc. All rights reserved.
 *
 *    read data from cache file
 */
- (void)readFromFile;

/**
 *    Copyright © 2013 CC Inc. All rights reserved.
 *
 *    save data to cache file
 */
- (void)saveToFile;

/**
 *    Copyright © 2013 CC Inc. All rights reserved.
 *
 *    delete all data from cache file
 */
- (void)deleteFromFile;


- (void)defaultSettingConfig;
@end


