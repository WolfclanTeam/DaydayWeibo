//
//  KZJCommonView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCommonView.h"

@interface KZJCommonView ()

@end

@implementation KZJCommonView
@synthesize tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"通用设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (tableview==nil)
    {
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource =self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [tableview.layer setBackgroundColor:colorref];
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        [self.view addSubview:tableview];
    }
    
    titleArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"阅读模式",@"字号设置",@"显示备注信息", nil],[NSArray arrayWithObjects:@"自动加载更多",nil],[NSArray arrayWithObjects:@"开启快速拖动", nil],[NSArray arrayWithObjects:@"横竖屏自动切换", nil],[NSArray arrayWithObjects:@"图片质量设置", nil],[NSArray arrayWithObjects:@"声音与振动",@"多语言环境", nil],nil];
}

#pragma mark tableview代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markremind";
    UITableViewCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
    if (indexPath.section==1||indexPath.section==2||indexPath.section==3)
    {
        UISwitch*swich = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        swich.center = CGPointMake(SCREENWIDTH-40, 22);
        if (indexPath.section==3)
        {
            swich.on = NO;
        }else
        {
            swich.on = YES;
        }
        
        [cell.contentView addSubview:swich];
    }else
    {
        UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30, 12, 20, 20)];
        image.image = [UIImage imageNamed:@"login_detail@2x"];
        [cell.contentView addSubview:image];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titleArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1||section==2)
    {
        return 15;
    }
    return 0.0001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    //    view.alpha = 0;
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1||section==2)
    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
        if (section==1)
        {
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH, 13)];
            label.text = @"到达列表底部时自动加载'更多'微博";
            label.font = [UIFont systemFontOfSize:13];
            [view addSubview:label];
        }else if (section==2)
        {
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH, 13)];
            label.text = @"浏览列表是可使用拖动条快速拖动";
            label.font = [UIFont systemFontOfSize:13];
            [view addSubview:label];
        }
        return view;
    }
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.001)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
