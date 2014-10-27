//
//  KZJFindView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"KZJDealData.h"
@interface KZJFindView : UITableView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray*titleDetailArray;
    NSArray*titleImageDetailArray;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTitle:(NSArray*)titleArray withTitleImage:(NSArray*)imageArray withTopicArray:(NSArray*)topicArray;
@end
