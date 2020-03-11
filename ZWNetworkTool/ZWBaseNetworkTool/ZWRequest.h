//
//  ZWRequest.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWRequestDefinations.h"
@class ZWRequest;

@protocol ZWRequestDelegate <NSObject>
@required
- (void)ZWRequest:(ZWRequest*)request didCancelWithError:(NSError *)error;
- (void)ZWRequest:(ZWRequest*)request didFailWithError:(NSError *)error;
- (void)ZWRequest:(ZWRequest*)request didFinishLoadingWithResult:(id)result;
@optional
- (void)ZWRequest:(ZWRequest*)request didReceiveResponse:(NSURLResponse *)response;
- (void)ZWRequest:(ZWRequest*)request didSendPercent:(float)percent;
- (void)ZWRequest:(ZWRequest*)request didReceivePercent:(float)percent;
@end

@interface ZWRequest : NSObject

@property (weak, nonatomic) id <ZWRequestDelegate> delegate;
@property (assign, nonatomic) ZWRequestBodyType bodyType;
@property (copy, nonatomic) NSString     * url;
@property (copy, nonatomic) NSString     * httpMethod;
@property (copy, nonatomic) NSDictionary * paramaters;
@property (copy, nonatomic) NSDictionary * httpHeaderFields;
@property (assign, nonatomic) ZWRequestAlgorithmEncryption algorithmEncryption;

+ (ZWRequest*)requestWithURL:(NSString *)url
                  httpMethod:(NSString *)httpMethod
                  paramaters:(NSDictionary *)paramaters
                    bodyType:(ZWRequestBodyType)bodyType
            httpHeaderFields:(NSDictionary *)httpHeaderFields
            algorithmEncryption:(ZWRequestAlgorithmEncryption)algorithmEncryption
                    delegate:(id<ZWRequestDelegate>)delegate;

- (void)connect;
- (void)disconnect;
@end
