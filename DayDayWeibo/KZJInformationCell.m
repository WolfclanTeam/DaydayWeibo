//
//  KZJInformationCell.m
//  DayDayWeibo
//
//  Created by bk on 14-10-21.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJInformationCell.h"

@implementation KZJInformationCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 59, SCREENWIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 44, 44)];
        [self addSubview:_image];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame =CGRectMake(SCREENWIDTH-40, 20, 30, 20);
        _btn.layer.borderWidth = 0.5;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
        _btn.layer.borderColor = colorref;
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        _btn.layer.cornerRadius = 1;
        [_btn addTarget:self action:@selector(view:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 200, 20)];
        _labelName.font = [UIFont systemFontOfSize:15];
        [self addSubview:_labelName];
        
        _labelDetial = [[UILabel alloc]initWithFrame:CGRectMake(55, 33, 230, 18)];
        _labelDetial.font = [UIFont systemFontOfSize:12];
        _labelDetial.textColor = [UIColor grayColor];
        [self addSubview:_labelDetial];
    }
    return self;
}
-(void)view:(UIButton*)btn
{
    NSLog(@"%@",btn.titleLabel.text);
    if (btn.titleLabel.text!=nil)
    {
        [[KZJRequestData requestOnly] startRequestData8:btn.titleLabel.text];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"relation" object:nil userInfo:[NSDictionary dictionaryWithObject:btn.titleLabel.text forKey:<#(id<NSCopying>)#>]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
   
}

@end
