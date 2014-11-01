//
//  KZJMeTableView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMeTableView.h"
#import "KZJAppDelegate.h"
@implementation KZJMeTableView
-(void)setWithTitle:(NSArray*)arrayTitle withImage:(NSArray*)arrayImage style:(UITableViewStyle)style withArray:(NSArray *)array
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
    [self.layer setBackgroundColor:colorref];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    
//    NSLog(@"%@",array);
    for (UserInformation*userInformation in array)
    {
        NSString*str1 = [NSString stringWithFormat:@"%@",userInformation.uid];
        NSString*str2 = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"]];
        if ([str1 isEqualToString:str2])
        {
//            NSLog(@"%@",info);
            info = userInformation;
            [self reloadData];
//            NSLog(@"%@",info);
        }
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]);
//        NSLog(@"%@",userInformation);
    }
    
    self.backgroundView = nil;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    titleArray = [NSArray arrayWithArray:arrayTitle];
    imageArray = [NSArray arrayWithArray:arrayImage];
    self.tableHeaderView = ({
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
        view.backgroundColor = [UIColor whiteColor];
        UIButton*headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(-1, 0, self.frame.size.width+2, 60);
        headBtn.layer.borderWidth = 0.3;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.902, 0.902, 0.902, 1 });
        headBtn.layer.borderColor = colorref;
        [headBtn addTarget:self action:@selector(myView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:headBtn];
        
        UIImageView*headImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
        if (info.photo)
        {
            [headImage sd_setImageWithURL:[NSURL URLWithString:info.photo]];
        }else{
            headImage.image = [UIImage imageNamed:@"activity_card_locate@2x"];
        }
        headImage.tag = 110;
        NSString*name = info.name;
        
        float lenght = [[KZJRequestData alloc]textLength:name]*18;
        UILabel*namelabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 5, lenght, 25)];
        namelabel.text = info.name;
        //            NSLog(@"%@",info.photo);
        //            namelabel.backgroundColor = [UIColor redColor];
        namelabel.tag = 111;
        namelabel.textColor = [UIColor blackColor];
        
        UILabel*briefLabel  = [[UILabel alloc]initWithFrame:CGRectMake(62, 33, 220, 25)];
        briefLabel.tag = 112;
        briefLabel.text = [NSString stringWithFormat:@"简介:%@",info.brief];
        //            briefLabel.backgroundColor = [UIColor redColor];
        briefLabel.textColor = [UIColor blackColor];
        briefLabel.font = [UIFont systemFontOfSize:12];
        
        UIImageView*image1 = [[UIImageView alloc]initWithFrame:CGRectMake(300, 25, 12, 15)];
        image1.image = [UIImage imageNamed:@"login_detail@2x"];
        
        [headBtn addSubview:image1];
        [headBtn addSubview:briefLabel];
        [headBtn addSubview:namelabel];
        [headBtn addSubview:headImage];
        NSArray*array1 = [NSArray arrayWithObjects:@"微博",@"关注",@"粉丝", nil];
        for (int i = 0; i<3; i++)
        {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0+i*SCREENWIDTH/3, 60, SCREENWIDTH/3, 40);
            //                [btn setTitle:@"das" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag =1000+i;
            UILabel*kind = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH/3, 20)];
            kind.text = array1[i];
            kind.textAlignment = NSTextAlignmentCenter;
            kind.tag = 1010+i;
            kind.font = [UIFont systemFontOfSize:13];
            [btn addSubview:kind];
            
            UILabel*num = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/3, 20)];
            num.textAlignment = NSTextAlignmentCenter;
            num.font = [UIFont systemFontOfSize:14];
            if (i ==0)
            {
                num.text = [NSString stringWithFormat:@"%@",info.statuses];
            }else if (i==1)
            {
                num.text = [NSString stringWithFormat:@"%@",info.care];
            }else if (i==2)
            {
                num.text = [NSString stringWithFormat:@"%@",info.fans];
            }
//            NSLog(@"%@,%@,%@",info.statuses,info.care,info.fans);
            [btn addSubview:num];
            [view addSubview:btn];
        }
        
        view.userInteractionEnabled = YES;
        view;
    });
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"passValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passAction:) name:@"passValue" object:nil];
}

//登陆成功更新内容
-(void)passAction:(NSNotification*)notif
{
    if ([[notif userInfo] objectForKey:@"avatar_hd"]!=nil)
    {
        KZJAppDelegate*app = (KZJAppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSManagedObjectContext *context = app.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInformation"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
        for (UserInformation *info1 in fetchedObjects) {
//            NSLog(@"Name: %@", info1.brief);
            UIImageView*imageView = (UIImageView*)[self viewWithTag:110];
            [imageView sd_setImageWithURL:[NSURL URLWithString:info1.photo]];
            
            UILabel*nameLabel = (UILabel *)[self viewWithTag:111];
            nameLabel.text = info1.name;
//            NSLog(@"%@",info1.name);
        }
        NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
        [user setObject: [[notif userInfo] objectForKey:@"name"] forKey:@"用户名"];
        [user setObject: [[notif userInfo] objectForKey:@"avatar_hd"] forKey:@"头像"];
        [user synchronize];
        
        [self setNeedsDisplay];
    }
    
}
//微博,关注,粉丝按钮单击事件
-(void)btnAction:(UIButton*)btn
{
    UILabel*label = (UILabel*)[self viewWithTag:btn.tag+10];

    NSNotification*notification = [NSNotification notificationWithName:@"fans" object:self userInfo:[NSDictionary dictionaryWithObject:label.text forKey:@"btnTitle"]];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}
//个人主页单击事件
-(void)myView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myView" object:nil];
}

#pragma mark 我的页面的tableview的代理
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*meMark = @"meMark";
    KZJMeTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:meMark];
    if (cell ==nil)
    {
        cell = [[KZJMeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meMark];
    }
//    NSLog(@"%@",cell.subviews);
    cell.image.image = [UIImage redraw:[UIImage imageNamed:imageArray[indexPath.section][indexPath.row]] Frame:CGRectMake(0, 0, 20, 20)];
    if (indexPath.section==3&&indexPath.row ==1)
    {
        NSArray*draftNum = [[KZJRequestData requestOnly]getCoreData:@"StoreWeibo"];
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        label.text = [NSString stringWithFormat:@"%d",draftNum.count];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor lightGrayColor];
        [cell.image1 addSubview:label];
    }else
    {
        cell.image1.image = [UIImage imageNamed:@"login_detail@2x"];
    }
    
    if (indexPath.section==1&&indexPath.row==1)
    {
        if (info.collectionNum ==nil||[info.collectionNum isEqualToString:@"0"])
        {
            NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@(0)",titleArray[indexPath.section][indexPath.row]]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
//            NSLog(@"%d",[str length]);
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4, [str length]-4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, [str length]-4)];
            //对于上面设置的字符串只能赋给attributeText,无法赋给text
            cell.label1.attributedText=str;

        }else
        {
            NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",titleArray[indexPath.section][indexPath.row],info.collectionNum]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4,[str length]-4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, [str length]-4)];
            //对于上面设置的字符串只能赋给attributeText,无法赋给text
            cell.label1.attributedText=str;
        }
        
    }else if(indexPath.section==1&&indexPath.row==0)
    {
        if (info.photoNum ==nil||[info.photoNum isEqualToString:@"0"])
        {
            NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:@"%@(0)",titleArray[indexPath.section][indexPath.row]]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
//            NSLog(@"%d",[str length]);
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4, [str length]-4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, [str length]-4)];
            //对于上面设置的字符串只能赋给attributeText,无法赋给text
            cell.label1.attributedText=str;
            
        }else
        {
            NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(%@)",titleArray[indexPath.section][indexPath.row],info.photoNum]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(4,[str length]-4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, [str length]-4)];
            //对于上面设置的字符串只能赋给attributeText,无法赋给text
            cell.label1.attributedText=str;
        }
    }else
    {
        cell.label1.text = titleArray[indexPath.section][indexPath.row];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3)
    {
        return 10;
    }
    return 0.0001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray*array = titleArray[section];
    return [array count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1&&indexPath.row==0)
    {
        [[KZJRequestData requestOnly]startRequestData5:1 withID:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"picture" object:nil];
    }else if (indexPath.section ==3 &&indexPath.row==0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"card" object:nil];
    }else if (indexPath.section ==1 &&indexPath.row==1)
    {
//        [[KZJRequestData requestOnly]startRequestData5:1 withType:@"1"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"collect" object:nil];
    }else if (indexPath.section ==3 &&indexPath.row==1)
    {
        //        [[KZJRequestData requestOnly]startRequestData5:1 withType:@"1"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"draft" object:nil];
    }else if (indexPath.section ==0&&indexPath.row==0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"newFriend" object:nil];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    view.alpha=0;
    return view;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
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
