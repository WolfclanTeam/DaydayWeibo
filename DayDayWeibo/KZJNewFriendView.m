//
//  KZJNewFriendView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/30.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJNewFriendView.h"

@interface KZJNewFriendView ()

@end

@implementation KZJNewFriendView
@synthesize friendTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新的好友";
    
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    friendTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    friendTable.delegate = self;
    friendTable.dataSource = self;
    [friendTable addHeaderWithTarget:self action:@selector(headerRefresh)];
    [friendTable headerBeginRefreshing];
    [friendTable addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.view addSubview:friendTable];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"people" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friend:) name:@"people" object:nil];
}
-(void)friend:(NSNotification*)notif
{
    dataArr = [[notif userInfo] objectForKey:@"people"];
    [friendTable headerEndRefreshing];
    [friendTable footerEndRefreshing];
    [friendTable reloadData];
}
-(void)headerRefresh
{
    page = 1;
    [[KZJRequestData requestOnly]startRequestData15:page];
}
-(void)footerRefresh
{
    page++;
    [[KZJRequestData requestOnly]startRequestData15:page];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markFriend";
    KZJInformationCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[dataArr[indexPath.row] objectForKey:@"profile_image_url"]]];
    cell.labelName.text = [dataArr[indexPath.row]objectForKey:@"name"];
    cell.labelDetial.text = [NSString stringWithFormat:@"简介:%@",[dataArr[indexPath.row]objectForKey:@
                                                                 "description"]];
    if ([[dataArr[indexPath.row]objectForKey:@"following"] intValue]==0)
    {
        [cell.btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted@2x"] forState:UIControlStateNormal];
    }else if([[dataArr[indexPath.row]objectForKey:@"following"] intValue]==1)
    {
        if ([[dataArr[indexPath.row]objectForKey:@"follow_me"] intValue]==1) {
            [cell.btn setImage:[UIImage imageNamed:@"card_icon_attention@2x"] forState:UIControlStateNormal];
        }else
        {
            [cell.btn setImage:[UIImage imageNamed:@"card_icon_arrow@2x"] forState:UIControlStateNormal];
        }
    }
    cell.btn.titleLabel.text = [NSString stringWithFormat:@"%@",[dataArr[indexPath.row]objectForKey:@"id"]];
    cell.btn.titleLabel.hidden = YES;
    [cell.btn setHidden:NO];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
