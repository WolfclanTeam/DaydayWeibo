//
//  KZJMyHomeView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJShareSheet.h"
@interface KZJMyHomeView : UIViewController<UISearchBarDelegate>
{
    NSMutableArray *dataArr;
    int page;
}
@property(retain,nonatomic)NSString*ID;
@property(retain,nonatomic)KZJWeiboTableView *weiboList;;
@end
