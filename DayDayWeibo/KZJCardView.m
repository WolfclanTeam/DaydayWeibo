//
//  KZJCardView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCardView.h"

@interface KZJCardView ()

@end

@implementation KZJCardView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的名片";
    
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton*btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"userinfo_tabicon_more@2x"] Frame:CGRectMake(0, 0, 25, 22)] title:nil target:self action:@selector(share)];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnUpdate];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
    [self.view.layer setBackgroundColor:colorref];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    UIImageView*photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    UserInformation*info = [[[KZJRequestData alloc]init]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    [photo sd_setImageWithURL:[NSURL URLWithString:info.photo]];
    UIImage*image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"http://m.weibo.cn/u/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]] imageSize:250 Topimg:photo.image];
    UIImageView*imageview = [[UIImageView alloc]initWithFrame:CGRectMake(45, 100, 230, 250)];
    imageview.image = image;
    imageview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageview];
    
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(45, 352, 230, 70)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel*nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 230, 40)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = info.name;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:nameLabel];
    
    UILabel*welcomeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 230, 30)];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = @"扫描上面的二维码,关注我吧";
    welcomeLabel.font = [UIFont systemFontOfSize:13];
    welcomeLabel.textColor = [UIColor grayColor];
    [view addSubview:welcomeLabel];
}
-(void)share
{
    KZJShareSheet*view = [KZJShareSheet shareWeiboView];
    view.tag = 1000;
    [self.view addSubview:view];
}
-(void)back
{
    self.hidesBottomBarWhenPushed = NO;
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
