//
//  KZJFindController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"KZJDealData.h"
#import"KZJLoadView.h"
#import"KZJFindView.h"
#import"KZJInformationCell.h"
#import"KZJHotTopicView.h"
#import"KZJFindManView.h"
#import"KZJHotWeiboView.h"
#import"KZJRoundView.h"
#import "SlideAnimation.h"
#import"iflyMSC.framework/Headers/IFlyRecognizerViewDelegate.h"
#import"iflyMSC.framework/Headers/IFlyRecognizerView.h"
//#import "iflyMSC/IFlyRecognizerViewDelegate.h"
//#import "iflyMSC/IFlyRecognizerView.h"
#import"iflyMSC.framework/Headers/IFlySpeechUtility.h"
#import"iflyMSC.framework/Headers/IFlySpeechConstant.h"

@interface KZJFindController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,IFlyRecognizerViewDelegate>
{
    NSArray*titleArray;
    NSArray*topicArray;
    NSArray*peopleArray;
//    NSArray*relationArray;
//    int flag,flag1;
    NSDictionary*dictDetail;
    SlideAnimation *slideAnimationController;
    
    
    IFlyRecognizerView*iflyRecognizerView;
}
@property(retain,nonatomic)KZJFindView*topicTable;
@property(retain,nonatomic)UITableView*tableview;
@end
