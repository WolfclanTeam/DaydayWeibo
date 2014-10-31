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
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBiggerPhotoArray:(NSArray*)biggerArray withControllerView:(UIView*)view
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        mainview = view;
        biggerPhotoArray = [NSArray arrayWithArray:biggerArray];
        image1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 100, 96)];
        image1.tag = 1100;
        image2 = [[UIImageView alloc]initWithFrame:CGRectMake(110, 2, 100, 96)];
        image2.tag = 1101;
        image3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, 2, 100, 96)];
        image3.tag = 1102;
        [self addSubview:image1];
        [self addSubview:image2];
        [self addSubview:image3];
        image1.userInteractionEnabled = YES;
        image2.userInteractionEnabled = YES;
        image3.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(biggerImage:)];
//        tap.view.tag = 1100;
        [image1 addGestureRecognizer:tap];
        UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(biggerImage:)];
//        tap1.view.tag = 1101;
        [image2 addGestureRecognizer:tap1];
        UITapGestureRecognizer*tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(biggerImage:)];
//        tap2.view.tag = 1102;
        [image3 addGestureRecognizer:tap2];

    }
    return self;
}
-(void)biggerImage:(UITapGestureRecognizer*)tap
{
    NSLog(@"%d,%d",self.tag,tap.view.tag);
    UIImage*image = ((UIImageView*)tap.view).image;
    UIImageView*imageview;
    NSLog(@"%f",SCREENHEIGHT);
    if (self.superview.frame.size.height==SCREENHEIGHT-20)
    {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT)];
    }else if (self.superview.frame.size.height==SCREENHEIGHT-64)
    {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    }
   
    
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    indicator.center = CGPointMake(160, 200);
    [indicator startAnimating];
    [imageview addSubview:indicator];
     [mainview addSubview:imageview];
    
    UIButton*save = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.superview.frame.size.height==SCREENHEIGHT-20)
    {
        save.frame = CGRectMake(10, SCREENHEIGHT-50, 25, 25);
    }else if (self.superview.frame.size.height==SCREENHEIGHT-64)
    {
        save.frame = CGRectMake(10, SCREENHEIGHT-30-64, 25, 25);
    }
    
    [save setBackgroundColor:[UIColor blackColor]];
    save.tag = tap.view.tag+100;
    [save setImage:[UIImage imageNamed:@"preview_save_icon_highlighted@2x"] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:save];
    
    UILabel*detailLabel;
    if (self.superview.frame.size.height==SCREENHEIGHT-20)
    {
        detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-80, SCREENWIDTH-20, 25)];
    }else if (self.superview.frame.size.height==SCREENHEIGHT-64)
    {
        detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-60-64, SCREENWIDTH-20, 25)];
    }
//    NSLog(@"%@",biggerPhotoArray);
    detailLabel.text = [biggerPhotoArray[(self.tag-1000)*3+tap.view.tag-1100] objectForKey:@"text"];
    detailLabel.textColor = [UIColor blackColor];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.userInteractionEnabled = YES;
   
    UITapGestureRecognizer*taptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)];
    imageview.userInteractionEnabled = YES;
    [imageview addGestureRecognizer:taptap];
    [imageview addSubview:detailLabel];
    
//    NSLog(@"%@",biggerPhotoArray[(self.tag-1000)*3+tap.view.tag-1100]);
    [imageview sd_setImageWithURL:[NSURL URLWithString:[biggerPhotoArray[(self.tag-1000)*3+tap.view.tag-1100] objectForKey:@"original_pic"]] placeholderImage:image  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [indicator removeFromSuperview];
        
        
        UITapGestureRecognizer*tapdetail = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail:)];
        detailLabel.tag = tap.view.tag+200;
        [detailLabel addGestureRecognizer:tapdetail];
        
    }];

}
-(void)detail:(UITapGestureRecognizer*)tap
{
//    NSLog(@"%@",biggerPhotoArray[(self.tag-1000)*3+tap.view.tag-1300]);
    [tap.view.superview.superview removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"photoDetailWeibo" object:nil userInfo:biggerPhotoArray[(self.tag-1000)*3+tap.view.tag-1300]];
}

-(void)saveAction:(UIButton*)save
{
    UIImage*image = ((UIImageView*)save.superview).image;
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)back:(UITapGestureRecognizer*)tap
{
    [tap.view removeFromSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
