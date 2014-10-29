//
//  KZJPictureView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJPictureView.h"

@interface KZJPictureView ()

@end

@implementation KZJPictureView
@synthesize photoTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"相册";
    photoArray = [[NSArray alloc]init];
    photoBiggerArray = [[NSArray alloc]init];
    
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton*btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"userinfo_tabicon_more@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(update)];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:btnUpdate];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"photo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoShow:) name:@"photo" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"photoDetailWeibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(photoDetailWeibo:) name:@"photoDetailWeibo" object:nil];
    
}
-(void)photoDetailWeibo:(NSNotification*)notif
{
    KZJDetailWeiboViewController*detailView = [[KZJDetailWeiboViewController alloc]init];
//    NSLog(@"%@",[notif userInfo]);
    detailView.dataDict = [notif userInfo];
    detailView.kind = @"非模态";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailView animated:NO];
}
-(void)photoShow:(NSNotification*)notif
{
//    [photoArray]
    photoArray = [[notif userInfo] objectForKey:@"photo"];
    photoBiggerArray = [[notif userInfo] objectForKey:@"photoBigger"];
    page = 1;
//    NSLog(@"%@",photoArray);
    if (photoTable==nil)
    {
        photoTable = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
        photoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        photoTable.delegate = self;
        photoTable.dataSource = self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [photoTable.layer setBackgroundColor:colorref];
        self.view.layer.backgroundColor = colorref;
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        photoTable.tableHeaderView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
            UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 30)];
            label.text =@"我的相册";
            [view addSubview:label];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        photoTable.tableFooterView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
            view.userInteractionEnabled= YES;
            
            UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
            label.userInteractionEnabled = YES;
            label.text = @"更多";
            [view addSubview:label];
            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(more)];
            [label addGestureRecognizer:tap];
            label.textAlignment = NSTextAlignmentCenter;
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        [photoTable addHeaderWithTarget:self action:@selector(headerRefreshing)];
        [self.view addSubview:photoTable];
    }else
    {
        [photoTable reloadData];
    }
}
-(void)headerRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [photoTable reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [photoTable headerEndRefreshing];
    });
}
-(void)more
{
    if ([photoArray count]<page*12)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经没有更多的图片了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        
    }else
    {
        page++;
        [photoTable reloadData];
    }
}
#pragma mark table代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markPhoto";
    KZJPhotoCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[KZJPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark withBiggerPhotoArray:photoBiggerArray withControllerView:self.view];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<[photoArray count]/3)
    {
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+1] objectForKey:@"thumbnail_pic"]]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+2] objectForKey:@"thumbnail_pic"]]];
    }else if([photoArray count]%3==1)
    {
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
    }else if([photoArray count]%3==2)
    {
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+1] objectForKey:@"thumbnail_pic"]]];
    }else
    {
        NSLog(@"%d",indexPath.row);
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+1] objectForKey:@"thumbnail_pic"]]];
        [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+2] objectForKey:@"thumbnail_pic"]]];
    }
    cell.tag = 1000+indexPath.row;
    return  cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([photoArray count]>12*page)
    {
        return page*4;
    }else if([photoArray count]%3==0)
    {
        return [photoArray count]/3;
    }
    return [photoArray count]/3+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.alpha = 0;
    return view;
}

-(void)update
{
    UIActionSheet*actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"刷新",@"返回首页", nil];
    [actionSheet showInView:self.view];
}
-(void)back
{
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        self.hidesBottomBarWhenPushed = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"home" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (buttonIndex ==0)
    {
        [photoTable headerBeginRefreshing];
    }
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
