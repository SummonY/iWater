//
//  ViewController.h
//  iWater
//
//  Created by D404 on 15-4-5.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface ViewController : UIViewController {
    UIImageView* bgImage;       // 背景
    UIImageView* logoImage;     // logo图片
    UILabel* logoLabel;         // logo文字
    UITextField* userNameTxt;   // 用户名
    UITextField* passwordTxt;   // 密码
    UIButton* loadBtn;          // 登录
    
    // 用户名、密码
    NSString* loginName;
    NSString* loginPassword;
    
    
}

@property (nonatomic, retain)id<UIViewPassValueDelegate>passDelegate;


@end

