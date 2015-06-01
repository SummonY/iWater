//
//  TestNetwork.m
//  WWS
//
//  Created by D404 on 15-3-27.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import <arpa/inet.h>
#import "TestNetwork.h"
#import "Reachability.h"

@implementation TestNetwork

#pragma mark ----测试网络状态----
- (int)testNetStatus {
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_addr.s_addr = inet_addr("219.140.162.169");
    addr4.sin_port = htons(8901);
    Reachability* reach = [Reachability reachabilityWithAddress:&addr4];
    //判断该设备网络状态
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"网络不可达");
            return 0;
        case ReachableViaWWAN:
            NSLog(@"使用3G/4G网络");
            return 1;
        case ReachableViaWiFi:
            NSLog(@"使用WiFi网络访问");
            return 2;
        default:
            break;
    }
}

// 测试Wifi状态
- (void)testWifi {
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable) {
        NSLog(@"WiFi网络已经连接");
    } else {
        NSLog(@"WiFi网络不可用！");
    }
}

// 测试3G/4G网络状态
- (void)testInternet {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"3G/4G网络已经连接！");
    }
    else
    {
        NSLog(@"3G/4G网络不可用！");
    }
}


@end
