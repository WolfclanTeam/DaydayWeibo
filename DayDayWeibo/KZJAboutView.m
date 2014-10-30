//
//  KZJAboutView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJAboutView.h"

@interface KZJAboutView ()

@end

@implementation KZJAboutView
@synthesize tableview;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于微博";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (tableview==nil)
    {
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource =self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [tableview.layer setBackgroundColor:colorref];
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        
        tableview.tableHeaderView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
            view.backgroundColor = [UIColor clearColor];
            UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            image.center = CGPointMake(SCREENWIDTH/2, 45);
            image.image = [UIImage imageNamed:@"more_weibo@2x"];
            [view addSubview:image];
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
            label.center = CGPointMake(SCREENWIDTH/2, 90);
            label.text = @"微博";
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
            label1.center = CGPointMake(SCREENWIDTH/2, 110);
            label1.text = @"Versionxxx";
            label1.font = [UIFont systemFontOfSize:15];
            label1.textColor = [UIColor orangeColor];
            label1.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label1];
            
            view;
        });
        tableview.tableFooterView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
            view.backgroundColor = [UIColor clearColor];
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
            label.center = CGPointMake(SCREENWIDTH/2, 30);
            label.text = @"客服电话(按当地市话标准收费)";
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
            label1.center = CGPointMake(SCREENWIDTH/2, 55);
            label1.text = @"企业用户:4000 980 980";
            label1.font = [UIFont systemFontOfSize:13];
            label1.textColor = [UIColor lightGrayColor];
            label1.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label1];
            
            UILabel*label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
            label2.center = CGPointMake(SCREENWIDTH/2, 75);
            label2.text = @"个人用户:4000 960 960";
            label2.font = [UIFont systemFontOfSize:13];
            label2.textColor = [UIColor lightGrayColor];
            label2.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label2];
            
            UILabel*label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
            label3.center = CGPointMake(SCREENWIDTH/2, 100);
            label3.text = @"视频播放技术由vitamio提供";
            label3.font = [UIFont systemFontOfSize:12];
            label3.textColor = [UIColor lightGrayColor];
            label3.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label3];
            
            UILabel*label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
            label4.center = CGPointMake(SCREENWIDTH/2, 120);
            label4.text = @"微博服务使用协议";
            label4.font = [UIFont systemFontOfSize:10];
            label4.textColor = [UIColor blueColor];
            label4.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label4];
            
            UILabel*label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
            label5.center = CGPointMake(SCREENWIDTH/2, 140);
            label5.text = @"Copyright 2009-2014 WEIBO";
            label5.font = [UIFont systemFontOfSize:10];
            label5.textColor = [UIColor lightGrayColor];
            label5.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label5];
            
            
            
            view;
        });
        
        [self.view addSubview:tableview];
    }
    titleArray = [NSArray arrayWithObjects:@"给我评分",@"官方微博",@"常见问题",@"版本更新",nil];
    
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)back
{
    //    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableview代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markremind";
    UITableViewCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    
    UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30, 12, 20, 20)];
    image.image = [UIImage imageNamed:@"login_detail@2x"];
    [cell.contentView addSubview:image];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        [self grade];
        
    }else if (indexPath.row ==3)
    {
        if (indicatorview==nil)
        {
            indicatorview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorview.center = CGPointMake(160, 200);//设置大小
            //    indicatorView.frame.size = CGSizeMake(100, 80);
            [self.view addSubview:indicatorview];
            [indicatorview startAnimating];
            NSLog(@"1231");
        }else
        {
            NSLog(@"===");
            [self.view addSubview:indicatorview];
        }
        
        NSString *URL = @"http://itunes.apple.com/lookup?id=386098453";
        NSURL*url = [NSURL URLWithString:URL];
        //
        NSURLRequest*request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        //创建get异步请求
        getConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//接收到请求响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    getData = [[NSMutableData alloc]init];
}
//连接建立,开始接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [getData appendData:data];
    
}
//数据加载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [indicatorview removeFromSuperview];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *results = [[NSString alloc] initWithBytes:[getData bytes] length:[getData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [results objectFromJSONString];
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            //trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
            alert.tag = 10000;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
    }
    
}
//请求失败触发事件
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection == getConnection)
    {
        NSLog(@"请求失败,error=%@",error);
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==0) {
            
            [self grade];
        }
    }
}
#pragma mark 给我评分
-(void)grade
{
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    [storeProductViewController setDelegate:self];
    
    UIActivityIndicatorView*indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(160, 200);//设置大小
    //    indicatorView.frame.size = CGSizeMake(100, 80);
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 40)];
    label.center = CGPointMake(160, 250);
    label.text = @"页面加载中,请稍等...";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    //        label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    
    //下面字典应该填写自己的app ID
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : @"386098453"}
                                          completionBlock:^(BOOL result, NSError *error) {
                                              if (error) {
                                                  NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                                                  [indicator stopAnimating];//活动指示器停止动画
                                                  [indicator removeFromSuperview];
                                                  [label removeFromSuperview];
                                              } else {
                                                  [self presentViewController:storeProductViewController animated:YES completion:nil];
                                                  [indicator stopAnimating];//活动指示器停止动画
                                                  [indicator removeFromSuperview];
                                                  [label removeFromSuperview];
                                              }
                                          }];
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
