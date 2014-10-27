//
//  KZJHomeController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJHomeController.h"

@interface KZJHomeController ()

@end

@implementation KZJHomeController

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

    self.automaticallyAdjustsScrollViewInsets=NO;
    
    // Do any additional setup after loading the view.
    page = 1;
    weiboList = [[KZJWeiboTableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-49) view:self.tabBarController.view];
    KZJRequestData *dataManger = [KZJRequestData requestOnly];
    [dataManger getHomeWeibo];
    [dataManger passWeiboData:^(NSDictionary *dict) {
        dataArr = [dict objectForKey:@"statuses"];
        weiboList.dataArr = dataArr;
        [self.view addSubview:weiboList];
        
        [weiboList addHeaderWithTarget:self action:@selector(headerRefresh)];
        [weiboList headerBeginRefreshing];
        [weiboList addFooterWithTarget:self action:@selector(footerRefresh)];

        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushDetailWeibo:) name:@"DETAILWEIBO" object:nil];
}

-(void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        [datamanager getHomeWeibo];
        
        [datamanager passWeiboData:^(NSDictionary *dict) {
            weiboList.dataArr = [dict objectForKey:@"statuses"];
            [weiboList reloadData];
            page = 1;
        }];
        
//        [weiboList reloadData];
        [weiboList headerEndRefreshing];
    });
}
//
//
-(void)footerRefresh
{
    page++;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        [datamanager getNewWeibo:[NSString stringWithFormat:@"%d",page]];
        
        [datamanager passWeiboData:^(NSDictionary *dict) {
            NSMutableArray *weibos = [NSMutableArray arrayWithArray:weiboList.dataArr];
            for (int i =0; i<[[dict objectForKey:@"statuses"] count]; i++)
            {
                [weibos addObject:[[dict objectForKey:@"statuses"] objectAtIndex:i]];
            }
            NSLog(@"====%d",[weibos count]);
            weiboList.dataArr = weibos;
            
            [weiboList headerEndRefreshing];
            [weiboList reloadData];
        }];
        
        [weiboList reloadData];
        [weiboList footerEndRefreshing];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)pushDetailWeibo:(NSNotification*)noti
{
    NSDictionary *dict = [noti userInfo];
    KZJDetailWeiboViewController *detailWeibo = [[KZJDetailWeiboViewController alloc] init];
    UINavigationController *nav_detailWeibo = [[UINavigationController alloc] initWithRootViewController:detailWeibo];
    detailWeibo.dataDict = dict;
    [self presentViewController:nav_detailWeibo animated:YES completion:nil];
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
