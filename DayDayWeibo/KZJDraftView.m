//
//  KZJDraftView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJDraftView.h"

@interface KZJDraftView ()

@end

@implementation KZJDraftView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"草稿箱";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView*draftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    draftTable.delegate = self;
    draftTable.dataSource = self;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
    draftTable.layer.backgroundColor = colorref;
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
    draftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:draftTable];
    
    draftArray = [[NSArray alloc]init];
    draftArray = [[KZJRequestData requestOnly]getCoreData:@"StoreWeibo"];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"draftMark";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    StoreWeibo*storeWeibo = draftArray[indexPath.section];
    cell.imageView.image = [UIImage imageWithData:storeWeibo.image];
    cell.textLabel.text = storeWeibo.textContent;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [draftArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZJShareController*shareView = [[KZJShareController alloc]init];
    StoreWeibo*storeWeibo = draftArray[indexPath.section];
    NSLog(@"%@",storeWeibo.textContent);
    shareView.weiboContentTextView.text = storeWeibo.textContent;
    self.hidesBottomBarWhenPushed = YES;
    UINavigationController*shareC = [[UINavigationController alloc]initWithRootViewController:shareView];
    [self presentViewController:shareC animated:YES completion:^{
        
    }];
    //微博用sharecontroller，评论用KZJCommentWeiboViewController
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
