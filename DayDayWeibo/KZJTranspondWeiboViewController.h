//
//  KZJTranspondWeiboViewController.h
//  DayDayWeibo
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCommentTranspondBaseController.h"
#import "UIImageView+WebCache.h"
@interface KZJTranspondWeiboViewController : KZJCommentTranspondBaseController
/**
 param 接收 名称
 */
@property(retain,nonatomic)NSString *whoLabelContent;
/**
 param 接收 内容
 */
@property(retain,nonatomic)NSString *detailViewContent;

/**
 param 接收 图片url
 */
@property(retain,nonatomic)NSString *urlString;



@property(copy,nonatomic)NSString *Id; //id 要转发的微博ID。
@property(copy,nonatomic)NSString *status;//status 添加的转发文本，必须做URLencode，内容不超过140个汉字，不填则默认为“转发微博”。
@end
