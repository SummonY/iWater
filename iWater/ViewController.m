//
//  ViewController.m
//  iWater
//
//  Created by D404 on 15-4-5.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import "ViewController.h"
#import "iToast.h"
#import "TestNetwork.h"
#import "MBProgressHUD.h"
#import "DownUpLoadView.h"
#import "DownLoadWaterWorks.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *locationName;
    NSString *locationCode;
    NSString *locationXian;
    
    DownLoadWaterWorks* downLoadWW;
}

@synthesize passDelegate = _passDelegate;

#pragma mark ----初始化界面----
- (void)loadView
{
    [super loadView];
    // 获取屏幕大小
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    float userNameHigh = screenBounds.size.height*0.382;            //相对坐标点Y轴
    
    self.view = [[UIView alloc] initWithFrame:screenBounds];
    
    // 设置背景图片
    bgImage = [[UIImageView alloc] initWithFrame:screenBounds];
    [bgImage setImage:[UIImage imageNamed:@"bg"]];
    
    // 设置LOGO
    logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((screenBounds.size.width - 120) / 2, userNameHigh-150, 120, 110)];
    [logoImage setImage:[UIImage imageNamed:@"logo"]];
    
    // 设置软件名
    logoLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenBounds.size.width-180)/2 , userNameHigh, 180, 30)];
    [logoLabel setText:@"农村饮水工程"];
    [logoLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [logoLabel setTextColor:[UIColor whiteColor]];
    
    // 设置用户名和密码区域
    userNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(2, userNameHigh+169-130, screenBounds.size.width - 4, 40)];
    [userNameTxt setPlaceholder:@"请输入用户名"];
    userNameTxt.backgroundColor = [UIColor whiteColor];
    [userNameTxt setFont:[UIFont systemFontOfSize:14]];
    userNameTxt.clearButtonMode = UITextFieldViewModeAlways;
    userNameTxt.delegate = self;
    
    passwordTxt = [[UITextField alloc] initWithFrame:CGRectMake(2, userNameHigh+210-130, screenBounds.size.width - 4, 40)];
    [passwordTxt setPlaceholder:@"请输入密码"];
    passwordTxt.backgroundColor = [UIColor whiteColor];
    [passwordTxt setFont:[UIFont systemFontOfSize:14]];
    [passwordTxt setSecureTextEntry:YES];
    passwordTxt.clearButtonMode = UITextFieldViewModeAlways;
    passwordTxt.delegate = self;
    
    
    // 设置登录按钮
    loadBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, userNameHigh+280-130, screenBounds.size.width - 20, 40)];
    [loadBtn setBackgroundImage:[UIImage imageNamed:@"Btn"] forState:UIControlStateNormal];
    [loadBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loadBtn addTarget:self action:@selector(loadServer:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加到主视图
    [self.view addSubview:bgImage];
    [self.view addSubview:logoImage];
    [self.view addSubview:logoLabel];
    [self.view addSubview:userNameTxt];
    [self.view addSubview:passwordTxt];
    [self.view addSubview:loadBtn];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    downLoadWW = [[DownLoadWaterWorks alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ----用户登录服务器----
- (void) loadServer:(id)sender
{
    NSLog(@"用户登录...");
    loginName = userNameTxt.text;
    loginPassword = passwordTxt.text;
    
    if ([loginName isEqualToString:@""]) {
        [[iToast makeText:@"请输入用户名"] show];
        return ;
    }
    else if ([loginPassword isEqualToString:@""]) {
        [[iToast makeText:@"请输入密码"] show];
        return ;
    }
    
    // 检测网络连接
    TestNetwork *testNet = [[TestNetwork alloc] init];
    int netStatus = [testNet testNetStatus];
    if (netStatus == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络不可达" message:@"未检测到网络，请检查网络重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"正在登录...";
    [HUD showWhileExecuting:@selector(loginCheck) onTarget:self withObject:nil animated:YES];
    
}

#pragma mark ----验证用户信息----
- (void)loginCheck
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://219.140.162.169:8901/SCUploadProject/Login?loginName=%@&loginPassword=%@", loginName, loginPassword]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0f];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"data = %@", data);
    NSString *link = [[NSString alloc] initWithFormat:@"%@", data];
    link = [NSString stringWithCString:[link UTF8String] encoding:NSUTF8StringEncoding];
    NSLog(@"link = %@", link);
    
    if ([link isEqualToString:@"(null)"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"无法访问服务器，请确认网络连接正常!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    else
    {
        NSError *error = nil;
        NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *resultDic = [array objectAtIndex:0];
        NSString *auth = [resultDic objectForKey:@"loginState"];
        
        NSLog(@"%@", resultDic);
        NSLog(@"%@", auth);
        
        if ([auth isEqualToString:@"success"]) {
            locationName = [resultDic objectForKey:@"userShiArea"];
            locationCode = [resultDic objectForKey:@"userCode"];
            locationXian = [resultDic objectForKey:@"userXianArea"];
            //[[iToast makeText:@"正在登录，请稍等..."] show];*/
            [self performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:YES];
            //[self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误,请重新登录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
    }
}

#pragma mark ----登录成功----
- (void)loginSuccess
{
    DownUpLoadView* downUpView = [[DownUpLoadView alloc] init];
    self.passDelegate = downUpView;
    NSLog(@"Name:%@, Code:%@, Xian:%@", locationName, locationCode, locationXian);
    [_passDelegate setName:locationName setCode:locationCode setXian:locationXian];
    [self presentViewController:downUpView animated:YES completion:^{}];
    //[self performSegueWithIdentifier:@"loginSegue" sender:self];
}


#pragma mark ----点击空白，键盘自动消失----
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self->userNameTxt resignFirstResponder];
    [self->passwordTxt resignFirstResponder];
}


//屏幕上移
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

//屏幕下移
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up
{
    const int movementDistance = 150;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance:movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
