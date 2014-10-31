//
//  KZJWeiboCell.m
//  MyWeiBo
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "KZJWeiboCell.h"

@implementation KZJWeiboCell
@synthesize HeadImageView,idLabel,timeLabel,viewForHead;
@synthesize Weibocontent,weiboImages;
@synthesize retweetContent,retweetImages,retweetWeibo;
@synthesize retweetBtn,retweetBg,retweetNum;
@synthesize commentBtn,commentBg,commentNum;
@synthesize attitudeBtn,attitudeBg,attitudeNum;
@synthesize mainView,boundsView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //
        divisionView = [[UIView alloc] init];
        divisionView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [self addSubview:boundsView];
        
        //分隔每个cell
        boundsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 8)];
        boundsView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [self addSubview:boundsView];
        
        //设置显示大图的图片视图
        picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT)];
        imageScroll.backgroundColor = [UIColor blackColor];
        imageScroll.bounces = NO;
        [imageScroll addSubview:picImageView];
        
        
        //移除系统cell上原有的控件
        [self.imageView removeFromSuperview];
        [self.textLabel removeFromSuperview];
        [self.detailTextLabel removeFromSuperview];
        
        //用于显示博主ID的label
        idLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, SCREENWIDTH-75, 25)];
        idLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:idLabel];
        
        //显示微博时间来源
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 33, SCREENWIDTH-75, 15)];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLabel];
        
//        //用于显示博主头像的imageview
        viewForHead = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 40, 40)];
        
        HeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 30, 30)];
        HeadImageView.contentMode = UIViewContentModeScaleAspectFill;
//        HeadImageView.clipsToBounds = YES;
        viewForHead.userInteractionEnabled = YES;
        HeadImageView.userInteractionEnabled = YES;
        [viewForHead addSubview:HeadImageView];
        [self addSubview:viewForHead];
        
        //
        actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake(SCREENWIDTH-25, 10, 20, 20);
        [actionBtn setBackgroundImage:[UIImage redraw:[UIImage imageNamed:@"timeline_icon_more@2x.png"] Frame:CGRectMake(0, 0, 20, 20)] forState:UIControlStateNormal];
        [actionBtn setBackgroundImage:[UIImage redraw:[UIImage imageNamed:@"timeline_icon_more_highlighted@2x.png"] Frame:CGRectMake(0, 0, 20, 20)] forState:UIControlStateSelected];
        [actionBtn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionBtn];
        
//
//        //显示微博正文的textview
        Weibocontent = [[RTLabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 0)];
        Weibocontent.userInteractionEnabled = YES;
        Weibocontent.font = [UIFont systemFontOfSize:13];
        Weibocontent.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
        Weibocontent.delegate = self;
        [self addSubview:Weibocontent];
//
//        //显示微博图片
        weiboImages = [[UIView alloc] init];
        weiboImages.userInteractionEnabled = YES;
        weiboImages.hidden = YES;
        [self addSubview:weiboImages];
//
//        //转发微博
        retweetWeibo = [[UIView alloc] init];
        retweetWeibo.hidden = YES;
        retweetWeibo.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        retweetWeibo.userInteractionEnabled = YES;
        
        //转发微博正文
        retweetContent = [[RTLabel alloc] initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 0)];
        retweetContent.tag = 2001;
        retweetContent.userInteractionEnabled = YES;
        retweetContent.font = [UIFont systemFontOfSize:12];
        retweetContent.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        retweetContent.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
        retweetContent.delegate = self;

//
//        //转发微博图片
        retweetImages = [[UIView alloc] init];
        retweetImages.tag = 2003;
        retweetImages.hidden = NO;
        retweetImages.userInteractionEnabled = YES;
//
        [retweetWeibo addSubview:retweetContent];
        [retweetWeibo addSubview:retweetImages];
        [self addSubview:retweetWeibo];
//
//        //转发
        retweetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        retweetBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
        retweetBg.image = [UIImage redraw:[UIImage imageNamed:@"rettoolbar_icon_retweet@2x.png"] Frame:CGRectMake(0, 0, 20, 20)];
        retweetNum = [[UILabel alloc] initWithFrame:CGRectMake(40,5, SCREENWIDTH/3-50, 20)];
        retweetNum.font = [UIFont systemFontOfSize:13];
        retweetNum.textColor = [UIColor grayColor];
        [retweetBtn addSubview:retweetBg];
        [retweetBtn addSubview:retweetNum];
        
        //评论
        commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
        commentBg.image = [UIImage redraw:[UIImage imageNamed:@"comtoolbar_icon_comment@2x.png"] Frame:CGRectMake(0, 0, 20, 20)];
        commentNum = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREENWIDTH/3-50, 20)];
        commentNum.font = [UIFont systemFontOfSize:13];
        commentNum.textColor = [UIColor grayColor];
        [commentBtn addSubview:commentBg];
        [commentBtn addSubview:commentNum];
        
        //态度
        attitudeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attitudeBg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 20, 20)];
        attitudeBg.image = [UIImage redraw:[UIImage imageNamed:@"attitoolbar_icon_unlike@2x.png"] Frame:CGRectMake(0, 0, 20, 20)];
        attitudeNum = [[UILabel alloc] initWithFrame:CGRectMake(40,5, SCREENWIDTH/3-50, 20)];
        attitudeNum.font = [UIFont systemFontOfSize:13];
        attitudeNum.textColor = [UIColor grayColor];
        [attitudeBtn addSubview:attitudeBg];
        [attitudeBtn addSubview:attitudeNum];
        
        [self addSubview:commentBtn];
        [self addSubview:retweetBtn];
        [self addSubview:attitudeBtn];
        
    }
    return self;
}

#pragma mark-action按钮
-(void)actionBtn:(UIButton*)sender
{
    int num = sender.tag - 10000;
    //
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha =0.75;
    
    NSNumber *userID = [[[weiboData objectAtIndex:num] objectForKey:@"user"] objectForKey:@"id"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"] isEqualToString:[userID stringValue]])
    {
        comSelectView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH-40, SCREENHEIGHT/3-30)];
        comSelectView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        comSelectView.layer.cornerRadius = 8.0;
        comSelectView.layer.masksToBounds = YES;
        comSelectView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        
        //
        collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectBtn.backgroundColor = [UIColor whiteColor];
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        collectBtn.frame = CGRectMake(0, 0, comSelectView.frame.size.width, comSelectView.frame.size.height/3-1);
        collectL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, collectBtn.frame.size.width-20, collectBtn.frame.size.height)];
        BOOL favorited = [[[weiboData objectAtIndex:num] objectForKey:@"favorited"] boolValue];
        if (favorited)
        {
            collectL.text = @"取消收藏";
        }else
        {
            collectL.text = @"收藏";
        }
        [collectBtn addSubview:collectL];
        
        //
        UIButton *extensionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        extensionBtn.backgroundColor = [UIColor whiteColor];
        [extensionBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        extensionBtn.frame = CGRectMake(0, comSelectView.frame.size.height/3, comSelectView.frame.size.width, comSelectView.frame.size.height/3-1);
        UILabel *extensionL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, extensionBtn.frame.size.width-20, extensionBtn.frame.size.height)];
        extensionL.text = @"推广";
        [extensionBtn addSubview:extensionL];
        
        //删除
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        deleteBtn.frame = CGRectMake(0, comSelectView.frame.size.height/3*2, comSelectView.frame.size.width, comSelectView.frame.size.height/3-1);
        UILabel *deleteL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, deleteBtn.frame.size.width-20, deleteBtn.frame.size.height)];
        deleteL.text = @"删除";
        deleteL.textColor = [UIColor redColor];
        [deleteBtn addSubview:deleteL];
        [deleteBtn addTarget:self action:@selector(delegateAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = 12000+num;
        
        //
        [comSelectView addSubview:collectBtn];
        [comSelectView addSubview:extensionBtn];
        [comSelectView addSubview:deleteBtn];
    }else
    {
        comSelectView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH-40, SCREENHEIGHT/2-40)];
        comSelectView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
        comSelectView.layer.cornerRadius = 8.0;
        comSelectView.layer.masksToBounds = YES;
        comSelectView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        
        //
        collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectBtn.backgroundColor = [UIColor whiteColor];
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        collectBtn.frame = CGRectMake(0, 0, comSelectView.frame.size.width, comSelectView.frame.size.height/4-1);
        collectL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, collectBtn.frame.size.width-20, collectBtn.frame.size.height)];
        BOOL favorited = [[[weiboData objectAtIndex:num] objectForKey:@"favorited"] boolValue];
        if (favorited)
        {
            collectL.text = @"取消收藏";
        }else
        {
            collectL.text = @"收藏";
        }
        [collectBtn addSubview:collectL];
        
        //
        UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attentionBtn.backgroundColor = [UIColor whiteColor];
        [attentionBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        attentionBtn.frame = CGRectMake(0, comSelectView.frame.size.height/4, comSelectView.frame.size.width, comSelectView.frame.size.height/4-1);
        UILabel *attentionL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,attentionBtn.frame.size.width-20, attentionBtn.frame.size.height)];
        following = [[[[weiboData objectAtIndex:num] objectForKey:@"user"] objectForKey:@"following"] boolValue];
        if (following)
        {
            attentionL.text = @"取消关注";
        }else
        {
            attentionL.text = @"关注";
        }
        [attentionBtn addSubview:attentionL];
        attentionBtn.tag = 13000+num;
        [attentionBtn addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //
        UIButton *shieldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shieldBtn.backgroundColor = [UIColor whiteColor];
        [shieldBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        shieldBtn.frame = CGRectMake(0, comSelectView.frame.size.height/4*2, comSelectView.frame.size.width, comSelectView.frame.size.height/4-1);
        UILabel *shieldL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, shieldBtn.frame.size.width-20, shieldBtn.frame.size.height)];
        shieldL.text = @"屏蔽";
        [shieldBtn addSubview:shieldL];
        
        //
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reportBtn.backgroundColor = [UIColor whiteColor];
        [reportBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        reportBtn.frame = CGRectMake(0, comSelectView.frame.size.height/4*3, comSelectView.frame.size.width, comSelectView.frame.size.height/4-1);
        UILabel *reportL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, reportBtn.frame.size.width-20, reportBtn.frame.size.height)];
        reportL.text = @"举报";
        [reportBtn addSubview:reportL];
        
        
        //
        [comSelectView addSubview:collectBtn];
        [comSelectView addSubview:attentionBtn];
        [comSelectView addSubview:reportBtn];
        [comSelectView addSubview:shieldBtn];
    }
    
    collectBtn.tag = 11000+num;
    [collectBtn addTarget:self action:@selector(collectWeibo:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backWeibo:)];
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    //
    [mainView addSubview:bgView];
    [mainView addSubview:comSelectView];
}

-(void)collectWeibo:(UIButton*)sender
{
    int num = sender.tag - 11000;
    NSNumber *weiboID = [[weiboData objectAtIndex:num] objectForKey:@"id"];
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager createFavoritesWeibo:[weiboID stringValue]];
    [datamanager passWeiboData:^(NSDictionary *dict) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [bgView removeFromSuperview];
        [comSelectView removeFromSuperview];
    }];
}

-(void)delegateAction:(UIButton*)sender
{
    int num = sender.tag-12000;
    NSNumber *weiboID = [[weiboData objectAtIndex:num] objectForKey:@"id"];
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    [datamanager deleteWeibo:[weiboID stringValue]];
    [datamanager passWeiboData:^(NSDictionary *dict) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [bgView removeFromSuperview];
        [comSelectView removeFromSuperview];
        NSNotification *refreshNoti = [[NSNotification alloc] initWithName:@"REFRESH" object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:refreshNoti];
    }];
}

-(void)attentionAction:(UIButton*)sender
{
    int num = sender.tag-13000;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    NSNumber *userID = [[[weiboData objectAtIndex:num] objectForKey:@"user"] objectForKey:@"id"];
    NSLog(@"%@",[userID stringValue]);
    if (following)
    {
        [datamanager destroyFriendships:[userID stringValue]];
        [bgView removeFromSuperview];
        [comSelectView removeFromSuperview];
    }else
    {
        [datamanager createFriendships:[userID stringValue]];
        [bgView removeFromSuperview];
        [comSelectView removeFromSuperview];
    }
}

-(void)backWeibo:(id)sender
{
    [bgView removeFromSuperview];
    [comSelectView removeFromSuperview];
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

#pragma mark-解析超链接
-(NSString*)parseLink:(NSString*)text
{
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    
    for (NSString *linkString in matchArray)
    {
        //三种不同超链接
        //<a href='user://@用户'></a>
        //<a href='http://www.baidu.com '>http://www.baidu.com</a>
        //<a href='topic://#话题#'>#话题#</a>
        NSString *replacing = nil;
        if ([linkString hasPrefix:@"@"])
        {
            replacing = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }else if ([linkString hasPrefix:@"http"])
        {
            replacing = [NSString stringWithFormat:@"<a href='http://%@'>%@</a>",[linkString URLEncodedString],@"网页链接"];
        }else if ([linkString hasPrefix:@"#"])
        {
            replacing = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[linkString URLEncodedString],linkString];
        }
        if (replacing!=nil)
        {
            text =  [text stringByReplacingOccurrencesOfString:linkString withString:replacing];
        }
    }
    return text;
}

#pragma mark-设置cell内容与高度
-(void)setCell:(NSArray *)dataArr indexPath:(NSIndexPath *)indexPath
{
    actionBtn.tag = 10000+indexPath.row;
    weiboData = dataArr;
    CGFloat weiboImgHeight = 0.0f;
    CGFloat statuHeight = 0.0f;
    retweetWeibo.hidden = YES;
    //博主ID
    idLabel.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
    //微博发布时间以及来源
    NSString *sourceStr = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"source"];
    NSString *inputSource;
    if (sourceStr.length!=0)
    {
        NSArray *array=[sourceStr componentsSeparatedByString:@">"];
        NSString *sourString=[array objectAtIndex:1];
        inputSource = [NSString stringWithFormat:@"来自%@",[sourString substringToIndex:(sourString.length-3)]];
    }else
    {
        inputSource = @"";
    }
    
    NSString *timeStr = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    NSDateFormatter *getFormatter = [[NSDateFormatter alloc] init];
    [getFormatter setDateFormat:@"EEE MMM dd H:mm:ss Z yyyy"];
    NSDate *inputDate = [getFormatter dateFromString:timeStr];
    if ([[self compareDate:inputDate] isEqualToString:@"今天"])
    {
        NSTimeInterval timeBetween = -[inputDate timeIntervalSinceDate:[NSDate date]];
        timeBetween+=420;
        if (timeBetween/60 < 60)
        {
            timeLabel.text = [NSString stringWithFormat:@"%d分钟前 %@",(int)timeBetween/60,inputSource];
        }else if (timeBetween/3600>0&&timeBetween/3600<24)
        {
            timeLabel.text = [NSString stringWithFormat:@"%d小时前 %@",(int)timeBetween/3600,inputSource];
        }
    }else if ([[self compareDate:inputDate] isEqualToString:@"昨天"])
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"H:mm"];
        NSString *inputTimeStr = [inputFormatter stringFromDate:inputDate];
        timeLabel.text = [NSString stringWithFormat:@"昨天 %@ %@",inputTimeStr,inputSource];
    }else
    {
        NSDateFormatter *moreInputFormatter = [[NSDateFormatter alloc] init];
        [moreInputFormatter setDateFormat:@"MM-dd"];
        NSString *inputTimeStr = [moreInputFormatter stringFromDate:inputDate];
        timeLabel.text = [NSString stringWithFormat:@"%@ %@",inputTimeStr,inputSource];
    }
    
    //博主头像
    [HeadImageView sd_setImageWithURL:[NSURL URLWithString:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"touxiang_40x40.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        HeadImageView.image = [UIImage redraw:image Frame:CGRectMake(0, 0, 30, 30)];
    }];
    //微博正文
    NSString *weiboText = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"text"];
    [self parseLink:weiboText];
    Weibocontent.text = [self parseLink:weiboText];
    CGFloat textViewContentHeight = Weibocontent.optimumSize.height;
    Weibocontent.frame = CGRectMake(10, 55, SCREENWIDTH-20, textViewContentHeight);
    
    //微博图片
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count] == 0)
    {
        weiboImages.hidden = YES;
        weiboImgHeight = 0.0f;
    }else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count] == 1)
    {
        weiboImages.hidden = NO;
        [weiboImages.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGSize sizeH = [GetNetImageSize downloadImageSizeWithURL:[NSURL URLWithString:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"thumbnail_pic"]]];
        weiboImgHeight = sizeH.height;
        
        weiboImages.frame = CGRectMake(10, 50+textViewContentHeight+10, sizeH.width, sizeH.height);
        UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sizeH.width, sizeH.height)];
        
        [aImage sd_setImageWithURL:[[dataArr objectAtIndex:indexPath.row] objectForKey:@"thumbnail_pic"]];
        [weiboImages addSubview:aImage];
        
    }else if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count] > 1)
    {
        [weiboImages.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        weiboImages.hidden = NO;
        if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count]%3 == 0)
        {
            weiboImgHeight = 100*[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count]/3;
        }else
        {
            weiboImgHeight = 100*([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count]/3+1);
        }
        
        weiboImages.frame = CGRectMake(10, 50+textViewContentHeight+10, 300, weiboImgHeight);
        for (int i = 0; i<[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count]; i++)
        {
            UIImageView *AweiboImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*(i%3), 100*(i/3), 100, 100)];
            [AweiboImage sd_setImageWithURL:[NSURL URLWithString:[[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] objectAtIndex:i] objectForKey:@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, 100));
                 UIImage *newImage = [UIImage imageWithCGImage:imageRef];
                 AweiboImage.frame = CGRectMake(100*(i%3), 100*(i/3), 100, 100);
                 AweiboImage.image = newImage;
             }];
            
            [weiboImages addSubview:AweiboImage];
        }
    }
    
    //转发微博
    if ([[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"])
    {
        retweetWeibo.hidden = NO;
        NSString *statuID = [[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"];
        NSString *statuDetail = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"text"];
        NSString *retweetWeiboText = [NSString stringWithFormat:@"@%@:%@",statuID,statuDetail];
        retweetContent.text = [self parseLink:retweetWeiboText];
        CGFloat staContentHeight = retweetContent.optimumSize.height;
        retweetContent.frame = CGRectMake(10, 10, SCREENWIDTH-20, staContentHeight);
//
        if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count] == 0)
        {
            weiboImages.hidden = YES;
            retweetImages.hidden = YES;
            statuHeight = staContentHeight+10;
        }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count] == 1)
        {
            [retweetImages.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            weiboImages.hidden = YES;
            retweetImages.hidden = NO;
            CGSize sizeH = [GetNetImageSize downloadImageSizeWithURL:[NSURL URLWithString:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"]]];
            statuHeight = sizeH.height+staContentHeight+10;
            retweetImages.frame = CGRectMake(10, staContentHeight+10, sizeH.width, sizeH.height);
            UIImageView *aImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sizeH.width, sizeH.height)];
            
            [aImage sd_setImageWithURL:[NSURL URLWithString:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"]] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
                 
             }];
            [retweetImages addSubview:aImage];
            
        }else if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count] > 1)
        {
            [retweetImages.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            CGFloat statuImageHeight = 0.0f;
            weiboImages.hidden = YES;
            retweetImages.hidden = NO;
            if ([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count]%3 == 0)
            {
                statuImageHeight = 100*[[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count]/3;
            }else
            {
                statuImageHeight = 100*([[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count]/3+1);
            }
            
            retweetImages.frame = CGRectMake(10, staContentHeight+10, 300, statuImageHeight);
            statuHeight = staContentHeight+statuImageHeight+10;
            for (int i = 0; i<[[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] count]; i++)
            {
                UIImageView *AweiboImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*(i%3), 100*(i/3), 100, 100)];
                [AweiboImage sd_setImageWithURL:[NSURL URLWithString:[[[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"pic_urls"] objectAtIndex:i] objectForKey:@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                     CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, 100));
                     UIImage *newImage = [UIImage imageWithCGImage:imageRef];
                     AweiboImage.frame = CGRectMake(100*(i%3), 100*(i/3), 100, 100);
                     AweiboImage.image = newImage;
                 }];
                
                [retweetImages addSubview:AweiboImage];
            }
        }
//
    }
    retweetWeibo.frame = CGRectMake(0, 50+textViewContentHeight+10, SCREENWIDTH, statuHeight);
    self.frame = CGRectMake(0, 0, SCREENWIDTH, 60+35+textViewContentHeight+weiboImgHeight+statuHeight);
    
    //转发
    retweetBtn.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width/3, 30);
    retweetNum.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"reposts_count"]];
    if ([retweetNum.text isEqualToString:@"0"])
    {
        retweetNum.text = @"转发";
    }
    [retweetBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    //评论
    commentBtn.frame = CGRectMake(self.frame.size.width/3, self.frame.size.height-30, self.frame.size.width/3, 30);
    commentNum.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"comments_count"]];
    if ([commentNum.text isEqualToString:@"0"])
    {
        commentNum.text = @"评论";
    }
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    //表态
    attitudeBtn.frame = CGRectMake(self.frame.size.width/3*2, self.frame.size.height-30, self.frame.size.width/3, 30);
    attitudeNum.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"attitudes_count"]];
    if ([attitudeNum.text isEqualToString:@"0"])
    {
        attitudeNum.text = @"赞";
    }
    [attitudeBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    
    divisionView.frame = CGRectMake(0, self.frame.size.height-31, SCREENWIDTH, 1);
    [self addSubview:divisionView];
    
    
    //点击微博图片触发显示大图方法
//    UITapGestureRecognizer *bigger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
//    bigger.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *moreBigger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
    weiboImages.tag = 7000+indexPath.row;
    moreBigger.numberOfTapsRequired = 1;
    [weiboImages addGestureRecognizer:moreBigger];
    
    //点击转发图片触发显示大图方法
    if ([[[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"])
    {
        UIImageView *staImage = (UIImageView*)[retweetWeibo viewWithTag:2002];
        UITapGestureRecognizer *staBigger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
        staImage.tag = 3000+indexPath.row;
        staBigger.numberOfTapsRequired = 1;
        [staImage addGestureRecognizer:staBigger];
        
        UIView *staImageS = [retweetWeibo viewWithTag:2003];
        UITapGestureRecognizer *moreStaBigger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
        staImageS.tag = 8000+indexPath.row;
        moreStaBigger.numberOfTapsRequired = 1;
        [staImageS addGestureRecognizer:moreStaBigger];
    }
    
    //
    if ([[dataArr objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"])
    {
        UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetViewAction:)];
        retweetTap.numberOfTapsRequired = 1;
        retweetWeibo.tag = 9000+indexPath.row;
        [retweetWeibo addGestureRecognizer:retweetTap];
    }
    
    UITapGestureRecognizer *userHome = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserHome:)];
    userHome.numberOfTapsRequired = 1;
    viewForHead.tag = 10000+indexPath.row;
    [viewForHead addGestureRecognizer:userHome];
    
    
    //点击cell低端按钮
    retweetBtn.tag = 4000+indexPath.row;
    commentBtn.tag = 5000+indexPath.row;
    attitudeBtn.tag = 6000+indexPath.row;
    [retweetBtn addTarget:self action:@selector(retweetAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [attitudeBtn addTarget:self action:@selector(attitudeAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark-RTLabelDelegate

-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString = [url host];
    urlString = [urlString URLDecodedString];
    NSLog(@"%@",urlString);
    if ([urlString hasPrefix:@"http://"])
    {
        NSDictionary *dict = @{@"http": urlString};
        NSNotification *webNoti = [[NSNotification alloc] initWithName:@"WEBPUSH" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:webNoti];
    }else if ([urlString hasPrefix:@"@"])
    {
//        NSString *str = [urlString substringFromIndex:1];
        
    }
}

#pragma mark-转发评论表态触发方法

//点击转发触发方法
-(void)retweetAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%d",btn.tag);
    int row = btn.tag-4000;
    NSDictionary *dict = @{@"weiboID":[[weiboData objectAtIndex:row] objectForKey:@"id"]};
    NSNotification *retNoti = [[NSNotification alloc] initWithName:@"RETWEIBO" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:retNoti];
}
//点击评论触发方法
-(void)commentAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%d",btn.tag);
    int row = btn.tag-5000;
    NSDictionary *dict = [weiboData objectAtIndex:row];
    NSNotification *comNoti = [[NSNotification alloc] initWithName:@"CLICKCOMMENT" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:comNoti];
}
//点击表态触发方法
-(void)attitudeAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%d",btn.tag);
//    attitudeBg.image = [UIImage redraw:[UIImage imageNamed:@"messagescenter_good@2x.png"] Frame:CGRectMake(0, 0, 20, 20)];
}


-(void)retweetViewAction:(id)sender
{
    UITapGestureRecognizer *retweetTap = (UITapGestureRecognizer*)sender;
    int num = retweetTap.view.tag-9000;
    KZJRequestData *datamanager = [KZJRequestData requestOnly];
    NSNumber *weiboID = [[[weiboData objectAtIndex:num] objectForKey:@"retweeted_status"] objectForKey:@"id"];
    NSString *str = [weiboID stringValue];
    [datamanager getADetailWeibo:str];
    [datamanager passWeiboData:^(NSDictionary *dict) {
        NSNotification *detailWeiboNoti = [[NSNotification alloc] initWithName:@"DETAILWEIBO" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:detailWeiboNoti];
    }];
}


-(void)pushUserHome:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    int num = tap.view.tag-10000;
    NSNumber *userID = [[[weiboData objectAtIndex:num] objectForKey:@"user"] objectForKey:@"id"];
    NSString *userIDStr = [userID stringValue];
    NSDictionary *dict = @{@"userIDStr":userIDStr};
    NSNotification *pushUser = [[NSNotification alloc] initWithName:@"PUSHUSER" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:pushUser];
//    NSString *domain = [[[weiboData objectAtIndex:num] objectForKey:@"user"] objectForKey:@"domain"];
//    KZJRequestData *dataManager = [KZJRequestData requestOnly];
//    [dataManager getUserMessage:domain];
}

#pragma mark-放大图片显示大图

-(void)backAction
{
    self.superview.superview.superview.hidden = NO;
    [imageScroll removeFromSuperview];
}

-(void)biggerAction:(id)sender
{
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = picImageView.center;
    [picImageView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    UITapGestureRecognizer *bigTap = (UITapGestureRecognizer*)sender;
    UIImageView *orImage;
    int num;
    NSURL *imageUrl;
    if (bigTap.view.tag>=3000&&bigTap.view.tag<4000)
    {
        num = bigTap.view.tag-3000;
        imageUrl = [NSURL URLWithString:[[[weiboData objectAtIndex:num] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]];
        NSLog(@"%@",[[[weiboData objectAtIndex:num] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]);
        orImage = (UIImageView*)bigTap.view;
    }else if(bigTap.view.tag>=1000&&bigTap.view.tag<2000)
    {
        num = bigTap.view.tag-1000;
        imageUrl = [NSURL URLWithString:[[weiboData objectAtIndex:num] objectForKey:@"original_pic"]];
        orImage = (UIImageView*)bigTap.view;
        NSLog(@"%@",[[weiboData objectAtIndex:num] objectForKey:@"original_pic"]);
    }else if (bigTap.view.tag>=7000&&bigTap.view.tag<8000)
    {
        num = bigTap.view.tag-7000;
        imageUrl = [NSURL URLWithString:[[weiboData objectAtIndex:num] objectForKey:@"original_pic"]];
        NSLog(@"%@",[[weiboData objectAtIndex:num] objectForKey:@"original_pic"]);
        orImage = [[bigTap.view subviews] objectAtIndex:0];
    }else if (bigTap.view.tag>=8000&&bigTap.view.tag<9000)
    {
        num = bigTap.view.tag-8000;
        imageUrl = [NSURL URLWithString:[[[weiboData objectAtIndex:num] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]];
        NSLog(@"%@",[[[weiboData objectAtIndex:num] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]);
        orImage = [[bigTap.view subviews] objectAtIndex:0];
    }
    
    picImageView.frame = CGRectMake(self.superview.center.x, self.superview.center.y, 0, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    UIImage *OrgImage = [UIImage redraw:orImage.image Frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [picImageView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [UIView commitAnimations];
    
    
    [picImageView sd_setImageWithURL:imageUrl placeholderImage:OrgImage options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         UIImage *newImage = [UIImage redraw:image Frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, image.size.height/image.size.width*[UIScreen mainScreen].bounds.size.width)];
         picImageView.image = newImage;
         picImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, newImage.size.height);
         imageScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, newImage.size.height+20);
         
         [indicatorView stopAnimating];
         [indicatorView removeFromSuperview];
         
         if (picImageView.frame.size.height<SCREENHEIGHT)
         {
             picImageView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
         }
         
         picImageView.userInteractionEnabled = YES;
         UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
         [picImageView addGestureRecognizer:pinch];
         
//         UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//         [picImageView addGestureRecognizer:pan];

         
     }];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    backTap.numberOfTapsRequired = 1;
    [imageScroll addGestureRecognizer:backTap];
    [mainView addSubview:imageScroll];
    self.superview.superview.superview.hidden = YES;
    
    
}

-(void)pinchAction:(id)sender
{
    NSLog(@"捏合");
    UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)sender;
    picImageView.transform = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
}

-(void)panAction:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        beginPoint = CGPointMake(0, 0);
    }
    CGPoint nowPoint = [pan translationInView:picImageView];
    float offX = nowPoint.x-beginPoint.x;
    float offY = nowPoint.y-beginPoint.y;
    picImageView.center = CGPointMake(picImageView.center.x+offX, picImageView.center.y+offY);
//    if (picImageView.center.x>picImageView.frame.size.width/2)
//    {
//        picImageView.center = CGPointMake(picImageView.frame.size.width/2, picImageView.center.y);
//    }
//    if (picImageView.center.y>picImageView.frame.size.height/2)
//    {
//        if (picImageView.frame.size.height<SCREENHEIGHT)
//        {
//            picImageView.center = CGPointMake(picImageView.center.x, SCREENHEIGHT/2);
//        }else
//        {
//            picImageView.center = CGPointMake(picImageView.center.x, picImageView.center.y);
//        }
//    }
//    if (picImageView.center.x<picImageView.frame.size.width/2)
//    {
//        picImageView.center = CGPointMake(picImageView.frame.size.width/2, picImageView.center.y);
//    }
//    if (picImageView.center.y<picImageView.frame.size.height/2)
//    {
//        picImageView.center = CGPointMake(picImageView.center.x, picImageView.frame.size.height/2);
//    }
    beginPoint = nowPoint;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
