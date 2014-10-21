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
    
//    NSLog(@"%@",array);
    for (UserInformation*userInformation in array)
    {
        NSString*str1 = [NSString stringWithFormat:@"%@",userInformation.uid];
        NSString*str2 = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserID"]];
        if ([str1 isEqualToString:str2])
        {
//            NSLog(@"%@",info);
            info = userInformation;
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
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            UILabel*kind = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH/3, 20)];
            kind.text = array1[i];
            kind.textAlignment = NSTextAlignmentCenter;
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
            [btn addSubview:num];
            [view addSubview:btn];
        }
        
        view.userInteractionEnabled = YES;
        view;
    });
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"passValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passAction:) name:@"passValue" object:nil];
}

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
-(void)btnAction
{
    NSLog(@"21");
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
    cell.image.image = [UIImage imageNamed:imageArray[indexPath.section][indexPath.row]];
    cell.image1.image = [UIImage imageNamed:@"login_detail@2x"];
    cell.label1.text = titleArray[indexPath.section][indexPath.row];
    
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
    return 0.0001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
