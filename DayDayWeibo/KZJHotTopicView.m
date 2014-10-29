//
//  KZJHotTopicView.m
//  DayDayWeibo
//
//  Created by bk on 14/10/25.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJHotTopicView.h"

@interface KZJHotTopicView ()

@end

@implementation KZJHotTopicView
@synthesize topicArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"热门话题";
    UIButton*btnback = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 22) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"navigationbar_back@2x"] Frame:CGRectMake(0, 0, 30, 22)] title:nil target:self action:@selector(back)];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView*tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"markTopic";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"#%@#",[topicArray[indexPath.row] objectForKey:@"name"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicArray.count;
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
