//
//  KZJFindController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJFindController.h"

@interface KZJFindController ()

@end

@implementation KZJFindController
@synthesize topicTable,tableview;
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
    slideAnimationController  = [[SlideAnimation alloc] init];
    
    self.navigationController.delegate =self;
    
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    peopleArray = [[NSArray alloc]init];
//    relationArray = [[NSArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hourtopic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topic:) name:@"hourtopic" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    KZJLoadView*loadView = [KZJLoadView viewWithCenter:CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2) withLabelText:@"页面加载中..."];
    loadView.tag =1000;
    [self.view addSubview:loadView];
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    
    [[KZJRequestData requestOnly]startRequestData4];
}

-(void)topic:(NSNotification*)notif
{
    KZJLoadView*loadView = (KZJLoadView*)[self.view viewWithTag:1000];
    [loadView removeFromSuperview];
    NSDictionary*dict = [notif userInfo];
    topicArray = [NSArray arrayWithArray:[dict objectForKey:[[dict allKeys] objectAtIndex:0]]];
//    NSLog(@"%@",dict);
    int num = arc4random_uniform([topicArray count]);
    
    UIView*view =[[UIView alloc]initWithFrame:CGRectMake(0, 5, 260, 34)];
    view.tag = 1250;
    view.layer.cornerRadius = 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.9, 0.9, 0.9, 1 });
    view.layer.backgroundColor = colorref;
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    view.userInteractionEnabled = YES;
    
    UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    image.tag = 1251;
    image.image = [UIImage imageNamed:@"searchbar_textfield_search_icon_disable@2x"];
    [view addSubview:image];
    UITextField*textfield = [[UITextField alloc]initWithFrame:CGRectMake(30, 2, 230, 30)];
    textfield.tag = 1252;
    textfield.delegate =self;
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([topicArray count])
    {
        textfield.placeholder = [NSString stringWithFormat:@"大家都在搜:%@",[topicArray[num]objectForKey:@"name"]];
    }
    
    textfield.font = [UIFont systemFontOfSize:15];
    textfield.keyboardType = UIKeyboardTypeDefault;
    
    //完成按钮
    UIBarButtonItem*itemDone1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    //
    UIBarButtonItem*itemDone = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIToolbar*tools = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,30 )];
    tools.items = [NSArray arrayWithObjects:itemDone,itemDone1, nil];
    textfield.inputAccessoryView = tools;
    
    [view addSubview:textfield];
    UIBarButtonItem*leftItem1 = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    UIButton*btnRecord = [UIButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, 30, 35) backgroundImage:[UIImage redraw:[UIImage imageNamed:@"message_voice_background@2x"] Frame:CGRectMake(0, 0, 30,35)] title:nil target:self action:@selector(record:)];
    UIBarButtonItem*leftItem2 = [[UIBarButtonItem alloc]initWithCustomView:btnRecord];
    btnRecord.tag = 1253;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftItem1,leftItem2, nil];
    
    NSArray*titleNameArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"热门微博",@"找人", nil],[NSArray arrayWithObjects:@"游戏中心",@"应用",@"周边", nil],[NSArray arrayWithObjects:@"电影",@"听歌",@"发现兴趣", nil], nil];
    
    NSArray*titleImageArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"o_weibo@2x",@"findfriend_icon_star@2x", nil], [NSArray arrayWithObjects:@"more_icon_channelmanage@2x",@"more_icon_code@2x",@"lbs_nearbypeople_popuphint_location_icon@2x", nil],[NSArray arrayWithObjects:@"topic_movie@2x",@"tabbar_compose_music@2x",@"group_edit_member_more@2x", nil],nil];
    
    topicTable = [[KZJFindView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-113) style:UITableViewStylePlain withTitle:titleNameArray withTitleImage:titleImageArray withTopicArray:topicArray];
    [self.view addSubview:topicTable];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"people" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(people:) name:@"people" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"relation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(relation:) name:@"relation" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attention" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(attention) name:@"attention" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelAttention" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelAttention) name:@"cancelAttention" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hotTopic" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotTopic) name:@"hotTopic" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hotWeibo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotWeibo) name:@"hotWeibo" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"findMan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(findMan) name:@"findMan" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"round" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(round) name:@"round" object:nil];
    [self.navigationController setNavigationBarHidden:NO];
//    NSLog(@"%d",[self.view.subviews count]);
}
#pragma mark 进入热门微博页
-(void)hotWeibo
{
    KZJHotWeiboView*hotWeiboView = [[KZJHotWeiboView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotWeiboView animated:YES];
}
#pragma mark 进入找人页
-(void)findMan
{
    KZJFindManView *findManView = [[KZJFindManView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:findManView animated:YES];
}
#pragma mark 进入周边页
-(void)round
{
    KZJRoundView*roundView= [[KZJRoundView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:roundView animated:YES];
}
#pragma mark 进入热门话题页
-(void)hotTopic
{
    KZJHotTopicView*hotTopicView = [[KZJHotTopicView alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    hotTopicView.topicArray = topicArray;
    [self.navigationController pushViewController:hotTopicView animated:YES];
}
#pragma mark 取消关注
-(void)cancelAttention
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"取消关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
#pragma mark 关注
-(void)attention
{
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"关注成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
#pragma mark 搜索返回的个人关系信息
-(void)relation:(NSNotification*)notif
{
    dictDetail = [[notif userInfo] objectForKey:@"target"];
    if ([[dictDetail objectForKey:@"followed_by"] intValue])
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"你确定关取消注该用户?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag = 110;
        [alert show];
    }else
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:nil message:@"你确定关注该用户?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alert.tag =111;
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
    }
}
#pragma mark 搜索返回的个人信息
-(void)people:(NSNotification*)notif
{
//    NSLog(@"%@",[[notif userInfo] objectForKey:@"people"]);
//    flag1 =1;
    peopleArray = [[notif userInfo] objectForKey:@"people"];
//    if (flag1==1&&flag==1)
//    {
        [tableview reloadData];
//    }
}
#pragma mark 录音和取消按钮
-(void)record:(UIButton*)btn
{
//    NSLog(@"2131e3");
    if ([btn.titleLabel.text isEqualToString:@"取消"])
    {
        UITextField*textfield = (UITextField*)[self.navigationController.view viewWithTag:1252];
        [textfield resignFirstResponder];
        
        [tableview removeFromSuperview];
        
        
        if ([topicArray count])
        {
            int num = arc4random_uniform([topicArray count]);
            textfield.placeholder = [NSString stringWithFormat:@"大家都在搜:%@",[topicArray[num]objectForKey:@"name"]];
        }

        for (UIView*view in self.navigationController.view.subviews)
        {
            if ([NSStringFromClass(view.class) isEqualToString:@"UINavigationBar"])
            {
                UIButton*btnItem = (UIButton*)[view viewWithTag:1253];
                [btnItem setTitle:nil forState:UIControlStateNormal];
                [btnItem setBackgroundImage:[UIImage redraw:[UIImage imageNamed:@"message_voice_background@2x"] Frame:CGRectMake(0, 0, 30,35)] forState:UIControlStateNormal];
            }
        }
    }else
    {
        
    }
}
-(void)doneAction:(id)sender
{
    UITextField*textfield = (UITextField*)[self.navigationController.view viewWithTag:1252];
    [textfield resignFirstResponder];
}
#pragma mark textfield代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (tableview==nil)
    {
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
        tableview.delegate =self;
        tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableview.backgroundColor = [UIColor greenColor];
    }else
    {
        [tableview reloadData];
    }
    [self.tabBarController.view addSubview:tableview];
    
    for (UIView*view in self.navigationController.view.subviews)
    {
        if ([NSStringFromClass(view.class) isEqualToString:@"UINavigationBar"])
        {
            UIButton*btnItem = (UIButton*)[view viewWithTag:1253];
            [btnItem setTitle:@"取消" forState:UIControlStateNormal];
            [btnItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnItem setBackgroundImage:nil forState:UIControlStateNormal];
            btnItem.titleLabel.font = [UIFont systemFontOfSize:15];
        }
    }
    textField.placeholder = @"请输入您要搜索的昵称";
    
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    self.hidesBottomBarWhenPushed = NO;
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"%d,%d===%@",range.length,range.location,string);
   
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[KZJRequestData requestOnly]startRequestData6:textField.text];
    
//    [textField resignFirstResponder];
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mark = @"markInformation";
    KZJInformationCell*cell = [tableview dequeueReusableCellWithIdentifier:mark];
    if (cell==nil)
    {
        cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    [cell.image sd_setImageWithURL:[NSURL URLWithString:[peopleArray[indexPath.row] objectForKey:@"profile_image_url"]]];
    cell.labelName.text = [peopleArray[indexPath.row]objectForKey:@"name"];
    cell.labelDetial.text = [NSString stringWithFormat:@"简介:%@",[peopleArray[indexPath.row]objectForKey:@
                                                                 "description"]];
//    for (NSDictionary*dict in relationArray)
//    {
//        if ([[dict objectForKey:@"id"] isEqual:[peopleArray[indexPath.row] objectForKey:@"id"]])
//        {
//            if ([[dict objectForKey:@"followed_by"] intValue])
//            {
//                [cell.btn setImage:[UIImage imageNamed:@"card_icon_arrow@2x"] forState:UIControlStateNormal];
//            }else
//            {
//                [cell.btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted@2x"] forState:UIControlStateNormal];
//            }
//        }
//    }
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
    [cell.btn setHidden:NO];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [peopleArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelAttention" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"attention" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"relation" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"people" object:nil];
}
#pragma mark - Navigation Controller Delegate
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    
    
    BaseAnimation *animationController;
    
    animationController = slideAnimationController;
    switch (operation) {
        case UINavigationControllerOperationPush:
            animationController.type = AnimationTypePresent;
            return  animationController;
        case UINavigationControllerOperationPop:
            animationController.type = AnimationTypeDismiss;
            return animationController;
        default: return nil;
    }
    
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
