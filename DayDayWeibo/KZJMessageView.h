//
//  KZJMessage.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-19.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Redraw.h"
@interface KZJMessageView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *messageTableView;
@property(strong,nonatomic)NSMutableArray *iconArr;  //消息页面的头像数组
@end
