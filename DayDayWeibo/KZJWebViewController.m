//
//  KZJWebViewController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-27.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJWebViewController.h"

@interface KZJWebViewController ()

@end

@implementation KZJWebViewController
@synthesize urlString;

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"加载中...";
    //返回按钮设置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    //分享按钮设置
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_more@2x.png"] Frame:CGRectMake(0,0,30,30)]];
    shareBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:shareItem];
    
    //webView控制按钮视图
    myWebViewControl = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40)];
    myWebViewControl.backgroundColor = [UIColor whiteColor];
    //webView后退
    UIButton *abackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    abackBtn.frame = CGRectMake(0, 0, 40, 40);
    UIImageView *abackBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    abackBG.image = [UIImage imageNamed:@"webtoolbar_leftarrow@2x.png"];
    [abackBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    [abackBtn addSubview:abackBG];
    [myWebViewControl addSubview:abackBtn];
    
    //webView前进
    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardBtn.frame = CGRectMake(40, 0, 40, 40);
    UIImageView *forwardBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    forwardBG.image = [UIImage imageNamed:@"toolbar_rightarrow@2x.png"];
    [forwardBtn addTarget:self action:@selector(goforward:) forControlEvents:UIControlEventTouchUpInside];
    [forwardBtn addSubview:forwardBG];
    [myWebViewControl addSubview:forwardBtn];
    
    //webView刷新以及停止刷新
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(SCREENWIDTH-40, 0, 40, 40);
    refreshBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    NSLog(@"%hhd",myWebView.isLoading);
    if (myWebView.isLoading)
    {
        refreshBG.image = [UIImage imageNamed:@"toolbar_refresh@2x.png"];
    }else
    {
        refreshBG.image = [UIImage imageNamed:@"toolbar_stop@2x.png"];
    }
    [refreshBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    [refreshBtn addSubview:refreshBG];
    [myWebViewControl addSubview:refreshBtn];
    
    [self.view addSubview:myWebViewControl];
    //
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-40-64)];
    myWebView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
    
//    [myWebView goBack]
    
    //
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(0, 0, 100, 100);
    indicatorView.center = self.view.center;
    [indicatorView startAnimating];
    [self.view addSubview:indicatorView];
}


-(void)refreshAction:(id)sender
{
    NSLog(@"%hhd",myWebView.isLoading);
    if (myWebView.isLoading)
    {
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        self.title = @"无标题";
        [myWebView stopLoading];
        refreshBG.image = [UIImage imageNamed:@"toolbar_refresh@2x.png"];
    }else
    {
        [myWebView reload];
        self.title = @"加载中...";
        refreshBG.image = [UIImage imageNamed:@"toolbar_stop@2x.png"];
    }
}

-(void)goback:(id)sender
{
    if (myWebView.canGoBack == YES)
    {
        [myWebView goBack];
    }else
    {
        NSLog(@"没有前一网页");
    }
}

-(void)goforward:(id)sender
{
    if (myWebView.canGoForward == YES)
    {
        [myWebView goForward];
    }else
    {
        NSLog(@"没有后一网页");
    }
}

-(void)shareBtnAction:(id)sender
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    refreshBG.image = [UIImage imageNamed:@"toolbar_refresh@2x.png"];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
}


-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
