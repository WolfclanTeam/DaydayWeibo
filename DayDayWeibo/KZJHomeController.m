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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_friendsearch@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    btn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    
    page = 1;
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49) view:self.tabBarController.view];
    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    [dataManger getHomeWeibo];
    [dataManger passWeiboData:^(NSDictionary *dict) {
        dataArr = [dict objectForKey:@"statuses"];
        weiboList.dataArr = dataArr;
        [self.navigationController.view addSubview:weiboList];
        
        [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
        [weiboList headerBeginRefreshing];
        [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
        
        weiboList.headerRefreshingText = @"加载中";
        weiboList.footerRefreshingText = @"加载中";
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"DETAILWEIBO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"CLICKCOMMENT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushWebView:) name:@"WEBPUSH" object:nil];
}

-(void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        [datamanager getHomeWeibo];
        
        [datamanager passWeiboData:^(NSDictionary *dict) {
            weiboList.dataArr = [dict objectForKey:@"statuses"];
            [weiboList reloadData];
            page = 1;
        }];
        
        [weiboList reloadData];
        [weiboList headerEndRefreshing];
    });
}
//
//
-(void)footerRefresh
{
    page++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        [datamanager getNewWeibo:[NSString stringWithFormat:@"%d",page]];
        
        [datamanager passWeiboData:^(NSDictionary *dict) {
            NSMutableArray *weibos = [NSMutableArray arrayWithArray:weiboList.dataArr];
            for (int i =0; i<[[dict objectForKey:@"statuses"] count]; i++)
            {
                [weibos addObject:[[dict objectForKey:@"statuses"] objectAtIndex:i]];
            }
            NSLog(@"====%d",[weibos count]);
            weiboList.dataArr = weibos;
            
            [weiboList headerEndRefreshing];
            [weiboList reloadData];
        }];
        
        [weiboList reloadData];
        [weiboList footerEndRefreshing];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)pushDetailWeibo:(NSNotification*)noti
{
    NSLog(@"===%@,",noti.name);
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
