//
//  KZJDetailWeiboViewController.h
//  WeiboTest
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailWeiboTableView.h"
#import"KZJWebViewController.h"

@interface KZJDetailWeiboViewController : UIViewController
{
    DetailWeiboTableView *detail;
    UIScrollView *weiboScroll;
    int num;
    
}
@property(nonatomic,retain)NSDictionary *dataDict;
@property(nonatomic,assign)BOOL fromCom;
@property(retain,nonatomic)NSString*kind;

@end
