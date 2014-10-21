//
//  KZJRequestData.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJRequestData.h"

@implementation KZJRequestData

#pragma mark 微博返回信息
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess )
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"已登陆" forKey:@"登陆状态"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
            [user setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"Token"];
            [user setObject:[(WBAuthorizeResponse *)response userID] forKey:@"UserID"];
            [user synchronize];
            NSLog(@"%@",[(WBAuthorizeResponse *)response userID]);
            
            [self startRequestData1];
//            [self startRequestData2];
            
        }
    }
    
}
#pragma mark 微博请求信息
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
-(void)startRequestData1
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"uid",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"991"];

    NSDictionary*params2=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"uid",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://rm.api.weibo.com/2/remind/unread_count.json" httpMethod:@"GET" params:params2 delegate:self withTag:@"993"];
}
-(void)startRequestData2
{
    //    NSDictionary*params2=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/comments/to_me.json" httpMethod:@"GET" params:nil delegate:self withTag:@"992"];
}

#pragma mark 微博认证请求返回结果结束
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{

//    NSLog(@"%@",result);
    //    NSLog(@"===");
    if ([request.tag isEqualToString:@"991"])
    {
        [self userData:result];
//        NSLog(@"%@",result);
    }else if ([request.tag isEqualToString:@"992"])
    {
//        NSLog(@"%@",result);

    }else if ([request.tag isEqualToString:@"993"])
    {
        NSLog(@"%@",result);
        [self unread:result];
    }
}
#pragma mark 返回用户未读信息数(不包含未读微博)
-(void)unread:(NSString*)result
{
    NSDictionary*dict = [result objectFromJSONString];
    NSArray*keyArray = [NSArray arrayWithObjects:@"follower",@"cmt",@"dm",@"attention_follower",@"mention_status",@"mention_cmt",@"group", @"private_group",@"notice",@"invite",@"badge",@"photo",@"all_cmt",@"attention_follower",nil];
    int num=0;
    for (NSString*key in keyArray)
    {
        num+=[[dict objectForKey:key] intValue];
    }
//    NSLog(@"%d",num);
    
    KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    NSArray*array = [self getCoreData:@"UserInformation"];
    for (UserInformation*info in array)
    {
        if ([info.uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]])
        {
            info.unread = [NSString stringWithFormat:@"%d",num];
//            NSLog(@"%@",info.unread);
        }
    }
    [context save:nil];
}

@end
