//
//  KZJAccountViewCell.m
//  DayDayWeibo
//
//  Created by bk on 14-10-21.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJAccountViewCell.h"

@implementation KZJAccountViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self)
    {
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, SCREENWIDTH, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
        
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
        [self addSubview:_image];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 250, 45)];
        [self addSubview:_nameLabel];
        
        _loginView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 35, 15, 15)];
        [_image addSubview:_loginView];
        
        _unreadLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-20,20, 15, 15)];
        [self addSubview:_unreadLabel];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
