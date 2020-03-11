//
//  ZWClient.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWNetworkTool.h"
#import "ZWBaseClient.h"

@interface ZWClient : ZWBaseClient
{
    BOOL _needLogin;
}

- (void)normalPostWithMethodName:(NSString *)methodName params:(NSMutableDictionary *)params;

@end


