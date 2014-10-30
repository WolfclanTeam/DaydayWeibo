//
//  KZJAboutView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<StoreKit/StoreKit.h>
@interface KZJAboutView : UIViewController<UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate,NSURLConnectionDataDelegate>
{
    NSArray*titleArray;
    NSURLConnection*getConnection;//post请求连接
    NSMutableData*getData;
    UIActivityIndicatorView*indicatorview ;

}
@property(retain,nonatomic)UITableView*tableview;

@end
