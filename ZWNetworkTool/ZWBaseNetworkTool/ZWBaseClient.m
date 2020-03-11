//
//  ZWBaseClient.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZWBaseClient.h"
#import "ZWRequest.h"
#import "ZWNetworkTool.h"

typedef void(^ZWBaseClientCompleteSuccessBlock) (id resultDictionary);
typedef void(^ZWBaseClientCompleteFailureBlock) (ZWBaseClient * errorClient);

@interface ZWBaseClient () <ZWRequestDelegate> {
    BOOL _cancelled;
}

@property (strong, nonatomic) ZWRequest * request;
@property (copy, nonatomic) ZWBaseClientCompleteSuccessBlock successBlock;
@property (copy, nonatomic) ZWBaseClientCompleteFailureBlock failureBlock;
@property (assign, nonatomic) BOOL preparedToComplete;

+ (NSMutableArray*)sharedClients;

@end

@implementation ZWBaseClient

+ (NSMutableArray*)sharedClients {
    static NSMutableArray * sharedClients = nil;
    if (sharedClients == nil) {
        sharedClients = [[NSMutableArray alloc] init];
    }
    return sharedClients;
}

+ (void)cancelOperationsForController:(id)controller {
    NSMutableArray * operations = [self sharedClients];
    NSInteger index = 0;
    while (index < operations.count) {
        ZWBaseClient * client = [operations objectAtIndex:index];
        if([client isKindOfClass:[ZWBaseClient class]]) {
            if (client.controller == controller) {
                [client cancel];
            } else {
                index ++;
            }
        } else {
            index ++;
        }
    }
}

- (instancetype)initWithDelegate:(id)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        _cancelled = NO;
        _hasError = YES;
        _workWithNoRespond = NO;
        self.needAlert = YES;
        self.parsedAsJSON = YES;
        self.needLoadingHUD = YES;
        self.preparedToComplete = NO;
    }
    return self;
}

- (instancetype)initWithComplete:(void(^) (id resultDictionary))successBlock failure:(void(^) (ZWBaseClient * errorClient))failureBlock {
    return [self initWithComplete:successBlock failure:failureBlock controller:nil];
}

- (instancetype)initWithComplete:(void(^) (id resultDictionary))successBlock failure:(void(^) (ZWBaseClient * errorClient))failureBlock controller:(id)controller {
    if (self = [super init]) {
        if (successBlock) self.successBlock = successBlock;
        if (failureBlock) self.failureBlock = failureBlock;
        self.controller = controller;
        _cancelled = NO;
        _hasError = YES;
        _workWithNoRespond = NO;
        self.needAlert = YES;
        self.parsedAsJSON = YES;
        self.needLoadingHUD = YES;
        self.preparedToComplete = NO;
    }
    return self;
}

//- (void)dealloc {
//    NSLog(@"dealloc request = %@", _request.url);
//}

- (void)cancel {
    if (self.preparedToComplete) return;
    self.preparedToComplete = YES;
    if (!_cancelled) {
        _cancelled = YES;
        self.delegate = nil;
        [self.request disconnect];
        [self loadingComplete];
    }
}

- (void)showAlert {
    if (self.needAlert) {
        NSString * alertMsg = nil;
        if ([self.errorMessage isKindOfClass:[NSString class]] && self.errorMessage.length > 0) {
            alertMsg = self.errorMessage;
        } else {
            alertMsg = ZWText(@"request_default_error");
        }
        
        // should show alert
//        [KSFloatingView showType:KSFloatingTypeError text:alertMsg life:2 animated:YES];
    }
}

- (ZWRequestBodyType)postDataTypeWithParameters:(NSDictionary*)params {
    ZWRequestBodyType type = ZWRequestBodyTypeNormal;
    for (id param in params.allValues) {
        if ([param isKindOfClass:[NSData class]]) {
            type = ZWRequestBodyTypeMultipart;
            break;
        } else if ([param isKindOfClass:[NSDictionary class]] || [param isKindOfClass:[NSArray class]]) {
            type = ZWRequestBodyTypeJson;
            break;
        }
    }
    return type;
}

- (void)getWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    [self loadRequestWithMethodName:methodName httpMethod:@"GET" paramaters:paramaters bodyType:ZWRequestBodyTypeNone httpHeaderFields:nil  algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)postWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    ZWRequestBodyType type = [self postDataTypeWithParameters:paramaters];
    [self loadRequestWithMethodName:methodName httpMethod:@"POST" paramaters:paramaters bodyType:type httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)postWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters withalgorithmEncryption:(ZWRequestAlgorithmEncryption)algorithmEncryption {
    ZWRequestBodyType type = ZWRequestBodyTypeText;
    switch (algorithmEncryption) {
        case ZWRequestAlgorithmEncryptionNone:
        {
            type = [self postDataTypeWithParameters:paramaters];
        }
            break;
            
        case ZWRequestAlgorithmEncryptionAES:
        {
            type = ZWRequestBodyTypeText;
        }
            break;
    }

    
    [self loadRequestWithMethodName:methodName httpMethod:@"POST" paramaters:paramaters bodyType:type httpHeaderFields:nil algorithmEncryption:algorithmEncryption];
}
- (void)putWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    ZWRequestBodyType type = [self postDataTypeWithParameters:paramaters];
    [self loadRequestWithMethodName:methodName httpMethod:@"PUT" paramaters:paramaters bodyType:type httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)deleteWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    ZWRequestBodyType type = [self postDataTypeWithParameters:paramaters];
    [self loadRequestWithMethodName:methodName httpMethod:@"DELETE" paramaters:paramaters bodyType:type httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)jsonPostWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    [self loadRequestWithMethodName:methodName httpMethod:@"POST" paramaters:paramaters bodyType:ZWRequestBodyTypeJson httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)jsonPutWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    [self loadRequestWithMethodName:methodName httpMethod:@"PUT" paramaters:paramaters bodyType:ZWRequestBodyTypeJson httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)jsonDeleteWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)paramaters {
    [self loadRequestWithMethodName:methodName httpMethod:@"DELETE" paramaters:paramaters bodyType:ZWRequestBodyTypeJson httpHeaderFields:nil algorithmEncryption:ZWRequestAlgorithmEncryptionNone];
}
- (void)loadRequestWithMethodName:(NSString *)methodName
                       httpMethod:(NSString *)httpMethod
                       paramaters:(NSMutableDictionary *)paramaters
                         bodyType:(ZWRequestBodyType)bodyType
                 httpHeaderFields:(NSDictionary *)httpHeaderFields
              algorithmEncryption:(ZWRequestAlgorithmEncryption)algorithmEncryption{
    [_request disconnect];
    
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionaryWithDictionary:paramaters];
    NSMutableDictionary * headerFields = [NSMutableDictionary dictionaryWithDictionary:httpHeaderFields];
    id delegate = self;
    
    self.request = [ZWRequest requestWithURL:methodName
                                  httpMethod:httpMethod
                                  paramaters:paramsDic
                                    bodyType:bodyType
                            httpHeaderFields:headerFields
                         algorithmEncryption:algorithmEncryption
                                    delegate:delegate];
    [self.request connect];
    [[[self class] sharedClients] addObject:self];
    if (_needLoadingHUD) [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (id)parseResultWithData:(NSData*)data {
    // should be implemented in sub-class
    if (self.parsedAsJSON) {
        // should parse as JSON
        NSError * error = nil;
        id result = [self parseJSONData:data error:&error];
        if (error) {
            _hasError = YES;
            self.errorCode = error.code;
            self.errorMessage = [error localizedDescription];
        }
        return result;
    }
    return data;
}

- (void)loadingComplete {
    if (_needLoadingHUD) {
        NSArray * clientsAll = [[self class] sharedClients];
        NSMutableArray * clientsStillNeedHUD = [NSMutableArray arrayWithCapacity:clientsAll.count];
        for (ZWBaseClient * client in clientsAll) {
            if (client.needLoadingHUD && client != self) [clientsStillNeedHUD addObject:client];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = clientsStillNeedHUD.count > 0;
    }
    [[[self class] sharedClients] removeObject:self];
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error {
    NSError * parseError = nil;
    id result = nil;
    if ([data isKindOfClass:[NSData class]] && data.length > 0) {
        result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
    }
    
    if (!([result isKindOfClass:[NSDictionary class]] || [result isKindOfClass:[NSArray class]])) {
        if (error != nil) {
            * error = [self errorWithCode:ZWRequestErrorParse
                                 userInfo:@{NSLocalizedDescriptionKey:ZWText(@"request_default_error")}];
        }
    }
    
    return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:ZWRequestErrorDomain code:code userInfo:userInfo];
}

#pragma mark
#pragma mark - ZWRequestDelegate
- (void)ZWRequest:(ZWRequest*)request didCancelWithError:(NSError *)error {
    // do nothing
}
- (void)ZWRequest:(ZWRequest*)request didFailWithError:(NSError *)error {
    if (_cancelled || _workWithNoRespond) {
        // do nothing
    } else {
        self.errorCode = error.code;
        NSString * errorStr = [NSString stringWithFormat:@"%@", [error localizedDescription]];
        if (!([errorStr isKindOfClass:[NSString class]] && errorStr.length > 0)) {
            errorStr = [NSString stringWithFormat:@"%@", [[error userInfo] objectForKey:NSLocalizedDescriptionKey]];
        }
        if (!([errorStr isKindOfClass:[NSString class]] && errorStr.length > 0) || error.code == -1003) {
            errorStr = ZWText(@"request_ssl_error");
        }
        self.errorMessage = errorStr;
        if (self.delegate && [self.delegate respondsToSelector:@selector(client:didFinishLoadingWithResult:)]) {
            [self.delegate client:self didFinishLoadingWithResult:error];
        } else {
            __weak __typeof(self)weakSelf = self;
            ZWBaseClientCompleteFailureBlock handler = self.failureBlock;
            @autoreleasepool {
                if (handler) {
                    [weakSelf showAlert];
                    handler(weakSelf);
                }
            }
        }
    }
    [self loadingComplete];
}
- (void)ZWRequest:(ZWRequest*)request didFinishLoadingWithResult:(id)resultData {
    if (_cancelled || _workWithNoRespond) {
        // do nothing
    } else {
        // parse data
        _hasError = NO;
        id result = [self parseResultWithData:resultData];
        
        // callbacks
        if (self.delegate && [self.delegate respondsToSelector:@selector(client:didFinishLoadingWithResult:)]) {
            [self.delegate client:self didFinishLoadingWithResult:result];
        } else {
            __weak __typeof(self)weakSelf = self;
            if (_hasError) {
                ZWBaseClientCompleteFailureBlock handler = self.failureBlock;
                @autoreleasepool {
                    if (handler) {
                        [weakSelf showAlert];
                        handler(weakSelf);
                    }
                }
            } else {
                ZWBaseClientCompleteSuccessBlock handler = self.successBlock;
                @autoreleasepool {
                    if (handler) {
                        handler(result);
                    }
                }
            }
        }
    }
    [self loadingComplete];
}
- (void)ZWRequest:(ZWRequest*)request didReceiveResponse:(NSURLResponse *)response {
    // do nothing
}
- (void)ZWRequest:(ZWRequest*)request didSendPercent:(float)percent {
    if ([self.delegate respondsToSelector:@selector(client:didSendPercent:)]) [self.delegate client:self didSendPercent:percent];
}
- (void)ZWRequest:(ZWRequest*)request didReceivePercent:(float)percent {
    if ([self.delegate respondsToSelector:@selector(client:didReceivePercent:)]) [self.delegate client:self didReceivePercent:percent];
}


@end

