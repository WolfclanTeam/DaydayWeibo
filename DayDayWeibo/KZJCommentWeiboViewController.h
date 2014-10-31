//
//  KZJCommentWeiboViewController.h
//  DayDayWeibo
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCommentTranspondBaseController.h"
typedef void(^PassTitleText)(NSString*);
@interface KZJCommentWeiboViewController : KZJCommentTranspondBaseController
{
    PassTitleText passTItleText;
}
//@property(assign,nonatomic)PassTitleText passTItleText;
@property(retain,nonatomic)NSString *titleText;

//cid 需要回复的评论ID。
@property(copy,nonatomic)NSString *cid;
//id 需要评论的微博ID。
@property(copy,nonatomic)NSString *commentId;
//comment 回复评论内容
@property(copy,nonatomic)NSString *commentContent;
//comment_ori 当评论转发微博时，是否评论给原微博，0：否、1：是，默认为0
@property(copy,nonatomic)NSString *comment_ori;
                             
-(void)passTitle:(PassTitleText)passTItleTextBlock;
@end
