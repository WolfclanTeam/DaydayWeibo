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
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginOut" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initView) name:@"loginOut" object:nil];
}
-(void)reloadTable
{
//    [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:[[KZJRequestData alloc]getCoreData:@"UserInformation"]] ;
//    [meTableView reloadData];
//    [self initView];
    NSLog(@"退出");
}
-(void)viewWillAppear:(BOOL)animated
{
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
-(void)initView
{
    arrayTableTitle = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"新的好友",@"完善资料", nil],[NSArray arrayWithObjects:@"我的相册",@"我的收藏",@"赞", nil],[NSArray arrayWithObjects:@"微博支付",@"个性化", nil],[NSArray arrayWithObjects:@"我的名片",@"草稿箱", nil], nil];
    
    arrayTableImage = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"findfriend_icon_popolarroots@2x",@"findfriend_icon_guess@2x", nil],[NSArray arrayWithObjects:@"timeline_icon_photo@2x",@"more_icon_collection1@2x",@"messagescenter_good@2x", nil],[NSArray arrayWithObjects:@"userinfo_relationship_indicator_friends@2x",@"userinfo_relationship_indicator_friends@2x", nil],[NSArray arrayWithObjects:@"userinfo_relationship_indicator_friends@2x",@"timeline_card_small_article@2x", nil], nil];
    
    NSArray*array = [[KZJRequestData alloc]getCoreData:@"UserInformation"];
//    NSLog(@"%@",array);
    if (SCREENHEIGHT ==480)
    {
        if ([self.view.subviews count]>0)
        {
            //                meTableView.array = array;
            meTableView = [[KZJMeTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,SCREENHEIGHT-113)];
            [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:array];
            
            NSLog(@"3132");
        }else
        {
            NSLog(@"3132213");
            //                meTableView.array = [NSArray arrayWithArray:array];
            meTableView = [[KZJMeTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREENHEIGHT-113)];
            [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:array];
            //                NSLog(@"%@",array);
        }
    }else
    {
        //            meTableView.array = array;
        meTableView = [[KZJMeTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREENHEIGHT-113)];
        [meTableView  setWithTitle:arrayTableTitle withImage:arrayTableImage style:UITableViewStylePlain withArray:array];
    }
    meTableView.scrollsToTop = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    for (UIView*view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
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
