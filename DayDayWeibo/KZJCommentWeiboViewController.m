//
//  KZJCommentWeiboViewController.m
//  DayDayWeibo
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCommentWeiboViewController.h"

@interface KZJCommentWeiboViewController ()

@end

@implementation KZJCommentWeiboViewController

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
    
    self.titleLabel.text = @"回复评论";
    self.growingTextView.placeholder = @"写评论...";
    self.commentTranspondLabel.text = @"同时转发";
    
   
    self.myToolBar.items = @[self.atItem,self.searchHuaTiItem,self.moreItem];
    
   
   
}
#pragma mark atMethod
-(void)atMethod
{
    
}
-(void)cancelMethod
{
    [self.growingTextView resignFirstResponder];
    
    if ([self.growingTextView hasText])
    {
        UIAlertView *saveAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存到草稿箱？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        [saveAlertView show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 重写父类收到键盘已回收的通知方法
-(void)keyboardDidHide
{
    
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(buttonIndex ==1)
    {
#warning  保存到草稿箱
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark HPGrowingTextViewDelegate
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if ([self.growingTextView hasText])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
    }
}

//#pragma mark commentTranspondMethod 重写父类方法
//-(void)commentTranspondMethod
//{
//    self.commentTranspondImageView.image = [uiim]
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
