//
//  KZJMessageController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMessageController.h"

@interface KZJMessageController ()
{
    SlideAnimation *slideAnimationController;
  
}
@end

@implementation KZJMessageController
@synthesize messageTableView;

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
   // self.tabBarController.delegate = self;
    //创建动画
    slideAnimationController  = [[SlideAnimation alloc] init];
   
    self.navigationController.delegate =self;
    [self setMyView];//设置MessageView给当前self.view
    [self initMessageTableView]; //初始化消息页面
    
    self.navigationItem.title = @"消息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发起聊天" style:UIBarButtonItemStylePlain target:self action:@selector(startChat)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
}
-(void)initMessageTableView
{
    iconArr = [[NSMutableArray alloc] initWithObjects:@"messagescenter_at",@"messagescenter_comments",@"messagescenter_good",@"messagescenter_messagebox@2x", nil];
    titleArr = @[@"@我的",@"评论",@"赞",@"未关注人私信"];
   
    
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource =self;
    [self.messageTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //自动刷新(一进入程序就下拉刷新)
    [self.messageTableView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.messageTableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.messageTableView.headerReleaseToRefreshText = @"释放更新";
    self.messageTableView.headerRefreshingText = @"加载中";
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [self.messageTableView setTableFooterView:view];
    

}
#pragma mark view的属性
-(void)setMyView
{
    self.messageTableView = [[KZJMessageTableView alloc] initWithFrame:self.view.bounds];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.view = self.messageTableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.messageTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.messageTableView headerEndRefreshing];
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
    
    cell.imageView.image =[UIImage redraw:[UIImage imageNamed:[iconArr objectAtIndex:indexPath.row]] Frame:CGRectMake(0, 0, 30, 30)];
    
    
    
    return cell;
}
#pragma mark UITableVIewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0)
    {
        [self performSelector:@selector(presentmyContentVC)];//@我的页面
    }
    else if (indexPath.row==1)
    {
        [self performSelector:@selector(presentmyCommentVC)];
    }
    else if (indexPath.row==2)
    {
        [self performSelector:@selector(presentmySupportVC)];
    }
    
}
-(void)presentmyContentVC
{
    KZJ_MyCotentViewController *myContentVC = [[KZJ_MyCotentViewController alloc] init]; //@我的页面
   
    [self.navigationController pushViewController:myContentVC animated:YES];
}
-(void)presentmyCommentVC
{
    KZJCommentViewController *commentVC = [[KZJCommentViewController alloc] init];
    [self.navigationController pushViewController:commentVC animated:YES];
}
-(void)presentmySupportVC
{
    KZJSupportViewController *supportVC = [[KZJSupportViewController alloc] init];
    [self.navigationController pushViewController:supportVC animated:YES];
}
#pragma mark 发起聊天
-(void)startChat
{
    NSLog(@"发起聊天");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation Controller Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
   
    
    BaseAnimation *animationController;
   
        animationController = slideAnimationController;
        switch (operation) {
        case UINavigationControllerOperationPush:
            animationController.type = AnimationTypePresent;
            return  animationController;
        case UINavigationControllerOperationPop:
            animationController.type = AnimationTypeDismiss;
            return animationController;
        default: return nil;
    }
    
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
