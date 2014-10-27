//
//  KZJDetailWeiboViewController.h
//  WeiboTest
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailWeiboTableView.h"

@interface KZJDetailWeiboViewController : UIViewController
{
    DetailWeiboTableView *detail;
}
@property(nonatomic,retain)NSDictionary *dataDict;

@end
