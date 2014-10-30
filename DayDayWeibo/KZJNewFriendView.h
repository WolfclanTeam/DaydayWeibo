//
//  KZJNewFriendView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/30.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJInformationCell.h"
@interface KZJNewFriendView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    NSArray*dataArr;
}
@property(retain,nonatomic)UITableView*friendTable;
@end
