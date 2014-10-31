//
//  KZJHomeController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJWeiboTableView.h"
#import"KZJDetailWeiboViewController.h"
#import"MJRefresh/MJRefresh.h"
#import "KZJDetailWeiboViewController.h"
#import "KZJWebViewController.h"
#import"KZJMyHomeView.h"
#import"ZBarViewController.h"
#import"KZJTranspondWeiboViewController.h"
#import "DWBubbleMenuButton.h"
@interface KZJHomeController : UIViewController
{
    int page;
    NSMutableArray *dataArr;
    KZJWeiboTableView *weiboList;
    UserInformation*info;
    NSArray *listArr;
    BOOL whoseWeibo;
}
@property(nonatomic,retain)UIButton * btnTitleView;
@property(strong,nonatomic)DWBubbleMenuButton *downMenuButton;
@end
