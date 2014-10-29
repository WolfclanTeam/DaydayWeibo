//
//  KZJHotTopicView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZJHotTopicView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(retain,nonatomic)NSArray*topicArray;
@end
