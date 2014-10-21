//
//  KZJSetTableView.m
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJSetTableView.h"

@implementation KZJSetTableView
-(id)initWithFrame:(CGRect)frame withTitle:(NSArray *)arrayTitle
{
    self = [super initWithFrame:frame];
    if (self)
    {
        titleArray = [NSArray arrayWithArray:arrayTitle];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
//        self.tableFooterView = ({
//            UIView*view = [[UIView alloc]init];
//            view.backgroundColor = [UIColor lightTextColor];
//            
//            view;
//        });
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [self.layer setBackgroundColor:colorref];

    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*mark = @"meMark";
    KZJSetTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
  
    if (cell==nil)
    {
        cell = [[KZJSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
    }
    
    
    
    
    if (indexPath.section ==4)
    {
        cell.label.frame = CGRectMake(5, 0, SCREENWIDTH-10, 40);
        cell.label.textAlignment = NSTextAlignmentCenter;
        cell.label.textColor = [UIColor redColor];
    }else if(!(indexPath.section==3&&indexPath.row==1))
    {
        
        if (indexPath.row==0&&indexPath.section ==0)
        {
            NSArray*array = [[KZJRequestData alloc]getCoreData:@"UserInformation"];
            int num = 0;
            NSLog(@"%@",array);
            for (UserInformation*info in array)
            {
                num += [info.unread intValue];
            }
            NSLog(@"num=%d",num);
            if (num==0)
            {
                cell.image1.image = [UIImage imageNamed:@"login_detail@2x"];
            }else
            {
                cell.unreadLabel.layer.cornerRadius =7;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0.1, 0.1, 1 });
                cell.unreadLabel.layer.backgroundColor = colorref;
                cell.unreadLabel.text = [NSString stringWithFormat:@"%d",num];
                cell.unreadLabel.font = [UIFont systemFontOfSize:12];
                cell.unreadLabel.textAlignment =NSTextAlignmentCenter;
                cell.unreadLabel.textColor = [UIColor blackColor];
            }
        }else
        {
            cell.image1.image = [UIImage imageNamed:@"login_detail@2x"];
        }
    }else
    {
        if ([[KZJRequestData alloc] cacheNumber]!=nil)
        {
            cell.cacheLaabel.text = [NSString stringWithFormat:@"%@M",[[KZJRequestData alloc] cacheNumber]];
        }else
        {
            cell.cacheLaabel.text = @"0.00M";
        }
        cell.cacheLaabel.textColor = [UIColor grayColor];
        cell.cacheLaabel.font = [UIFont systemFontOfSize:15];
    }
    cell.label.text = titleArray[indexPath.section][indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 5;
    }
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 15)];
    view.alpha=0;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==4)
    {
        KZJAppDelegate*app = (KZJAppDelegate*)[UIApplication sharedApplication].delegate;
        //定义uiview动画
//        [UIView beginAnimations:@"exit" context:(__bridge void *)(app.window)];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        //    [UIView setAnimationDelay:1];//延迟3秒开始播放
//        [UIView setAnimationDelegate:self];//设置动画代理
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];//动画停止之后调用的方法
//        [UIView setAnimationDuration:1];//动画运行时间
//        //    [UIView setAnimationRepeatAutoreverses:YES];//设置是否自动回到初始状态
//        app.window.transform=CGAffineTransformMakeScale(0.1, 0.1);
//
//        [UIView commitAnimations];//提交动画
        
        
        CABasicAnimation*transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D transform1 = CATransform3DMakeScale(0.1, 0.1, 0.1);
        CATransform3D transform2 = CATransform3DMakeTranslation(140, 200, 100);
        [transformAnimation setDuration:1];
        CATransform3D transform = CATransform3DConcat(transform1, transform2);//组合两个3d transform
        transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
        transformAnimation.delegate =self;
        transformAnimation.fillMode = kCAFillModeBackwards;
        transformAnimation.removedOnCompletion = NO;
        [[app.window layer] addAnimation:transformAnimation forKey:@"213"];
        
    }
    if (indexPath.section ==0&&indexPath.row==0)
    {
        NSNotification*notification= [NSNotification notificationWithName:@"pushAccount" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }else if (indexPath.section==3&&indexPath.row==1)
    {
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:cachPath error:&error];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存清理完毕" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [tableView reloadData];
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    exit(0);
}
//动画结束执行方法
//动画正常结束number = 1
-(void)animationDidStop:(NSString *)animationName finished:(NSNumber*)number context:(void *)context
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
