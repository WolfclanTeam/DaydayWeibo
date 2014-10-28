//
//  KZJHotWeiboView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJWeiboTableView.h"
@interface KZJHotWeiboView : UIViewController
{
    int page;
    NSMutableArray *dataArr;
}
@property(retain,nonatomic)KZJWeiboTableView *weiboList;
@end
