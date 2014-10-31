//
//  KZJDetailWeiboViewController.m
//  WeiboTest
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "KZJDetailWeiboViewController.h"

@interface KZJDetailWeiboViewController ()

@end

@implementation KZJDetailWeiboViewController
@synthesize dataDict,fromCom,kind;

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
    num = 1;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //标题
    self.title = @"微博正文";
    //返回按钮设置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushWebView:) name:@"COMPUSHWEB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCommentWeibo:) name:@"COMMENTWEIBO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyComment:) name:@"REPLYCOMMENT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRetWeibo:) name:@"DETAILRETWEIBO" object:nil];

    //分享按钮设置
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_more@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    shareBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:shareItem];
    
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    NSNumber *weiboID = [dataDict objectForKey:@"id"];
    NSString *str = [NSString stringWithFormat:@"%@",weiboID];
    
    self.automaticallyAdjustsScrollViewInsets  = NO;
    
    [datamanager getCommentList:str];
    [datamanager passWeiboData:^(NSDictionary *dict) {
        if ([kind isEqualToString:@"非模态"])
        {
            detail = [[DetailWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30) dataDict:dataDict superView:self.view];
        }else if ([kind isEqualToString:@"非模态1"])
        {
            detail = [[DetailWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30) dataDict:dataDict superView:self.view];
        }
        else
        {
            detail = [[DetailWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-30) dataDict:dataDict superView:self.view];
        }
        
        detail.commentsArr = [dict objectForKey:@"comments"];
        if (self.fromCom == YES)
        {
            [detail reloadData];
        }
//        self.navigationController.view = detail;
        [detail addHeaderWithTarget:self action:@selector(headerRefresh)];
        [detail addFooterWithTarget:self action:@selector(footerRefresh)];
        
        detail.headerRefreshingText = @"加载中";
        detail.footerRefreshingText = @"加载中";
        
    }];
}

-(void)pushRetWeibo:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    NSLog(@"%@",dict);
    KZJTranspondWeiboViewController *retweetWeibo = [[KZJTranspondWeiboViewController alloc] init];
    [self.navigationController pushViewController:retweetWeibo animated:YES];

}

-(void)replyComment:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    NSLog(@"%@",dict);
    KZJCommentWeiboViewController *replyComment = [[KZJCommentWeiboViewController alloc] init];
    [replyComment passTitle:^(NSString *string) {
        string = @"回复评论";
    }];
//    replyComment.titleText = @"回复评论";
    [self.navigationController pushViewController:replyComment animated:YES];
    
}

-(void)pushCommentWeibo:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    NSLog(@"%@",dict);
    KZJCommentWeiboViewController *commentWeibo = [[KZJCommentWeiboViewController alloc] init];
    [self.navigationController pushViewController:commentWeibo animated:YES];
    
}

-(void)shareBtnAction:(id)sender
{
    KZJShareSheet*view = [KZJShareSheet shareWeiboView];
    [self.navigationController.view addSubview:view];
}

-(void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [detail headerEndRefreshing];
       
    });
}
//
//
-(void)footerRefresh
{
    num++;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    NSNumber *weiboID = [dataDict objectForKey:@"id"];
    NSString *str = [weiboID stringValue];
    NSString *page = [NSString stringWithFormat:@"%d",num];
    [datamanager getNewComment:str page:page];
    [datamanager passWeiboData:^(NSDictionary *dict) {
        if ([[dict objectForKey:@"comments"] count] ==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多评论了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [detail footerEndRefreshing];
        }else
        {
            NSMutableArray *comData = [NSMutableArray arrayWithArray:detail.commentsArr];
            NSArray *array = [dict objectForKey:@"comments"];
            for (int i = 0;i < [array count];i++)
            {
                [comData addObject:[array objectAtIndex:i]];
            }
            detail.commentsArr = comData;
            [detail reloadData];
            [detail footerEndRefreshing];
        }
    }];
}

-(void)pushWebView:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    KZJWebViewController *webView = [[KZJWebViewController alloc] init];
    UINavigationController *nav_webView = [[UINavigationController alloc] initWithRootViewController:webView];
    webView.urlString = [dict objectForKey:@"http"];
    [self presentViewController:nav_webView animated:YES completion:nil];
}

-(void)backAction
{
    if ([kind isEqualToString:@"非模态"])
    {
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }else if ([kind isEqualToString:@"非模态1"])
    {
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
