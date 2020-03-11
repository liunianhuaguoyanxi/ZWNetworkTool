//
//  ZWSocketManager.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ZWSocketManager.h"
#import "BayeuxClient.h"
#import "ZWClient.h"
#import "ZWEngine.h"

#import "ZWClient+API.h"
#define ADD_NTF_OBJ(_name, _sel, _obj) [[NSNotificationCenter defaultCenter] addObserver:self selector:_sel name:_name object:_obj]
#define ADD_NTF(_name, _sel) ADD_NTF_OBJ(_name, _sel, nil)
#define POST_NTF(_name, _obj) [[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj]
#define REM_NTF(_name) [[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil];
#define WSNTF_TMsgReceived @"WSNTF_TicketMessageReceived"
#define WSNTF_SCMsgReceived @"WSNTF_SessionChatMessageReceived"
#define WSNTF_SessionControl @"WSNTF_SessionControl"
#define WSNTF_TicketControl @"WSNTF_TicketControl"
@interface ZWSocketManager () <BayeuxClientDelegate> {
    NSMutableArray * _channelsArray;
    BOOL _lastConnectedStatus;
    
    //
    ZWClient * _client;
}
@property (strong, nonatomic) BayeuxClient * bayeuxClient;
@property (strong, nonatomic) NSTimer * timerReconnect;
@property (strong, nonatomic) NSTimer * timerRelogin;

@end

@implementation ZWSocketManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // Initialization Code
        _channelsArray = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApplicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationApplicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

/*
 /provider/id/chat/id
 /provider/id/servicedesk/id
 /provider/id/ticket/id
 */

- (void)connect {
    [self disconnect];
    
    #ifdef BuiltForInternalTest
    NSString * url = @"ws://push.xxxtest.com/cometd";
    #else
    NSString * url = @"ws://push.xxx.com/cometd";
    #endif
    



    self.bayeuxClient = [[BayeuxClient alloc] initWithURLString:url];
    
    // configurations
    self.bayeuxClient.orginHeader = @"https://admin.xxx.com";
    self.bayeuxClient.ewei_userID = [[ZWEngine engine].userID longLongValue];
    self.bayeuxClient.ewei_providerID = [[ZWEngine engine].providerID longLongValue];
    
    [self.bayeuxClient subscribeToChannel:[NSString stringWithFormat:@"/provider/%@", [ZWEngine engine].providerID]];
    
    /*
#ifdef DEBUG
    [self.bayeuxClient subscribeToChannel:@"/service/console"];
#endif
    */
    
    // connect
    self.bayeuxClient.delegate = self;
    [self.bayeuxClient connect];
    
    // recover subscribed channels
    if (_channelsArray.count > 0) {
        for (NSString * str in _channelsArray) {
            [self.bayeuxClient subscribeToChannel:str];
        }
    }
}

- (void)disconnect {
    if ([self.timerReconnect isValid]) {[self.timerReconnect invalidate]; self.timerReconnect = nil;}
    _connected = NO;
    self.bayeuxClient.delegate = nil;
    [self.bayeuxClient disconnect];
    [self publishMessageForLogout];
}

- (void)reset {
    [self disconnect];
    [_channelsArray removeAllObjects];
}

- (BOOL)subscribeChannelWithServiceDeskID:(long long)serviceDeskID {
    return [self subscribeToChannel:[NSString stringWithFormat:@"/provider/%@/serviceDesk/%lld", [ZWEngine engine].providerID, serviceDeskID]];
}
- (BOOL)unsubscribeChannelWithServiceDeskID:(long long)serviceDeskID {
    return [self unsubscribeFromChannel:[NSString stringWithFormat:@"/provider/%@/serviceDesk/%lld", [ZWEngine engine].providerID, serviceDeskID]];
}

- (BOOL)subscribeChannelWithChatID:(long long)chatID {
    return [self subscribeToChannel:[NSString stringWithFormat:@"/provider/%@/chat/%lld", [ZWEngine engine].providerID, chatID]];
}
- (BOOL)unsubscribeChannelWithChatID:(long long)chatID {
    return [self unsubscribeFromChannel:[NSString stringWithFormat:@"/provider/%@/chat/%lld", [ZWEngine engine].providerID, chatID]];
}

- (BOOL)subscribeChannelWithTicketID:(long long)ticketID {
    return [self subscribeToChannel:[NSString stringWithFormat:@"/provider/%@/ticket/%lld", [ZWEngine engine].providerID, ticketID]];
}
- (BOOL)unsubscribeChannelWithTicketID:(long long)ticketID {
    return [self unsubscribeFromChannel:[NSString stringWithFormat:@"/provider/%@/ticket/%lld", [ZWEngine engine].providerID, ticketID]];
}

#pragma mark - Private Methods
- (BOOL)subscribeToChannel:(NSString*)channel {
    // avoid existing ones
    for (NSString * item in _channelsArray) {
        if ([channel isEqualToString:item]) {
            return NO;
        }
    }
    
    // about to subscribe
    [_channelsArray addObject:channel];
    [self.bayeuxClient subscribeToChannel:channel];
    return YES;
}
- (BOOL)unsubscribeFromChannel:(NSString*)channel {
    id toBeRemoved = nil;
    for (NSString * str in _channelsArray) {
        if ([str isEqualToString:channel]) {
            toBeRemoved = str;
            break;
        }
    }
    if (toBeRemoved == nil) return NO;
    
    // about to unsubscribe
    [_channelsArray removeObject:toBeRemoved];
    [self.bayeuxClient unsubscribeFromChannel:channel];
    return YES;
}

- (void)publishMessageForLogin {
//eg:
//    if ([self.timerRelogin isValid]) {[self.timerRelogin invalidate];}
//    self.timerRelogin = nil;
//    if (_client) {[_client cancel]; _client = nil;}
//    ZWClient * client = [[ZWClient alloc] initWithComplete:^(id resultDictionary) {
//        _client = nil;
//    } failure:^(KSClient * errorClient) {
//        _client = nil;
//        self.timerRelogin = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(publishMessageForLogin) userInfo:nil repeats:NO];
//    } controller:nil];
//    [client addLongconnectionSessionWithID:[self.bayeuxClient getSessionID] userID:9527];
//    _client = client;
}
- (void)publishMessageForLogout {
//eg:
//    if ([self.timerRelogin isValid]) {[self.timerRelogin invalidate]; self.timerRelogin = nil;}
//    if (_client) {[_client cancel]; _client = nil;}
//    if ([self.bayeuxClient getSessionID].hasValue) {
//        ZWClient * client = [[ZWClient alloc] initWithComplete:^(id resultDictionary) {
//            _client = nil;
//        } failure:^(KSClient * errorClient) {
//            _client = nil;
//        } controller:nil];
//        [client deleteLongconnectionSessionWithID:[self.bayeuxClient getSessionID]];
//        _client = client;
//    }
}


#pragma mark - WebSocket Reconnect
- (void)reconnectAfterAWhile {
#ifdef DEBUG
    NSLog(@"BayeuxClient Reconnect After 5 Seconds");
#endif
    [self disconnect];
    self.timerReconnect = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(connect) userInfo:nil repeats:NO];
}

#pragma mark - BayeuxClientDelegate
- (void)bayeuxClient:(BayeuxClient *)client receivedMessage:(NSDictionary *)message fromChannel:(NSString *)channel {
#ifdef DEBUG
    NSLog(@"BayeuxClient received from channel:%@\n message:\n%@", channel, message);
#endif
//eg:
//    NSArray * channelComponentsArr = nil;
//    if ([channel containsString:@"ticket/"]) {
//        // ticket message
//        channelComponentsArr = [channel componentsSeparatedByString:@"ticket/"];
//    } else if ([channel containsString:@"chat/"]) {
//        // chat message
//        channelComponentsArr = [channel componentsSeparatedByString:@"chat/"];
//    } else if ([channel containsString:@"provider/"]) {
//        // provider message
//        channelComponentsArr = [channel componentsSeparatedByString:@"provider/"];
//    }
//
//    if ([channelComponentsArr isKindOfClass:[NSArray class]] && channelComponentsArr.count > 1) {
//        long long channelID = [[channelComponentsArr objectAtIndex:1] longLongValue];
//
//        NSDictionary * data = [message getDictionaryForKey:@"data"];
//
//        if (data) {
//            NSDictionary * objectDic = @{@"channelID": [NSNumber numberWithLongLong:channelID], @"data": data};
//            NSString * type = [data getStringValueForKey:@"type" defaultValue:nil];
//
//            if ([channel containsString:@"ticket"] && [type containsString:@"ticket"]) {
//                // Ticket Logs & Messages (工单日志 消息长连接)
//                POST_NTF(WSNTF_TMsgReceived, objectDic);
//            } else if ([channel containsString:@"chat"] && [type containsString:@"chat"]) {
//                // Session Chat Logs & Messages (会话日志 消息长连接)
//                POST_NTF(WSNTF_SCMsgReceived, objectDic);
//            } else if ([channel containsString:@"provider"] && (![channel containsString:@"chat"]) && [type containsString:@"chat"]) {
//                // Session Control (会话状态变更，长连接)
//                POST_NTF(WSNTF_SessionControl, objectDic);
//            } else if ([channel containsString:@"provider"] && (![channel containsString:@"ticket"]) && [type containsString:@"ticket"]) {
//                // Ticket Control (工单状态变更，长连接)
//                POST_NTF(WSNTF_TicketControl, objectDic);
//            }
//        }
//    }
}

#pragma mark - Optional BayeuxClientDelegate methods
- (void)bayeuxClientDidConnect:(BayeuxClient *)client {
#ifdef DEBUG
    NSLog(@"BayeuxClient connected.");
#endif
    _connected = YES;
    [self publishMessageForLogin];
}
- (void)bayeuxClient:(BayeuxClient *)client subscribedToChannel:(NSString *)channel {
#ifdef DEBUG
    NSLog(@"BayeuxClient subscribed to channel - %@", channel);
    /*
    if ([channel isEqualToString:@"/service/console"]) {
        [self publishMessageForLogin];
    }*/
#endif
}
- (void)bayeuxClient:(BayeuxClient *)client unsubscribedFromChannel:(NSString *)channel {
#ifdef DEBUG
    NSLog(@"BayeuxClient successfully unsubscribed from channel - %@", channel);
#endif
}
- (void)bayeuxClient:(BayeuxClient *)client publishedMessageId:(NSString *)messageId toChannel:(NSString *)channel error:(NSError *)error {
#ifdef DEBUG
    NSLog(@"BayeuxClient The server has responded to a published message.");
#endif
}
- (void)bayeuxClient:(BayeuxClient *)client failedToSubscribeToChannel:(NSString *)channel withError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"BayeuxClient encountered an error while subscribing to channel - %@", channel);
#endif
    [self disconnect];
    [self reconnectAfterAWhile];
}
- (void)bayeuxClient:(BayeuxClient *)client failedToSerializeMessage:(id)message withError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"BayeuxClient encountered an error while serializing a message.");
#endif
    [self disconnect];
    [self reconnectAfterAWhile];
}
- (void)bayeuxClient:(BayeuxClient *)client failedToDeserializeMessage:(id)message withError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"BayeuxClient encountered an error while deserializing a message.");
#endif
    [self disconnect];
    [self reconnectAfterAWhile];
}
- (void)bayeuxClient:(BayeuxClient *)client failedWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"BayeuxClient encountered some error which likely caused it to disconnect.");
#endif
    [self disconnect];
    [self reconnectAfterAWhile];
}
- (void)bayeuxClientDidDisconnect:(BayeuxClient *)client {
#ifdef DEBUG
    NSLog(@"BayeuxClient successfully disconnected gracefully, because you asked it to.");
#endif
    _connected = NO;
}

#pragma mark - Notifications
- (void)notificationApplicationDidEnterBackground:(NSNotification*)sender {
    _lastConnectedStatus = _connected;
    if (_connected) {
        [self disconnect];
    }
}
- (void)notificationApplicationWillEnterForeground:(NSNotification*)sender {
    if (_lastConnectedStatus) {
        [self connect];
    }
}
@end

