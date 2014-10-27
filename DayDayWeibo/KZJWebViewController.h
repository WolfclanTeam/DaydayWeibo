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
    UIWebView *webView;
    UIActivityIndicatorView *indicatorView;

}
@property (nonatomic,retain) NSString *urlString;

@end
