//
//  KZJRequestData.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KZJAppDelegate.h"
#import "UserInformation.h"
@interface KZJRequestData : NSObject<WeiboSDKDelegate,UIApplicationDelegate>
@property(retain,nonatomic)NSDictionary*userInformation;
@end
