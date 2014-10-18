//
//  KZJAccountView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJAccountView.h"

@implementation KZJAccountView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"meMark";
    CustomCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    for (UIView*view in cell.subviews)
    {
        [view removeFromSuperview];
    }
    UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
    [image sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"帐号1"]];
    //    image.backgroundColor  =[UIColor redColor];
    [cell addImageView:image];
    
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
