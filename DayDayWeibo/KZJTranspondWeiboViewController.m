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
@synthesize whoLabelContent,detailViewContent,urlString,Id,status;
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
    
    self.myToolBar.items = @[self.atItem,self.spaceButtonItem,self.searchHuaTiItem,self.spaceButtonItem,self.faceItem,self.spaceButtonItem,self.moreItem];
   
    UIView *weiboView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-150, 80, 300, 60)];
    weiboView.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    [self.growingTextView addSubview:weiboView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60,60)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"dsfsd.png"]];
    imageView.backgroundColor = [UIColor purpleColor];
    [weiboView addSubview:imageView];
    
    UILabel *whoLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 235, 20)];
    whoLabel.text = whoLabelContent;
    [weiboView addSubview:whoLabel];
    
    UITextView *detailView = [[UITextView alloc] initWithFrame:CGRectMake(65, 20, 235, 40)];
    detailView.backgroundColor =[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    detailView.editable = NO;
    detailView.text = detailViewContent;
    [weiboView addSubview:detailView];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}
-(void)sendMethod
{
    [self.growingTextView resignFirstResponder];
    NSString *is_comment = nil;
    if (self.commentTranspondImageView.image == [UIImage imageNamed:@"diaglog_recommended_check"])
    {
        is_comment = @"3";
    }
    else
    {
        is_comment = @"0";
    }
    KZJRequestData *requstData = [KZJRequestData requestOnly];
    [requstData zljRepostWeibo:self.Id Status:self.status is_comment:is_comment];
}
-(void)cancelMethod
{
    
    [self.growingTextView resignFirstResponder];
    

}
-(void)keyboardDidHide
{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
