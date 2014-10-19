//
//  KZJMessage.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-19.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMessageView.h"

@implementation KZJMessageView
@synthesize messageTableView,iconArr;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.iconArr = [[NSMutableArray alloc] initWithObjects:@"messagescenter_at",@"messagescenter_comments",@"messagescenter_good",@"messagescenter_messagebox@2x", nil];
        [self initArrData]; //对数组数据初始化
        
        self.messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.frame.size.height) style:UITableViewStylePlain];
        self.messageTableView.delegate = self;
        self.messageTableView.dataSource =self;
        UIView *view = [UIView new];
        
        view.backgroundColor = [UIColor clearColor];
        
        [self.messageTableView setTableFooterView:view];
        [self addSubview:self.messageTableView];
    }
    return self;
}
-(void)initArrData
{
    
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"在此添加标题";
    cell.detailTextLabel.text = @"在此添加内容";
    cell.imageView.image =[UIImage redraw:[UIImage imageNamed:[iconArr objectAtIndex:indexPath.row]] Frame:CGRectMake(0, 0, 30, 30)];
    
   
    
    return cell;
}
#pragma mark UITableVIewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55;
//}
@end
