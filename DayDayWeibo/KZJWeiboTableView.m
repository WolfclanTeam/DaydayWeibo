//
//  KZJWeiboTableView.m
//  WeiboTest
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "KZJWeiboTableView.h"

@implementation KZJWeiboTableView
@synthesize dataArr,kind,selectedBtn,photoArray,flag,peopleArray,addressArray;

- (id)initWithFrame:(CGRect)frame view:(UIView*)view
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        page = 1;
        self.delegate = self;
        self.dataSource = self;
        flag=1;
        
        //
        theView = view;
    }
    return self;
}

#pragma mark - TableViewDelegate && TableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (flag ==2)
    {
         return 100;
    }else if (flag == 0)
    {
        return 30;
    }else if (flag ==3||flag==4)
    {
        return 60;
    }
    CGFloat height = 0.0f;
    KZJWeiboCell *cell = (KZJWeiboCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    height = cell.frame.size.height;
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%d",flag);
    if (flag == 2)
    {
        if ([photoArray count]>12*page)
        {
            return page*4;
        }else if([photoArray count]%3==0)
        {
            return [photoArray count]/3;
        }
        return [photoArray count]/3+1;
    }else if (flag ==0)
    {
        return 1;
    }else if (flag ==3)
    {
        return [peopleArray count];
    }else if (flag==4)
    {
        return [addressArray count];
    }
    return [dataArr count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (flag ==0)
    {
        return 4;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%d",flag);
    if (flag==2)
    {
        static NSString*mark = @"markPhoto";
        KZJPhotoCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell==nil)
        {
            cell = [[KZJPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row<[photoArray count]/3)
        {
            [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
            [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+1] objectForKey:@"thumbnail_pic"]]];
            [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+2] objectForKey:@"thumbnail_pic"]]];
        }else if([photoArray count]%3==1)
        {
            [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
        }else if([photoArray count]%3==2)
        {
            [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
            [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+1] objectForKey:@"thumbnail_pic"]]];
        }else
        {
            NSLog(@"%d",indexPath.row);
            [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3] objectForKey:@"thumbnail_pic"]]];
            [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+1] objectForKey:@"thumbnail_pic"]]];
            [cell.image3 sd_setImageWithURL:[NSURL URLWithString:[photoArray[indexPath.row*3+2] objectForKey:@"thumbnail_pic"]]];
        }
        
        return  cell;
    }else if (flag == 0)
    {
        static NSString*mark1 = @"homeMark";
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:mark1];
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark1];
        }
        if (indexPath .section==0)
        {
            cell.textLabel.text = @"基本信息";
        }else if (indexPath .section==1)
        {
            cell.textLabel.text = @"我的应用";
        }else if (indexPath .section==2)
        {
            cell.textLabel.text = @"赞";
        }else if (indexPath .section==3)
        {
            cell.textLabel.text = @"我的微数据";
        }
        UIImageView*image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-30, 5, 20, 20)];
        image.image = [UIImage imageNamed:@"login_detail@2x"];
        [cell.contentView addSubview:image];
        return cell;
    }else if (flag==3)
    {
        static NSString*mark = @"markFind";
        KZJInformationCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell ==nil)
        {
            cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        }
        
        if (peopleArray.count>0)
        {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[peopleArray[indexPath.row] objectForKey:@"profile_image_url"]]];
            cell.labelName.text = [peopleArray[indexPath.row]objectForKey:@"screen_name"];
            cell.labelDetial.text = [NSString stringWithFormat:@"简介:%@",[peopleArray[indexPath.row]objectForKey:@"description"]];
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
            cell.btn.titleLabel.text = [NSString stringWithFormat:@"%@",[peopleArray[indexPath.row] objectForKey:@"id"]];
            cell.btn.titleLabel.hidden = YES;
            [cell.btn setHidden:NO];
        }
        return cell;
    }else if (flag ==4)
    {
        static NSString*mark = @"markFind";
        KZJInformationCell*cell = [tableView dequeueReusableCellWithIdentifier:mark];
        if (cell ==nil)
        {
            cell = [[KZJInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mark];
        }
        
        if (addressArray.count>0)
        {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[addressArray[indexPath.row] objectForKey:@"icon"]]];
            cell.labelName.text = [addressArray[indexPath.row]objectForKey:@"address"];
            cell.labelDetial.text = [NSString stringWithFormat:@"%@人",[addressArray[indexPath.row]objectForKey:@"checkin_num"]];
            [cell.btn setHidden:YES];
        }
        return cell;

    }
    //重用
    static NSString *iden = @"CELLMARK";
    KZJWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil)
    {
        cell = [[KZJWeiboCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    cell.mainView = theView;
    [cell setCell:dataArr indexPath:indexPath];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:@"我的主页"])
    {
        if (flag ==1)
        {
            KZJRequestData *datamanager = [KZJRequestData requestOnly];
            NSNumber *weiboID = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
            
            NSString *str = [weiboID stringValue];
            [datamanager getADetailWeibo:str];
            [datamanager passWeiboData:^(NSDictionary *dict) {
                NSNotification *detailWeiboNoti = [[NSNotification alloc] initWithName:@"DETAILWEIBO" object:self userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:detailWeiboNoti];
            }];
        }else if (flag==2)
        {
            
        }else if(flag ==0)
        {
            
        }
    }else if([kind isEqualToString:@"位置周边"])
    {
        if (flag==1)
        {
            KZJRequestData *datamanager = [KZJRequestData requestOnly];
            NSNumber *weiboID = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
            
            NSString *str = [NSString stringWithFormat:@"%@",weiboID];
            [datamanager getADetailWeibo:str];
            [datamanager passWeiboData:^(NSDictionary *dict) {
                NSNotification *detailWeiboNoti = [[NSNotification alloc] initWithName:@"DETAILWEIBO" object:self userInfo:dict];
                [[NSNotificationCenter defaultCenter] postNotification:detailWeiboNoti];
            }];
        }
    }else
    {
        KZJRequestData *datamanager = [KZJRequestData requestOnly];
        NSNumber *weiboID = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *str = [NSString stringWithFormat:@"%@",weiboID];
        [datamanager getADetailWeibo:str];
        [datamanager passWeiboData:^(NSDictionary *dict) {
            NSNotification *detailWeiboNoti = [[NSNotification alloc] initWithName:@"DETAILWEIBO" object:self userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:detailWeiboNoti];
        }];
    }
}

//区头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([kind isEqualToString:@"我的主页"])
    {
        if (section==0)
        {
            return 30;
        }else
        {
            return 10;
        }
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
        NSArray*titleArray = [NSArray arrayWithObjects:@"主页",@"微博",@"相册", nil];
        for (int i = 0; i<[titleArray count]; i++)
        {
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(80+53*i, 0, 53, 30);
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            //        btn.backgroundColor = [UIColor redColor];
            btn.tag = 1000+i;
            if (flag ==1&&i==1)
            {
                selectedBtn = btn;
                btn.selected = YES;
            }
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        
        UILabel*line = [[UILabel alloc]initWithFrame:CGRectMake(92+flag*53, 28, 30, 2)];
        line.backgroundColor = [UIColor orangeColor];
        line.tag = 999;
        [view addSubview:line];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
        [view.layer setBackgroundColor:colorref];
        CGColorSpaceRelease(colorSpace);
        CGColorRelease(colorref);
        return view;
    }
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.906, 0.906, 0.906, 1 });
    [view.layer setBackgroundColor:colorref];
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(colorref);
    return view;
}
-(void)btnAction:(UIButton*)btn
{
    UILabel*line = (UILabel*)[self viewWithTag:999];
    selectedBtn.selected = NO;
    btn.selected = YES;
    selectedBtn = btn;
    flag = btn.tag-1000;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    line.frame = CGRectMake(btn.frame.origin.x+12, 18, 30, 2);
    [UIView commitAnimations];
    page =1;
    if ([btn.titleLabel.text isEqualToString:@"相册"])
    {

        self.tableFooterView = ({
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
            view.userInteractionEnabled= YES;
            
            UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
            label.userInteractionEnabled = YES;
            label.text = @"更多";
            [view addSubview:label];
            UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(more)];
            [label addGestureRecognizer:tap];
            label.textAlignment = NSTextAlignmentCenter;
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        [self reloadData];
    }else
    {
        self.tableFooterView = nil;
        [self reloadData];
    }
    if ([btn.titleLabel.text isEqualToString:@"微博"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addHeader" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removeHeader" object:nil];
    }
}
-(void)more
{
    flag =2;
    if ([photoArray count]<page*12)
    {
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经没有更多的图片了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else
    {
        page++;
        [self reloadData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >=200)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"hideCover" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NoHideCover" object:nil];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
