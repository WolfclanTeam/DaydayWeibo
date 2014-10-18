//
//  KZJSetView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJSetView.h"

@interface KZJSetView ()

@end

@implementation KZJSetView

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    NSArray*titleeArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"账号管理", nil],[NSArray arrayWithObjects:@"提醒和通知",@"通用设置",@"隐私与安全" ,nil],[NSArray arrayWithObjects:@"意见反馈",@"关于微博" , nil],[NSArray arrayWithObjects:@"夜间模式",@"清理缓存" , nil], [NSArray arrayWithObjects:@"退出微博", nil],nil];
    KZJSetTableView*setTable = [[KZJSetTableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withTitle:titleeArray];
    [self.view addSubview:setTable];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"pushAccount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAccount) name:@"pushAccount" object:nil];
}
-(void)pushAccount
{
    KZJNextView*accountView = [[KZJNextView alloc]init];
    
    [self.navigationController pushViewController:accountView animated:YES];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
