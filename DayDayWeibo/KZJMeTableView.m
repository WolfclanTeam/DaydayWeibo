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
-(id)initWithFrame:(CGRect)frame withTitle:(NSArray*)arrayTitle withImage:(NSArray*)arrayImage style:(UITableViewStyle)style
{
    NSLog(@"324");
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.backgroundView = nil;
        self.delegate = self;
        self.dataSource = self;
        titleArray = [NSArray arrayWithArray:arrayTitle];
        imageArray = [NSArray arrayWithArray:arrayImage];
        self.tableHeaderView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
            
            UIButton*headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            headBtn.frame = CGRectMake(-1, 0, self.frame.size.width+2, 60);
            headBtn.layer.borderWidth = 0.3;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.902, 0.902, 0.902, 1 });
            headBtn.layer.borderColor = colorref;
            [view addSubview:headBtn];
            
            UIImageView*headImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55, 55)];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"头像"])
            {
                [headImage sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"头像"]];
            }else{
                headImage.image = [UIImage imageNamed:@"activity_card_locate@2x"];
            }
            headImage.tag = 110;
            NSString*name = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"用户名"];
            float lenght = [name length]*18;
            UILabel*namelabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 5, lenght, 25)];
            
            namelabel.backgroundColor = [UIColor redColor];
            namelabel.tag = 111;
            namelabel.textColor = [UIColor blackColor];
            
            UILabel*briefLabel  = [[UILabel alloc]initWithFrame:CGRectMake(62, 33, 200, 25)];
            
            KZJAppDelegate*app =(KZJAppDelegate*) [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *context = app.managedObjectContext;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInformation"
                                                      inManagedObjectContext:context];
            [fetchRequest setEntity:entity];
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
            NSLog(@"%@",fetchedObjects);
            for (UserInformation *info in fetchedObjects) {
                briefLabel.text = info.brief;
                NSLog(@"%@",info);
                namelabel.text = info.name;
            }
            briefLabel.backgroundColor = [UIColor redColor];
            briefLabel.textColor = [UIColor blackColor];
            briefLabel.font = [UIFont systemFontOfSize:12];
            
            [headBtn addSubview:briefLabel];
            [headBtn addSubview:namelabel];
            [headBtn addSubview:headImage];
            
            for (int i = 0; i<3; i++)
            {
                UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0+i*SCREENWIDTH/3, 60, SCREENWIDTH/3, 40);
                [btn setTitle:@"das" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
            }
            
            view.userInteractionEnabled = YES;
            view;
        });
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"passValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passAction:) name:@"passValue" object:nil];
    return self;
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
        for (UserInformation *info in fetchedObjects) {
            NSLog(@"Name: %@", info.brief);
            
            UIImageView*imageView = (UIImageView*)[self viewWithTag:110];
            imageView.image = [UIImage imageWithData:info.photo];
            
            UILabel*nameLabel = (UILabel *)[self viewWithTag:111];
            nameLabel.text = info.name;
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
    CustomCell*cell = [tableView dequeueReusableCellWithIdentifier:meMark];
    if (cell ==nil)
    {
        cell = [[CustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:meMark];
    }
    for (UIView*view in cell.subviews)
    {
        [view removeFromSuperview];
    }
    UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 30, 20)];
    image.image = [UIImage imageNamed: imageArray[indexPath.section][indexPath.row]];
    [cell addImageView:image];
    
    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 80, 30)];
    label1.text = titleArray[indexPath.section][indexPath.row];
    [cell addLabel:label1];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
