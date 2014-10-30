//
//  KZJ@MyCotentViewController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMyMessageDetailBaseController.h"
#import "KZJWeiboTableView.h"
#import "JGProgressHUD.h"
@interface KZJ_MyCotentViewController : KZJMyMessageDetailBaseController
{
    NSArray *listArr;
    
    KZJWeiboTableView *weiboTableView;
    
    NSMutableArray *statuseArr ;
}
@property(strong,nonatomic)KZJWeiboTableView *weiboTableView;
@end
