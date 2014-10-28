//
//  KZJCollectView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCollectView.h"

@interface KZJCollectView ()

@end

@implementation KZJCollectView
@synthesize weiboList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收藏";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    page =1;

    
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) view:self.tabBarController.view];
    [self.view addSubview:weiboList];
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
    
    
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"myfavorites" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myfavorites:) name:@"myfavorites" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"myCollect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myCollect:) name:@"myCollect" object:nil];
    
}
-(void)myCollect:(NSNotification*)notif
{
    [weiboList headerEndRefreshing];
    [weiboList footerEndRefreshing];
    
    NSDictionary*dict = [notif userInfo];
    dataArr = [dict objectForKey:@"statuses"];
    NSLog(@"====%d",[dataArr count]);
    weiboList.dataArr = dataArr;
    [weiboList reloadData];
}
-(void)headerRefresh
{
    page =1;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData11:page];
    
}
//
-(void)footerRefresh
{
    
    page++;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData11:page];
    
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
