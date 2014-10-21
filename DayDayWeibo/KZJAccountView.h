//
//  KZJAccountView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "UIImageView+WebCache.h"
@interface KZJAccountView : UITableView<UITableViewDataSource,UITableViewDelegate,WBHttpRequestDelegate>
{
    NSMutableArray*numberArray;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style numArray:(NSArray*)array;
@end
