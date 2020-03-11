//
//  ZWBaseClient.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWRequestDefinations.h"
@class  ZWBaseClient;

@protocol ZWBaseClientDelegate <NSObject>
@required
// callback method
- (BOOL)client:(ZWBaseClient *)sender didFinishLoadingWithResult:(id)result;

@optional
- (void)client:(ZWBaseClient *)sender didSendPercent:(float)percent;
- (void)client:(ZWBaseClient *)sender didReceivePercent:(float)percent;

@end
@interface ZWBaseClient : NSObject
{
    // if YES the request may not call back when completed, the default value is NO
    BOOL _workWithNoRespond;
}

// object that respond while request is completed
@property (weak, nonatomic) id <ZWBaseClientDelegate> delegate;

// description of error
@property (copy, nonatomic) NSString * errorMessage;
// code of error
@property (assign, nonatomic) NSInteger errorCode;
// YES if the request failed with some error
@property (assign, nonatomic) BOOL        hasError;

// identifier for different kinds of requests in one object
@property (assign, nonatomic) NSInteger   requestID;

// YES if this request need the loading HUD
@property (assign, nonatomic) BOOL        needLoadingHUD;
// if NO the request may ignore errors without alerts, the default value is YES
@property (assign, nonatomic) BOOL        needAlert;
// if YES the result would be parsed as json, the default value is YES
@property (assign, nonatomic) BOOL        parsedAsJSON;

// client should cancel while controller dealloc
@property (weak, nonatomic) id controller;

+ (void)cancelOperationsForController:(id)controller;

/**
 *    Copyright © 2015 Tags. Inc. All rights reserved.
 *
 *    初始化EHClient实例
 *
 *    @param     delegate 回调对象实例
 *
 *    @return    return a BSClient object
 */
- (instancetype)initWithDelegate:(id)delegate;

- (instancetype)initWithComplete:(void(^) (id resultDictionary))successBlock failure:(void(^) (ZWBaseClient * errorClient))failureBlock;

- (instancetype)initWithComplete:(void(^) (id resultDictionary))successBlock failure:(void(^) (ZWBaseClient * errorClient))failureBlock controller:(id)controller;

/**
 *
 *    中断并取消请求
 */
- (void)cancel;

/**
 *
 *    通过UIAlertView展示错误信息
 */
- (void)showAlert;

/**
 *
 *    发送GET请求
 *
 *    @param     methodName URL后缀
 *    @param     params     a dictionary with all parameters (NSNumber, NSString)
 */
- (void)getWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params;

/**
 *
 *    load a http request type as POST
 *
 *    @param     methodName URL后缀
 *    @param     params     a dictionary with all parameters (NSNumber, NSString, UIImage, NSData)
 */
- (void)postWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params;
- (void)postWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters withalgorithmEncryption:(ZWRequestAlgorithmEncryption)algorithmEncryption;
- (void)putWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params;
- (void)deleteWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params;
- (void)jsonPostWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters;
- (void)jsonPutWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters;
- (void)jsonDeleteWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters;

/**
 *    Copyright © 2015 Tags. Inc. All rights reserved.
 *
 *    load a http request
 *
 *    @param     methodName URL
 *    @param     httpMethod @"GET" or @"POST"
 *    @param     paramaters a dictionary with all parameters (NSNumber, NSString, NSData)
 *    @param     bodyType http body
 *    @param     httpHeaderFields http header fields
 */
- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                       paramaters:(NSMutableDictionary *)paramaters
                         bodyType:(ZWRequestBodyType)bodyType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
              algorithmEncryption:(ZWRequestAlgorithmEncryption)algorithmEncryption;

/**
 *    Copyright © 2015 Tags. Inc. All rights reserved.
 *
 *    默认以 JSON 格式解析返回数据
 */
- (id)parseResultWithData:(NSData*)data;

@end

