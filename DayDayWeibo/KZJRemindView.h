//
//  KZJRemindView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJRemindSubView.h"
@interface KZJRemindView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray*titleArray;
}
@property(retain,nonatomic)UITableView*tableview;

@end
