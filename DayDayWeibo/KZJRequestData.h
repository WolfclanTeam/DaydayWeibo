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
-(NSString*)cacheNumber;
-(id)searchEntityName:(NSString*)name uid:(NSString*)uid;
-(void)startRequestData1;
-(void)startRequestData2;


#pragma mark 张立坚 的消息页面@我的  数据请求
/**
 
 "@我的"  数据请求
 */
-(void)zljRequestData1;
#pragma mark 张立坚 的消息页面 "评论"  数据请求
-(void)zljRequestData2;
#pragma mark  张立坚 的消息页面 "赞"  数据请求
-(void)zljRequestData3;

@end
