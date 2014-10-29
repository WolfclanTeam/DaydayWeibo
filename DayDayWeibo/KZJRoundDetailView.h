//
//  KZJRoundDetailView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface KZJRoundDetailView : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager* locationManager;
    int flag;
    int page;
    NSMutableArray *dataArr;
    NSDictionary*locationDict;
    float locationLatitude;
    float locationLongitude;
}
@property(retain,nonatomic)KZJWeiboTableView *weiboList;
@property (nonatomic, weak) UIButton *selectedBtn;
@property(retain,nonatomic)MKMapView *mapView;
@end
