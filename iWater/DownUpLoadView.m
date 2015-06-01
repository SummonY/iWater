//
//  DownUpLoadView.m
//  iWater
//
//  Created by D404 on 15-4-6.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import "DownUpLoadView.h"
#import "iToast.h"
#import "MBProgressHUD.h"
#import "DownLoadWaterWorks.h"
#import "SelectWaterWorksView.h"
#import "TestNetwork.h"
#import <AVFoundation/AVFoundation.h>

static DownUpLoadView *DefaultManager = nil;


@interface DownUpLoadView ()

@end

NSString *TMP_UPLOAD_IMG_PATH=@"";
NSString *imageNameHead=@"";

@implementation DownUpLoadView {
    //UIImageView* bgImage;
    // 界面
    UINavigationBar* navBar;
    UIScrollView* mainScroll;
    
    // 下载
    UIButton* downloadBtn;
    UILabel* loginCity;
      
    DownLoadWaterWorks* downLoadWW;
    // 选择水厂名称
    SelectWaterWorksView* selectWW;
    // 显示选择的水厂名称
    UILabel* WWNameShow;
    
    //选中水厂名字和编号
    NSString *waterWorkName;
    NSString *waterWorkCode;

    // 位置
    NSData* totalData;
    
    // 检测网络
    TestNetwork *testNet;
}

@synthesize locationName = _locationName;
@synthesize locationCode = _locationCode;
@synthesize locationXian = _locationXian;

#pragma mark ----加载界面----
- (void)loadView
{
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 获取屏幕大小
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    // 设置导航条
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 15, screenBounds.size.width, 45)];
    navBar.backgroundColor = [UIColor lightGrayColor];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake((navBar.frame.size.width - 180) / 2, 0, 180, 45)];
    [title setText:@"湖北省农村饮水工程"];
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    
    
    UIButton* logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenBounds.size.width - 52, 2, 50, 40)];
    [logOutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logOutBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:title];
    [navBar addSubview:logOutBtn];
    
    // 设置滚动条
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, screenBounds.size.width, screenBounds.size.height - 60)];
    [mainScroll setContentSize:CGSizeMake(screenBounds.size.width, screenBounds.size.height + 90)];
    
    // 设置下载区域
    UIView* downLoadView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, screenBounds.size.width - 10, 45)];
    UIImageView* downloadBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, downLoadView.frame.size.width, 45)];
    [downloadBG setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* downloadImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 30, 30)];
    [downloadImage setImage:[UIImage imageNamed:@"waterworks"]];
    UILabel* downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 110, 30)];
    [downloadLabel setText:@"获取水厂列表:"];
    
    downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(downLoadView.frame.size.width / 2, 7, downLoadView.frame.size.width / 2 - 5, 30)];
    [downloadBtn setTitle:@"下载水厂列表" forState:UIControlStateNormal];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"Btn"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downLoadWaterWorks:) forControlEvents:UIControlEventTouchUpInside];
    
    [downLoadView addSubview:downloadBG];
    [downLoadView addSubview:downloadImage];
    [downLoadView addSubview:downloadLabel];
    [downLoadView addSubview:downloadBtn];
    
    
    // 设置水厂选择区域
    UIView* seltWatWorksView = [[UIView alloc] initWithFrame:CGRectMake(5, 55, screenBounds.size.width - 10, 80)];
    UIImageView* seltWatWorksBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, seltWatWorksView.frame.size.width, seltWatWorksView.frame.size.height)];
    [seltWatWorksBG setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* seltWatWorksImg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 2, 30, 30)];
    [seltWatWorksImg setImage:[UIImage imageNamed:@"location"]];
    
    UILabel* seltTitle = [[UILabel alloc] initWithFrame:CGRectMake((seltWatWorksView.frame.size.width - 70) / 2, 2, 70, 30)];
    [seltTitle setText:@"选择水厂"];
    
    
    UIImageView* splitLineImg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 35, seltWatWorksView.frame.size.width - 6, 1)];
    [splitLineImg setImage:[UIImage imageNamed:@"line"]];
    UILabel* seltloginCityLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 40, 77, 35)];
    [seltloginCityLbl setText:@"水厂位置:"];
    loginCity = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 210, 35)];
    [loginCity setText:@""];
    
    UIButton* selectWWBtn = [[UIButton alloc] initWithFrame:CGRectMake(seltWatWorksView.frame.size.width - 93, 40, 90, 35)];
    [selectWWBtn setTitle:@"选择水厂>" forState:UIControlStateNormal];
    [selectWWBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [selectWWBtn setBackgroundColor:[UIColor whiteColor]];
    [selectWWBtn addTarget:self action:@selector(selectWaterWorksName:) forControlEvents:UIControlEventTouchUpInside];
    
    [seltWatWorksView addSubview:seltWatWorksBG];
    [seltWatWorksView addSubview:seltWatWorksImg];
    [seltWatWorksView addSubview:seltTitle];
    [seltWatWorksView addSubview:splitLineImg];
    [seltWatWorksView addSubview:seltloginCityLbl];
    [seltWatWorksView addSubview:loginCity];
    [seltWatWorksView addSubview:selectWWBtn];

        
    // 上传水厂位置信息
    UIView* uploadLocationView = [[UIView alloc] initWithFrame:CGRectMake(5, 140, screenBounds.size.width - 10, 150)];
    UIImageView* uploadLocationBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, uploadLocationView.frame.size.width, uploadLocationView.frame.size.height)];
    [uploadLocationBG setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* uploadLocationImg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 2, 30, 30)];
    [uploadLocationImg setImage:[UIImage imageNamed:@"location"]];
    
    UILabel* upLocTitle = [[UILabel alloc] initWithFrame:CGRectMake((uploadLocationView.frame.size.width - 70) / 2, 2, 70, 30)];
    [upLocTitle setText:@"水厂坐标"];
    
    UIImageView* splitLineImgloc = [[UIImageView alloc] initWithFrame:CGRectMake(3, 35, uploadLocationView.frame.size.width - 6, 1)];
    [splitLineImgloc setImage:[UIImage imageNamed:@"line"]];
    
    UILabel* WaterWorksNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 36, 77, 35)];
    [WaterWorksNameLbl setText:@"水厂名称:"];
    
    WWNameShow = [[UILabel alloc] initWithFrame:CGRectMake(80, 36, seltWatWorksView.frame.size.width - 80, 35)];
    [WWNameShow setText:@"(尚未选择水厂)"];
    
    UIImageView* splitLineImgloc2 = [[UIImageView alloc] initWithFrame:CGRectMake(3, 72, uploadLocationView.frame.size.width - 6, 1)];
    [splitLineImgloc2 setImage:[UIImage imageNamed:@"line"]];
    UILabel* longitudeLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 73, 40, 30)];
    [longitudeLbl setText:@"经度:"];
    _longitude = [[UILabel alloc] initWithFrame:CGRectMake(45, 73, 100, 30)];
    [_longitude setText:@""];
    UILabel* latitudeLbl = [[UILabel alloc] initWithFrame:CGRectMake(screenBounds.size.width / 2, 73, 40, 30)];
    [latitudeLbl setText:@"纬度:"];
    _latitude = [[UILabel alloc] initWithFrame:CGRectMake(screenBounds.size.width / 2 + 40, 73, 100, 30)];
    [_latitude setText:@""];
    
    UIImageView* splitLineImgloc3 = [[UIImageView alloc] initWithFrame:CGRectMake(3, 107, uploadLocationView.frame.size.width - 6, 1)];
    [splitLineImgloc3 setImage:[UIImage imageNamed:@"line"]];
    
    UILabel* uploadLocLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 110, 145, 35)];
    [uploadLocLabel setText:@"点击上传水厂坐标:"];
    
    UIButton* uploadLocBtn = [[UIButton alloc] initWithFrame:CGRectMake(uploadLocationView.frame.size.width / 2, 110, uploadLocationView.frame.size.width / 2 - 5, 35)];
    [uploadLocBtn setTitle:@"上传水厂坐标" forState:UIControlStateNormal];
    [uploadLocBtn setBackgroundImage:[UIImage imageNamed:@"Btn"] forState:UIControlStateNormal];
    [uploadLocBtn addTarget:self action:@selector(uploadLoc:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [uploadLocationView addSubview:uploadLocationBG];
    [uploadLocationView addSubview:uploadLocationImg];
    [uploadLocationView addSubview:upLocTitle];
    [uploadLocationView addSubview:splitLineImgloc];
    [uploadLocationView addSubview:WaterWorksNameLbl];
    [uploadLocationView addSubview:WWNameShow];
    [uploadLocationView addSubview:splitLineImgloc2];
    [uploadLocationView addSubview:longitudeLbl];
    [uploadLocationView addSubview:_longitude];
    [uploadLocationView addSubview:latitudeLbl];
    [uploadLocationView addSubview:_latitude];
    [uploadLocationView addSubview:splitLineImgloc3];
    [uploadLocationView addSubview:uploadLocLabel];
    [uploadLocationView addSubview:uploadLocBtn];

    
    // 上传水厂照片信息
    UIView* uploadPictureView = [[UIView alloc] initWithFrame:CGRectMake(5, 295, screenBounds.size.width - 10, mainScroll.contentSize.height - 300)];
    UIImageView* uploadPictureBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, uploadLocationView.frame.size.width, uploadPictureView.frame.size.height)];
    [uploadPictureBG setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView* uploadPicImg = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 30, 30)];
    [uploadPicImg setImage:[UIImage imageNamed:@"waterworks"]];
    
    UILabel* uploadPicTitle = [[UILabel alloc] initWithFrame:CGRectMake((uploadPictureView.frame.size.width - 70) / 2, 2, 70, 35)];
    [uploadPicTitle setText:@"水厂照片"];
    
    UIImageView* splitLine3Img = [[UIImageView alloc] initWithFrame:CGRectMake(3, 40, uploadPictureBG.frame.size.width - 6, 1)];
    [splitLine3Img setImage:[UIImage imageNamed:@"line"]];
    
    UILabel* showCamLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 55, 45, 30)];
    [showCamLbl setText:@"拍摄:"];
    
    UIButton* showCamBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 45, 50, 50)];
    [showCamBtn setImage:[UIImage imageNamed:@"showCamBtn"] forState:UIControlStateNormal];
    [showCamBtn addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* upPicLbl = [[UILabel alloc] initWithFrame:CGRectMake(uploadPictureView.frame.size.width / 2, 55, 45, 30)];
    [upPicLbl setText:@"上传:"];
    
    UIButton* upPicBtn = [[UIButton alloc] initWithFrame:CGRectMake(uploadPictureView.frame.size.width / 2 + 50, 45, 50, 50)];
    [upPicBtn setImage:[UIImage imageNamed:@"upPicBtn"] forState:UIControlStateNormal];
    [upPicBtn addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 124, uploadPictureView.frame.size.width - 40, uploadPictureView.frame.size.height - 130)];
    [imageView setBackgroundColor:[UIColor cyanColor]];
    
    [uploadPictureView addSubview:uploadPictureBG];
    [uploadPictureView addSubview:uploadPicImg];
    [uploadPictureView addSubview:uploadPicTitle];
    [uploadPictureView addSubview:splitLine3Img];
    [uploadPictureView addSubview:showCamLbl];
    [uploadPictureView addSubview:showCamBtn];
    [uploadPictureView addSubview:upPicLbl];
    [uploadPictureView addSubview:upPicBtn];
    [uploadPictureView addSubview:imageView];
    
    //添加约束
    [imageView sizeToFit];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint* constraint=[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:uploadPictureView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
    [uploadPictureView addConstraint:constraint];
    constraint=[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:showCamBtn attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2];
    [uploadPictureView addConstraint:constraint];
    constraint=[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:uploadPictureView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20];
    [uploadPictureView addConstraint:constraint];
    constraint=[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:uploadPictureView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20];
    [uploadPictureView addConstraint:constraint];
    
    // 添加视图到滚动条
    [mainScroll addSubview:downLoadView];
    [mainScroll addSubview:seltWatWorksView];
    [mainScroll addSubview:uploadLocationView];
    [mainScroll addSubview:uploadPictureView];
    
    // 添加到主视图
    [self.view addSubview:navBar];
    [self.view addSubview:mainScroll];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    downLoadWW = [[DownLoadWaterWorks alloc] init];
    [downLoadWW setName:_locationName setCode:_locationCode setXian:_locationXian];
    
    // 设置登录城市
    if (![_locationXian isEqualToString:@""])
    {
        [loginCity setText:[NSString stringWithFormat:@"%@ > %@ >", _locationName, _locationXian]];
    }
    else
    {
        [loginCity setText:[NSString stringWithFormat:@"%@ >", _locationName]];
    }
    
    // 若已经下载，则设置下载按钮为已下载。
    if ([downLoadWW isExisted]) {
        [downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
    }
    
    // 初始化选择水厂界面
    selectWW = [[SelectWaterWorksView alloc] init];
    if ([_locationXian isEqualToString:@""]) {
        [selectWW initTableView:_locationName];
    }
    else {
        [selectWW initTableView:_locationXian];
    }
    //[selectWW initTableView:_locationName];
    
    
    //位置
    [[DownUpLoadView getSharedInstance]setDelegate:self];
    [[DownUpLoadView getSharedInstance]startUpdating];
    

    // 利用通知传值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passCodeAndName:) name:@"passCodeAndName" object:nil];
    
    waterWorkName = @"";
    waterWorkCode = @"";
    imageName = @"";
    
    // 检测网络连接
    testNet = [[TestNetwork alloc] init];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ----用户退出----
- (void)logOut:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark ----下载水厂列表----
- (void)downLoadWaterWorks:(id)sender
{
    NSLog(@"下载水厂列表");
    if ([downLoadWW isExisted]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"重新下载?" message:@"水厂列表已下载，是否重新下载更新?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        int netStatus = [testNet testNetStatus];
        if (netStatus == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络不可达" message:@"未检测到网络，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else
        {
            MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.delegate = self;
            HUD.labelText = @"正在下载...";
            [HUD showWhileExecuting:@selector(downLoadWWList) onTarget:self withObject:selectWW.waterWorks animated:YES];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消操作");
    }
    else if(buttonIndex == 1)
    {
        // 检测网络连接
        int netStatus = [testNet testNetStatus];
        if (netStatus == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络不可达" message:@"未检测到网络，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else
        {
            MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.delegate = self;
            HUD.labelText = @"正在下载...";
            [HUD showWhileExecuting:@selector(downLoadWWList) onTarget:self withObject:selectWW.waterWorks animated:YES];
        }
    }
}

// 下载水厂列表
- (void)downLoadWWList
{
    int suc = [downLoadWW downloadList];
    if (suc == 1) {
        [downloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
        [downloadBtn setBackgroundColor:[UIColor lightGrayColor]];
        if ([_locationXian isEqualToString:@""]) {
            [selectWW initTableView:_locationName];
        }
        else {
            [selectWW initTableView:_locationXian];
        }
        
        [[iToast makeText:@"下载成功！"] show];
    }
    else if (suc == -1)
    {
        [self performSelectorOnMainThread:@selector(netError) withObject:self waitUntilDone:NO];
    }
    else
    {
        [[iToast makeText:@"下载成功！"] show];
    }
}

// 网络出现异常
- (void)netError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载失败" message:@"访问服务器出错，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark ----选择水厂----
- (void)selectWaterWorksName:(id)sender
{
    NSLog(@"选择水厂");
    if (![downLoadWW isExisted])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未下载" message:@"尚未下载水厂列表，是否下载?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return ;
    }
    else
    {
        [self presentViewController:selectWW animated:YES completion:^{}];
    }
}


// 使用代理传值，获取登录所在市、县、编码
- (void)setName:(NSString *)name setCode:(NSString *)code setXian:(NSString *)xian
{
    _locationName = name;
    _locationCode = code;
    _locationXian = xian;
}

// 使用通知传值，获取所选水厂编号、水厂名称
- (void)passCodeAndName:(NSNotification* )notification
{
    NSDictionary* codeAndNameDic = [notification userInfo];
    waterWorkCode = [codeAndNameDic objectForKey:@"code"];
    waterWorkName = [codeAndNameDic objectForKey:@"name"];
    
    [WWNameShow setText:waterWorkName];
    NSLog(@"水厂名称 = %@", WWNameShow.text);
    NSLog(@"水厂编号 = %@", waterWorkCode);
}

#pragma mark ----上传水厂位置信息----
// 初始化
-(void)initiate{
    NSLog(@"初始化位置管理器");
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
}

- (void)didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation{
    [_latitude setText:[NSString stringWithFormat:
                            @"%f",newLocation.coordinate.latitude]];
    [_longitude setText:[NSString stringWithFormat:
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
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    /*
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"定位服务未启用" message:@"位置信息获取失败，未打开定位服务，或未授权该软件定位功能，请先打开定位服务并授权该软件定位功能!" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alertLocation show];
        return;
    }*/
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        NSLog(@"null locationManager");
    }
    [locationManager startUpdatingLocation];
}

-(void) stopUpdating{
    [locationManager stopUpdatingLocation];
}

// 上传位置信息
- (void)uploadLoc:(id)sender {
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"定位服务未启用" message:@"未打开定位服务，或未授权该软件定位功能，请先在设置中打开定位服务并为该软件授权定位功能，然后重试!" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else if ([waterWorkCode isEqualToString:@""]) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"选择水厂" message:@"请先选择并确定您所在的水厂名称！" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else
    {
        [locationManager startUpdatingLocation];
        NSLog(@"longitude = %@", _longitude.text);
        NSLog(@"latitude = %@", _latitude.text);
        if ([_longitude.text isEqualToString:@""] || [_latitude.text isEqualToString:@""]) {
            UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"位置信息为空" message:@"尚未获取到位置信息，请打开定位服务并为该软件授权定位功能，并稍等后重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertLocation show];
        }
        
        int netStatus = [testNet testNetStatus];
        if (netStatus == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络不可达" message:@"未检测到网络，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://219.140.162.169:8901/SCUploadProject/UploadGPSData?SCCode=%@&longitude=%@&latitude=%@", waterWorkCode, _longitude.text, _latitude.text]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
            NSURLConnection* conn = [NSURLConnection connectionWithRequest:request delegate:self];
            
            if (conn == nil)
            {
                UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"服务器请求失败，请先检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertLocation show];
                return ;
            }
        }
    }
    
}

// 服务器响应时激发该方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"响应服务器数据的长度：%lld", response.expectedContentLength);
}

// 接收服务器数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    totalData = data;
}

// 连接服务器失败时激发
- (void)connection:(NSURLConnection* )connection didFailWithError:(NSError *)error
{
    UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"无法连接服务器，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertLocation show];
}

// 数据加载完成
- (void)connectionDidFinishLoading:(NSURLConnection* )connection
{
    NSString* content = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
    NSLog(@"上传状态：%@", content);
    if ([content isEqualToString:@"ok"])
    {
        [[iToast makeText:@"水厂位置信息上传成功！"] show];
    }
    else
    {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"水厂位置信息上传失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if ([self.delegate respondsToSelector:@selector(didUpdateToLocation:fromLocation:)]) {
        [self.delegate didUpdateToLocation:oldLocation fromLocation:newLocation];
    }
}


#pragma mark ----拍摄并上传图像----

- (void)showCamera:(id)sender {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"相机功能不可用" message:@"无法拍摄照片，请先在设置中为该软件授权相机服务，然后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertLocation show];
        return ;
    }
    
    if ([waterWorkCode isEqualToString:@""]) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"选择水厂" message:@"尚未选择水厂,请选择水厂后重试！" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else
    {
        camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.allowsEditing = YES;
        isCamera = TRUE;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"相机不可用" message:@"摄像头不可用, 无法拍摄照片，请检查重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        [self presentViewController:camera animated:YES completion:^{}];
    }
}

//点击上传图片按钮
- (void)uploadImage:(id)sender {
    imageName = imageNameHead;
    NSLog(@"image name = %@", imageName);
    if ([imageName isEqualToString:@""]) {
        UIAlertView *alertLocation = [[UIAlertView alloc] initWithTitle:@"上传图片" message:@"尚未拍摄图片，请先选取水厂并拍摄后重试！" delegate:self cancelButtonTitle:@"取消上传" otherButtonTitles:nil, nil];
        [alertLocation show];
    }
    else
    {
        int netStatus = [testNet testNetStatus];
        if (netStatus == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络不可达" message:@"未检测到网络，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
        else
        {
            MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.delegate = self;
            HUD.labelText = @"正在上传照片...";
            [HUD showWhileExecuting:@selector(uploadWaterWorks) onTarget:self withObject:selectWW.waterWorks animated:YES];
        }
    }
}

// 上传照片
- (void)uploadWaterWorks
{
    NSString *SCCode = [[NSString alloc] initWithFormat:@"%@",waterWorkCode];
    NSLog(@"SCCode = %@", SCCode);
    //设置参数
    NSMutableDictionary *sugestDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [sugestDic setValue:[NSString stringWithFormat:@"%@", SCCode] forKey:@"SCCode"];
    
    NSString *result = [[NSString alloc] init];
    result = [self uploadPicture:sugestDic imagePathName:TMP_UPLOAD_IMG_PATH imageNameUp:imageName];
    NSLog(@"RUSULT = %@", result);
    if ([result isEqualToString:@"ok"])
    {
        [[iToast makeText:@"水厂照片信息上传成功！"] show];
    }
    else
    {
        UIAlertView *alertPic = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"水厂图片信息上传失败，请点击重新上传！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertPic show];
    }
}


#pragma mark 上传图片
- (NSString *)uploadPicture:(NSMutableDictionary *)sugestDic imagePathName:(NSString *)imagePathName imageNameUp:(NSString *)imageNameUp
{
    NSString *url = [[NSString alloc] initWithFormat:@"http://219.140.162.169:8901/SCUploadProject/UploadSCPic"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];

    NSLog(@"imagePathName = %@", imagePathName);
    
    NSString *boundary = @"---------------------------7db372eb000e2";
    NSString *mpBoundary = [[NSString alloc] initWithFormat:@"--%@", boundary];
    NSString *endMpBoundary = [[NSString alloc] initWithFormat:@"%@--", mpBoundary];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePathName];
    
    NSLog(@"%@", image);
    
    NSMutableString *body = [[NSMutableString alloc] init];
    
    NSArray *keys = [sugestDic allKeys];
    
    for (int i = 0; i < [keys count]; ++i) {
        NSString *key = [keys objectAtIndex:i];
        [body appendFormat:@"%@\r\n", mpBoundary];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [body appendFormat:@"%@\r\n", [sugestDic objectForKey:key]];
    }
    
    NSData *data;
    if (UIImagePNGRepresentation(image)) {
        NSLog(@"PNG image");
        data = UIImagePNGRepresentation(image);
        
        if (image) {
            [body appendFormat:@"%@\r\n", mpBoundary];
            [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", imageNameUp];
            [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
        }
    }
    else {
        NSLog(@"JPEG image");
        data = UIImageJPEGRepresentation(image, 0.5);
        if (image) {
            [body appendFormat:@"%@\r\n", mpBoundary];
            [body appendFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", imageNameUp];
            [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
        }
    }
    
    NSString *end = [[NSString alloc] initWithFormat:@"\r\n%@", endMpBoundary];
    NSMutableData *myRequestData = [NSMutableData data];
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:data];
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *content = [[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSLog(@"resultData = %@", resultData);
    NSLog(@"result = %@", result);
    
    return result;
}


#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    //[picker dismissModalViewControllerAnimated:YES];
    NSLog(@"info = %@", info);
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {         //若为相机，则保存到相册
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    imageName = [[NSString alloc] init];
    UIImage *newImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(300, 300)];
    imageName = [NSString stringWithFormat:@"%@%@", [self generateUuidString], @".png"];
    
    imageNameHead = [[NSString alloc] initWithString:imageName];
    [self saveImage:newImage WithName:imageName];
    //[picker dismissViewControllerAnimated:YES];
    
    NSLog(@"imagefile name = %@", imageName);
    
    isCamera = false;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    isCamera = false;
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}


//图片压缩
- (UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize
{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageNameF
{
    NSLog(@"保存图片");
    imageView.image = tempImage;
    NSLog(@"===TMP_UPLOAD_IMG_PATH===%@",TMP_UPLOAD_IMG_PATH);
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageNameF];
    
    // and then we write it out
    TMP_UPLOAD_IMG_PATH= [[NSString alloc] initWithString:fullPathToFile];
    NSArray *nameAry=[TMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
    NSLog(@"===new fullPathToFile===%@",fullPathToFile);
    NSLog(@"===new fullPathToFile===%@",TMP_UPLOAD_IMG_PATH);
    NSLog(@"===new FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
}

//产生UUID
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}


- (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

@end
