//
//  KZJCommentViewController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCommentViewController.h"
#import "UIImageView+WebCache.h"
@interface KZJCommentViewController ()

@end
KZJRequestData *requestData;
JGProgressHUD *HUD;
@implementation KZJCommentViewController
@synthesize myTableView;
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
    avatar_largeArr = [[NSMutableArray alloc] init];
    nameArr = [[NSMutableArray alloc] init];
    created_atArr = [[NSMutableArray alloc] init];
    statusCreated_atArr = [[NSMutableArray alloc] init];
    sourceArr = [[NSMutableArray alloc] init];
    bmiddle_picArr = [[NSMutableArray alloc] init];
    textArr = [[NSMutableArray alloc] init];
    statusNameArr = [[NSMutableArray alloc] init];
    statusTextArr = [[NSMutableArray alloc] init];
    statusArr = [[NSMutableArray alloc] init];
    
    xmlParser = [[KZJXMLParser alloc] init];
    
    __weak typeof (sourceArr)sourcArr = sourceArr;
    xmlParser.passValueBlock = ^(NSString *string)
    {
        [sourcArr addObject:string];
    };

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotifiData:) name:@"notifiMethod" object:nil];
    listArr = @[@"所有评论",@"关注人的",@"我发出的"];
    
    
   
    
    [self.btnTitleView setTitle:@"所有评论" forState:UIControlStateNormal];
    self.downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-50,64,100,30)
                                                 expansionDirection:DirectionDown];
    
    
    [self.downMenuButton addButtons:[self createDemoButtonArray]];
    self.downMenuButton.buttonSpacing = 0;
    
    [self addTableView];
    //进度条
    HUD= [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];

    [HUD showInView:self.view];
    [self.view addSubview:self.downMenuButton];
    
    requestData = [KZJRequestData requestOnly];
    [requestData zljRequestData2:1];

    // 2.集成刷新控件
    [self setupRefresh];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];

    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.myTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.myTableView.headerPullToRefreshText = @"下拉刷新";
    self.myTableView.headerReleaseToRefreshText = @"释放更新";
    self.myTableView.headerRefreshingText = @"加载中";
    
    self.myTableView.footerPullToRefreshText = @"更多...";
    self.myTableView.footerReleaseToRefreshText = @"更多...";
    self.myTableView.footerRefreshingText = @"加载中...";
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据

    [avatar_largeArr removeAllObjects] ;
    [nameArr removeAllObjects];
    [created_atArr removeAllObjects];
    [statusCreated_atArr removeAllObjects] ;
    [sourceArr removeAllObjects];
    [bmiddle_picArr removeAllObjects];
    [textArr removeAllObjects];
    [statusNameArr removeAllObjects];
    [statusTextArr removeAllObjects];
    
    [requestData zljRequestData2:1];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
      
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据
    static int page = 1;
    [requestData zljRequestData2:++page];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.myTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTableView footerEndRefreshing];
    });
}

#pragma mark 通知的方法
-(void)getNotifiData:(NSNotification*)note
{
    
    NSDictionary *dict = [note userInfo];

   NSArray *commentsArr = [dict objectForKey:@"comments"];
//    NSLog(@"%@",commentsArr);
    for (NSDictionary *commentsDict in commentsArr)
    {
        
        [avatar_largeArr addObject:[[commentsDict objectForKey:@"user"] objectForKey:@"avatar_large"]];
        [nameArr addObject:[[commentsDict objectForKey:@"user"] objectForKey:@"name"]];
        
       //[commentsDict objectForKey:@"created_at"]

        [created_atArr addObject:[self fommatTime:[commentsDict objectForKey:@"created_at"]]];
        
        
        [xmlParser iosParseXML:[commentsDict objectForKey:@"source"]];
        
        if ([[commentsDict objectForKey:@"status"] objectForKey:@"bmiddle_pic"]==nil)
        {
            [bmiddle_picArr addObject:[[[commentsDict objectForKey:@"status"] objectForKey:@"user"] objectForKey:@"avatar_large"]];

        }
        else
        {
           [bmiddle_picArr addObject:[[commentsDict objectForKey:@"status"] objectForKey:@"bmiddle_pic"]];
        }
        [textArr addObject:[commentsDict objectForKey:@"text"]];
        [statusNameArr addObject:[[[commentsDict objectForKey:@"status"]
                                  objectForKey:@"user"] objectForKey:@"name"]];
        [statusTextArr addObject:[[commentsDict objectForKey:@"status"] objectForKey:@"text"]];
        
        
        
        [statusArr addObject:[commentsDict objectForKey:@"status"]];
        
    }
 

    if ([HUD isVisible])
    {
        [HUD dismissAnimated:YES];
    }
    
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource =self;
    [self.myTableView reloadData];

}
#pragma mark 格式时间
-(NSString*)fommatTime:(NSString*)date
{
    
    NSDateFormatter *getFormatter = [[NSDateFormatter alloc] init];
    [getFormatter setDateFormat:@"EEE MMM dd H:mm:ss Z yyyy"];
     NSDate *inputDate = [getFormatter dateFromString:date];


    [getFormatter setLocale:[NSLocale currentLocale]];
    [getFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSString *strTime = [getFormatter stringFromDate:inputDate];
  
    return strTime;
}

-(void)addTableView
{
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.myTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.myTableView];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [avatar_largeArr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ZLJCostomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        //cell = [[ZLJCostomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      
            NSArray *nibTableCells = [[NSBundle mainBundle] loadNibNamed:@"ZLJCostomTableViewCell" owner:self options:nil];
            cell = [nibTableCells objectAtIndex:0];
        CALayer *l = [cell.avatarImageView layer];   //获取ImageView的层
        [l setMasksToBounds:YES];
        [l setCornerRadius:cell.avatarImageView.frame.size.height/2];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 252, 15)];
        titleLabel.tag = 10000;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [cell.weiboBtn addSubview:titleLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 252, 30)];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor grayColor];
        textLabel.tag = 10001;
        textLabel.font = [UIFont systemFontOfSize:10];
        [cell.weiboBtn addSubview:textLabel];
        
        [cell.replyBtn addTarget:self action:@selector(replyMethod) forControlEvents:UIControlEventTouchUpInside];
       
        [cell.weiboBtn addTarget:self action:@selector(myWeiboDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.weiboBtn setTag:indexPath.section];
    }
    
//    cell.backgroundColor = [UIColor redColor];
    if (nameArr.count>0)
    {
        cell.nameLabel.text = [nameArr objectAtIndex:indexPath.section];
    
    
    cell.timeLabel.text = [created_atArr objectAtIndex:indexPath.section];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[avatar_largeArr objectAtIndex:indexPath.section]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.sourceLabel.text = [NSString stringWithFormat:@"来自%@",[sourceArr objectAtIndex:indexPath.section]];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:[bmiddle_picArr objectAtIndex:indexPath.section]] placeholderImage:[UIImage imageNamed:@"ployhold.png"]];
    [cell.whoBtn setTitle:[textArr objectAtIndex:indexPath.section] forState:UIControlStateNormal];
    
    UILabel *statusNameLabel  =  (UILabel*)[cell.weiboBtn viewWithTag:10000];
    statusNameLabel.text = [statusNameArr objectAtIndex:indexPath.section];
    UILabel *statusLabel = (UILabel*)[cell.weiboBtn viewWithTag:10001];
    statusLabel.text = [statusTextArr objectAtIndex:indexPath.section];
    }
    return cell;
}
-(void)myWeiboDetail:(UIButton*)sender
{
   
    KZJDetailWeiboViewController *detailWeiboVC = [[KZJDetailWeiboViewController alloc] init];
    detailWeiboVC.dataDict = [statusArr objectAtIndex:[sender tag]] ;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detailWeiboVC];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
#pragma mark 回复评论 方法
-(void)replyMethod
{
    NSLog(@"回复");
    KZJCommentWeiboViewController *commentWeiboVC = [[KZJCommentWeiboViewController alloc] init];
    [self.navigationController pushViewController:commentWeiboVC animated:YES];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8; // you can have your own choice, of course
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    
    
    [self.btnTitleView setTitle:[listArr objectAtIndex:(int)sender.tag] forState:UIControlStateNormal];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.downMenuButton dismissButtons];
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
