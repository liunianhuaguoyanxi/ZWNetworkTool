//
//  ZWClient+API2.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWClient+API2.h"

#import "ZWEngine.h"
@implementation ZWClient (API2)

#pragma mark - Private

- (void)loadAPI2RequestWithMethodName:(NSString*)methodName params:(NSMutableDictionary*)params {
    NSString * method = @"https://admin.xxx.com";
    
    method = [method stringByAppendingFormat:@"/api2/%@", methodName];
    if (_needLogin) {
        method = [method stringByAppendingFormat:@"?%@=%@", [ZWEngine engine].loginKey, [ZWEngine engine].loginValue];
    }
    [self loadRequestWithMethodName:method httpMethod:@"POST" paramaters:params bodyType:ZWRequestBodyTypeJson httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}



#pragma mark - Basic

- (void)sendEngineerRequestToEmail:(NSString*)email {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:1];
    if (email) [params setObject:email forKey:@"email"];
    [self loadAPI2RequestWithMethodName:@"OpenEngineerApi.sendResetPasswordEmail" params:params];
}


- (void)sendBindVerifyCodeToPhone:(NSString*)phone imageVerifyCode:(NSString*)imageVerifyCode imageIdentifier:(NSString*)imageIdentifier {
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:phone forKey:@"mobilePhone"];
    [params setObject:imageVerifyCode forKey:@"verifyCode"];
    [params setObject:imageIdentifier forKey:@"uid"];
    [self loadAPI2RequestWithMethodName:@"OpenUserApi.sendSmsCodeForBindUserPhone" params:params];
}


- (void)sendResetPasswordVerifyCodeToPhone:(NSString*)phone
                           imageVerifyCode:(NSString*)imageVerifyCode
                           imageIdentifier:(NSString*)imageIdentifier {
    _needLogin = NO;
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:4];
    [params setObject:phone forKey:@"username"];
    [params setObject:@"password_update" forKey:@"userChangeType"];
    [params setObject:imageVerifyCode forKey:@"verifyCode"];
    [params setObject:imageIdentifier forKey:@"verifyCodeNo"];
    [self loadAPI2RequestWithMethodName:@"OpenAccountApi.getVerifyCodeNew" params:params];
}

@end
