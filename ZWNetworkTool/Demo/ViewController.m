//
//  ViewController.m
//  ZWNetworkTool
//
//  Created by 流年划过颜夕 on 2020/3/11.
//  Copyright © 2020 liunianhuaguoyanxi. All rights reserved.
//

#import "ViewController.h"
#import "ZWClient+API.h"

#import "ZWSocketManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getTheLatestVersionFromAppStoreWithAppID];
}

//HTTP请求示例
-(void)getTheLatestVersionFromAppStoreWithAppID
{
    ZWClient * client = [[ZWClient alloc] initWithComplete:^(id resultDictionary) {
        

        
        
    } failure:^(ZWBaseClient * errorClient) {

    } controller:self];
    [client getTheLatestVersionFromAppStoreWithAppID:@"963975817"];
}

//长连接请求示例：移除订阅
//长连接仅作逻辑展示，实际需添加您有效的订阅地址
- (void)unsubscribeChannelWithTicketID:(long long)ticketID
{
      [[ZWSocketManager sharedManager] unsubscribeChannelWithTicketID:ticketID];
}

//长连接请求示例：订阅
//长连接仅作逻辑展示，实际需添加您有效的订阅地址
- (void)subscribeChannelWithTicketID:(long long)ticketID
{
       [[ZWSocketManager sharedManager] subscribeChannelWithTicketID:ticketID];
}

@end
