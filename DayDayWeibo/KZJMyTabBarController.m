//
//  KZJMyTabBarController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJMyTabBarController.h"

@interface KZJMyTabBarController ()

@end

@implementation KZJMyTabBarController

@synthesize selectedBtn,seletedImageArr,imageArr,direction,btnArr,titleArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithImage:(NSMutableArray *)image SeletedImage:(NSMutableArray *)seletedImage
{
    if (self = [super init])
    {
        imageArr = image;
        seletedImageArr = seletedImage;
    }
    return self;
}
-(void)btn
{
    //    self.tabBar.backgroundColor = [UIColor blackColor];
    CGRect rect = self.tabBar.frame;
    int number = [self.imageArr count]>5?5:(int)[self.imageArr count];
    //在视图上添加按钮
    for (int i = 0; i<number; i++)
    {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i==2)
        {
            btn.frame = CGRectMake(i*rect.size.width/number, 0, rect.size.width/number, rect.size.height);
            btn.tag = 1000+i;
            
            //            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setBackgroundImage:[self.imageArr objectAtIndex:i] forState:UIControlStateNormal];
            [btn setImage:[UIImage redraw:[UIImage imageNamed:@"tabbar_compose_icon_add@2x"] Frame:CGRectMake(0, 0, 30, 28)] forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBar addSubview:btn];
            [self.btnArr addObject:btn];
        }else
        {
            btn.frame = CGRectMake(i*rect.size.width/number, 0, rect.size.width/number, rect.size.height);
            btn.tag = 1000+i;
            //            [btn setBackgroundColor:[UIColor whiteColor]];
           
            [btn setImage:[UIImage redraw:[self.imageArr objectAtIndex:i] Frame:CGRectMake(0, 0, 25, 28)] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
            
            //调整标题位置
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(12, 31, 40, 15)];
            [label setBackgroundColor:[UIColor clearColor]];
            label.font=[UIFont boldSystemFontOfSize:9.5];
            label.tag =1100+i;
            label.text = titleArray[i];
            label.textColor = [UIColor grayColor];
            label.textAlignment=NSTextAlignmentCenter;
            
            [btn addSubview:label];
            
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBar addSubview:btn];
            [self.btnArr addObject:btn];
            if (i == 0 &&flag==0)
            {
                
                [btn setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:i] Frame:CGRectMake(0, 0, 31, 35)] forState:UIControlStateSelected];
                label.textColor = [UIColor orangeColor];
                btn.selected = YES;
                self.selectedBtn = btn;
            }
        }
        
    }
    
}

/**
 *  自定义TabBar的按钮点击事件
 */
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    if (button.tag-1000==2)
    {
        
        //2.再将当前按钮设置为选中
        if (self.selectedIndex!=button.tag-1000)
        {
            UILabel*label1 = (UILabel*)[self.view viewWithTag:1100+self.selectedIndex];
            label1.textColor = [UIColor grayColor];
            ;
            [button setBackgroundImage:[self.seletedImageArr objectAtIndex:button.tag-1000] forState:UIControlStateSelected];
            [button setImage:[UIImage redraw:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted@2x"] Frame:CGRectMake(0, 0, 30, 28)] forState:UIControlStateSelected];
            self.selectedIndex = button.tag-1000;
        }else
        {
            [button setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:button.tag-1000] Frame:CGRectMake(0, 0, 60, 35)] forState:UIControlStateSelected];
            [button setImage:[UIImage redraw:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted@2x"] Frame:CGRectMake(0, 0, 30, 28)] forState:UIControlStateSelected];
            self.selectedIndex = button.tag-1000;
        }
    }else
    {
        UILabel*label1 = (UILabel*)[self.view viewWithTag:1100+self.selectedIndex];
        label1.textColor = [UIColor grayColor];
        //2.再将当前按钮设置为选中
        if (self.selectedIndex!=button.tag-1000)
        {
            
            
            [button setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:button.tag-1000] Frame:CGRectMake(0, 0, 31, 35)] forState:UIControlStateSelected];
            self.selectedIndex = button.tag-1000;
            
        }else
        {
            [button setImage:[UIImage redraw:[self.seletedImageArr objectAtIndex:button.tag-1000] Frame:CGRectMake(0, 0, 31, 35)] forState:UIControlStateSelected];
            self.selectedIndex = button.tag-1000;
        }
        UILabel*label = (UILabel*)[self.view viewWithTag:1100+self.selectedIndex];
        label.textColor = [UIColor orangeColor];
    }
    
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    
    [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:button.tag-1000]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //初始化原来的tabbar的image
    for (int i=0; i<self.imageArr.count; i++)
    {
        //        UINavigationController* nav = [self.viewControllers objectAtIndex:i];
        UIImage* selectImg = [self.imageArr objectAtIndex:i];
        if (self.tabBarItem.image==NULL || self.tabBarItem.image==nil)
        {
            [self.tabBarItem setImage:selectImg];
        }
    }
    //隐藏原有的tabBar
    //    self.tabBar.hidden =YES;  //隐藏TabBarController自带的下部的条s
    
    [self btn];
    
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
