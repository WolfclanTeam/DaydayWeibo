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
            
        }else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"未登陆" forKey:@"登陆状态"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
}
#pragma mark 微博请求信息
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
-(void)startRequestData1
{

//    NSLock*lock = [[NSLock alloc]init];
//    [lock lock];
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"uid",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"991"];
//    [lock unlock];
}
-(void)startRequestData2
{
    //    NSDictionary*params2=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/comments/to_me.json" httpMethod:@"GET" params:nil delegate:self withTag:@"992"];
}

#pragma mark 微博认证请求返回结果结束
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSLog(@"%@",request.tag);
    //    NSLog(@"===");
    if ([request.tag isEqualToString:@"991"])
    {
        [self userData:result];
        
    }else if ([request.tag isEqualToString:@"992"])
    {
//        NSLog(@"%@",result);

    }
}

#pragma mark 处理请求回来的用户个人信息
-(void)userData:(NSString*)result
{
    NSDictionary*dict = [result objectFromJSONString];
    //        NSLog(@"===%@",dict);
    KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    UserInformation*userInformation = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"UserInformation"
                                       inManagedObjectContext:context];
    
    userInformation.name = [dict objectForKey:@"name"];
    userInformation.photo = [dict objectForKey:@"avatar_hd"];
    
    
    userInformation.brief = [dict objectForKey:@"description"];
    userInformation.token = [[NSUserDefaults standardUserDefaults]objectForKey:@"Token"];
    userInformation.statuses = [NSString stringWithFormat:@"%@",[dict objectForKey:@"statuses_count"]];
    
    userInformation.care =[NSString stringWithFormat:@"%@",[dict objectForKey:@"friends_count"]] ;
    
    userInformation.fans =[NSString stringWithFormat:@"%@",[dict objectForKey:@"followers_count"]]  ;
    userInformation.uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    NSLog(@"%@",[dict objectForKey:@"id"]);
    NSArray*array = [[KZJRequestData alloc]getCoreData:@"UserInformation"];
    //        NSLog(@"%@",array);
    int flag = 0;
    for (UserInformation*info in array)
    {
        NSString*str1 = [NSString stringWithFormat:@"%@",userInformation.uid];
        NSString*str2 = [NSString stringWithFormat:@"%@",info.uid];
        if ([str1 isEqualToString:str2])
        {
            flag ++;
            if (flag>=2)
            {
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你好,你已经登录过该账号,请直接选择账号登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [context deleteObject:info];
            }
            
        }
        //        [context deleteObject:info];
    }
    
    [context save:nil];
    
    NSNotification*notification=nil;
    notification = [NSNotification notificationWithName:@"passValue" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //        NSNotification*notification1= [NSNotification notificationWithName:@"login" object:self userInfo:nil];
    //        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    NSNotification*notification2= [NSNotification notificationWithName:@"addlogin" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
}
#pragma mark 单例
-(id)initOnly
{

    static KZJRequestData*request = nil;
    if (!request)
    {
        request = [[KZJRequestData alloc]init];
    }
    return request;
}

#pragma mark 通过传入实体名获得实体数据
-(NSArray *)getCoreData:(NSString *)entityName
{
    KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    
    return fetchedObjects;
}

#pragma mark 通过传入实体名和要删除的某个实体数据,可实现删除
-(NSArray *)deleteCoreData:(NSString *)entityName withData:(UserInformation*)info
{
    KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    for (UserInformation*info1 in fetchedObjects)
    {
        if ([info isEqual:info1])
        {
            [context deleteObject:info1];
        }
    }
    [context save:nil];
    fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    return fetchedObjects;
}

#pragma mark 测试文字长度
-(int)textLength:(NSString *)dataString
{
    float sum = 0.0;
    for(int i=0;i<[dataString length];i++)
    {
        NSString *character = [dataString substringWithRange:NSMakeRange(i, 1)];
        if([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            sum++;
        }
        else
            sum += 0.7;
    }
    return ceil(sum);
}
#pragma mark 排列账号管理页账号顺序
-(NSArray*)loginRank:(NSArray*)array
{
    NSMutableArray*array1 = [NSMutableArray arrayWithArray:array];
    NSMutableArray*rankArray = [[NSMutableArray alloc]init];
    for (UserInformation*info in array1)
    {
        if ([info.uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]])
        {
            [rankArray addObject:info];
        }
    }
    for (UserInformation*info in array1)
    {
        if (![info.uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]])
        {
            [rankArray addObject:info];
        }
        
    }
    return rankArray;
}


@end
