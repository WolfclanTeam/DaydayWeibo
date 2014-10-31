//
//  KZJDraftView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJShareController.h"
#import "KZJCommentWeiboViewController.h"
@interface KZJDraftView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray*draftArray;
}
@property(retain,nonatomic)UITableView*draftTable;
@end
