//
//  KZJ@MyCommentSupportBaseController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWBubbleMenuButton.h"
@interface KZJMyMessageDetailBaseController : UIViewController
{
    UIView *moveView;
}

@property(strong,nonatomic)UIButton *btnTitleView;
@property(strong,nonatomic)DWBubbleMenuButton *downMenuButton;
@end
