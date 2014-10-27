//
//  KZJMeTableViewCell.m
//  DayDayWeibo
//
//  Created by bk on 14-10-21.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMeTableViewCell.h"

@implementation KZJMeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self)
    {
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        [self addSubview:_image];
        
        _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(320-20, 7, 12, 15)];
        [self addSubview:_image1];
        
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 150, 30)];
        [self addSubview:_label1];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
