//
//  KZJCommentTranspondBaseController.h
//  DayDayWeibo
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "KZJAppDelegate.h"
@interface KZJCommentTranspondBaseController : UIViewController<HPGrowingTextViewDelegate,UIAlertViewDelegate>

@property(retain,nonatomic)UILabel *whoLabel;
@property(retain,nonatomic)UILabel *titleLabel;
@property(retain,nonatomic)HPGrowingTextView *growingTextView;
@property(retain,nonatomic)UIToolbar *myToolBar;
@property(retain,nonatomic)UIButton *commentTranspondBtn;
@property(retain,nonatomic)UILabel *commentTranspondLabel;
@property(retain,nonatomic)UIImageView *commentTranspondImageView;
@property(retain,nonatomic)UIBarButtonItem *atItem;
@property(retain,nonatomic)UIBarButtonItem *searchHuaTiItem;
@property(retain,nonatomic)UIBarButtonItem *faceItem;
@property(retain,nonatomic)UIBarButtonItem *moreItem;
@property(retain,nonatomic)UIBarButtonItem *spaceButtonItem ;

@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;
@end
