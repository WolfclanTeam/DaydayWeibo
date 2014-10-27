//
//  KZJShareScopeTableController.h
//  DayDayWeibo
//
//  Created by apple on 14-10-25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^changeWeiboVisibleScopeBlock)(NSString *str,int socpeValue);
@interface KZJShareScopeTableController : UITableViewController
{
    NSArray *scopeArr;
    NSMutableArray *imageScopeArr;
    NSUserDefaults *userDefaults;
}
@property(copy,nonatomic)changeWeiboVisibleScopeBlock scopeVisibleBlock;
@end
