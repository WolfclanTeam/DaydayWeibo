//
//  KZJCommentViewController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMyMessageDetailBaseController.h"
#import "ZLJCostomTableViewCell.h"
#import "KZJXMLParser.h"
#import "JGProgressHUD.h"
#import "KZJCommentWeiboViewController.h"
#import "KZJDetailWeiboViewController.h"
@interface KZJCommentViewController : KZJMyMessageDetailBaseController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *listArr;
    NSMutableArray *avatar_largeArr;
    NSMutableArray *nameArr;
    NSMutableArray *created_atArr;
    NSMutableArray *statusCreated_atArr;
     NSMutableArray *sourceArr;
    NSMutableArray *bmiddle_picArr;
    NSMutableArray *textArr;
    NSMutableArray *statusNameArr;
    NSMutableArray *statusTextArr;
    KZJXMLParser *xmlParser;
    
    
    NSMutableArray *statusArr;
    
}
@property(retain,nonatomic)UITableView *myTableView;
@end
