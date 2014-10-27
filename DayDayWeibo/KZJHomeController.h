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

@interface KZJHomeController : UIViewController
{
    int page;
    NSMutableArray *dataArr;
    KZJWeiboTableView *weiboList;
}
@end
