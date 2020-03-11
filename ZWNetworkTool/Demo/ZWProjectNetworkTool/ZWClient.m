//
//  ZWClient.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWClient.h"
#import "ZWEngine.h"

@implementation ZWClient
#pragma mark
#pragma mark - reconstruct

- (instancetype)initWithDelegate:(id)delegate {
    if (self = [super initWithDelegate:delegate]) {
        // Initialization Code
        _needLogin = YES;
    }
    return self;
}

- (instancetype)initWithComplete:(void(^) (id resultDictionary))successBlock failure:(void(^) (ZWBaseClient * errorClient))failureBlock controller:(id)controller {
    if (self = [super initWithComplete:successBlock failure:failureBlock controller:controller]) {
        // Initialization Code
        _needLogin = YES;
    }
    return self;
}

- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                       paramaters:(NSMutableDictionary *)paramaters
                         bodyType:(ZWRequestBodyType)bodyType
                 httpHeaderFields:(NSMutableDictionary *)httpHeaderFields
              algorithmEncryption:(ZWRequestAlgorithmEncryption)algorithmEncryption{
//eg
    // method name
//    NSString * method = methodName;
//    NSString *lowerURL = [method lowercaseString];
//    if (![lowerURL hasPrefix:@"http"]) {
//        // add base domain
//        method = [NSString stringWithFormat:@"%@/%@", [ZWDomain baseAPIURL], methodName];
//    }
    
//eg:
    // http header fields
//    NSMutableDictionary * headerFields = [httpHeaderFields mutableCopy];
//    if (_needLogin) {
//        // avoid nil token
//        if (![ZWEngine engine].isSignedIn) return;
//
//        if (!headerFields) headerFields = [NSMutableDictionary dictionary];
//        [headerFields setObject:[ZWEngine engine].loginValue forKey:[ZWEngine engine].loginKey];
//
//        //请求URL后拼接Token，防止劫持后或者headerFields被吞或失效
//        if (![method containsString:@"_token="]&&[httpMethod isEqualToString:@"GET"]&&[ZWEngine engine].loginValue.hasValue) {
//
//            if ([method containsString:@"?"]) {
//            method = [method stringByAppendingFormat:@"&%@=%@", [ZWEngine engine].loginKey, [ZWEngine engine].loginValue];
//            }else
//            {
//             method = [method stringByAppendingFormat:@"?%@=%@", [ZWEngine engine].loginKey, [ZWEngine engine].loginValue];
//            }
//
//
//        }
//    }
//
//      [super loadRequestWithMethodName:method httpMethod:httpMethod paramaters:paramaters bodyType:bodyType httpHeaderFields:headerFields algorithmEncryption:algorithmEncryption];
    
    
    [super loadRequestWithMethodName:methodName httpMethod:httpMethod paramaters:paramaters bodyType:bodyType httpHeaderFields:httpHeaderFields algorithmEncryption:algorithmEncryption];

}

- (id)parseResultWithData:(NSData*)data {
    NSDictionary * result = [super parseResultWithData:data];
    if ([result isKindOfClass:[NSDictionary class]]) {
//eg:
        // should check responded data
//        NSInteger status = [result getIntegerValueForKey:@"status" defaultValue:0];
//        if (status != 0) {
//            NSDictionary * errorDic = [result getDictionaryForKey:@"result"];
//            NSString * msg = [errorDic objectForKey:@"error_description"];
//            if (!([msg isKindOfClass:[NSString class]] && msg.length > 0)) {
//                msg = NSLocalizedString(@"err_unknown", nil);
//            }
//            if ([[errorDic objectForKey:@"error"] isEqualToString:@"user_permission_failed"]) {
//
//            }
//            self.errorMessage = msg;
//            self.errorCode = status;
//            if (_needLogin) {
//                if (status == ZWSDKErrorCodeTokenInvalid || status == ZWSDKErrorCodeTokenError || status == ZWRequestErrorCodeAUTHENTICATION_FAILED || status == ZWRequestErrorCodeNewTOKEN_EMPTY ||
//                    status == ZWRequestErrorCodeNewTOKEN_NOT_FOUND || status == ZWRequestErrorCodeNewTOKEN_EXPIRED) {
//                    // login session expired
//                    self.needAlert = NO;
//                    self.errorMessage = NSLocalizedString(@"err_token_invalid", nil);
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_DidSignout object:self];
//                } else if (status == ZWSDKErrorCodeDomainInvalid) {
//                    // domain invalid
//                    self.needAlert = NO;
//                    self.errorMessage = NSLocalizedString(@"err_domain_invalid", nil);
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_DidSignout object:self];
//                }
//            }
//            self.hasError = YES;
//        }
//    } else {
//        self.hasError = YES;
    }
    return result;
}

- (void)postWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params {
    [self loadRequestWithMethodName:methodName httpMethod:@"POST" paramaters:params bodyType:ZWRequestBodyTypeJson httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}

- (void)normalPostWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params {
    [self loadRequestWithMethodName:methodName httpMethod:@"POST" paramaters:params bodyType:ZWRequestBodyTypeNormal httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}

#pragma mark - Public API Methods

// to be implemented in sub-classes

@end
