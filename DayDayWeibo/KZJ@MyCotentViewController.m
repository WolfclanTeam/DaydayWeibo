//
//  KZJ@MyCotentViewController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJ@MyCotentViewController.h"
 static int page =1;
@interface KZJ_MyCotentViewController ()

@end

@implementation KZJ_MyCotentViewController
@synthesize weiboTableView;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReceive:) name:@"receiveMyData" object:nil];
    
    listArr =@[@"所有微博", @"关注人的微博", @"原创微博", @"所有评论", @"关注人的评论"];
    
    statuseArr = [[NSMutableArray alloc] init];
    
    self.downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-50,64,100,30)
                                                                expansionDirection:DirectionDown];
    

    [self.downMenuButton addButtons:[self createDemoButtonArray]];
    self.downMenuButton.buttonSpacing = 0;
   
    
    //数据请求
    KZJRequestData *requsetData = [KZJRequestData requestOnly];
    [requsetData zljRequestData1:1];
    
    
    self.weiboTableView = [[KZJWeiboTableView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64) view:self.tabBarController.view];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.weiboTableView.tableFooterView = view;
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
    
    [self.view addSubview:self.weiboTableView];
     [self.view addSubview:self.downMenuButton];
}
-(void)dataReceive:(NSNotification*)note
{
   
    NSDictionary *dict = [note userInfo];
    NSArray*array = [dict objectForKey:@"statuses"];
    if ([array count] ==0)
    {
        JGProgressHUD *progress = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        progress.position = JGProgressHUDPositionBottomCenter;
        progress.textLabel.text = @"没有更多数据";
        progress.indicatorView =nil;
        
        [progress dismissAfterDelay:1 animated:YES];
        [progress showInView:self.view animated:YES];
        [self.weiboTableView removeFooter];
    }
    [statuseArr addObjectsFromArray:[dict objectForKey:@"statuses"]];
 
   self.weiboTableView.dataArr = statuseArr;
    [self.weiboTableView reloadData];
    
    
}
-(void)addHeader
{
    [self.weiboTableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    [self.weiboTableView headerBeginRefreshing];

}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    page =1;
    KZJRequestData *requsetData = [KZJRequestData requestOnly];
    [requsetData zljRequestData1:page];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.weiboTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.weiboTableView headerEndRefreshing];
    });
}
-(void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.weiboTableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
       
        KZJRequestData *requsetData = [KZJRequestData requestOnly];
        [requsetData zljRequestData1:++page];
        
        
        // 模拟延迟加载数据，因此2秒后才调用）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [vc.weiboTableView reloadData];
            // 结束刷新
            [vc.weiboTableView footerEndRefreshing];
        });
    }];
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
   
    
   
    [self.btnTitleView setTitle:[listArr objectAtIndex:(int)sender.tag] forState:UIControlStateNormal];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.downMenuButton dismissButtons];
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
