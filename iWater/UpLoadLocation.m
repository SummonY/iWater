//
//  UpLoadLocation.m
//  iWater
//
//  Created by D404 on 15-4-7.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import "UpLoadLocation.h"

@implementation UpLoadLocation

//位置

- (void)didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation{
    [latitudeLabel setText:[NSString stringWithFormat:
                            @"%f",newLocation.coordinate.latitude]];
    [longitudeLabel setText:[NSString stringWithFormat:
                             @"%f",newLocation.coordinate.longitude]];
    
}

+ (id) getSharedInstance{
    if (!DefaultManager) {
        DefaultManager = [[self allocWithZone:NULL]init];
        [DefaultManager initiate];
    }
    return DefaultManager;
}



-(void)startUpdating {
    [locationManager startUpdatingLocation];
}

-(void) stopUpdating{
    [locationManager stopUpdatingLocation];
}

- (IBAction)uploadLocation:(id)sender {
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"GPS服务不可用" message:@"未打开GPS,或未允许定位服务,请先打开GPS并允许定位服务,然后重试!" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else if ([waterWorkCode isEqualToString:@""]) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"选择水厂" message:@"尚未选择水厂,请选择水厂后重试！" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else
    {
        [locationManager startUpdatingLocation];
        NSLog(@"longitude = %@", longitudeLabel.text);
        NSLog(@"latitude = %@", latitudeLabel.text);
        
        NSString *SCCode = waterWorkCode;
        
        NSString *locationStr = [[NSString alloc] initWithFormat:@"http://219.140.162.169:8901/SCUploadProject/UploadGPSData?SCCode=%@&longtitude=%@&latitude=%@", SCCode, longitudeLabel.text, latitudeLabel.text];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:locationStr]];
        [request startSynchronous];
        NSLog(@"%@", [request responseString]);
        NSString * state = [request responseString];
        if ([state isEqualToString:@"ok"]) {
            [[iToast makeText:@"水厂位置信息上传成功！"] show];
        }
        else
        {
            UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"水厂位置信息上传失败!" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
            [alertLocation show];
        }
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if ([self.delegate respondsToSelector:@selector(didUpdateToLocation:fromLocation:)]) {
        [self.delegate didUpdateToLocation:oldLocation fromLocation:newLocation];
    }
}

@end
