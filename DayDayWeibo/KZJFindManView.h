//
//  KZJFindManView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJInformationCell.h"
#import "KZJPullDownView.h"
#import "KZJInformationCell.h"
@interface KZJFindManView : UIViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,KZJPullDownViewProtocol>
{
    NSArray*manArray;
    NSDictionary*dictDetail;
    NSDictionary*dictDetail2;
    NSString*type;
    NSArray*peopleArray;
}
@property(retain,nonatomic)UITableView*tableview;
@property(retain,nonatomic)UITableView*findTable;
@end
