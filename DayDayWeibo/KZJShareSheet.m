//
//  KZJShareSheet.m
//  DayDayWeibo
//
//  Created by bk on 14-10-23.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJShareSheet.h"

@implementation KZJShareSheet

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(KZJShareSheet*)shareWeiboView
{
    static KZJShareSheet*view1 = nil;
    if (view1==nil)
    {
        view1 =[[KZJShareSheet alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20)];
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-200-20, SCREENWIDTH, 200)];
        view.backgroundColor= [UIColor whiteColor];
        NSArray*titleArray = [NSArray arrayWithObjects:@"私信",@"微信好友",@"朋友圈",@"短信",@"发送邮件", nil];
        UILabel*title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 25)];
        title.text = @"分享到";
        [view addSubview:title];
        for (int i =0; i<5; i++)
        {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+i*64, 40, 44, 44);
            btn.tag = 1000+i;
            if (i==0) {
                [btn setImage:[UIImage imageNamed:@"more_chat@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_chat_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==1)
            {
                [btn setImage:[UIImage imageNamed:@"more_weixin@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_weixin_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==2)
            {
                [btn setImage:[UIImage imageNamed:@"more_circlefriends@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_circlefriends_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==3)
            {
                [btn setImage:[UIImage imageNamed:@"more_mms@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_mms_highlighted@2x"] forState:UIControlStateHighlighted];
            }else if (i==4)
            {
                [btn setImage:[UIImage imageNamed:@"more_email@2x"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"more_email_highlighted@2x"] forState:UIControlStateHighlighted];
            }
            [btn addTarget:view1.superview action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+i*64, 85, 44, 25)];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titleArray[i];
            titleLabel.tag = 1100+i;
            titleLabel.font = [UIFont systemFontOfSize:11];
            [view addSubview:titleLabel];
        }
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, SCREENWIDTH, 1)];
        line.backgroundColor = [UIColor grayColor];
        [view addSubview:line];
        
        UIButton*cancel  =[UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = CGRectMake(0, 170, SCREENWIDTH, 30);
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancel addTarget:view1.superview action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:cancel];
        
        UIView*view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        view2.backgroundColor= [UIColor blackColor];
        view2.alpha = 0.5;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:view1 action:@selector(cancel1)];
        [view2 addGestureRecognizer:tap];
        
        [view1 addSubview:view2];
        [view1 addSubview:view];
        
        UILabel*line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, SCREENWIDTH, 3)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:line1];
        
        
    }
    view1.tag = 999;
    return view1;
}
-(void)cancel1
{
    [self removeFromSuperview];
}

-(void)btnAction:(UIButton*)btn
{
    UILabel*label = (UILabel*)[self viewWithTag:btn.tag+100];
    if ([label.text isEqualToString:@"短信"])
    {
        NSURL*url=[NSURL URLWithString:@"sms:15915839305"];
        //判断能否打开短信功能
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //打开短信
            [[UIApplication sharedApplication]openURL:url];
        }
        else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"无法打开短信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        
    }else if ([label.text isEqualToString:@"发送邮件"])
    {
        NSString*urlStr=[NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",@"331993917@qq.com",@"1021571396@qq.com",@"下午开会",@"确定国家十三五规划"];
        NSURL*url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@",url);
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
        else{
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"邮件调用失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    [self cancel1];
}




+(UIView*)shareCardView
{
    UIView*view;
    return view;
}
@end
