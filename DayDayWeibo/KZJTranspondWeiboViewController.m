//
//  KZJTranspondWeiboViewController.m
//  DayDayWeibo
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJTranspondWeiboViewController.h"

@interface KZJTranspondWeiboViewController ()

@end

@implementation KZJTranspondWeiboViewController

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
    self.titleLabel.text = @"转发微博";
    self.commentTranspondLabel.text = @"同时评论";
    self.growingTextView.placeholder = @"说说分享心得";
    
    self.myToolBar.items = @[self.atItem,self.spaceButtonItem,self.searchHuaTiItem,self.spaceButtonItem,self.moreItem];
   
}
//#pragma mark commentTranspondMethod 重写父类方法
//-(void)commentTranspondMethod
//{
//    
//}
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
