//
//  ZWClient+API2.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWClient (API2)
//eg:
- (void)sendEngineerRequestToEmail:(NSString*)email;

//通过图形码，手机账号，获取绑定手机的验证码
- (void)sendBindVerifyCodeToPhone:(NSString*)phone
                  imageVerifyCode:(NSString*)imageVerifyCode
                  imageIdentifier:(NSString*)imageIdentifier;


//通过图形码，手机账号，获取重置密码的验证码
- (void)sendResetPasswordVerifyCodeToPhone:(NSString*)phone
                           imageVerifyCode:(NSString*)imageVerifyCode
                           imageIdentifier:(NSString*)imageIdentifier;
@end

NS_ASSUME_NONNULL_END
