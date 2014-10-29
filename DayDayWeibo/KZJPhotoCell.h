//
//  KZJPhotoCell.h
//  DayDayWeibo
//
//  Created by bk on 14/10/24.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZJPhotoCell : UITableViewCell
{
    NSArray*biggerPhotoArray;
    UIView*mainview;
}
@property(retain,nonatomic)UIImageView*image1;
@property(retain,nonatomic)UIImageView*image2;
@property(retain,nonatomic)UIImageView*image3;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withBiggerPhotoArray:(NSArray*)biggerArray withControllerView:(UIView*)view;
@end
