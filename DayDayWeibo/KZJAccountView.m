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
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        numberArray = [[NSMutableArray alloc]initWithArray:array];

    }
    return self;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"meMark";
    KZJAccountViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
    if (cell ==nil)
    {
        cell = [[KZJAccountViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    
    if (indexPath.row<[numberArray count]&&indexPath.section ==0)
    {
       
        
        UserInformation*info = numberArray[indexPath.row];
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:info.photo]];
        cell.nameLabel.text = info.name;
        if (indexPath.row==0)
        {
            cell.loginView.image = [UIImage redraw:[UIImage imageNamed:@"login_fonud_check@2x"] Frame:CGRectMake(0, 0, 15, 15)];
            [cell.loginView setHidden:NO];
        }
        if (info.unread !=nil&&![info.unread isEqualToString:@"0"])
        {
            cell.unreadLabel.layer.cornerRadius =7;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0.1, 0.1, 1 });
            cell.unreadLabel.layer.backgroundColor = colorref;
            CGColorSpaceRelease(colorSpace);
            CGColorRelease(colorref);
            
            cell.unreadLabel.text = info.unread;
            cell.unreadLabel.font = [UIFont systemFontOfSize:12];
            cell.unreadLabel.textAlignment =NSTextAlignmentCenter;
            cell.unreadLabel.textColor = [UIColor blackColor];
            [cell.unreadLabel setHidden:NO];
        }else
        {
            [cell.unreadLabel setHidden:YES];
        }
    }
    else if(indexPath.section ==0)
    {
        cell.image.image = [UIImage imageNamed:@"accountmanage_add@2x"];
        cell.nameLabel.text = @"添加账号";
        cell.nameLabel.textAlignment = NSTextAlignmentLeft;
        cell.nameLabel.frame = CGRectMake(55, 5, 250, 45);
        cell.nameLabel.textColor = [UIColor blackColor];
        [cell.loginView setHidden:YES];
        [cell.image setHidden:NO];
        [cell.unreadLabel setHidden:YES];
    }else
    {
        cell.nameLabel.textAlignment = NSTextAlignmentCenter;
        cell.nameLabel.frame = CGRectMake(0, 0, SCREENWIDTH, 30);
        cell.nameLabel.text = @"退出当前账号";
        cell.nameLabel.textColor = [UIColor redColor];
        [cell.line setHidden:YES];
        [cell.image setHidden:YES];
        [cell.unreadLabel setHidden:YES];
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
            [user setObject:nil forKey:@"Token"];
            [user setObject:nil forKey:@"UserID"];
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
            
            [[KZJRequestData requestOnly]startRequestData1];
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
