//
//  KZJRemindSubView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/30.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZJRemindSubView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(retain,nonatomic)NSString*kind;
@property(retain,nonatomic)NSArray*titlesArray;
@end
