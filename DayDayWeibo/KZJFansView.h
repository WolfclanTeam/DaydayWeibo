//
//  KZJFansView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-21.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJInformationCell.h"
@interface KZJFansView : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int flag;
    NSArray*number,*relationArray;
    int page;
    NSDictionary*dictDetail;
    NSDictionary*dictDetail2;
}
@property(retain,nonatomic)NSString*kind;
@property(retain,nonatomic)NSString*ID;
@property(retain,nonatomic)UITableView*fanstable;


@end
