//
//  ZWSocketManager.h
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWSocketManager : NSObject

@property (readonly) BOOL connected;

+ (instancetype)sharedManager;

- (void)connect;
- (void)disconnect;
- (void)reset;

- (BOOL)subscribeChannelWithServiceDeskID:(long long)serviceDeskID;
- (BOOL)unsubscribeChannelWithServiceDeskID:(long long)serviceDeskID;

- (BOOL)subscribeChannelWithChatID:(long long)chatID;
- (BOOL)unsubscribeChannelWithChatID:(long long)chatID;

- (BOOL)subscribeChannelWithTicketID:(long long)ticketID;
- (BOOL)unsubscribeChannelWithTicketID:(long long)ticketID;
@end

NS_ASSUME_NONNULL_END
