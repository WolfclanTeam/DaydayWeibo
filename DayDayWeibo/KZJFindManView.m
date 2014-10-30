//
//  KZJFindManView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJFindManView.h"

@interface KZJFindManView ()

@end

@implementation KZJFindManView
@synthesize tableview,findTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    peopleArray = [[NSArray alloc]init];
    
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找人";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    type = @"default";
    
    [self.view addSubview:tableview];
    tableview.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        UISearchBar*searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        searchBar.tag = 998;
        searchBar.delegate = self;
        
        [view addSubview:searchBar];
        NSArray*btnTitle = [NSArray arrayWithObjects:@"名人",@"专家",@"兴趣",@"风云榜", nil];
        NSArray*btnImage = [NSArray arrayWithObjects:@"findfriend_icon_star",@"findfriend_icon_star",@"friendcircle_compose_friendcirclebutton@2x",@"timeline_card_small_article@2x", nil];
        for (int i = 0; i<4; i++)
        {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREENWIDTH/4*i, 40, SCREENWIDTH/4, 60);
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SCREENWIDTH/4, 15)];
            label.text = btnTitle[i];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [btn addSubview:label];
            [btn setImage:[UIImage redraw:[UIImage imageNamed:btnImage[i]] Frame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
            [view addSubview:btn];
        }
        view;
    });
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview headerBeginRefreshing];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"findManView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findManView:) name:@"findManView" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"relation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relation:) name:@"relation" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attention" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(attention) name:@"attention" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelAttention" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelAttention) name:@"cancelAttention" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"people" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(people:) name:@"people" object:nil];
}

-(void)findManView:(NSNotification*)notif
{
    manArray = [[notif userInfo] objectForKey:@"findMan"];
//    NSLog(@"%@",manArray);
    [tableview headerEndRefreshing];
    [tableview reloadData];
}
-(void)headerRefresh
{
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager startRequestData12:type];
}
//
-(void)relation:(NSNotification*)notif
{
    dictDetail = [[notif userInfo] objectForKey:@"target"];
//    NSLog(@"%@",[dictDetail objectForKey:@"followed_by"]);
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
//            NSLog(@"%@",dictDetail);
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
    [tableview headerBeginRefreshing];
}
-(void)attention
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [tableview headerBeginRefreshing];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableview])
    {
        static NSString*mark = @"markFind";
        KZJInformationCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell ==nil)
        {
            cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        }
        
        if (manArray.count>0)
        {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[manArray[indexPath.row] objectForKey:@"profile_image_url"]]];
            cell.labelName.text = [manArray[indexPath.row]objectForKey:@"screen_name"];
            cell.labelDetial.text = [[manArray[indexPath.row]objectForKey:@"status"] objectForKey:@"text"];
            NSLog(@"%@",[manArray[indexPath.row]objectForKey:@"following"]);
            if ([[manArray[indexPath.row]objectForKey:@"following"] intValue]==0)
            {
                [cell.btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted@2x"] forState:UIControlStateNormal];
            }else if([[manArray[indexPath.row]objectForKey:@"following"] intValue]==1)
            {
                if ([[manArray[indexPath.row]objectForKey:@"follow_me"] intValue]==1) {
                    [cell.btn setImage:[UIImage imageNamed:@"card_icon_attention@2x"] forState:UIControlStateNormal];
                }else
                {
                    [cell.btn setImage:[UIImage imageNamed:@"card_icon_arrow@2x"] forState:UIControlStateNormal];
                }
            }
            cell.btn.titleLabel.text = [NSString stringWithFormat:@"%@",[manArray[indexPath.row] objectForKey:@"id"]];
            cell.btn.titleLabel.hidden = YES;
            [cell.btn setHidden:NO];
        }
        return cell;
    }
    static NSString *mark = @"markInformation";
    KZJInformationCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    if (peopleArray.count>0)
    {
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[peopleArray[indexPath.row] objectForKey:@"profile_image_url"]]];
        cell.labelName.text = [peopleArray[indexPath.row]objectForKey:@"name"];
        cell.labelDetial.text = [NSString stringWithFormat:@"简介:%@",[peopleArray[indexPath.row]objectForKey:@
                                                                     "description"]];
        if ([[peopleArray[indexPath.row]objectForKey:@"following"] intValue]==0)
        {
            [cell.btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted@2x"] forState:UIControlStateNormal];
        }else if([[peopleArray[indexPath.row]objectForKey:@"following"] intValue]==1)
        {
            if ([[peopleArray[indexPath.row]objectForKey:@"follow_me"] intValue]==1) {
                [cell.btn setImage:[UIImage imageNamed:@"card_icon_attention@2x"] forState:UIControlStateNormal];
            }else
            {
                [cell.btn setImage:[UIImage imageNamed:@"card_icon_arrow@2x"] forState:UIControlStateNormal];
            }
        }
        cell.btn.titleLabel.text = [NSString stringWithFormat:@"%@",[peopleArray[indexPath.row]objectForKey:@"id"]];
        cell.btn.titleLabel.hidden = YES;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tableview])
    {
        return 10;
    }
    return peopleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:tableview])
    {
        return 20;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    NSDictionary*dict = @{@"default":@"人气关注",@"ent":@"影视名星",@"music":@"音乐",@"sports":@"体育",@"fashion":@"时尚",@"art":@"艺术",@"cartoon":@"动漫",@"games":@"游戏",@"trip":@"旅行",@"food":@"美食",@"health":@"健康",@"literature":@"文学",@"stock":@"炒股",@"business":@"商界",@"tech":@"科技",@"house":@"房产",@"auto":@"汽车",@"fate":@"命理",@"govern":@"政府",@"medium":@"媒体",@"marketer":@"营销专家"};
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-10, 20)];
    label.text = [dict objectForKey:type];
    label.tag = 1000;
    label.font = [UIFont systemFontOfSize:10];
    [view addSubview:label];
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SCREENWIDTH-40, 0, 40, 20);
    if ([[[UIDevice currentDevice] systemVersion] intValue]<8)
    {
        [btn setImage:[UIImage redraw:[UIImage imageNamed:@"userinfo_icon_screening@2x"] Frame:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
    }else if ([[[UIDevice currentDevice] systemVersion] intValue]>=8)
    {
        [btn setImage:[UIImage imageNamed:@"userinfo_icon_screening@2x"] forState:UIControlStateNormal];
    }
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    [btn addTarget:self action:@selector(screen:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
    [view.layer setBackgroundColor:colorref];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    return  view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)screen:(UIButton*)btn
{
    static int flaggg=0;
    if (!flaggg)
    {
        NSArray*titles = [NSArray arrayWithObjects:@"人气关注",@"影视名星",@"音乐",@"体育",@"时尚",@"艺术",@"动漫",@"游戏",@"旅行",@"美食",@"健康",@"文学", nil];
        int height = tableview.contentOffset.y>34?84:184-tableview.contentOffset.y;
        KZJPullDownView*view = [[KZJPullDownView alloc]initWithFrame:CGRectMake(SCREENWIDTH-105,height, 100, 100) withTitles:titles];
        view.delegate = self;
        view.tag = 999;
        [self.view addSubview:view];
        flaggg=1;
    }else if (flaggg)
    {
        KZJPullDownView*view = (KZJPullDownView*)[self.view viewWithTag:999];
        [view removeFromSuperview];
        flaggg=0;
    }
}

-(void)clickTable:(NSString *)title
{
    NSDictionary*dict = @{@"default":@"人气关注",@"ent":@"影视名星",@"music":@"音乐",@"sports":@"体育",@"fashion":@"时尚",@"art":@"艺术",@"cartoon":@"动漫",@"games":@"游戏",@"trip":@"旅行",@"food":@"美食",@"health":@"健康",@"literature":@"文学"};
    for (NSString*str in dict.allKeys)
    {
        NSString*typeeee = [dict objectForKey:str];
        if ([title isEqualToString:typeeee])
        {
            type = str;
            [tableview headerBeginRefreshing];
            return;
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    KZJPullDownView*view = (KZJPullDownView*)[self.view viewWithTag:999];
//    NSLog(@"%f",scrollView.contentOffset.y);
    int height = scrollView.contentOffset.y>100?84:184-scrollView.contentOffset.y;
    view.frame = CGRectMake(SCREENWIDTH-105,height, 100, 100);
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        for (UIView *view in [cc subviews])
        {
            // 遍历出来的是UINavigationButton。不知道是不是类，反正我跟不出来所以把他转成字符串再比较
            if ([NSStringFromClass(view.class) isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
    }
    if (findTable==nil)
    {
        findTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREENWIDTH, SCREENHEIGHT-104)];
        findTable.delegate =self;
        findTable.dataSource = self;
        findTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        tableview.backgroundColor = [UIColor greenColor];
        
    }else
    {
        [findTable reloadData];
    }
    [self.view addSubview:findTable];
    
    UIBarButtonItem*itemDone1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    //
    UIBarButtonItem*itemDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIToolbar*tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,30 )];
    tools.items = [NSArray arrayWithObjects:itemDone,itemDone1, nil];
    searchBar.inputAccessoryView = tools;
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [[KZJRequestData requestOnly]startRequestData6:searchBar.text];
    
}
-(void)doneAction:(id)sender
{
    UISearchBar*searchBar = (UISearchBar*)[self.view viewWithTag:998];
    [searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [findTable removeFromSuperview];
    [searchBar resignFirstResponder];
}
#pragma mark 搜索返回的个人信息
-(void)people:(NSNotification*)notif
{
    peopleArray = [[notif userInfo] objectForKey:@"people"];
    NSLog(@"%@",peopleArray);
    [findTable reloadData];
}

-(void)back
{
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelAttention" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attention" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"relation" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"people" object:nil];
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
