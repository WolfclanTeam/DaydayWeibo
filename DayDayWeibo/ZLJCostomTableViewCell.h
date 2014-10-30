//
//  ZLJCostomTableViewCell.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLJCostomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *whoBtn;
@property (strong, nonatomic) IBOutlet UIButton *weiboBtn;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;

@property (strong, nonatomic) IBOutlet UIButton *replyBtn;

@property (strong, nonatomic) IBOutlet UIImageView *contentImageView;

@end
