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
@synthesize draftTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"草稿箱";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    draftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
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
//**********删除与添加****************
//tableview响应编辑
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [draftTable setEditing:editing animated:animated];
}
//cell响应的编辑按钮样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray*array = [[KZJRequestData alloc]getCoreData:@"StoreWeibo"];
        for (StoreWeibo*storeWeibo in array)
        {
            if ([storeWeibo.textContent isEqualToString:cell.detailTextLabel.text])
            {
                draftArray = (NSMutableArray*)[[KZJRequestData alloc]deleteCoreData:@"StoreWeibo" withData:storeWeibo];
                //                NSLog(@"===%@",numberArray);
                [tableView reloadData];
            }
        }
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"draftMark";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mark];
    }
    StoreWeibo*storeWeibo = draftArray[indexPath.section];
    cell.imageView.image = [UIImage imageWithData:storeWeibo.image];
    cell.textLabel.text = storeWeibo.identifierName;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = storeWeibo.textContent;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
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
    StoreWeibo*storeWeibo = draftArray[indexPath.section];
    if ([storeWeibo.identifierName isEqualToString:@"微博"])
    {
        KZJShareController*shareView = [[KZJShareController alloc]init];
        shareView.weiboContent = storeWeibo.textContent;
        shareView.myImage = [UIImage imageWithData:storeWeibo.image];
        self.hidesBottomBarWhenPushed = YES;
        UINavigationController*shareC = [[UINavigationController alloc]initWithRootViewController:shareView];
        [self presentViewController:shareC animated:YES completion:^{
            
        }];
    }else if ([storeWeibo.identifierName isEqualToString:@"评论"])
    {
        KZJCommentWeiboViewController*commentView = [[KZJCommentWeiboViewController alloc]init];
        commentView.commentContent = storeWeibo.textContent;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentView animated:YES];
    }
    
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
