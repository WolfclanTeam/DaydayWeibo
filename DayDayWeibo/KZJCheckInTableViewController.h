//
//  KZJCheckInTableViewController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JGProgressHUD.h"
#import "KZJRequestData.h"
#import "KZJShareController.h"

@interface KZJCheckInTableViewController : UITableViewController<UISearchDisplayDelegate,CLLocationManagerDelegate>
{
   
    NSArray *allItems;
    NSMutableArray *addressArr;
    NSMutableArray *checkin_user_numArr; //去过数
    NSMutableArray *titleArr;
    
    CLLocationManager* locationManager;
    
    JGProgressHUD *HUDProgress;
    
    NSString *currentLocation;//当前位置

    float locationLatitude;
    float locationLongitude;
    
}
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (nonatomic, copy) NSArray *searchResults;
@property (strong, nonatomic) IBOutlet UITableView *geoTableView;

@property (strong, nonatomic)    CLLocationManager* locationManager;
@property(strong,nonatomic)UINavigationController *myNavigationController;

@end
