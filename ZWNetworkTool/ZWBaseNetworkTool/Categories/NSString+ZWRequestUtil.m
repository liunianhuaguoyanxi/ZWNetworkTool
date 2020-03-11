//
//  NSString+ZWRequestUtil.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "NSString+ZWRequestUtil.h"


@implementation NSString (ZWRequestUtil)
- (NSString*)ZWRequestURLEncodedString {
    NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"~!@#$%^&*()-+={}\"[]|\\<> \n\t\r"].invertedSet;
//    NSCharacterSet * characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
}

- (NSString*)ZWRequestURLDecodedString {
    return [self stringByRemovingPercentEncoding];
}

- (NSData*)ZWRequestEncodedData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
@end
