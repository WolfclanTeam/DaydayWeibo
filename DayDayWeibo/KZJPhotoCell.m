//
//  KZJPhotoCell.m
//  DayDayWeibo
//
//  Created by bk on 14/10/24.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJPhotoCell.h"

@implementation KZJPhotoCell
@synthesize image1,image2,image3;
- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        image1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 100, 96)];
        image2 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 2, 100, 96)];
        image3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, 2, 100, 96)];
        [self addSubview:image1];
        [self addSubview:image2];
        [self addSubview:image3];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
