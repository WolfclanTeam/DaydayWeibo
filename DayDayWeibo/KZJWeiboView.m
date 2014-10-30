//
//  KZJWeiboView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJWeiboView.h"

@interface KZJWeiboView ()

@end

@implementation KZJWeiboView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"全部微博";
    
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) view:self.tabBarController.view];
    [self.view addSubview:weiboList];
    [weiboList addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"myweibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myWeibo:) name:@"myweibo" object:nil];
}

-(void)myWeibo:(NSNotification*)notif
{
    [weiboList headerEndRefreshing];
    [weiboList footerEndRefreshing];
    
    NSDictionary*dict = [notif userInfo];
    dataArr = [dict objectForKey:@"statuses"];
    weiboList.dataArr = dataArr;
    [weiboList reloadData];
}
-(void)headerRefreshing
{
    page = 1;
    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    [dataManger startRequestData5:page withType:@"0" withID:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
}
-(void)footerRefreshing
{
    page++;
    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    [dataManger startRequestData5:page withType:@"0" withID:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
}
-(void)back
{
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
