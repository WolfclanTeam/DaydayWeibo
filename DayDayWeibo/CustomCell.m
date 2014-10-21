//
//  CustomCell.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(void)addLabel:(UILabel *)label
{
    [self addSubview:label];
    
}
-(void)addImageView:(UIImageView *)imageView
{
    [self addSubview:imageView];
}
-(void)addView:(UIView *)view
{
    [self addView:view];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
