//
//  DetailWeiboTableView.h
//  WeiboTest
//
//  Created by Ibokan on 14-10-23.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "GetNetImageSize.h"
#import "KZJCommentCell.h"
#import"RTLabel.h"
#import"RegexKitLite.h"
#import"NSString+URLEncoding.h"


@interface DetailWeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate,RTLabelDelegate>
{
    UIImageView *picImageView;//显示微博图片大图的图片视图
    UIScrollView *imageScroll;//用于添加picImageView的滑动视图
    UIView *footView;
    //微博信息
    UIView *headView;
    UIImageView*headImage;
    UILabel *idLabel;
    UILabel *timeLabel;
    UIView *viewForHeadImage;
    //微博内容
    RTLabel *weiboConnent;
    UIView*weiboImages;
    UIImageView *weiboSingleImage;
    //转发内容
    UIView *retweetView;
    RTLabel *retweetContent;
    UIImageView *retweetSingleImage;
    UIView *retweetImages;
    
    
    UIButton *repostsBtn;
    UIImageView *repostsBG;
    UILabel *repostsCount;
    UIButton *commentBtn;
    UIImageView *commentBG;
    UILabel *commentCount;
    UIButton *attitudesBtn;
    UIImageView *attitudesBG;
    UILabel *attitudeCount;
    
    NSNumber *repostsNum;
    NSNumber *commentsNum;
    NSNumber *attitudesNum;
    
    //
    UIView *selectView;
    UIView *boundsView;
    UIView *bgView;
    UIView *comSelectView;
    
    //
    NSArray *dataArr;
    
    //
    NSDictionary *theWeiboDict;
    CGPoint beginPoint;
}

@property (nonatomic,retain) NSDictionary *commentDict;
@property (nonatomic,retain) NSArray *commentsArr;

- (id)initWithFrame:(CGRect)frame dataDict:(NSDictionary*)weiboDict superView:(UIView*)supView;
@end
