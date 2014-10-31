//
//  KZJLoginView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJLoginView.h"

@implementation KZJLoginView
-(instancetype)initWithFrame:(CGRect)frame withLabelTitle:(NSString *)labelTitle withImage:(UIImage *)image
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    self = [super initWithFrame:frame];
    if (self)
    {
        UIButton*loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setTitle:@"登陆或注册" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        loginBtn.frame = CGRectMake(110, (self.frame.size.height-49)/2+80, 100, 40);
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"common_relationship_button_background@2x"] forState:UIControlStateNormal];
        loginBtn.layer.borderWidth = 0.5;
        [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginBtn];
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(50, self.frame.size.height/2-30, self.frame.size.width-100, 60)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = labelTitle;
        [self addSubview:label];
        
        UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 60, self.frame.size.width-120, 100)];
        imageView.image = image;
        [self addSubview:imageView];
        
    }
    return self;
}
-(void)login
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
