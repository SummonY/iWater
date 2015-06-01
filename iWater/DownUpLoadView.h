//
//  DownUpLoadView.h
//  iWater
//
//  Created by D404 on 15-4-6.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PassValueDelegate.h"

//位置
@protocol LocationHandlerDelegate <NSObject>

@required
-(void) didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation *)oldLocation;

@end

@interface DownUpLoadView : UIViewController<UIViewPassValueDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, NSURLConnectionDataDelegate> {
    
    // 位置
    CLLocationManager *locationManager;
    
    // 图片
    BOOL isCamera;
    NSString *imageName;        //图片名称
    UIImageView *imageView;
    UIImagePickerController *camera;
}

@property(nonatomic, retain)NSString *locationName;
@property(nonatomic, retain)NSString *locationXian;
@property(nonatomic, retain)NSString *locationCode;

// 位置
@property(nonatomic, strong) id<LocationHandlerDelegate> delegate;

// 经度纬度
@property(nonatomic, retain)UILabel *longitude;
@property(nonatomic, retain)UILabel *latitude;



- (void)downLoadWaterWorks:(id)sender;

@end
