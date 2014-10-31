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
@synthesize btnTitleView,downMenuButton;
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
    whoseWeibo = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Token"]!=nil)
    {
        info =[[[KZJRequestData alloc]init]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    }
    // Do any additional setup after loading the view.
    
    listArr = @[@"首页",@"好友圈",@"我的微博",@"周边微博"];
    
    
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
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) view:self.tabBarController.view];
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
    weiboList.headerRefreshingText = @"加载中";
    weiboList.footerRefreshingText = @"加载中";
    weiboList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:weiboList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"DETAILWEIBO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"CLICKCOMMENT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushWebView:) name:@"WEBPUSH" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUser:) name:@"PUSHUSER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefresh) name:@"REFRESH" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retweetWeibo:) name:@"RETWEIBO" object:nil];
    
    
    btnTitleView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, self.navigationItem.titleView.frame.size.height)];
    btnTitleView.titleLabel.text = info.name;
    [btnTitleView setTitle:info.name forState:UIControlStateNormal];
    //btnTitleView.titleLabel.font=[UIFont systemFontOfSize:14];
    btnTitleView.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btnTitleView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTitleView addTarget:self action:@selector(dropDownMenuMethod) forControlEvents:UIControlEventTouchUpInside];
    //btnTitleView.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView =btnTitleView;

    
    downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-50,64,100,30)
                                                          expansionDirection:DirectionDown];
    [self.downMenuButton addButtons:[self createDemoButtonArray]];
    self.downMenuButton.buttonSpacing = 0;

    
    [self.navigationController.view addSubview:downMenuButton];
}
-(void)dropDownMenuMethod
{
  
    static BOOL onOff = YES;
    
    if (onOff)
    {
        [self.downMenuButton showButtons];
        onOff = NO;
    }
    else
    {
        [self.downMenuButton dismissButtons];
        onOff = YES;
    }
}
- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in listArr) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(self.view.center.x, 64, 100.f, 30.f);
        //        button.layer.cornerRadius = button.frame.size.height / 2.f;
        //button.backgroundColor = [UIColor whiteColor];
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        //        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}
- (void)menuButtonAction:(UIButton *)sender {
    
    
    if (sender.tag == 0)
    {
        whoseWeibo = YES;
        [weiboList headerBeginRefreshing];
        NSLog(@"123");
    }else if (sender.tag == 2)
    {
        whoseWeibo = NO;
        [weiboList headerBeginRefreshing];
    }
    [self.btnTitleView setTitle:[listArr objectAtIndex:(int)sender.tag] forState:UIControlStateNormal];
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
    KZJTranspondWeiboViewController *retweetWeibo = [[KZJTranspondWeiboViewController alloc] init];
    retweetWeibo.whoLabelContent = [dict objectForKey:@"userID"];
    retweetWeibo.detailViewContent = [dict objectForKey:@"weiboText"];
    retweetWeibo.urlString = [dict objectForKey:@"weiboImageUrl"];
    retweetWeibo.Id = [dict objectForKey:@"weiboID"];
    retweetWeibo.status = [dict objectForKey:@"retWeibo"];
   [self.navigationController pushViewController:retweetWeibo animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)headerRefresh
{
    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    page = 1;
    if (whoseWeibo)
    {
                [dataManger getHomeWeibo];
        [dataManger passWeiboData:^(NSDictionary *dict) {
            dataArr = [dict objectForKey:@"statuses"];
            weiboList.dataArr = dataArr;
            [weiboList headerEndRefreshing];
            [weiboList reloadData];
        }];
    }else
    {
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        [datamanager startRequestData5:page withType:@"0" withID:info.uid];
        [datamanager passWeiboData:^(NSDictionary *dict)
         {
             dataArr = [dict objectForKey:@"statuses"];
             weiboList.dataArr = dataArr;
             [weiboList headerEndRefreshing];
             [weiboList reloadData];
        }];
    }
    
}
//
//
-(void)footerRefresh
{
    page++;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    if (whoseWeibo)
    {
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
    }else
    {
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        [datamanager startRequestData5:page withType:@"0" withID:info.uid];
        [datamanager passWeiboData:^(NSDictionary *dict)
         {
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
        
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
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
