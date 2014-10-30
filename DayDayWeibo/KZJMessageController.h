//
//  KZJMessageController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJMessageTableView.h"
#import "KZJ@MyCotentViewController.h"
#import "UIImage+Redraw.h"
#import "SlideAnimation.h"
#import "KZJCommentViewController.h"
#import "KZJSupportViewController.h"
@interface KZJMessageController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>
{
   
   NSMutableArray *iconArr;  //消息页面的头像数组
   NSArray *titleArr;
}
@property(strong,nonatomic)KZJMessageTableView *messageTableView;


@end
