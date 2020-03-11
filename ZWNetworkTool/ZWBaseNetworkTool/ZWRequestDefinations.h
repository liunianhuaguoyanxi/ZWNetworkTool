//
//  ZWRequestDefinations.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#ifndef ZWRequestDefinations_h
#define ZWRequestDefinations_h
#import <Foundation/Foundation.h>
extern NSString *const ZWRequestErrorDomain; // "ZWRequestErrorDomain"
#define ZWText(_key) [NSBundle.mainBundle localizedStringForKey:(_key) value:@"" table:(@"ZWFrameworkText")]
#define ZWRequestTimeOutInterval   30.0
#define ZWRequestStringBoundary    @"0x912913kiwi43764376x0"
#define AESKey      @"de8a7105654cb9d4"

#define ZWRequestLogPrint 1
//bodyType
typedef  NS_ENUM(NSInteger, ZWRequestBodyType) {
    ZWRequestBodyTypeNone       = 0,
    ZWRequestBodyTypeNormal     = 10, // for normal data post, such as "user=name&password=psd"
    ZWRequestBodyTypeMultipart  = 20,  // for uploading images and files.
    ZWRequestBodyTypeJson       = 30,
    ZWRequestBodyTypeText       = 40  // for Algorithm Encryption TEXT.
};

//ErrorCode
typedef NS_ENUM(NSInteger, ZWRequestErrorCode) {
    ZWRequestErrorNone      = 0,
    ZWRequestErrorUknown    = 1,
    ZWRequestErrorRequest   = 2,
    ZWRequestErrorParse     = 3
};

//isEncryption
typedef NS_ENUM(NSInteger, ZWRequestAlgorithmEncryption) {
    /*
    非加密*/
    ZWRequestAlgorithmEncryptionNone    = 0,
    /*
     加密算法：AES
     加密模式：ECB
     填充模式：ISO10126Padding
     数据块：128位
     密钥：de8a7105654cb9d4 （16位，存于Admin数据库常量表中ADMIN_API_BODY_DECRYPT_KEY）
     输出模式：Base64
     字符集：UTF-8*/
    ZWRequestAlgorithmEncryptionAES     = 10
};

#endif /* ZWRequestDefinations_h */
