//
//  KZJCommentCell.h
//  WeiboTest
//
//  Created by Ibokan on 14-10-23.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import"RTLabel.h"


@interface KZJCommentCell : UITableViewCell<RTLabelDelegate>

@property(nonatomic,retain)UIImageView *headImageView;
@property(nonatomic,retain)UILabel *idLabel;
@property(nonatomic,retain)UILabel *timeLbel;
@property(nonatomic,retain)RTLabel *commentContent;

-(void)setCellCommentData:(NSArray*)commentArr indexPath:(NSIndexPath*)indexPath;

@end
