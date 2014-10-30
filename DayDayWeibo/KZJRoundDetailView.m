//
//  KZJRoundDetailView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJRoundDetailView.h"

@interface KZJRoundDetailView ()

@end

@implementation KZJRoundDetailView
@synthesize mapview,weiboList,selectedBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"位置周边";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.0f;
//    if ([[[UIDevice currentDevice] systemVersion] intValue]>=8)
//    {
//        NSLog(@"%@",[[UIDevice currentDevice] systemVersion]);
//        [locationManager requestAlwaysAuthorization];
//    }
    [locationManager startUpdatingLocation];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) view:self.tabBarController.view];
    page = 1;
    weiboList.kind = self.navigationItem.title;
    [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
    [weiboList headerBeginRefreshing];
    [self.view addSubview:weiboList];
    weiboList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weiboList.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
        if (mapview==nil)
        {
            mapview = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
            mapview.delegate = self;
        }
        [view addSubview:mapview];
        NSArray*titleArray = [NSArray arrayWithObjects:@"微博",@"图片",@"人",@"地点", nil];
        for (int i = 0; i<4; i++)
        {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREENWIDTH/4*i, 150, SCREENWIDTH/4, 30);
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            btn.tag = 1000+i;
            if (flag==0&&i==0)
            {
                selectedBtn = btn;
            }
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(10+80*flag, 178, 60, 2)];
        line.backgroundColor = [UIColor orangeColor];
        line.tag = 999;
        [view addSubview:line];
        view;
    });
    
    flag =0;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"roundDetail" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(roundDetail:) name:@"roundDetail" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"photoDetailWeibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoDetailWeibo:) name:@"photoDetailWeibo" object:nil];
    
}
-(void)photoDetailWeibo:(NSNotification*)notif
{
    KZJDetailWeiboViewController*detailView = [[KZJDetailWeiboViewController alloc]init];
    //    NSLog(@"%@",[notif userInfo]);
    detailView.dataDict = [notif userInfo];
    detailView.kind = @"非模态";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:NO];
}
-(void)roundDetail:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    if (flag==0)
    {
        dataArr = [dict objectForKey:@"statuses"];
        weiboList.dataArr = dataArr;
        
    }else if (flag==1)
    {
        dataArr = [dict objectForKey:@"photo"];
//        NSLog(@"%@",dict);
        NSArray*photoB = [NSArray arrayWithArray:[dict objectForKey:@"photoBigger"]];
        weiboList.photoArray = dataArr;
        weiboList.photoBiggerArray = photoB;
    }else if (flag==2)
    {
        dataArr = [dict objectForKey:@"users"];

        weiboList.peopleArray = dataArr;
    }else if (flag==3)
    {
        dataArr = [dict objectForKey:@"pois"];
        NSLog(@"%@",dataArr);
        weiboList.addressArray = dataArr;
    }
    
    [weiboList reloadData];
    [weiboList headerEndRefreshing];
}
-(void)btnAction:(UIButton*)btn
{
    UILabel*line = (UILabel*)[self.view viewWithTag:999];
    selectedBtn = btn;
    flag = btn.tag-1000;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    line.frame = CGRectMake(10+80*flag, 178, 60, 2);
    [UIView commitAnimations];
    if ([btn.titleLabel.text isEqualToString:@"图片"])
    {
        [weiboList headerBeginRefreshing];
        [[KZJRequestData requestOnly]startRequestData14:page withLocationLat:locationLatitude withLocationLong:locationLongitude withType:btn.titleLabel.text];
        weiboList.flag = 2;
    }else if ([btn.titleLabel.text isEqualToString:@"微博"])
    {
        [weiboList headerBeginRefreshing];
        [[KZJRequestData requestOnly]startRequestData14:page withLocationLat:locationLatitude withLocationLong:locationLongitude withType:btn.titleLabel.text];
        weiboList.flag = 1;
    }else if ([btn.titleLabel.text isEqualToString:@"人"])
    {
        [weiboList headerBeginRefreshing];
        [[KZJRequestData requestOnly]startRequestData14:page withLocationLat:locationLatitude withLocationLong:locationLongitude withType:btn.titleLabel.text];
        weiboList.flag = 3;
    }else if ([btn.titleLabel.text isEqualToString:@"地点"])
    {
        [weiboList headerBeginRefreshing];
        [[KZJRequestData requestOnly]startRequestData14:page withLocationLat:locationLatitude withLocationLong:locationLongitude withType:btn.titleLabel.text];
        weiboList.flag = 4;
    }
    
}
-(void)headerRefresh
{
    page =1;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
//    NSLog(@"====3243546");
    
    CLGeocoder*coder = [[CLGeocoder alloc]init];
    [coder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        
         //移除所有大头针和气泡
         [mapview removeAnnotations:mapview.annotations];
         //
         if ([placemarks count]>0)
         {
             CLPlacemark*placeMark = [placemarks objectAtIndex:0];
             //设置显示区域region
             MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(placeMark.location.coordinate, 100, 100);
             [mapview setRegion:region animated:YES];
//             NSLog(@"%f,%f",mapview.centerCoordinate.latitude,mapview.centerCoordinate.longitude);
             //添加气泡信息
             MapLocation*annotation = [[MapLocation alloc]init];
             annotation.coordinate = placeMark.location.coordinate;
             annotation.state = [placeMark.addressDictionary objectForKey:@"State"];
             annotation.city = [placeMark.addressDictionary objectForKey:@"City"];
             annotation.streetAddress = [placeMark.addressDictionary objectForKey:@"Street"];
             annotation.zip = [placeMark.addressDictionary objectForKey:@"SubLocality"];
             [mapview addAnnotation:annotation];
             
             
             locationLatitude = manager.location.coordinate.latitude ;
             locationLongitude = manager.location.coordinate.longitude;
             
             [[KZJRequestData requestOnly]startRequestData14:page withLocationLat:locationLatitude withLocationLong:locationLongitude withType:@"微博"];
             
//             [[NSNotificationCenter defaultCenter]postNotificationName:@"roundDetail" object:nil];
         }
         
     }];
    
}
//设置大头针
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
//    NSLog(@"3243567");
    static NSString*mark = @"mark";
    MKPinAnnotationView*annotationView =(MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:mark];
    if (annotationView ==nil)
    {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:mark];
        annotationView.animatesDrop = YES;//大头针动画
        annotationView.canShowCallout = YES;//显示气泡信息
        annotationView.selected = YES;
    }
    return annotationView;
}
-(void)back
{
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
