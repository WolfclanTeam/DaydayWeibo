//
//  KZJWeiboView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZJWeiboView : UIViewController
{
    NSMutableArray *dataArr;
    KZJWeiboTableView *weiboList;
    int page;
}
@end
