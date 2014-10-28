//
//  KZJMyHomeView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMyHomeView.h"

@interface KZJMyHomeView ()

@end

@implementation KZJMyHomeView
@synthesize ID,weiboList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusBarView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20) view:self.tabBarController.view];
    weiboList.kind = @"我的主页";
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];

    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    [dataManger startRequestData5:1 withID:ID];
    [self.view addSubview:weiboList];
    
    NSArray*coverImages = [NSArray arrayWithObjects:@"page_cover_book_background@2x",@"page_cover_car_background@2x",@"page_cover_game_background@2x",@"page_cover_movie_background@2x",@"page_cover_music_background@2x",@"page_cover_poi_background@2x",@"page_cover_radio_background@2x",@"page_cover_topic_background@2x",@"page_cover_tv_background@2x", nil];
    int num = arc4random_uniform([coverImages count]);
    
    weiboList.tableHeaderView = ({
        UserInformation*info = [[KZJRequestData requestOnly]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
        
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
        UIImageView*imageCover = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 140)];
        imageCover.tag = 110;
        imageCover.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:coverImages[num] ofType:@"jpg"]];
        [view addSubview:imageCover];
        
        UIImageView*photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        photoImage.center = CGPointMake(SCREENWIDTH/2, 70);
        [photoImage sd_setImageWithURL:[NSURL URLWithString:info.photo]];
        photoImage.layer.cornerRadius = 25;
        photoImage.layer.borderWidth = 5;
        photoImage.layer.masksToBounds = YES;
        photoImage.layer.shouldRasterize = YES;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        photoImage.layer.borderColor = colorref;
        
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        [view addSubview:photoImage];
        
        UILabel*nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, SCREENWIDTH, 30)];
        nameLabel.text = info.name;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        [view addSubview:nameLabel];
        
        UIButton*fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fansBtn.frame = CGRectMake(160, 110, 60, 30);
        [fansBtn setTitle:[NSString stringWithFormat:@"粉丝 %@",info.care] forState:UIControlStateNormal];
        [fansBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:fansBtn];
        
        UIButton*careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        careBtn.frame = CGRectMake(100, 110, 60, 30);
        [careBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [careBtn setTitle:[NSString stringWithFormat:@"关注 %@",info.fans] forState:UIControlStateNormal];
        [view addSubview:careBtn];
        
        UILabel*detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 25)];
        detailLabel.text = [NSString stringWithFormat:@"简介:%@",info.brief];
        detailLabel.font = [UIFont systemFontOfSize:14];
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:detailLabel];
        
        UIButton*editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(0, 0, 80, 25);
        editBtn.center = CGPointMake(SCREENWIDTH/2, 180);
        [editBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
        //        editBtn.titleLabel.text = @"编辑资料";
        [editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        //        editBtn.titleLabel.textColor = [UIColor lightGrayColor];
        editBtn.layer.cornerRadius = 1;
        editBtn.layer.borderWidth = 1;
        editBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [editBtn setImage:[UIImage imageNamed:@"userinfo_relationship_indicator_edit@2x"] forState:UIControlStateNormal];
        [view addSubview:editBtn];
        view;
    });
    
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 25, 30, 25);
    btn.alpha = 0.5;
    btn.tag = 900;
    [btn setImage:[UIImage imageNamed:@"userinfo_navigationbar_back@2x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:btn];
    
    UIButton*find = [UIButton buttonWithType:UIButtonTypeCustom];
    find.frame = CGRectMake(SCREENWIDTH-75, 25, 30, 25);
    find.alpha = 0.5;
    find.tag = 901;
    [find setImage:[UIImage imageNamed:@"searchbar_textfield_search_icon_disable@2x"] forState:UIControlStateNormal];
    [find addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    [find setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:find];
    
    UIButton*share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(SCREENWIDTH-35, 25, 30, 25);
    share.alpha = 0.5;
    share.tag = 902;
    [share setImage:[UIImage imageNamed:@"music_more@2x"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [share setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:share];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hideCover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCover) name:@"hideCover" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NoHideCover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoHideCover) name:@"NoHideCover" object:nil];
 
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"photo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoShow:) name:@"photo" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"myweibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myWeibo:) name:@"myweibo" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"removeHeader" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeHead) name:@"removeHeader" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addHeader" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addHeader) name:@"addHeader" object:nil];
    
}

-(void)addHeader
{
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
}
-(void)removeHead
{
    [weiboList removeHeader];
    [weiboList removeFooter];
}
-(void)myWeibo:(NSNotification*)notif
{
    [weiboList headerEndRefreshing];
    [weiboList footerEndRefreshing];
    
    NSDictionary*dict = [notif userInfo];
    dataArr = [dict objectForKey:@"statuses"];
    NSLog(@"====%d",[dataArr count]);
    weiboList.dataArr = dataArr;
    [weiboList reloadData];
}

-(void)photoShow:(NSNotification*)notif
{
    //    [photoArray]
    weiboList.photoArray = [[notif userInfo] objectForKey:@"photo"];
                  
}
-(void)NoHideCover
{
    UIButton*btn =(UIButton*) [self.view viewWithTag:900];
    UIButton*find =(UIButton*) [self.view viewWithTag:901];
    UIButton*share =(UIButton*) [self.view viewWithTag:902];
    btn.hidden = NO;
    find.hidden = NO;
    share.hidden = NO;
}
-(void)hideCover
{
    UIButton*btn =(UIButton*) [self.view viewWithTag:900];
    UIButton*find =(UIButton*) [self.view viewWithTag:901];
    UIButton*share =(UIButton*) [self.view viewWithTag:902];
    btn.hidden = YES;
    find.hidden = YES;
    share.hidden = YES;
}
-(void)headerRefresh
{
    page =1;
     KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData5:page withType:@"0" withID:ID];
   
}
//
-(void)footerRefresh
{
    
    page++;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData5:page withType:@"0" withID:ID];
   
}
//返回按钮
-(void)back
{
    self.navigationController.navigationBarHidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
//查询按钮
-(void)find
{
    UISearchBar*searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, 44)];
    searchBar.delegate = self;
    
//    searchBar.showsCancelButton = YES;
    [self.view addSubview:searchBar];
    
    
}
//修改cancel样式
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    // 打印一下看上面的是什么类型，
    for(id cc in [searchBar subviews])
    {
        for (UIView *view in [cc subviews])
        {
//            for (UIView*view1 in view.subviews)
//            {
////                NSLog(@"%@",view1);
////                if ([NSStringFromClass(view1.class) isEqualToString:@"UIImageView"])
////                {
////                    UIImageView*image = (UIImageView*)view1;
////                    image.image = [UIImage imageNamed:@"more_icon_collection@2x 17"];
////                }
//            }
            // 在这打个断点试试看
            // 遍历出来的是UINavigationButton。不知道是不是类，反正我跟不出来所以把他转成字符串再比较
            if ([NSStringFromClass(view.class) isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar removeFromSuperview];
}
//分享按钮
-(void)share
{
    KZJShareSheet*view = [KZJShareSheet shareWeiboView];
    view.tag = 1000;
    [self.view addSubview:view];
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
