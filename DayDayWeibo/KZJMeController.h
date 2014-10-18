//
//  KZJMeController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJMeTableView.h"
#import "KZJLoginView.h"
#import "KZJSetView.h"
@interface KZJMeController : UIViewController
{
    NSArray*arrayTableTitle;
    NSArray*arrayTableImage;
}
@property(retain,nonatomic)KZJMeTableView*meTableView;
@end
