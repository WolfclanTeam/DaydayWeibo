//
//  KZJSetTableView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "KZJAccountView.h"
@interface KZJSetTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray*titleArray;
}
-(id)initWithFrame:(CGRect)frame withTitle:(NSArray*)arrayTitle;

@end
