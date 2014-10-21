//
//  KZJAccountView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJAccountView.h"

@implementation KZJAccountView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
         self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style numArray:(NSArray*)array
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:kAppKey];
        self.delegate = self;
        self.dataSource = self;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [self.layer setBackgroundColor:colorref];
        numberArray = [[NSMutableArray alloc]initWithArray:array];

    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"meMark";
    CustomCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    for (UIView*view in cell.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.row<[numberArray count]&&indexPath.section ==0)
    {
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, SCREENWIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addLabel:line];
        
        UserInformation*info = numberArray[indexPath.row];
        UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
        [image sd_setImageWithURL:[NSURL URLWithString:info.photo]];
        [cell addImageView:image];
        
        UILabel*nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 250, 45)];
        nameLabel.text = info.name;
        [cell addSubview:nameLabel];
        if (indexPath.row==0)
        {
            UIImageView*loginView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 35, 15, 15)];
            loginView.image = [UIImage redraw:[UIImage imageNamed:@"login_fonud_check@2x"] Frame:CGRectMake(0, 0, 15, 15)];
            [image addSubview:loginView];
            
        }
        
        UILabel*unreadLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-20,20, 15, 15)];
        unreadLabel.layer.cornerRadius =7;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0.1, 0.1, 1 });
        unreadLabel.layer.backgroundColor = colorref;
        unreadLabel.text = info.unread;
        unreadLabel.font = [UIFont systemFontOfSize:12];
        unreadLabel.textAlignment =NSTextAlignmentCenter;
        unreadLabel.textColor = [UIColor blackColor];
        if (unreadLabel.text ==nil||[unreadLabel.text isEqualToString:@"0"])
        {
            
        }else
        {
            [cell addLabel:unreadLabel];
        }
    }
    else if(indexPath.section ==0)
    {
        UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 45)];
        image.image = [UIImage imageNamed:@"accountmanage_add@2x"];
        [cell addImageView:image];
    }else
    {
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"退出当前账号";
        label.textColor = [UIColor redColor];
        [cell addLabel:label];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        return 30;
    }
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==1)
    {
        return 1;
    }
    return [numberArray count]+1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0&&indexPath.row>=[numberArray count])
    {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        [WeiboSDK sendRequest:request];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addlogin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addlogin) name:@"addlogin" object:nil];
        
    }else if(indexPath.section ==1)
    {
        NSArray*array = [[KZJRequestData alloc]getCoreData:@"UserInformation"];
        for (UserInformation*info in array)
        {
            if ([info.uid isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]])
            {
                numberArray = (NSMutableArray*)[[KZJRequestData alloc]deleteCoreData:@"UserInformation" withData:info];
//                NSLog(@"===%@",numberArray);
                [tableView reloadData];
            }
        }
//        NSNotification*notification1= [NSNotification notificationWithName:@"loginOut" object:self userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        
        NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
        [WeiboSDK logOutWithToken:[user objectForKey:@"Token"] delegate:self withTag:@"992"];
        if ([numberArray count]>0)
        {
            UserInformation*info = numberArray[0];
            [user setObject:info.token forKey:@"Token"];
            [user setObject:info.uid forKey:@"UserID"];
            
        }else
        {
            [user setObject:@"未登录" forKey:@"登陆状态"];
        }
        [user synchronize];
    }else
    {
        if (indexPath.row==0)
        {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你已登陆了该账号了,无须重复登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else
        {
            UserInformation*info = numberArray[indexPath.row];
            NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
            [user setObject:info.token forKey:@"Token"];
            [user setObject:info.uid forKey:@"UserID"];
            [user synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:@"已存在" forKey:@"账号管理"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [[[KZJRequestData alloc] initOnly]startRequestData1];
            numberArray = (NSMutableArray*)[[KZJRequestData alloc]loginRank:numberArray];
            [tableView reloadData];
            
            
        }
    }
}
-(void)addlogin
{
    numberArray = (NSMutableArray*)[[KZJRequestData alloc]getCoreData:@"UserInformation"];
    numberArray = (NSMutableArray*)[[KZJRequestData alloc]loginRank:numberArray];
    [self reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    view.alpha=0;
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
