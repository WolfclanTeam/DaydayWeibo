//
//  KZJRequestData.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJRequestData.h"

@implementation KZJRequestData

-(id)init
{
    if (self = [super init])
    {
        addressArr = [[NSMutableArray alloc] init];
        checkin_user_numArr = [[NSMutableArray alloc] init]; //去过数
        titleArr = [[NSMutableArray alloc] init];
    }
    return self;
}

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
    
    [self startRequestData5:1 withID:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    //    [self getHomeWeibo];
}
-(void)startRequestData2
{
    //    NSDictionary*params2=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/comments/to_me.json" httpMethod:@"GET" params:nil delegate:self withTag:@"992"];
}

-(void)startRequestData3:(int)page withTitle:(NSString*)title withID:(NSString*)ID
{
    NSString*count = [NSString stringWithFormat:@"%d",15*page];
    NSDictionary*params3=[NSDictionary dictionaryWithObjectsAndKeys:ID,@"uid",count,@"count",@"0",@"trim_status",nil];
    if ([title isEqualToString:@"关注"])
    {
        [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/friendships/friends.json" httpMethod:@"GET" params:params3 delegate:self withTag:@"994"];
    }else if ([title isEqualToString:@"粉丝"])
    {
        [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/friendships/followers.json" httpMethod:@"GET" params:params3 delegate:self withTag:@"995"];
    }
}
//请求话题的链接
-(void)startRequestData4
{
    //     [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/trends/daily.json" httpMethod:@"GET" params:nil delegate:self withTag:@"996"];
    //    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/trends/hourly.json" httpMethod:@"GET" params:nil delegate:self withTag:@"996"];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/trends/weekly.json" httpMethod:@"GET" params:nil delegate:self withTag:@"996"];
}

-(void)startRequestData5:(int)page withType:(NSString*)type  withID:(NSString*)ID
{
    if (page==1)
    {
        [weiboData removeAllObjects];
    }
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:ID,@"uid",@"20",@"count",[NSString stringWithFormat:@"%d",page],@"page",type,@"feature",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/user_timeline.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"997"];
}
-(void)startRequestData5:(int)page withID:(NSString*)ID
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:ID,@"uid",@"100",@"count",[NSString stringWithFormat:@"%d",page],@"page",@"1",@"feature",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/user_timeline.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"1003"];
    
}
-(void)startRequestData6:(NSString*)name
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:name,@"q",@"10",@"count",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/search/suggestions/users.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"998"];
}

-(void)startRequestData7:(NSString*)userID
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:userID,@"uid",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"999"];
}

-(void)startRequestData8:(NSString*)userID
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"source_id",userID,@"target_id",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/friendships/show.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"1000"];
}
-(void)startRequestData9:(NSString*)userID withName:(NSString*)name
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:userID,@"uid",name,@"screen_name",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/friendships/create.json" httpMethod:@"POST" params:params1 delegate:self withTag:@"1001"];
}
-(void)startRequestData10:(NSString*)userID withName:(NSString*)name
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:userID,@"uid",name,@"screen_name",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/friendships/destroy.json" httpMethod:@"POST" params:params1 delegate:self withTag:@"1002"];
}
-(void)startRequestData11:(int)page
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",page],@"page",@"25",@"count",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/favorites.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"1005"];
}
-(void)startRequestData12:(int)page withLocationLat:(float)latDu withLocationLong:(float)longDu
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",page],@"page",[NSString stringWithFormat:@"%f",latDu],@"lat",[NSString stringWithFormat:@"%f",longDu],@"long",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/place/nearby_timeline.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"1004"];
}
-(void)startRequestData12:(NSString*)type
{
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:type,@"category",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/suggestions/users/hot.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"1006"];
}

-(void)startRequestData13:(int)page
{
    if (page==1)
    {
        [weiboData removeAllObjects];
    }
    NSDictionary*params1=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",page],@"page",@"20",@"count",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/public_timeline.json" httpMethod:@"GET" params:params1 delegate:self withTag:@"1007"];
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
        //NSLog(@"%@",result);
        [self unread:result];
    }else if ([request.tag isEqualToString:@"1100"])
    {
       // NSLog(@"1100 = %@",result);
    }else if ([request.tag isEqualToString:@"1101"])
    {
        //NSLog(@"1101 = %@",result);
    }else if ([request.tag isEqualToString:@"994"])
    {
        [self fansData:result];
    }else if ([request.tag isEqualToString:@"995"])
    {
        NSLog(@"%@",[result objectFromJSONString]);
        [self fansData:result];
    }else if ([request.tag isEqualToString:@"996"])
    {
        //        NSLog(@"%@",[[[result objectFromJSONString] objectForKey:@"trends"] objectForKey:[[[[result objectFromJSONString] objectForKey:@"trends"] allKeys] objectAtIndex:0]]);
        //        NSLog(@"%@",result);
        
        NSNotification *notification = [NSNotification notificationWithName:@"hourtopic" object:self userInfo:[[result objectFromJSONString] objectForKey:@"trends"]];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        
    }else if ([request.tag isEqualToString:@"997"])
    {
        //        NSLog(@"%@",[[dict objectForKey:@"statuses"] objectAtIndex:0]);
        if (weiboData==nil)
        {
            weiboData = [[NSMutableArray alloc]init];
        }
        NSDictionary *dict = [result objectFromJSONString];
        for (NSDictionary*dict1 in [dict objectForKey:@"statuses"])
        {
            [weiboData addObject:dict1];
        }
        NSDictionary*dict2 = [NSDictionary dictionaryWithObject:weiboData forKey:@"statuses"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myweibo" object:nil userInfo:dict2];
        
    }else if ([request.tag isEqualToString:@"998"])
    {
        if ([[result objectFromJSONString] count]>0)
        {
            countNum = [[result objectFromJSONString] count];
            peopleArray = [[NSMutableArray alloc]initWithCapacity:[[result objectFromJSONString] count]];
            
            //            countNum1 = [[result objectFromJSONString] count];
            //            relationArray = [[NSMutableArray alloc]initWithCapacity:[[result objectFromJSONString] count]];
            
            for (NSDictionary*dict in [result objectFromJSONString])
            {
                [self startRequestData7:[NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]]];
            }
        }
    }else if ([request.tag isEqualToString:@"999"])
    {
        countNum--;
        [peopleArray addObject:[result objectFromJSONString]];
        //        [self startRequestData8:[NSString stringWithFormat:@"%@",[[result objectFromJSONString] objectForKey:@"id"]]];
        if (countNum==0)
        {
            NSDictionary*dict = [NSDictionary dictionaryWithObject:peopleArray forKey:@"people"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"people" object:nil userInfo:dict];
        }
    }else if ([request.tag isEqualToString:@"1000"])
    {
        //        NSLog(@"%@",[result objectFromJSONString]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"relation" object:nil userInfo:[NSDictionary dictionaryWithObject:[[result objectFromJSONString] objectForKey:@"target"] forKey:@"target"]];
    }else if ([request.tag isEqualToString:@"1001"])
    {
        //        NSLog(@"%@",result);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"attention" object:nil userInfo:nil];
        
    }else if ([request.tag isEqualToString:@"1002"])
    {
        //        NSLog(@"%@",result);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelAttention" object:nil userInfo:nil];
    }else if ([request.tag isEqualToString:@"HOMEWEIBO"])
    {
        NSDictionary *dict = [result objectFromJSONString];
        passBlock(dict);
    }else if ([request.tag isEqualToString:@"ADTAILWEIBO"])
    {
        NSDictionary *dict = [result objectFromJSONString];
        passBlock(dict);
    }else if ([request.tag isEqualToString:@"COMMENT"])
    {
        NSDictionary *dict = [result objectFromJSONString];
        passBlock(dict);
    }else if ([request.tag isEqualToString:@"GETWEIBO"])
    {
        NSDictionary *dict = [result objectFromJSONString];
        passBlock(dict);
    }else if ([request.tag isEqualToString:@"1003"])
    {
        
        [self photoNum:result];
        //用总微博数进行判断,实现遍历全部微博
        
    }else if ([request.tag isEqualToString:@"1004"])
    {
//         NSLog(@"1004 = %@",[result objectFromJSONString]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"roundweibo" object:nil userInfo:[result objectFromJSONString]];
        
        
    }else if ([request.tag isEqualToString:@"1005"])
    {
        if (collectData==nil)
        {
            collectData = [[NSMutableArray alloc]init];
        }
        NSDictionary *dict = [result objectFromJSONString];
        for (NSDictionary*dict1 in [dict objectForKey:@"favorites"])
        {
            NSDictionary*dict2 = [NSDictionary dictionaryWithDictionary:[dict1 objectForKey:@"status"]];
            [collectData addObject:dict2];
        }
        
        NSDictionary*dict3 = [NSDictionary dictionaryWithObject:collectData forKey:@"statuses"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myCollect" object:nil userInfo:dict3];
        
        
    }else if ([request.tag isEqualToString:@"1006"])
    {
//         NSLog(@"1006 = %@",[result objectFromJSONString]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"findManView" object:nil userInfo:[NSDictionary dictionaryWithObject:[result objectFromJSONString] forKey:@"findMan"]];
        
    }else if ([request.tag isEqualToString:@"1007"])
    {
        if (weiboData==nil)
        {
            weiboData = [[NSMutableArray alloc]init];
        }
        NSDictionary *dict = [result objectFromJSONString];
        for (NSDictionary*dict1 in [dict objectForKey:@"statuses"])
        {
            [weiboData addObject:dict1];
        }
        NSDictionary*dict2 = [NSDictionary dictionaryWithObject:weiboData forKey:@"statuses"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hotweibo" object:nil userInfo:dict2];
        
    }else if ([request.tag isEqualToString:@"1100"])
    {
        // NSLog(@"1100 = %@",result);
    }else if ([request.tag isEqualToString:@"1101"])
    {
        //NSLog(@"1101 = %@",result);
    }
    else if ([request.tag isEqualToString:@"1105"])
    {
        //  NSLog(@"签到：%@",result);
        NSDictionary *dict = [result objectFromJSONString];
        //NSLog(@"%@",dict);
        NSArray *poisArr =  [dict objectForKey:@"pois"];
        for (NSDictionary *contentDict in poisArr)
        {
            [addressArr addObject:[contentDict objectForKey:@"address"]];
            [checkin_user_numArr addObject:[contentDict objectForKey:@"checkin_user_num"]];
            [titleArr addObject:[contentDict objectForKey:@"title"]];
        }
        //        NSLog(@"%@",[[dict objectForKey:@"pois"] objectAtIndex:0]);
        //        NSLog(@"arr%@",[[[dict objectForKey:@"pois"] objectAtIndex:0] objectForKey:@"address"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkInPositionNoti" object:self userInfo:@{@"address": addressArr,@"checkin_user_num":checkin_user_numArr,@"title":titleArr}];
    }
    else if ([request.tag isEqualToString:@"1106"])
    {
        [JDStatusBarNotification showWithStatus:@"发送成功" dismissAfter:1 styleName:@"JDStatusBarStyleSuccess"];
        
        
    }else if ([request.tag isEqualToString:@"NEWCOMMENT"])
    {
        NSLog(@"%@",result);
        NSDictionary *dict = [result objectFromJSONString];
        passBlock(dict);
    }


}

#pragma mark 相册图片数量
-(void)photoNum:(NSString*)result
{
    if (photoArray==nil)
    {
        photoArray = [[NSMutableArray alloc]init];
    }
    static int pageNum = 1;
    if (pageNum==1)
    {
        [photoArray removeAllObjects];
    }
    int i =0;
    for (NSDictionary*dict in [[result objectFromJSONString] objectForKey:@"statuses"] )
    {
        if ([[dict objectForKey:@"pic_urls"] count]>0)
        {
            i=i+[[dict objectForKey:@"pic_urls"] count];
            for (NSString*str in [dict objectForKey:@"pic_urls"])
            {
                [photoArray addObject:str];
            }
        }
    }
    
    KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.managedObjectContext;
    UserInformation*info = [self searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    if (pageNum>1)
    {
        info.photoNum = [NSString stringWithFormat:@"%d",i+[info.photoNum intValue]];
    }else
    {
        info.photoNum = [NSString stringWithFormat:@"%d",i];
    }
    
    [context save:nil];
    //    NSLog(@"%d",[info.photoNum intValue]);
    
    //    NSLog(@"%d",[[[result objectFromJSONString] objectForKey:@"statuses"] count] );
    if ([[[result objectFromJSONString] objectForKey:@"statuses"] count]==100)
    {
        
        [self startRequestData5:++pageNum withID:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    }
    if ([[[result objectFromJSONString] objectForKey:@"statuses"] count]<100)
    {
        pageNum =1;
        //        NSLog(@"%@",photoArray);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"photo" object:nil userInfo:[NSDictionary dictionaryWithObject:photoArray forKey:@"photo"]];
    }
}
#pragma mark 关注用户信息
-(void)fansData:(NSString*)result
{
    NSDictionary*dict = [result objectFromJSONString];
    NSNotification*notification=[NSNotification notificationWithName:@"fansData" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
    //    NSLog(@"%@",result);
    userInformation.name = [dict objectForKey:@"name"];
    userInformation.photo = [dict objectForKey:@"avatar_hd"];
    
    userInformation.collectionNum = [NSString stringWithFormat:@"%@",[dict objectForKey:@"favourites_count"]];
    userInformation.brief = [dict objectForKey:@"description"];
    userInformation.token = [[NSUserDefaults standardUserDefaults]objectForKey:@"Token"];
    userInformation.statuses = [NSString stringWithFormat:@"%@",[dict objectForKey:@"statuses_count"]];
    
    userInformation.care =[NSString stringWithFormat:@"%@",[dict objectForKey:@"friends_count"]] ;
    
    userInformation.fans =[NSString stringWithFormat:@"%@",[dict objectForKey:@"followers_count"]]  ;
    userInformation.uid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    //    NSLog(@"%@",[dict objectForKey:@"id"]);
    NSArray*array = [[KZJRequestData alloc]getCoreData:@"UserInformation"];
    //    NSLog(@"=======%@",array);
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
        
    }
    
    NSNotification*notification2= [NSNotification notificationWithName:@"addlogin" object:self userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
}
#pragma mark 单例
+(id)requestOnly
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
        if (info1.uid ==nil)
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


#pragma mark-王锦章微博数据请求
-(void)getHomeWeibo
{
    //获取当前登录用户所关注用户的微博
    //https://api.weibo.com/2/statuses/friends_timeline.json
    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],@"access_token",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:parms delegate:self withTag:@"HOMEWEIBO"];
}

-(void)getNewWeibo:(NSString *)page
{
    //获取当前登录用户所关注用户的微博
    //https://api.weibo.com/2/statuses/friends_timeline.json
    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],@"access_token",page,@"page",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:parms delegate:self withTag:@"GETWEIBO"];
}

-(void)getADetailWeibo:(NSString*)weiboID
{
    //http://api.weibo.com/2/statuses/go
    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],@"access_token",weiboID,@"id", nil];
    NSLog(@"%@",parms);
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/show.json" httpMethod:@"GET" params:parms delegate:self withTag:@"ADTAILWEIBO"];
}

//根据微博ID获取某条微博评论列表
-(void)getCommentList:(NSString*)weiboID
{
    //https://api.weibo.com/2/comments/show.json
    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],@"access_token",weiboID,@"id", nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/comments/show.json" httpMethod:@"GET" params:parms delegate:self withTag:@"COMMENT"];
}
-(void)getNewComment:(NSString*)weiboID page:(NSString*)page
{
    //https://api.weibo.com/2/comments/show.json
    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"],@"access_token",weiboID,@"id",page,@"page", nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/comments/show.json" httpMethod:@"GET" params:parms delegate:self withTag:@"NEWCOMMENT"];
}
//代码块传值
-(void)passWeiboData:(passData)sender
{
    passBlock = sender;
}
#pragma mark 张立坚 的消息页面 "@我的"  数据请求
/**
 
 "@我的"  数据请求
 */
-(void)zljRequestData1
{
    //NSDictionary *params2 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"filter_by_source", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"filter_by_type", nil];
    
    
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/statuses/mentions.json" httpMethod:@"Get" params:params delegate:self withTag:@"1100"];
}

#pragma mark 张立坚 的消息页面 "评论"  数据请求
-(void)zljRequestData2
{
    //NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"page", nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/comments/by_me.json" httpMethod:@"Get" params:nil delegate:self withTag:@"1101"];
    
}
#pragma mark  张立坚 的消息页面 "赞"  数据请求
-(void)zljRequestData3
{
    
}

#pragma mark 张立坚 签到
-(void)zljRequestData4:(float)lat Long:(float)longDu page:(NSString*)page
{
    
    NSDictionary *param = @{@"lat":[NSString stringWithFormat:@"%f",lat],@"long":[NSString stringWithFormat:@"%f",longDu],@"range":@"5000",@"page":page,@"sort":@"0",@"count":@"20"};
    
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/place/nearby/pois.json" httpMethod:@"GET" params:param delegate:self withTag:@"1105"];
    
}
#pragma mark 张立坚 发微博
-(void)zljSendWeibo:(NSString*)message picArr:(NSMutableArray*)imageArr visible:(int)visible
{
    [JDStatusBarNotification showWithStatus:@"正在努力发送中..." styleName:JDStatusBarStyleWarning];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //113.255868,23.135174
    NSString *url;
    NSDictionary*params;
    if (message.length>0  && imageArr.count>1)
    {
        url = @"https://upload.api.weibo.com/2/statuses/upload.json";
        params=[NSDictionary dictionaryWithObjectsAndKeys:message,@"status",[imageArr objectAtIndex:0],@"pic",[NSString stringWithFormat:@"%d",visible],@"visible",nil];
    }
    else if(message.length>0)
    {
        url = @"https://api.weibo.com/2/statuses/update.json";
        params=[NSDictionary dictionaryWithObjectsAndKeys:message,@"status",[NSString stringWithFormat:@"%d",visible],@"visible",nil];
    }
    
    
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:url httpMethod:@"POST" params:params delegate:self withTag:@"1106"];
    
    
}@end
