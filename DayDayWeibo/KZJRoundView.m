//
//  KZJRoundView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJRoundView.h"

@interface KZJRoundView ()

@end

@implementation KZJRoundView
@synthesize weiboList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"周边";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
//    [KZJRequestData requestOnly]startRequestData12:1 withLocationLat:<#(float)#> withLocationLong:<#(float)#>
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=8)
    {
        NSLog(@"%@",[[UIDevice currentDevice] systemVersion]);
        [locationManager requestAlwaysAuthorization];
    }
    flag = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) view:self.tabBarController.view];
    page = 1;
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:weiboList];
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"roundweibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(roundweibo:) name:@"roundweibo" object:nil];
    
    
}
-(void)roundweibo:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    dataArr = [dict objectForKey:@"statuses"];
    weiboList.dataArr = dataArr;
    UserInformation*info = [[KZJRequestData requestOnly]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    weiboList.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 170)];
        UISearchBar*searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        searchBar.tag = 1000;
        searchBar.delegate = self;
        [view addSubview:searchBar];
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SCREENWIDTH, 55)];
        label.backgroundColor = [UIColor whiteColor];
        [view addSubview:label];
        UIImageView*imagePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 45, 45)];
        [imagePhoto sd_setImageWithURL:[NSURL URLWithString:info.photo]];
        [view addSubview:imagePhoto];
        
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREENWIDTH-50, 50, 40, 45);
        [btn setImage:[UIImage imageNamed:@"activity_card_locate@2x"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(daociyiyou) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 40, 20)];
        label1.text = @"到此一游";
        label1.font = [UIFont systemFontOfSize:10];
        label1.textColor = [UIColor blueColor];
        label1.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label1];
        
        UILabel*label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, SCREENWIDTH-120, 27)];
        label2.font = [UIFont systemFontOfSize:13];
        label2.text = [NSString stringWithFormat:@"位于%@",[locationDict objectForKey:@"Street"]];
        label2.textColor = [UIColor blackColor];
        [view addSubview:label2];
        
        UILabel*label3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 77, SCREENWIDTH-120, 18)];
        label3.font = [UIFont systemFontOfSize:10];
        label3.text = [NSString stringWithFormat:@"%@ %@",[locationDict objectForKey:@"City"],[locationDict objectForKey:@"SubLocality"]];
        label3.textColor = [UIColor grayColor];
        [view addSubview:label3];
        
        UILabel*label4 = [[UILabel alloc]initWithFrame:CGRectMake(0,105, SCREENWIDTH, 55)];
        label4.backgroundColor = [UIColor whiteColor];
        [view addSubview:label4];
        
        NSArray*titleArray = [NSArray arrayWithObjects:@"热点",@"吃喝玩乐",@"有缘人",@"足迹", nil];
        for (int i = 0; i<4; i++)
        {
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(SCREENWIDTH/4*i, 105, SCREENWIDTH/4, 55);
//            [button setBackgroundColor:[UIColor whiteColor]];
            [button setImage:[UIImage redraw:[UIImage imageNamed:@"compose_privatebutton_background@2x"] Frame:CGRectMake(0, 0, 35, 35)] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
            [view addSubview:button];
            UILabel*label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH/4, 25)];
            label5.textAlignment = NSTextAlignmentCenter;
            label5.text = titleArray[i];
            label5.font = [UIFont systemFontOfSize:11];
            label5.textColor = [UIColor blackColor];
            [button addSubview:label5];
        }
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [view.layer setBackgroundColor:colorref];
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        
        UIButton*btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 45, SCREENWIDTH-50, 55);
        [btn1 addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn1];
        view;
    });
    [weiboList reloadData];
    [weiboList headerEndRefreshing];
    [weiboList footerEndRefreshing];
}
-(void)nextView
{
    NSLog(@"dadsfdg");
}
//到此一游
-(void)daociyiyou
{
    NSLog(@"24268chdgbfu");
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations 
{
     NSLog(@"====3243546");
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark =[placemarks objectAtIndex:0];
//        NSString* currentLocation = [NSString stringWithFormat:@"%@,%@,%@,%@",[mark.addressDictionary objectForKey:@"State"],[mark.addressDictionary objectForKey:@"City"],[mark.addressDictionary objectForKey:@"SubLocality"],[mark.addressDictionary objectForKey:@"Street"]];
        NSLog(@"===%@",[mark.addressDictionary allKeys]);
        float locationLatitude = manager.location.coordinate.latitude ;
        float locationLongitude = manager.location.coordinate.longitude;
        if (!flag)
        {
            locationDict = [NSDictionary dictionaryWithDictionary:mark.addressDictionary];
            [[KZJRequestData requestOnly] startRequestData12:page withLocationLat:locationLatitude withLocationLong:locationLongitude];
            flag = 1;
        }
    }];
    
}
-(void)headerRefresh
{
    page =1;
    [locationManager startUpdatingLocation];
}

//
-(void)footerRefresh
{
    
    page++;
    [locationManager startUpdatingLocation];
}
-(void)back
{
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
