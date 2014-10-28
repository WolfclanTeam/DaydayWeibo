//
//  KZJCollectView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZJCollectView : UIViewController
{
    NSMutableArray *dataArr;
    int page;
}
@property(retain,nonatomic)KZJWeiboTableView *weiboList;
@end
