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
@interface KZJRequestData : NSObject<WeiboSDKDelegate,UIApplicationDelegate,WBHttpRequestDelegate>



-(NSArray*)getCoreData:(NSString*)entityName;
-(int)textLength:(NSString *)dataString;
-(NSArray*)loginRank:(NSArray*)array;
-(NSArray *)deleteCoreData:(NSString *)entityName withData:(UserInformation*)info;
-(id)initOnly;

@end
