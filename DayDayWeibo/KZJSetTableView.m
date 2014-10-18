//
//  KZJSetTableView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJSetTableView.h"

@implementation KZJSetTableView
-(id)initWithFrame:(CGRect)frame withTitle:(NSArray *)arrayTitle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        titleArray = [NSArray arrayWithArray:arrayTitle];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor lightTextColor];
    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"meMark";
    CustomCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    for (UIView*view in cell.subviews)
    {
        [view removeFromSuperview];
    }
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 40)];
    if (indexPath.section ==4)
    {
        label.frame = CGRectMake(5, 0, SCREENWIDTH-10, 40);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor redColor];
    }
    label.text = titleArray[indexPath.section][indexPath.row];
    [cell addLabel:label];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 5;
    }
    return 15;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==4)
    {
        exit(0);
    }
    if (indexPath.section ==0&&indexPath.row==0)
    {
        NSNotification*notification= [NSNotification notificationWithName:@"pushAccount" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
