//
//  KZJMeTableView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CustomCell.h"

@interface KZJMeTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray*titleArray;
    NSArray*imageArray;
}
-(id)initWithFrame:(CGRect)frame withTitle:(NSArray*)arrayTitle withImage:(NSArray*)arrayImage style:(UITableViewStyle)style;

@end
