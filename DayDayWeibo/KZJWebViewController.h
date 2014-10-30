//
//  KZJWebViewController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-27.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZJWebViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *myWebView;
    UIActivityIndicatorView *indicatorView;
    UIView *myWebViewControl;
    UIImageView *refreshBG;
}
@property (nonatomic,retain) NSString *urlString;

@end
