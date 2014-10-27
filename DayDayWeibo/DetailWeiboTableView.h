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

@interface DetailWeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *headView;
    UIImageView*headImage;
    UILabel *idLabel;
    UILabel *timeLabel;
    UITextView *weiboConnent;
    UIView*weiboImages;
    UIImageView *weiboSingleImage;
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
}

@property (nonatomic,retain) NSDictionary *commentDict;

- (id)initWithFrame:(CGRect)frame dataDict:(NSDictionary*)weiboDict superView:(UIView*)supView;
@end
