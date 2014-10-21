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
    NSLog(@"%d",num);
    
    KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    NSArray*array = [self getCoreData:@"UserInformation"];
    for (UserInformation*info in array)
    {
        if ([info.uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]])
        {
            info.unread = [NSString stringWithFormat:@"%d",num];
            NSLog(@"%@",info.unread);
        }
    }
    [context save:nil];
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
                if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"标示启动"]isEqualToString:@"启动"]&&![[[NSUserDefaults standardUserDefaults]objectForKey:@"账号管理"]isEqualToString:@"已存在"])
                {
                    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你好,你已经登录过该账号,请直接选择账号登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
                [[NSUserDefaults standardUserDefaults]setObject:@"已启动" forKey:@"标示启动"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [context deleteObject:info];
            }
            
        }
        //        [context deleteObject:info];
    }
    
    [context save:nil];
    
    NSNotification*notification=nil;
    notification = [NSNotification notificationWithName:@"passValue" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if ([array count]==1)
    {
        NSNotification*notification1= [NSNotification notificationWithName:@"login" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        NSLog(@"=dasfa-24354");
    }
    
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
#pragma mark 通过传入实体名和要修改的实体的属性uid,即可获得该实体
-(id)searchEntityName:(NSString*)name uid:(NSString*)uid
{
    KZJAppDelegate*appdelegate = (KZJAppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext*manager = appdelegate.managedObjectContext;
    //
    NSFetchRequest*request = [[NSFetchRequest alloc]initWithEntityName:name];
//    NSString*str = @".*k$";
    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"uid matches %@",uid];
    [request setPredicate:predicate];
    //
    NSArray*arr = [manager executeFetchRequest:request error:nil];
    if ([arr count]>0)
    {
        return arr[0];
    }
    return nil;
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

#pragma mark 获得缓存大小
-(NSString*)cacheNumber
{
    
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:cachPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [cachPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    NSString*cache = [NSString stringWithFormat:@"%.2f",folderSize/1024.0/1024.0];
    return cache;
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


@end
