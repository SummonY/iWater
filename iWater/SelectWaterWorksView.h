//
//  SelectWaterWorksView.h
//  iWater
//
//  Created by D404 on 15-4-7.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"

@interface SelectWaterWorksView : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
}

@property(nonatomic, retain)UITableView* waterWorks;
@property(nonatomic, retain)NSMutableArray* listarr;
@property(nonatomic, retain)NSMutableArray* searchResults;
//选中水厂名字和编号
@property(nonatomic, retain)NSString* waterWorkName;
@property(nonatomic, retain)NSString* waterWorkCode;

- (int)initTableView:(NSString*)locationName;

@end
