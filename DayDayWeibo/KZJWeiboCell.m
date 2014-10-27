//
//  KZJWeiboCell.m
//  MyWeiBo
//
//  Created by Ibokan on 14-10-22.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "KZJWeiboCell.h"

@implementation KZJWeiboCell
@synthesize HeadImageView,idLabel,timeLabel;
@synthesize Weibocontent,weiboImages;
@synthesize retweetContent,retweetImages,retweetWeibo;
@synthesize retweetBtn,retweetBg,retweetNum;
@synthesize commentBtn,commentBg,commentNum;
@synthesize attitudeBtn,attitudeBg,attitudeNum;
@synthesize mainView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
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
        idLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREENWIDTH-45, 25)];
        idLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:idLabel];
        
        //显示微博时间来源
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, SCREENWIDTH-45, 15)];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:timeLabel];
        
//        //用于显示博主头像的imageview
        HeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        HeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        HeadImageView.clipsToBounds = YES;
        [self addSubview:HeadImageView];
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
        retweetNum = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREENWIDTH/3-50, 20)];
        [retweetBtn addSubview:retweetBg];
        [retweetBtn addSubview:retweetNum];
        
        //评论
        commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
        commentBg.image = [UIImage redraw:[UIImage imageNamed:@"comtoolbar_icon_comment@2x.png"] Frame:CGRectMake(0, 0, 20, 20)];
        commentNum = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREENWIDTH/3-50, 20)];
        [commentBtn addSubview:commentBg];
        [commentBtn addSubview:commentNum];
        
        //态度
        attitudeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attitudeBg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 20, 20)];
        attitudeBg.image = [UIImage redraw:[UIImage imageNamed:@"attitoolbar_icon_unlike@2x.png"] Frame:CGRectMake(0, 0, 20, 20)];
        attitudeNum = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREENWIDTH/3-50, 20)];
        [attitudeBtn addSubview:attitudeBg];
        [attitudeBtn addSubview:attitudeNum];
        
        [self addSubview:commentBtn];
        [self addSubview:retweetBtn];
        [self addSubview:attitudeBtn];
        
    }
    return self;
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
    weiboData = dataArr;
    CGFloat weiboImgHeight = 0.0f;
    CGFloat statuHeight = 0.0f;
    retweetWeibo.hidden = YES;
    //博主ID
    idLabel.text = [[[dataArr objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
    //微博发布时间以及来源
    NSString *sourceStr = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"source"];
    NSArray *array=[sourceStr componentsSeparatedByString:@">"];
    NSString *separateString=[array objectAtIndex:1];
    NSString *inputSource = [separateString substringToIndex:(separateString.length-3)];
    
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
            timeLabel.text = [NSString stringWithFormat:@"%d分钟前 来自%@",(int)timeBetween/60,inputSource];
        }else if (timeBetween/3600>0&&timeBetween/3600<24)
        {
            timeLabel.text = [NSString stringWithFormat:@"%d小时前 来自%@",(int)timeBetween/3600,inputSource];
        }
    }else if ([[self compareDate:inputDate] isEqualToString:@"昨天"])
    {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"H:mm"];
        NSString *inputTimeStr = [inputFormatter stringFromDate:inputDate];
        timeLabel.text = [NSString stringWithFormat:@"昨天 %@ 来自%@",inputTimeStr,inputSource];
    }else
    {
        NSDateFormatter *moreInputFormatter = [[NSDateFormatter alloc] init];
        [moreInputFormatter setDateFormat:@"MM-dd"];
        NSString *inputTimeStr = [moreInputFormatter stringFromDate:inputDate];
        timeLabel.text = [NSString stringWithFormat:@"%@ 来自%@",inputTimeStr,inputSource];
    }
    
    //博主头像
    [HeadImageView sd_setImageWithURL:[NSURL URLWithString:[[[dataArr objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"touxiang_40x40.png"]];
    //微博正文
    NSString *weiboText = [[dataArr objectAtIndex:indexPath.row] objectForKey:@"text"];
    [self parseLink:weiboText];
    Weibocontent.text = [self parseLink:weiboText];
    CGFloat textViewContentHeight = Weibocontent.optimumSize.height;
    Weibocontent.frame = CGRectMake(10, 50, SCREENWIDTH-20, textViewContentHeight);
    
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
        
        weiboImages.frame = CGRectMake(10, 40+textViewContentHeight+10, sizeH.width, sizeH.height);
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
        
        weiboImages.frame = CGRectMake(10, 40+textViewContentHeight+10, 300, weiboImgHeight);
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
    retweetWeibo.frame = CGRectMake(0, 40+textViewContentHeight+10, SCREENWIDTH, statuHeight);
    self.frame = CGRectMake(0, 0, SCREENWIDTH, 50+35+textViewContentHeight+weiboImgHeight+statuHeight);
    
    //转发
    retweetBtn.frame = CGRectMake(0, self.frame.size.height-35, self.frame.size.width/3, 30);
    retweetNum.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"reposts_count"]];
    [retweetBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    //评论
    commentBtn.frame = CGRectMake(self.frame.size.width/3, self.frame.size.height-35, self.frame.size.width/3, 30);
    commentNum.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"comments_count"]];
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    //表态
    attitudeBtn.frame = CGRectMake(self.frame.size.width/3*2, self.frame.size.height-35, self.frame.size.width/3, 30);
    attitudeNum.text = [NSString stringWithFormat:@"%@",[[dataArr objectAtIndex:indexPath.row] objectForKey:@"attitudes_count"]];
    [attitudeBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    //点击微博图片触发显示大图方法
    UITapGestureRecognizer *bigger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
    bigger.numberOfTapsRequired = 1;
    
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
    }
}

#pragma mark-转发评论表态触发方法

//点击转发触发方法
-(void)retweetAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    NSLog(@"%d",btn.tag);
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
        orImage = (UIImageView*)bigTap.view;
    }else if(bigTap.view.tag>=1000&&bigTap.view.tag<2000)
    {
        num = bigTap.view.tag-1000;
        imageUrl = [NSURL URLWithString:[[weiboData objectAtIndex:num] objectForKey:@"original_pic"]];
        orImage = (UIImageView*)bigTap.view;
    }else if (bigTap.view.tag>=7000&&bigTap.view.tag<8000)
    {
        num = bigTap.view.tag-7000;
        imageUrl = [NSURL URLWithString:[[weiboData objectAtIndex:num] objectForKey:@"original_pic"]];
        orImage = [[bigTap.view subviews] objectAtIndex:0];
    }else if (bigTap.view.tag>=8000&&bigTap.view.tag<9000)
    {
        num = bigTap.view.tag-8000;
        imageUrl = [NSURL URLWithString:[[[weiboData objectAtIndex:num] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]];
        orImage = [[bigTap.view subviews] objectAtIndex:0];
    }
    
    picImageView.frame = CGRectMake(self.superview.center.x, self.superview.center.y, 0, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
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
         
         
         
     }];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    backTap.numberOfTapsRequired = 1;
    [imageScroll addGestureRecognizer:backTap];
    [mainView addSubview:imageScroll];
    self.superview.superview.superview.hidden = YES;
    
    
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
