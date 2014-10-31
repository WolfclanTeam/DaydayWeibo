//
//  KZJHotWeiboView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJHotWeiboView.h"

@interface KZJHotWeiboView ()

@end

@implementation KZJHotWeiboView
@synthesize weiboList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"热门微博";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    page = 1;
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) view:self.tabBarController.view];
    weiboList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:weiboList];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hotweibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotweibo:) name:@"hotweibo" object:nil];
}
-(void)hotweibo:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    dataArr = [dict objectForKey:@"statuses"];
    weiboList.dataArr = dataArr;
    [weiboList reloadData];
    [weiboList headerEndRefreshing];
    [weiboList footerEndRefreshing];
}

-(void)headerRefresh
{
    page =1;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData13:page];
    
}

//
-(void)footerRefresh
{
    
    page++;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData13:page];
    
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
