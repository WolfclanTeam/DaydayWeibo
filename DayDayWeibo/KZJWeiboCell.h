//
//  KZJWeiboCell.h
//  MyWeiBo
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "GetNetImageSize.h"
#import"RTLabel.h"
#import"RegexKitLite.h"
#import"NSString+URLEncoding.h"


@interface KZJWeiboCell : UITableViewCell<RTLabelDelegate>
{
    UIActivityIndicatorView *indicatorView;//活动控件，标示大图在下载中
    UIImageView *picImageView;//显示微博图片大图的图片视图
    UIScrollView *imageScroll;//用于添加picImageView的滑动视图
    NSArray *weiboData;//接收由viewcontroller传来的微博数据
    CGFloat lastScale;
    UIView *divisionView;
    UIButton *actionBtn;
    //
    UIView *bgView;
    UIView *comSelectView;
    
    //
    UIButton *collectBtn;
    UILabel *collectL;
    BOOL following;
    CGPoint beginPoint;
}

@property (nonatomic,retain) UIView *boundsView;
@property (nonatomic,retain) UIView *viewForHead;
@property (nonatomic,retain) UIImageView *HeadImageView;//头像视图
@property (nonatomic,retain) UILabel *timeLabel;//显示微博发布时间
@property (nonatomic,retain) UILabel *idLabel;//显示博主ID
@property (nonatomic,retain) RTLabel *Weibocontent;//微博正文
@property (nonatomic,retain) UIView *weiboImages;//显示微博图片
@property (nonatomic,retain) UIView *retweetWeibo;//转发微博视图
@property (nonatomic,retain) RTLabel *retweetContent;//转发微博正文
@property (nonatomic,retain) UIView *retweetImages;//显示转发微博图片
@property (nonatomic,retain) UIButton *retweetBtn;//转发按钮
@property (nonatomic,retain) UIImageView *retweetBg;//转发按钮图片
@property (nonatomic,retain) UILabel *retweetNum;//转发数
@property (nonatomic,retain) UIButton *commentBtn;//评论按钮
@property (nonatomic,retain) UIImageView *commentBg;//评论背景图
@property (nonatomic,retain) UILabel *commentNum;//评论数
@property (nonatomic,retain) UIButton *attitudeBtn;//表态按钮
@property (nonatomic,retain) UIImageView *attitudeBg;//表态背景图
@property (nonatomic,retain) UILabel *attitudeNum;//表态数
@property (nonatomic,retain)UIView *mainView;//controller的主View，用于显示大图视图

//设置自定义cell的内容与高度
-(void)setCell:(NSArray*)dataArr indexPath:(NSIndexPath*)indexPath;

@end
