//
//  KZJ@MyCommentSupportBaseController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-20.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMyMessageDetailBaseController.h"

@interface KZJMyMessageDetailBaseController ()

@end

@implementation KZJMyMessageDetailBaseController
@synthesize btnTitleView,downMenuButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //右侧按钮 设置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setMethod)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    
    //左侧按钮 放回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backMethod)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    
    btnTitleView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, self.navigationItem.titleView.frame.size.height)];
    [btnTitleView setTitle:@"所有微博" forState:UIControlStateNormal];
    //btnTitleView.titleLabel.font=[UIFont systemFontOfSize:14];
    btnTitleView.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btnTitleView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTitleView addTarget:self action:@selector(dropDownMenuMethod) forControlEvents:UIControlEventTouchUpInside];
    //testView.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView =btnTitleView;
    

    
}

-(void)dropDownMenuMethod
{


}

-(void)setMethod
{
    NSLog(@"设置");
}
-(void)backMethod
{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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
