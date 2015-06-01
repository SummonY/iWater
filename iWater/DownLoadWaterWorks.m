//
//  DownLoadWaterWorks.m
//  iWater
//
//  Created by D404 on 15-4-7.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import "DownLoadWaterWorks.h"
#import "iToast.h"
#import "TestNetwork.h"

@implementation DownLoadWaterWorks

@synthesize locationName = _locationName;
@synthesize locationCode = _locationCode;
@synthesize locationXian = _locationXian;

@synthesize exist = _exist;

#pragma mark ----下载水厂列表----
-(int)downloadList
{
    NSError *error;
    NSString *url = [[NSString alloc] initWithFormat:@"http://219.140.162.169:8901/SCUploadProject/DownloadSCName?paramCode=%@", _locationCode];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    _exist = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"reponse = %@", response);
    if (!response) {
        return -1;
    }
    NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    _listarr = [[NSMutableArray alloc] init];
    codeList = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array count]; ++i) {
        NSDictionary *listdic = [array objectAtIndex:i];
        NSString *teamname = (NSString *) [listdic objectForKey:@"水厂名称"];
        NSString *teamCode = (NSString *) [listdic objectForKey:@"水厂编号"];
        [_listarr addObject:teamname];
        [codeList addObject:teamCode];
        //NSLog(@"name = %@, code = %@", teamname, teamCode);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    if ([_locationXian isEqualToString:@""]) {
        jsonFileName = [[NSString alloc] initWithFormat:@"%@.json", _locationName];
    }
    else
    {
        jsonFileName = [[NSString alloc] initWithFormat:@"%@.json", _locationXian];
    }
    
    NSString *Json_path = [path stringByAppendingPathComponent:jsonFileName];
    [response writeToFile:Json_path atomically:YES];
    NSLog(@"%d", [response writeToFile:Json_path atomically:YES]);
    NSLog(@"%@", [response writeToFile:Json_path atomically:YES] ? @"Success" : @"Failed");
    int state = [response writeToFile:Json_path atomically:YES];
    if (state == 1)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

- (int)isExisted
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    if ([_locationXian isEqualToString:@""]) {
        jsonFileName = [[NSString alloc] initWithFormat:@"%@.json", _locationName];
    }
    else
    {
        jsonFileName = [[NSString alloc] initWithFormat:@"%@.json", _locationXian];
    }
    //jsonFileName = [[NSString alloc] initWithFormat:@"%@.json", _locationName];
    NSLog(@"fileName = %@", jsonFileName);
    NSString *Json_path = [path stringByAppendingPathComponent:jsonFileName];
    //NSLog(@"initiate Json_path = %@", Json_path);
    NSData *data = [NSData dataWithContentsOfFile:Json_path];
    _exist = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([_exist isEqualToString:@""]) {
        return 0;
    }
    else
        return 1;
}

// 初始化
- (void)setName:(NSString*)name setCode:(NSString*)code setXian:(NSString*)xian
{
    _locationName = name;
    _locationCode = code;
    _locationXian = xian;
}


@end
