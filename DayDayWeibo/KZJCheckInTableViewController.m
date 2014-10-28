//
//  KZJCheckInTableViewController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCheckInTableViewController.h"

@interface KZJCheckInTableViewController ()
@property(retain,nonatomic)KZJRequestData *requestData;
@end

@implementation KZJCheckInTableViewController
@synthesize searchDisplayController,geoTableView,locationManager,requestData,myNavigationController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    addressArr = [[NSMutableArray alloc] init];
    checkin_user_numArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.geoTableView setTableFooterView:view];
    
    self.searchDisplayController.searchBar.hidden = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    if ([[[UIDevice currentDevice] systemVersion] intValue]>=8)
    {
        [locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkInPositionNoti:) name:@"checkInPositionNoti" object:nil];
    
    HUDProgress = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUDProgress.center = self.view.center;
    
    HUDProgress.textLabel.text = @"加载中...";
   
    [HUDProgress showInView:self.view];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backMethod)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    self.title =@"我在这里";
    
    //self.searchBar.delegate = self;
   
    
    allItems = [[NSArray alloc] init];
    NSLog(@"定位");
    requestData  = [KZJRequestData requestOnly];
    
    [self setupRefresh];
}
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0)
{
   
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mark =[placemarks objectAtIndex:0];
        currentLocation = [NSString stringWithFormat:@"%@,%@,%@,%@",[mark.addressDictionary objectForKey:@"State"],[mark.addressDictionary objectForKey:@"City"],[mark.addressDictionary objectForKey:@"SubLocality"],[mark.addressDictionary objectForKey:@"Street"]];
        NSLog(@"%@",[mark.addressDictionary objectForKey:@"Street"]);
         locationLatitude = manager.location.coordinate.latitude ;
         locationLongitude = manager.location.coordinate.longitude;
       
        [requestData zljRequestData4:locationLatitude Long:locationLongitude page:@"1"];
       
    }];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
  
}
-(void)checkInPositionNoti:(NSNotification*)note
{
    if (HUDProgress.isVisible)
    {
         [HUDProgress dismissAnimated:YES];
    }
    
    
    NSLog(@"我收到了");
    NSDictionary *infoDict = [note userInfo];
    addressArr = [infoDict objectForKey:@"address"];
    checkin_user_numArr = [infoDict objectForKey:@"checkin_user_num"];
    titleArr = [infoDict objectForKey:@"title"];
    
    static int onlyFirst = 1;
    if (onlyFirst)
    {
        [addressArr insertObject:@"所在区域" atIndex:0];
        [checkin_user_numArr insertObject:@"" atIndex:0];
        [titleArr insertObject:currentLocation atIndex:0];
        onlyFirst = 0;
    }
   
    self.searchDisplayController.searchBar.hidden = NO;
    [self.geoTableView reloadData];
    
    
    
}
// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    NSLog(@"搜索");
}
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"sfsdf搜索");
}
#pragma mark 返回方法
-(void)backMethod
{
    
    if (self.navigationController== self.myNavigationController)
    {
         [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",self.navigationController);
    }
   else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
        rows = [self.searchResults count];
        
    }else{
        
        rows = [titleArr count];
        
    }
    
    return rows;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle   reuseIdentifier:CellIdentifier] ;
      
    }
    
    /* Configure the cell. */
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
        
    }else{
        
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            cell.detailTextLabel.text =[addressArr objectAtIndex:0];
        }
        else
        {
             cell.detailTextLabel.text =[NSString stringWithFormat:@"%@人去过·%@",[checkin_user_numArr objectAtIndex:indexPath.row],[addressArr objectAtIndex:indexPath.row]];
        }
       
        
    }   
    
    return cell;
    

}

- (void)filterContentForSearchText:(NSString*)searchText                               scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate                                      predicateWithFormat:@"SELF contains[cd] %@",                                     searchText];
    
    self.searchResults = [allItems filteredArrayUsingPredicate:resultPredicate];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{

    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.geoTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    
    
    self.geoTableView.footerPullToRefreshText = @"更多";
    self.geoTableView.footerReleaseToRefreshText = @"加载中...";
    self.geoTableView.footerRefreshingText = @"加载中...";
}

#pragma mark 开始进入刷新状态

- (void)footerRereshing
{
    static int page =1;
    
    [self.requestData zljRequestData4:locationLatitude Long:locationLongitude page:[NSString stringWithFormat:@"%d",++page]];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.geoTableView footerEndRefreshing];
    });
}


//接下来是UISearchDisplayController的委托方法，负责响应搜索事件：



#pragma mark - UISearchDisplayController delegate methods

//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
//    
//    [self filterContentForSearchText:searchString                                 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
//    
//    return YES;
//    
//}

//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
//    
//    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]                                 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]                                       objectAtIndex:searchOption]];
//    
//    return YES;
//    
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
   UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 2, 30, 40)];
    imageView.image = [UIImage imageNamed:@"common_checkbox_checked@2x"];
    imageView.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:imageView];
    KZJShareController *shareController = [[KZJShareController alloc] init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //cube
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController: shareController animated:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[titleArr objectAtIndex:indexPath.row] forKey:@"myLocation"];
    [userDefaults synchronize];
}


@end
