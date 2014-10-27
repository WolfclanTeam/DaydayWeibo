//
//  KZJMeController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMeController.h"

@interface KZJMeController ()

@end

@implementation KZJMeController
@synthesize meTableView;
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
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"我";
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"navigationbar_background@2x"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    
    
    
//    [self initView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initView) name:@"login" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fans" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fans:) name:@"fans" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"picture" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(picture) name:@"picture" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"card" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myCard) name:@"card" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"myView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myView) name:@"myView" object:nil];
}
//我的主页
-(void)myView
{
    KZJMyHomeView*myHomeView = [[KZJMyHomeView alloc]init];
    myHomeView.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:myHomeView animated:NO];
}
//我的名片
-(void)myCard
{
    KZJCardView*card = [[KZJCardView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:card animated:YES];
}
//我的相册
-(void)picture
{
    KZJPictureView*picture = [[KZJPictureView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picture animated:YES];
    
}
//微博,粉丝,关注
-(void)fans:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    if ([dict objectForKey:@"btnTitle"]!=nil)
    {
        if ([[dict objectForKey:@"btnTitle"]isEqualToString:@"微博"])
        {
            KZJWeiboView *weiboView = [[KZJWeiboView alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weiboView animated:NO];
        }else
        {
            KZJFansView*view = [[KZJFansView alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            view.ID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
            view.kind = [dict objectForKey:@"btnTitle"];
            [self.navigationController pushViewController:view animated:NO];
        }
    }
}
//#pragma mark viewcontroller页面跳转代理
//-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//    return 2;
//}
//-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//{
//
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"登陆状态"] isEqualToString:@"已登陆"])
    {
        [self initView];
        
    }else
    {
        KZJLoginView*loginview = [[KZJLoginView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-113)withLabelTitle:@"你好" withImage:[UIImage imageNamed:@"accountmanage_add@2x"]];
        for (UIView*view in self.view.subviews)
        {
            [view removeFromSuperview];
        }
        [self.view addSubview:loginview];
    }
}
//初始化界面
-(void)initView
{
    arrayTableTitle = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"新的好友",@"完善资料", nil],[NSArray arrayWithObjects:@"我的相册",@"我的收藏",@"赞", nil],[NSArray arrayWithObjects:@"微博支付",@"个性化", nil],[NSArray arrayWithObjects:@"我的名片",@"草稿箱", nil], nil];
    
    arrayTableImage = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"findfriend_icon_popolarroots@2x",@"findfriend_icon_guess@2x", nil],[NSArray arrayWithObjects:@"timeline_icon_photo@2x",@"more_icon_collection1@2x",@"messagescenter_good@2x", nil],[NSArray arrayWithObjects:@"commercialize_payment_insurance_icon@2x",@"common_icon_membership@2x", nil],[NSArray arrayWithObjects:@"findfriends_tab_qrcode_highlighted@2x",@"timeline_card_small_article@2x", nil], nil];
    
    NSArray*array = [[KZJRequestData alloc]getCoreData:@"UserInformation"];
//    NSLog(@"%@",array);
    if (SCREENHEIGHT ==480)
    {
        if ([self.view.subviews count]>0)
        {
            //                meTableView.array = array;
            if (meTableView==nil)
            {
                meTableView = [[KZJMeTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,SCREENHEIGHT-113)];
            }
            [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:array];
            
//            NSLog(@"3132");
        }else
        {
//            NSLog(@"3132213");
            if (meTableView==nil)
            {
                meTableView = [[KZJMeTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREENHEIGHT-113)];
            }
            [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:array];
            //                NSLog(@"%@",array);
        }
    }else
    {
        //            meTableView.array = array;
        if (meTableView==nil)
        {
             meTableView = [[KZJMeTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREENHEIGHT-113)];
        }
        [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:array];
    }
    meTableView.scrollsToTop = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    for (UIView*view in self.view.subviews)
//    {
//        [view removeFromSuperview];
//    }
    [self.view addSubview:meTableView];
    
}

#pragma mark 设置按钮事件
-(void)setAction
{
    KZJSetView*setview = [[KZJSetView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setview animated:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;

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
