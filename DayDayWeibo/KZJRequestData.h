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
    NSMutableArray*photoBiggerArray;
    NSMutableArray*peopleArray;
    int countNum;
    NSMutableArray*relationArray;
    int countNum1;
    passData passBlock;
    
    NSMutableArray*weiboData;
    NSMutableArray*collectData;
    NSMutableArray*friendData;
    
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

-(void)startRequestData5:(int)page withID:(NSString*)ID;//获取指定用户的相册

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
//-(void)startRequestDataWithLocationLat:(float)latDu withLocationLong:(float)longDu;//根据坐标获取用户当前地点的详细信息
-(void)startRequestData15:(int)page;//获取可能感兴趣的人


//锦章
-(void)passWeiboData:(passData)sender;//代码块传值
-(void)getHomeWeibo;//获取主页微博列表
-(void)getADetailWeibo:(NSString*)weiboID;//根据微博ID获取单条微博信息
-(void)getCommentList:(NSString*)weiboID;//根据微博ID获取评论列表
-(void)getNewWeibo:(NSString *)page;//根据页数获取用户微博
-(void)getNewComment:(NSString*)weiboID page:(NSString*)page;//根据微博ID以及页数获取微博评论
-(void)getUserMessage :(NSString*)domain;//根据个性域名获取用户信息
-(void)createFavoritesWeibo:(NSString*)weiboID;//收藏微博
-(void)deleteWeibo:(NSString*)weiboID;//删除自己发的微博
-(void)createFriendships:(NSString*)userID;//关注某用户
-(void)destroyFriendships:(NSString*)userID;//取消关注某用户



#pragma mark 张立坚 的消息页面@我的  数据请求
/**
 "@我的"  数据请求
 */
-(void)zljRequestData1:(int)page;

/**
 #pragma mark 张立坚 的消息页面 "评论"  数据请求
 */
-(void)zljRequestData2:(int)page;

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

/**
 jian 回复一条微博
 param  cid 需要回复的评论ID。
 param id 需要评论的微博ID。
 param comment 回复评论内容，必须做URLencode，内容不超过140个汉字。
 comment_ori 当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0
 */
-(void)zljreplyWeibo:(NSString*)cid Id:(NSString*)weiboId comment:(NSString*)commentContent comment_ori:(NSString*)comment_ori;
/**
 对一条微博进行评论
 @param  commentContent 评论内容，必须做URLencode，内容不超过140个汉字。
 @param id 需要评论的微博ID
 @param comment_ori 当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0。
 */
-(void)zljCommentWeibo:(NSString*)commentContent Id:(NSString*)Id comment_ori:(NSString*)comment_ori;

/**
 转发一条微博
 @param id 要转发的微博ID。
 @param status 添加的转发文本，必须做URLencode，内容不超过140个汉字，不填则默认为“转发微博”。
 @param is_comment 是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
 */
-(void)zljRepostWeibo:(NSString*)repostId Status:(NSString*)status is_comment:(NSString*)is_comment;
@end
