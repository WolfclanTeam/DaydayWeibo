//
//  CustomCell.h
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
-(void)addButton:(UIButton*)button;
-(void)addLabel:(UILabel*)label;
-(void)addImageView:(UIImageView*)imageView;
-(void)addView:(UIView*)view;
-(void)addButtonInView:(UIButton*)button;
-(void)addLabelInView:(UILabel*)label;
-(void)addImageViewInView:(UIImageView*)imageView;
@end
