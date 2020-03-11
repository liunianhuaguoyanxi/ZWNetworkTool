//
//  NSString+ZWRequestUtil.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZWRequestUtil)
- (NSString*)ZWRequestURLEncodedString;

- (NSString*)ZWRequestURLDecodedString;
- (NSData*)ZWRequestEncodedData;
@end

NS_ASSUME_NONNULL_END
