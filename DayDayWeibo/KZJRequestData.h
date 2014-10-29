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
#import "JDStatusBarNotification.h"
typedef void(^passData)(NSDictionary*);
@interface KZJRequestData : NSObject<WeiboSDKDelegate,UIApplicationDelegate,WBHttpRequestDelegate>
{
    NSMutableArray*arrayFans;
//    NSMutableDictionary*dictFans;
    NSMutableArray*photoArray;
    NSMutableArray*peopleArray;
    int countNum;
    NSMutableArray*relationArray;
    int countNum1;
    passData passBlock;
    
    NSMutableArray*weiboData;
    NSMutableArray*collectData;
    
    //坚 的数组 签到
    NSMutableArray *addressArr;
    NSMutableArray *checkin_user_numArr; //去过数
    NSMutableArray *titleArr;
}

//彬楷
-(NSArray*)getCoreData:(NSString*)entityName;
-(int)textLength:(NSString *)dataString;
-(NSArray*)loginRank:(NSArray*)array;
-(NSArray *)deleteCoreData:(NSString *)entityName withData:(UserInformation*)info;
+(id)requestOnly;
-(NSString*)cacheNumber;
-(id)searchEntityName:(NSString*)name uid:(NSString*)uid;
-(void)startRequestData1;
-(void)startRequestData2;
-(void)startRequestData3:(int)page withTitle:(NSString*)title withID:(NSString*)ID;//请求关注粉丝列表
-(void)startRequestData4;//请求话题
-(void)startRequestData5:(int)page withType:(NSString*)type withID:(NSString*)ID;
//请求指定ID微博(此处只为获取相册,后面结合时可重新利用),page为第几页,每页20条
//type为0：全部、1：原创、2：图片、3：视频、4：音乐

-(void)startRequestData5:(int)page withID:(NSString*)ID;

-(void)startRequestData6:(NSString*)name;//请求搜人的联想
-(void)startRequestData7:(NSString*)userID;//根据用户ID获取用户详情
-(void)startRequestData8:(NSString*)userID;//根据用户ID获取其和登陆用户的关系
-(void)startRequestData9:(NSString*)userID withName:(NSString*)name;//关注某用户
-(void)startRequestData10:(NSString*)userID withName:(NSString*)name;//取消关注某用户
-(void)startRequestData11:(int)page;//获取当前用户收藏
-(void)startRequestData12:(int)page withLocationLat:(float)latDu withLocationLong:(float)longDu;//获取周边动态
-(void)startRequestData12:(NSString*)type;//获取系统推荐用户
-(void)startRequestData13:(int)page;//获取热门微博(公共微博)
-(void)startRequestData14:(int)page withLocationLat:(float)latDu withLocationLong:(float)longDu withType:(NSString*)type;//获取周边微博,人,地点,图片

//锦章
-(void)passWeiboData:(passData)sender;
-(void)getHomeWeibo;
-(void)getADetailWeibo:(NSString*)weiboID;
-(void)getCommentList:(NSString*)weiboID;
-(void)getNewWeibo:(NSString *)page;
-(void)getNewComment:(NSString*)weiboID page:(NSString*)page;


#pragma mark 张立坚 的消息页面@我的  数据请求
/**
 "@我的"  数据请求
 */
-(void)zljRequestData1;

/**
 #pragma mark 张立坚 的消息页面 "评论"  数据请求
 */
-(void)zljRequestData2;

/**
 #pragma mark  张立坚 的消息页面 "赞"  数据请求
 */
-(void)zljRequestData3;

/**
 #pragma mark 张立坚 签到
 */
-(void)zljRequestData4:(float)lat Long:(float)longDu page:(NSString*)page;
/**
 张立坚 发微博
 */
-(void)zljSendWeibo:(NSString*)message picArr:(NSMutableArray*)imageArr visible:(int)visible;

@end
