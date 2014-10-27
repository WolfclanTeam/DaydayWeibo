//
//  KZJFindController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"KZJDealData.h"
#import"KZJLoadView.h"
#import"KZJFindView.h"
#import"KZJInformationCell.h"
#import"KZJHotTopicView.h"
#import"KZJFindManView.h"
#import"KZJHotWeiboView.h"
#import"KZJRoundView.h"


@interface KZJFindController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray*titleArray;
    NSArray*topicArray;
    NSArray*peopleArray;
//    NSArray*relationArray;
//    int flag,flag1;
    NSDictionary*dictDetail;
}
@property(retain,nonatomic)KZJFindView*topicTable;
@property(retain,nonatomic)UITableView*tableview;
@end
