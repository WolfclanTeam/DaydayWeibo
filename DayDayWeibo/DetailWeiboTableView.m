//
//  DetailWeiboTableView.m
//  WeiboTest
//
//  Created by Ibokan on 14-10-23.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "DetailWeiboTableView.h"

@implementation DetailWeiboTableView
@synthesize commentDict,commentsArr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame dataDict:(NSDictionary*)weiboDict superView:(UIView*)supView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [supView addSubview:self];
        self.delegate = self;
        self.dataSource = self;
        
        repostsNum = [weiboDict objectForKey:@"reposts_count"];
        commentsNum = [weiboDict objectForKey:@"comments_count"];
        attitudesNum = [weiboDict objectForKey:@"attitudes_count"];
        //微博用户头像
        viewForHeadImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[[weiboDict objectForKey:@"user"] objectForKey:@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"touxiang_40x40.png"]];
        [viewForHeadImage addSubview:headImage];
        
        
        //微博用户ID
        idLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0,SCREENWIDTH-50, 30)];
        idLabel.text = [[weiboDict objectForKey:@"user"] objectForKey:@"screen_name"];
        //微博发布时间
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, SCREENWIDTH-50, 10)];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        
        NSString *timeStr = [weiboDict objectForKey:@"created_at"];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *getFormatter = [[NSDateFormatter alloc] init];
        [getFormatter setDateFormat:@"EEE MMM dd H:mm:ss Z yyyy"];
        [inputFormatter setDateFormat:@"MM-dd H:mm"];
        NSDate *inputDate = [getFormatter dateFromString:timeStr];
        NSString *inputTimeStr = [inputFormatter stringFromDate:inputDate];
        
        NSString *sourceStr = [weiboDict objectForKey:@"source"];
        NSArray *array=[sourceStr componentsSeparatedByString:@">"];
        NSString *separateString=[array objectAtIndex:1];
        NSString *inputSource = [separateString substringToIndex:(separateString.length-3)];
        timeLabel.text = [NSString stringWithFormat:@"%@ 来自%@",inputTimeStr,inputSource];
        
        //微博正文
        weiboConnent = [[RTLabel alloc] initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20, 0)];
        weiboConnent.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
        weiboConnent.delegate = self;
        NSString *weiboText = [weiboDict objectForKey:@"text"];
        weiboConnent.text = [self parseLink:weiboText];
        weiboConnent.font = [UIFont systemFontOfSize:15];
        CGFloat weiboContentHeight = weiboConnent.optimumSize.height;
        weiboConnent.frame = CGRectMake(10, 50, SCREENWIDTH-20, weiboContentHeight);
        
        
        CGFloat weiboImageHeight = 0.0f;
        //微博图片
        if ([[weiboDict objectForKey:@"pic_urls"] count] == 0)
        {
            weiboImageHeight = 0.0f;
            NSLog(@"无图");
        }else if ([[weiboDict objectForKey:@"pic_urls"] count] == 1)
        {
            weiboSingleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50+weiboContentHeight, 100, 100)];
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            indicatorView.center = weiboSingleImage.center;
            [weiboSingleImage addSubview:indicatorView];
            [indicatorView startAnimating];
        
            [weiboSingleImage sd_setImageWithURL:[NSURL URLWithString:[weiboDict objectForKey:@"bmiddle_pic"]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage *newImage = [UIImage redraw:image Frame:CGRectMake(0, 0, 300, image.size.height/image.size.width*300)];
                weiboSingleImage.frame = CGRectMake(10, 50+weiboContentHeight+5, newImage.size.width, newImage.size.height);
                [indicatorView stopAnimating];
                [indicatorView removeFromSuperview];
            }];
            CGSize imageSize = [GetNetImageSize downloadImageSizeWithURL:[NSURL URLWithString:[weiboDict objectForKey:@"bmiddle_pic"]]];
            weiboImageHeight = imageSize.height/imageSize.width*300;
        }else if ([[weiboDict objectForKey:@"pic_urls"] count]>1)
        {

            if ([[weiboDict objectForKey:@"pic_urls"] count]%3 == 0)
            {
                weiboImageHeight = 100*[[weiboDict objectForKey:@"pic_urls"] count]/3;
            }else
            {
                weiboImageHeight = 100*([[weiboDict objectForKey:@"pic_urls"] count]/3+1);
            }
            
            weiboImages = [[UIView alloc] initWithFrame:CGRectMake(0, 50+weiboContentHeight, 300, weiboImageHeight)];
            for (int i = 0; i<[[weiboDict objectForKey:@"pic_urls"] count]; i++)
            {
                UIImageView *AweiboImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*(i%3), 100*(i/3), 100, 100)];
                [AweiboImage sd_setImageWithURL:[NSURL URLWithString:[[[weiboDict objectForKey:@"pic_urls"] objectAtIndex:i] objectForKey:@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, 100));
                    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
                    AweiboImage.frame = CGRectMake(100*(i%3), 100*(i/3), 100, 100);
                    AweiboImage.image = newImage;
                    weiboImages.frame = CGRectMake(10, 50+weiboContentHeight, 300, weiboImageHeight);
                }];
                
                [weiboImages addSubview:AweiboImage];
                
            }
            
        }
        
        //转发微博
        retweetView = [[UIView alloc] initWithFrame:CGRectMake(0, 50+weiboContentHeight, SCREENWIDTH, 0)];
        retweetView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        CGFloat retweetContentHeight = 0.0f;
        CGFloat retweetImageHeight = 0.0f;
        if ([weiboDict objectForKey:@"retweeted_status"])
        {
            
            retweetContent = [[RTLabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 0)];
            retweetContent.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
            retweetContent.delegate = self;
            NSString *retweetID = [[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"user"] objectForKey:@"screen_name"];
            NSString *retweetDetail = [[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"text"];
            NSString *retweetWeiboText = [NSString stringWithFormat:@"@%@:%@",retweetID,retweetDetail];
            retweetContent.text = [self parseLink:retweetWeiboText];
            retweetContent.font = [UIFont systemFontOfSize:14];
            retweetContentHeight = retweetContent.optimumSize.height;
            retweetContent.frame = CGRectMake(10, 0, SCREENWIDTH-20, retweetContentHeight);
            
            //转发微博图片
            if ([[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count] == 0)
            {
                retweetImageHeight = 0.0f;
                NSLog(@"无图");
                retweetView.frame = CGRectMake(10, 50+weiboContentHeight, SCREENWIDTH-20, retweetContentHeight);
            }else if ([[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count] == 1)
            {
                retweetSingleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, retweetContentHeight, 100, 100)];
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
                indicatorView.center = weiboSingleImage.center;
                [retweetSingleImage addSubview:indicatorView];
                [indicatorView startAnimating];
                
                [retweetSingleImage sd_setImageWithURL:[NSURL URLWithString:[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"bmiddle_pic" ]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    UIImage *newImage = [UIImage redraw:image Frame:CGRectMake(0, 0, 300, image.size.height/image.size.width*300)];
                    retweetSingleImage.frame = CGRectMake(10, retweetContentHeight+5, newImage.size.width, newImage.size.height);
                    [indicatorView stopAnimating];
                    [indicatorView removeFromSuperview];
                }];
                CGSize imageSize = [GetNetImageSize downloadImageSizeWithURL:[NSURL URLWithString:[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"bmiddle_pic" ]]];
                retweetImageHeight = imageSize.height/imageSize.width*300;
                [retweetView addSubview:retweetSingleImage];
                retweetView.frame = CGRectMake(0, 50+weiboContentHeight, SCREENWIDTH, retweetContentHeight+retweetImageHeight);
            }else if ([[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count]>1)
            {
                
                if ([[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count]%3 == 0)
                {
                    retweetImageHeight = 100*[[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count]/3;
                }else
                {
                    retweetImageHeight = 100*([[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count]/3+1);
                }
                
                retweetImages = [[UIView alloc] initWithFrame:CGRectMake(0, retweetContentHeight, 300, retweetImageHeight)];
                for (int i = 0; i<[[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ]count]; i++)
                {
                    UIImageView *AweiboImage = [[UIImageView alloc] initWithFrame:CGRectMake(100*(i%3), 100*(i/3), 100, 100)];
                    [AweiboImage sd_setImageWithURL:[NSURL URLWithString:[[[[weiboDict objectForKey:@"retweeted_status"] objectForKey:@"pic_urls" ] objectAtIndex:i] objectForKey:@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                     {
                         CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(image.size.width/2-50, image.size.height/2-50, 100, 100));
                         UIImage *newImage = [UIImage imageWithCGImage:imageRef];
                         AweiboImage.frame = CGRectMake(100*(i%3), 100*(i/3), 100, 100);
                         AweiboImage.image = newImage;
                         retweetImages.frame = CGRectMake(10,retweetContentHeight+5, 300, retweetImageHeight);
                     }];
                    
                    [retweetImages addSubview:AweiboImage];
                    
                }
                [retweetView addSubview:retweetImages];
                retweetView.frame = CGRectMake(0, 50+weiboContentHeight, SCREENWIDTH, retweetContentHeight+retweetImageHeight);
            }
            
        }
        
        //转发
        repostsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        repostsBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-30, 106, 30);
        repostsBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        repostsBG.image = [UIImage imageNamed:@"rettoolbar_icon_retweet@2x.png"];
        repostsCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 106-50, 30)];
        repostsCount.text = @"转发";
        [repostsBtn addSubview:repostsCount];
        [repostsBtn addSubview:repostsBG];
        [self.superview addSubview:repostsBtn];
        
        //评论
        commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(106, [UIScreen mainScreen].bounds.size.height-30, 107, 30);
        commentBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        commentBG.image = [UIImage imageNamed:@"comtoolbar_icon_comment@2x.png"];
        commentCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 107-50, 30)];
        commentCount.text = @"评论";
        [commentBtn addSubview:commentBG];
        [commentBtn addSubview:commentCount];
        [self.superview addSubview:commentBtn];
        
        //表态
        attitudesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attitudesBtn.frame = CGRectMake(213, [UIScreen mainScreen].bounds.size.height-30, 107, 30);
        attitudesBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        attitudesBG.image = [UIImage imageNamed:@"attitoolbar_icon_unlike@2x.png"];
        attitudeCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 107-50, 30)];
        attitudeCount.text = @"赞";
        [attitudesBtn addSubview:attitudesBG];
        [attitudesBtn addSubview:attitudeCount];
        [self.superview addSubview:attitudesBtn];
        
        
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,weiboContentHeight+50+weiboImageHeight+retweetImageHeight+retweetContentHeight)];
        [retweetView addSubview:retweetContent];
        [headView addSubview:retweetView];
        [headView addSubview:viewForHeadImage];
        [headView addSubview:idLabel];
        [headView addSubview:timeLabel];
        [headView addSubview:weiboConnent];
        [headView addSubview:weiboSingleImage];
        [headView addSubview:weiboImages];
        [headView addSubview:retweetView];
        self.tableHeaderView = headView;
        
    }
    return self;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    listView.backgroundColor = [UIColor whiteColor];
    UILabel *reposts = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    UILabel *comments = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 80, 20)];
    UILabel *attitudes = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 5, 80, 20)];
    reposts.font = [UIFont systemFontOfSize:12];
    comments.font = [UIFont systemFontOfSize:12];
    attitudes.font = [UIFont systemFontOfSize:12];
    [listView addSubview:reposts];
    [listView addSubview:comments];
    [listView addSubview:attitudes];
    reposts.text = [NSString stringWithFormat:@"%@ %@",@"转发",[repostsNum stringValue]];
    comments.text = [NSString stringWithFormat:@"%@ %@",@"评论",[commentsNum stringValue]];
    attitudes.text = [NSString stringWithFormat:@"%@ %@",@"赞",[attitudesNum stringValue]];
    return listView;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"jjjjjjjlllll");
    return [commentsArr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KZJCommentCell *cell = (KZJCommentCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"CELL";
    KZJCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[KZJCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellCommentData:commentsArr indexPath:indexPath];
    
    return cell;
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

#pragma mark-RTLabelDelegate

-(void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString = [url host];
    urlString = [urlString URLDecodedString];
    NSLog(@"%@",urlString);
    if ([urlString hasPrefix:@"http://"])
    {
        NSDictionary *dict = @{@"http": urlString};
        NSNotification *webNoti = [[NSNotification alloc] initWithName:@"COMPUSHWEB" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:webNoti];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.superview addSubview:bgView];
    bgView.backgroundColor = [UIColor grayColor];
    bgView.alpha = 0.9;
    
    comSelectView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH-40, SCREENHEIGHT/3)];
    comSelectView.alpha = 1;
    comSelectView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    replyBtn.backgroundColor = [UIColor whiteColor];
    replyBtn.frame = CGRectMake(0, 0, comSelectView.frame.size.width, comSelectView.frame.size.height/3);
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    copyBtn.backgroundColor = [UIColor whiteColor];
    copyBtn.frame = CGRectMake(0, comSelectView.frame.size.height/3, comSelectView.frame.size.width, comSelectView.frame.size.height/3);
    UIButton *denounceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    denounceBtn.backgroundColor = [UIColor whiteColor];
    denounceBtn.frame = CGRectMake(0, comSelectView.frame.size.height/3*2, comSelectView.frame.size.width, comSelectView.frame.size.height/3);
    [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [denounceBtn setTitle:@"举报" forState:UIControlStateNormal];
    [comSelectView addSubview:replyBtn];
    [comSelectView addSubview:copyBtn];
    [comSelectView addSubview:denounceBtn];
    [self.superview addSubview:comSelectView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backCom:)];
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
}



-(void)backCom:(id)sender
{
    [bgView removeFromSuperview];
    [comSelectView removeFromSuperview];
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
