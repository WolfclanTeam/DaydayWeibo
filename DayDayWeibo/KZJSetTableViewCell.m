//
//  KZJSetTableViewCell.m
//  DayDayWeibo
//
//  Created by bk on 14-10-21.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJSetTableViewCell.h"

@implementation KZJSetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self)
    {
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 40)];
        [self addSubview:_label];
        
        _unreadLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-20,15, 15, 15)];
        [self addSubview:_unreadLabel];
        
        _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20,15, 12, 15)];
        [self addSubview:_image1];
        
        _cacheLaabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 5, 45, 28)];
        [self addSubview:_cacheLaabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
