//
//  SelectWaterWorksView.m
//  iWater
//
//  Created by D404 on 15-4-7.
//  Copyright (c) 2015年 D404. All rights reserved.
//

#import "SelectWaterWorksView.h"
#import "iToast.h"

@interface SelectWaterWorksView ()

@end

@implementation SelectWaterWorksView {
    NSMutableArray *codeList;
    BOOL isFiltered;
    UIView* mask;
}

//@synthesize waterWorks = _waterWorks;

#pragma mark ----加载视图----
- (void)loadView
{
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    // 设置导航条
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 15, screenBounds.size.width, 45)];
    navBar.backgroundColor = [UIColor grayColor];
    
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake((navBar.frame.size.width - 80) / 2, 0, 80, 45)];
    [title setText:@"选择水厂"];
    [title setFont:[UIFont boldSystemFontOfSize:20]];
    
    
    UIButton* returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, 2, 50, 40)];
    [returnBtn setTitle:@"返回" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(returnSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:title];
    [navBar addSubview:returnBtn];
    
    _waterWorks = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, screenBounds.size.height - 60)];
    _waterWorks.dataSource = self;
    _waterWorks.delegate = self;
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    [searchBar setPlaceholder:@"搜索"];
    searchBar.delegate = self;
    _waterWorks.tableHeaderView = searchBar;
    
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height - 90)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0;
    
    
    [self.view addSubview:navBar];
    [self.view addSubview:_waterWorks];
    [self.view addSubview:mask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 初始化
- (int)initTableView:(NSString*)locationName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString* jsonFileName = [[NSString alloc] initWithFormat:@"%@.json", locationName];
    NSLog(@"fileName = %@", jsonFileName);
    NSString *Json_path = [path stringByAppendingPathComponent:jsonFileName];
    NSLog(@"initiate Json_path = %@", Json_path);
    NSData *data = [NSData dataWithContentsOfFile:Json_path];
    NSString* exist = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (![exist isEqualToString:@""])
    {
        NSError *error;
        id JsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        _listarr = [[NSMutableArray alloc] init];
        codeList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [JsonObject count]; ++i)
        {
            NSDictionary *listdic = [JsonObject objectAtIndex:i];
            NSString *teamname = (NSString *) [listdic objectForKey:@"水厂名称"];
            NSString *teamCode = (NSString *) [listdic objectForKey:@"水厂编号"];
            [_listarr addObject:teamname];
            [codeList addObject:teamCode];
            NSLog(@"name = %@, Code = %@", teamname, teamCode);
        }
        //[_waterWorks reloadData];
        return 1;
    }
    return 0;
}

- (void)getCode:(NSString*)fromName
{
    int i, index;
    for(i = 0; i < _listarr.count; ++i)
    {
        if ([_listarr[i] isEqualToString:fromName])
        {
            index = i;
            break;
        }
    }
    _waterWorkCode = codeList[index];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered)
    {
        return [_searchResults count];
    }
    else
    {
        return [_listarr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (isFiltered)
    {
        //cell.textLabel.text = [_searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = _searchResults[indexPath.row];
    }
    else
    {
        //cell.textLabel.text = [_listarr objectAtIndex:indexPath.row];
        cell.textLabel.text = _listarr[indexPath.row];
    }
    return cell;
}


#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFiltered)
    {
        _waterWorkName = _searchResults[indexPath.row];
        //waterWorkCode = codeList[indexPath.row];
        [self getCode:_waterWorkName];
    }
    else
    {
        _waterWorkName = _listarr[indexPath.row];
        [self getCode:_waterWorkName];
        //waterWorkCode = codeList[indexPath.row];
    }
    NSLog(@"indexPath.row = %ld", (long)indexPath.row);
    NSLog(@"水厂名称 = %@, 水厂编号 = %@", _waterWorkName, _waterWorkCode);
    NSString *nameStr = [NSString stringWithFormat:@"您选择的是: %@",_waterWorkName];
    [[iToast makeText:nameStr] show];
    NSString* nsMessage = [NSString stringWithFormat:@"当前选择%@, 是否确认选择?", _waterWorkName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认选择?" message:nsMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"取消操作");
    }
    else if(buttonIndex == 1)
    {
        // 传值
        [[NSNotificationCenter defaultCenter] postNotificationName:@"passCodeAndName" object:self userInfo:@{@"code":_waterWorkCode, @"name":_waterWorkName}];
        // 界面返回
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}



#pragma mark ----返回主界面----
- (void)returnSelect:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


// 键盘搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* searchTerm = [searchBar text];
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", searchTerm];
    _searchResults = [[NSMutableArray alloc] initWithArray:[_listarr filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"searchResults = %@", _searchResults);
    [_waterWorks reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"Begin Editing");
    isFiltered = YES;
    searchBar.showsCancelButton = YES;
    mask.alpha = 0.3;
    _waterWorks.allowsSelection = NO;
    _waterWorks.scrollEnabled = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBar Text Did End Editing");
}

// 搜索输入文字修改时触发
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text did change");
    if ([searchText length] == 0)
    {
        isFiltered = NO;
        mask.alpha = 0.3;
        _waterWorks.allowsSelection = NO;
        _waterWorks.scrollEnabled = NO;
        [_waterWorks reloadData];
        return ;
    }
    isFiltered = YES;
    mask.alpha = 0;
    _waterWorks.allowsSelection = YES;
    _waterWorks.scrollEnabled = YES;
    
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@", searchText];
    _searchResults = [[NSMutableArray alloc] initWithArray:[_listarr filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"searchResults = %@", _searchResults);
    [_waterWorks reloadData];
}


// 点击取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"cancle button");
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    _waterWorks.allowsSelection = YES;
    _waterWorks.scrollEnabled = YES;
    [searchBar resignFirstResponder];
    mask.alpha = 0;
    isFiltered = NO;
    [_waterWorks reloadData];
}

@end
