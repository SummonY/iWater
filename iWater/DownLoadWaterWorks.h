//
//  DownLoadWaterWorks.h
//  iWater
//
//  Created by D404 on 15-4-7.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadWaterWorks : NSObject {
    NSString* jsonFileName;
    NSMutableArray *_listarr;
    NSMutableArray *codeList;
}

@property(nonatomic, retain)NSString *exist;
@property(nonatomic, retain)NSString *locationName;
@property(nonatomic, retain)NSString *locationCode;
@property(nonatomic, retain)NSString *locationXian;

- (int)downloadList;
- (int)isExisted;
- (void)setName:(NSString*)name setCode:(NSString*)code setXian:(NSString*)xian;


@end
