//
//  KZJFansView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-21.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJFansView.h"

@interface KZJFansView ()

@end

@implementation KZJFansView
@synthesize kind,fanstable,ID;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = kind;
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    number = [[NSArray alloc]init];
    relationArray = [[NSArray alloc]init];
    if (fanstable ==nil)
    {
        fanstable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
        fanstable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [fanstable addHeaderWithTarget:self action:@selector(headerRefresh)];
        [fanstable addFooterWithTarget:self action:@selector(footerRefresh)];
        [fanstable headerBeginRefreshing];
        fanstable.delegate = self;
        fanstable.dataSource =self;
        [self.view addSubview:fanstable];
    }
    page=1;
    
    [[KZJRequestData requestOnly]startRequestData3:page withTitle:kind withID:ID];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fansData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fansData:) name:@"fansData" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"relation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relation:) name:@"relation" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attention" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(attention) name:@"attention" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelAttention" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelAttention) name:@"cancelAttention" object:nil];
    
}
-(void)fansData:(NSNotification*)notif
{
    NSDictionary*dict = [notif userInfo];
    number = [dict objectForKey:@"users"];
//    relationArray = [dict objectForKey:@"relation"];
    flag=1;
    [fanstable headerEndRefreshing];
    [fanstable footerEndRefreshing];
    [fanstable reloadData];
}
#pragma mark 下拉加载
-(void)footerRefresh
{
    int64_t delayInSeconds = 0.0001;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        page++;
        [[KZJRequestData requestOnly]startRequestData3:page withTitle:kind withID:ID];
        
    });
}
#pragma mark 上拉刷新
-(void)headerRefresh
{
    if (flag==1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [fanstable reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [fanstable headerEndRefreshing];
        });
    }
}
//搜索返回的个人关系信息
-(void)relation:(NSNotification*)notif
{
    dictDetail = [[notif userInfo] objectForKey:@"target"];
    NSLog(@"%@",[dictDetail objectForKey:@"followed_by"]);
    if ([[dictDetail objectForKey:@"followed_by"] intValue])
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"你确定取消关注该用户?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag = 110;
        [alert show];
    }else
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"你确定关注该用户?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag = 111;
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==110)
    {
        if (buttonIndex==0)
        {
            NSLog(@"%@",dictDetail);
            [[KZJRequestData requestOnly]startRequestData10:[NSString stringWithFormat:@"%@",[dictDetail objectForKey:@"id"]] withName:[dictDetail objectForKey:@"screen_name"]];
        }
    }else if (alertView.tag==111)
    {
        if (buttonIndex==0)
        {
            [[KZJRequestData requestOnly]startRequestData9:[NSString stringWithFormat:@"%@",[dictDetail objectForKey:@"id"]] withName:[dictDetail objectForKey:@"screen_name"]];
        }
    }else if (alertView.tag==112)
    {
        if (buttonIndex==0)
        {
            [[KZJRequestData requestOnly]startRequestData10:[NSString stringWithFormat:@"%@",[dictDetail2 objectForKey:@"id"]] withName:[dictDetail objectForKey:@"screen_name"]];
        }
    }
}
-(void)cancelAttention
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    if ([kind isEqualToString:@"关注"])
    {
        NSLog(@"313");
        [fanstable headerBeginRefreshing];
        [[KZJRequestData requestOnly]startRequestData3:page withTitle:kind withID:ID];
    }
}
-(void)attention
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
}

-(void)back
{
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableView代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markInformation";
    KZJInformationCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    if ([number count]>0)
    {
        [cell.image sd_setImageWithURL:[number[indexPath.row] objectForKey:@"profile_image_url"]];
        cell.labelName.text = [number[indexPath.row] objectForKey:@"name"];
        int follow = [[number[indexPath.row]objectForKey:@"follow_me"] intValue];
        if ([kind isEqualToString:@"关注"]) {
            if (follow ==1)
            {
                [cell.btn setImage:[UIImage imageNamed:@"card_icon_arrow@2x"] forState:UIControlStateNormal];
            }else
            {
                [cell.btn setImage:[UIImage imageNamed:@"card_icon_attention@2x"] forState:UIControlStateNormal];
            }
            cell.btn.tag = 1000+indexPath.row;
            [cell.btn addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([kind isEqualToString:@"粉丝"])
        {
            [cell.btn setImage:[UIImage imageNamed:@"login_user@2x"] forState:UIControlStateNormal];
            cell.btn.titleLabel.text = [NSString stringWithFormat:@"%@",[number[indexPath.row] objectForKey:@"id"]];
            cell.btn.titleLabel.hidden = YES;
        }
        
        NSDictionary*dict = [number[indexPath.row] objectForKey:@"status"];
        cell.labelDetial.text = [dict objectForKey:@"text"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [number count];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)attention:(UIButton*)btn
{
    NSLog(@"%d",btn.tag);
    dictDetail2 = number[btn.tag-1000];
    UIActionSheet*actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"置顶",@"私信",@"分组",@"取消关注", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==3)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"你确定取消关注该用户?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag = 112;
        [alert show];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelAttention" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attention" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"relation" object:nil];
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
