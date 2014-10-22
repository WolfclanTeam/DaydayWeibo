//
//  KZJShareController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJShareController.h"

@interface KZJShareController ()

@end

@implementation KZJShareController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelMethod)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMethod)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    
    
    UIView *titleView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    UILabel *sendWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 24)];
    sendWeiboLabel.text = @"发微博";
    [titleView addSubview:sendWeiboLabel];
    whoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 80, 20)];
    whoLabel.text = @"发微博inging";
    whoLabel.adjustsFontSizeToFitWidth = YES;
    [titleView addSubview:whoLabel];

    self.navigationItem.titleView = titleView;
}
#pragma mark 取消方法
-(void)cancelMethod
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark 发送方法
-(void)sendMethod
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
