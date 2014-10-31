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
#import "KZJFansView.h"
#import "KZJWeiboView.h"
#import "KZJPictureView.h"
#import "KZJCardView.h"
#import "KZJMyHomeView.h"
#import "KZJCollectView.h"
#import "KZJDraftView.h"
#import "KZJNewFriendView.h"
#import "SlideAnimation.h"
@interface KZJMeController : UIViewController<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
{
    NSArray*arrayTableTitle;
    NSArray*arrayTableImage;
    SlideAnimation *slideAnimationController;
}
@property(retain,nonatomic)KZJMeTableView*meTableView;
@end
