//
//  KZJFindView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJFindView.h"

@implementation KZJFindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withTitle:(NSArray*)titleNameArray withTitleImage:(NSArray*)imageArray withTopicArray:(NSArray*)topicArray
{
    self=[super initWithFrame:frame style:style];
    if (self)
    {
        titleDetailArray = [NSArray arrayWithArray:titleNameArray];
        titleImageDetailArray = [NSArray arrayWithArray:imageArray];
        NSArray*titleArray;
        if ([topicArray count])
        {
            titleArray = [[[KZJDealData alloc]init]random:[topicArray count] withNum:3];
        }
        self.delegate = self;
        self.dataSource = self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [self.layer setBackgroundColor:colorref];
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        
        self.tableHeaderView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            
            UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, SCREENWIDTH/2-10, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:line];
            
            UILabel*line1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+10, 29, SCREENWIDTH/2-10, 0.5)];
            line1.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:line1];
            
            UILabel*line2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 2, 0.5, 26)];
            line2.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:line2];
            
            UILabel*line3 = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 32, 0.5, 26)];
            line3.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:line3];
            
            UIButton*btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn1.frame =CGRectMake(5, 5, SCREENWIDTH/2-10, 20);
            btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if ([titleArray count])
            {
                [btn1 setTitle:[NSString stringWithFormat:@"#%@#",[[topicArray objectAtIndex:[titleArray[0] intValue]] objectForKey:@"name"]] forState:UIControlStateNormal];
            }
            btn1.titleLabel.textAlignment = NSTextAlignmentLeft;
            [view addSubview:btn1];
            
            UIButton*btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn2.frame =CGRectMake(SCREENWIDTH/2+5, 5, SCREENWIDTH/2-10, 20);
            btn2.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn2.titleLabel.textAlignment = NSTextAlignmentLeft;
            if ([titleArray count])
            {
                [btn2 setTitle:[NSString stringWithFormat:@"#%@#",[[topicArray objectAtIndex:[titleArray[1] intValue]] objectForKey:@"name"]] forState:UIControlStateNormal];
            }
            [view addSubview:btn2];
            
            UIButton*btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn3.frame =CGRectMake(5, 35, SCREENWIDTH/2-10, 20);
            btn3.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn3.titleLabel.textAlignment = NSTextAlignmentLeft;
            if ([titleArray count])
            {
                [btn3 setTitle:[NSString stringWithFormat:@"#%@#",[[topicArray objectAtIndex:[titleArray[2] intValue]] objectForKey:@"name"]] forState:UIControlStateNormal];
            }
            [view addSubview:btn3];
            
            UIButton*btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
            btn4.frame =CGRectMake(SCREENWIDTH/2+5, 35, SCREENWIDTH/2-10, 20);
            btn4.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn4.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn4 setTitle:@"热门话题" forState:UIControlStateNormal];
            [btn4 addTarget:self action:@selector(topic) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn4];
            view;
        });
    }
    return self;
}
-(void)topic
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hotTopic" object:nil userInfo:nil];
}
#pragma mark topicTable代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString*mark = @"mark";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if ( cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
    }
    cell.imageView.image = [UIImage redraw:[UIImage imageNamed:titleImageDetailArray[indexPath.section][indexPath.row]] Frame:CGRectMake(0, 0, 25, 25)];
    cell.textLabel.text = titleDetailArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 2;
    }
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    view.alpha=0;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hotWeibo" object:nil userInfo:nil];
    }else if (indexPath.section==0&&indexPath.row==1)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"findMan" object:nil userInfo:nil];
    }else if (indexPath.section==1&&indexPath.row==2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"round" object:nil userInfo:nil];
    }
}


@end
