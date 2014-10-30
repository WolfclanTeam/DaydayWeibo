//
//  KZJHomeController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJHomeController.h"

@interface KZJHomeController ()

@end

@implementation KZJHomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_friendsearch@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    btn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    //
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_pop@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    moreBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    [moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:moreItem];
    
    
    
    //
    page = 1;
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-49) view:self.tabBarController.view];
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
    weiboList.headerRefreshingText = @"加载中";
    weiboList.footerRefreshingText = @"加载中";
    weiboList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.view addSubview:weiboList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"DETAILWEIBO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"CLICKCOMMENT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushWebView:) name:@"WEBPUSH" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUser:) name:@"PUSHUSER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefresh) name:@"REFRESH" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retweetWeibo:) name:@"RETWEIBO" object:nil];
}

-(void)moreBtnAction:(id)sender
{
    ZBarViewController *zbar = [[ZBarViewController alloc] init];
    UINavigationController *nav_zbar = [[UINavigationController alloc] initWithRootViewController:zbar];
    [self presentViewController:nav_zbar animated:YES completion:nil];
}

-(void)retweetWeibo:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    NSLog(@"%@",dict);
}

-(void)headerRefresh
{
    page = 1;
    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    [dataManger getHomeWeibo];
    [dataManger passWeiboData:^(NSDictionary *dict) {
        dataArr = [dict objectForKey:@"statuses"];
        weiboList.dataArr = dataArr;
        [weiboList headerEndRefreshing];
        [weiboList reloadData];
    }];
}
//
//
-(void)footerRefresh
{
    page++;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager getNewWeibo:[NSString stringWithFormat:@"%d",page]];
    [datamanager passWeiboData:^(NSDictionary *dict) {
        NSMutableArray *weibos = [NSMutableArray arrayWithArray:weiboList.dataArr];
        for (int i =0; i<[[dict objectForKey:@"statuses"] count]; i++)
        {
            [weibos addObject:[[dict objectForKey:@"statuses"] objectAtIndex:i]];
        }
        weiboList.dataArr = weibos;
        [weiboList footerEndRefreshing];
        [weiboList reloadData];
    }];
        
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)pushDetailWeibo:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    KZJDetailWeiboViewController *detailWeibo = [[KZJDetailWeiboViewController alloc] init];
    UINavigationController *nav_detailWeibo = [[UINavigationController alloc] initWithRootViewController:detailWeibo];
    detailWeibo.dataDict = dict;
    if ([noti.name isEqualToString:@"CLICKCOMMENT"])
    {
        detailWeibo.fromCom = YES;
    }else
    {
        detailWeibo.fromCom = NO;
    }
    [self presentViewController:nav_detailWeibo animated:YES completion:nil];
}

-(void)pushWebView:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    KZJWebViewController *webView = [[KZJWebViewController alloc] init];
    UINavigationController *nav_webView = [[UINavigationController alloc] initWithRootViewController:webView];
    webView.urlString = [dict objectForKey:@"http"];
    [self presentViewController:nav_webView animated:YES completion:nil];
}

-(void)pushUser:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    KZJWebViewController *webView = [[KZJWebViewController alloc] init];
    UINavigationController *nav_webView = [[UINavigationController alloc] initWithRootViewController:webView];
    
    webView.urlString = [NSString stringWithFormat:@"http://m.weibo.cn/u/%@",[dict objectForKey:@"userIDStr"]];
    [self presentViewController:nav_webView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
