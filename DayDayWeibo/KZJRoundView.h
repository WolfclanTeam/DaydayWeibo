//
//  KZJRoundView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KZJWeiboTableView.h"
@interface KZJRoundView : UIViewController<UISearchBarDelegate,CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
    int flag;
    int page;
    NSMutableArray *dataArr;
    NSDictionary*locationDict;
}
@property(retain,nonatomic)KZJWeiboTableView *weiboList;
@end
