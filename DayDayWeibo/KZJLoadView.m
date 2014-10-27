//
//  KZJLoadView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJLoadView.h"

@implementation KZJLoadView

+(id)viewWithCenter:(CGPoint)center withLabelText:(NSString*)text
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.center = center;
    UIActivityIndicatorView*indicatorView= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = CGPointMake(view.frame.size.width/2, 20);
    [indicatorView startAnimating];
    [view addSubview:indicatorView];
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 100, 60)];
    label.text = text;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
