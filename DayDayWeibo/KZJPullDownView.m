//
//  KZJPullDownView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJPullDownView.h"

@implementation KZJPullDownView
-(KZJPullDownView*)initWithFrame:(CGRect)frame withTitles:(NSArray*)titleArray
{
    height = titleArray.count>5?5:titleArray.count;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 100, height*25)];
    if ( self)
    {
        titleArr = [NSArray arrayWithArray:titleArray];
        UITableView*tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, height*25) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource =self;
        [self addSubview:tableview];
    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markpull";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    cell.textLabel.text = titleArr[indexPath.row];
    if ([[[UIDevice currentDevice]systemVersion] intValue]<8)
    {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate clickTable:cell.textLabel.text];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
