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
        theWeiboDict = weiboDict;
        //设置显示大图的图片视图
        picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT)];
        imageScroll.backgroundColor = [UIColor blackColor];
        imageScroll.bounces = NO;
        [imageScroll addSubview:picImageView];
        
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
        
        //点击转发
        UITapGestureRecognizer *pushRetweetWeibo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushRetweetWeibo:)];
        pushRetweetWeibo.numberOfTapsRequired = 1;
        [retweetView addGestureRecognizer:pushRetweetWeibo];
        
        
        //点击头像
        UITapGestureRecognizer *userHome = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserHome:)];
        userHome.numberOfTapsRequired = 1;
        [viewForHeadImage addGestureRecognizer:userHome];
        
        
        //
        weiboSingleImage.userInteractionEnabled = YES;
        weiboImages.userInteractionEnabled = YES;
        retweetImages.userInteractionEnabled = YES;
        retweetSingleImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
        singleImageTap.numberOfTapsRequired = 1;
        weiboSingleImage.tag  = 1201;
        [weiboSingleImage addGestureRecognizer:singleImageTap];
        
        UITapGestureRecognizer *weiboImagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
        weiboImagesTap.numberOfTapsRequired = 1;
        weiboImages.tag = 1202;
        [weiboImages addGestureRecognizer:weiboImagesTap];

        UITapGestureRecognizer *singleRetImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
        singleRetImgTap.numberOfTapsRequired = 1;
        retweetSingleImage.tag = 1301;
        [retweetSingleImage addGestureRecognizer:singleRetImgTap];
        
        UITapGestureRecognizer *retweetImagesTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biggerAction:)];
        retweetImagesTap.numberOfTapsRequired = 1;
        retweetImages.tag = 1302;
        [retweetImages addGestureRecognizer:retweetImagesTap];
        
        //转发
        repostsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        repostsBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-30, 106, 30);
        repostsBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        repostsBG.image = [UIImage imageNamed:@"rettoolbar_icon_retweet@2x.png"];
        repostsCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 106-50, 30)];
        repostsCount.text = @"转发";
        [repostsBtn addSubview:repostsCount];
        [repostsBtn addSubview:repostsBG];
        [repostsBtn addTarget:self action:@selector(retweetWeiboAction:) forControlEvents:UIControlEventTouchUpInside];
        [repostsBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
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
        [commentBtn addTarget:self action:@selector(commentWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
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
        [attitudesBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
        [self.superview addSubview:attitudesBtn];
        
        
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,weiboContentHeight+50+weiboImageHeight+retweetImageHeight+retweetContentHeight+20)];
        boundsView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height-8, SCREENWIDTH, 8)];
        boundsView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
        [headView addSubview:boundsView];
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

-(void)pushRetweetWeibo:(UITapGestureRecognizer*)sender
{
    NSDictionary *dict = @{@"retWeibo":[theWeiboDict objectForKey:@"retweeted_status"]};
    NSNotification *pushRetWeibo = [[NSNotification alloc] initWithName:@"PUSHRETWEIBO" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:pushRetWeibo];
}


-(void)pushUserHome:(UITapGestureRecognizer*)sender
{
    NSDictionary *dict = @{@"userID":[[theWeiboDict objectForKey:@"user"] objectForKey:@"id"]};
    NSNotification *pushUserHome = [[NSNotification alloc] initWithName:@"DETAILPUSHUSER" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:pushUserHome];
}

#pragma mark - 放大图片
-(void)biggerAction:(UITapGestureRecognizer*)sender
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = picImageView.center;
    [picImageView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    NSURL *imageUrl;
    UIImageView *orgImageView;
    if (sender.view.tag == 1201)
    {
        orgImageView = (UIImageView*)sender.view;
        imageUrl = [NSURL URLWithString:[theWeiboDict objectForKey:@"original_pic"]];
    }else if(sender.view.tag == 1202)
    {
        orgImageView = [[sender.view subviews] objectAtIndex:0];
        imageUrl = [NSURL URLWithString:[theWeiboDict objectForKey:@"original_pic"]];
    }else if (sender.view.tag == 1301)
    {
        orgImageView = (UIImageView*)sender.view;
        imageUrl = [NSURL URLWithString:[[theWeiboDict objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]];
    }else if (sender.view.tag == 1302)
    {
        orgImageView = [[sender.view subviews] objectAtIndex:0];
        imageUrl = [NSURL URLWithString:[[theWeiboDict objectForKey:@"retweeted_status"] objectForKey:@"original_pic"]];
    }
    
    picImageView.frame = CGRectMake(self.superview.center.x, self.superview.center.y, 0, 0);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    UIImage *OrgImage = [UIImage redraw:orgImageView.image Frame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
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
    [self.superview.superview.superview.superview addSubview:imageScroll];
    
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
    beginPoint = nowPoint;
}

-(void)backAction
{
    [imageScroll removeFromSuperview];
}

-(void)retweetWeiboAction:(UIButton*)sender
{
    NSNumber *weiID = [theWeiboDict objectForKey:@"id"];
    NSString *weiboID = [weiID stringValue];
    NSString *weiboImageUrl;
    if ([[theWeiboDict objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"])
    {
        weiboImageUrl = [[theWeiboDict objectForKey:@"retweeted_status"] objectForKey:@"thumbnail_pic"];
    }else if ([theWeiboDict objectForKey:@"thumbnail_pic"])
    {
        weiboImageUrl = [theWeiboDict objectForKey:@"thumbnail_pic"];
    }else
    {
        weiboImageUrl = [[theWeiboDict objectForKey:@"user"] objectForKey:@"profile_image_url"];
    }
    NSString *userID = [[theWeiboDict objectForKey:@"user"] objectForKey:@"screen_name"];
    NSString *weiboText = [theWeiboDict objectForKey:@"text"];
    NSString *retWeibo;
    if ([theWeiboDict objectForKey:@"retweeted_status"])
    {
        retWeibo = [theWeiboDict objectForKey:@"text"];
    }else
    {
        retWeibo = @"";
    }

    NSDictionary *dict = @{@"weiboID":weiboID,@"weiboImageUrl":weiboImageUrl,@"userID":userID,@"weiboText":weiboText,@"retWeibo":retWeibo};
    NSNotification *retNoti = [[NSNotification alloc] initWithName:@"DETAILRETWEIBO" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:retNoti];
}

-(void)commentWeibo:(UIButton*)sender
{
    NSDictionary *dict = @{@"weiboID":[theWeiboDict objectForKey:@"id"]};
    NSNotification *comNoti = [[NSNotification alloc] initWithName:@"COMMENTWEIBO" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:comNoti];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    selectView = [[UIView alloc] initWithFrame:CGRectMake(100, 20, 40, 5)];
    selectView.backgroundColor = [UIColor blackColor];
    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    listView.backgroundColor = [UIColor whiteColor];
    UIButton *reposts = [UIButton buttonWithType:UIButtonTypeCustom];
    reposts.frame = CGRectMake(0, 0, 80, 20);
    UIButton *comments = [UIButton buttonWithType:UIButtonTypeCustom];
    comments.frame = CGRectMake(80, 0, 80, 20);
    UIButton *attitudes = [UIButton buttonWithType:UIButtonTypeCustom];
    attitudes.frame = CGRectMake(SCREENWIDTH-80, 0, 80, 20);
    UILabel *repostsL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 20)];
    UILabel *commentsL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 20)];
    UILabel *attitudesL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 20)];
    [reposts addSubview:repostsL];
    [comments addSubview:commentsL];
    [attitudes addSubview:attitudesL];

    repostsL.text = [NSString stringWithFormat:@"%@ %@",@"转发",[repostsNum stringValue]];
    commentsL.text = [NSString stringWithFormat:@"%@ %@",@"评论",[commentsNum stringValue]];
    attitudesL.text = [NSString stringWithFormat:@"%@ %@",@"赞",[attitudesNum stringValue]];
    
    
    repostsL.font = [UIFont systemFontOfSize:12];
    commentsL.font = [UIFont systemFontOfSize:12];
    attitudesL.font = [UIFont systemFontOfSize:12];
    repostsL.textColor = [UIColor grayColor];
    commentsL.textColor = [UIColor grayColor];
    attitudesL.textColor = [UIColor grayColor];
    [reposts addTarget:self action:@selector(repostsAction:) forControlEvents:UIControlEventTouchUpInside];
    [comments addTarget:self action:@selector(commentsAction:) forControlEvents:UIControlEventTouchUpInside];
    [attitudes addTarget:self action:@selector(attitudesAction:) forControlEvents:UIControlEventTouchUpInside];

    [listView addSubview:reposts];
    [listView addSubview:comments];
    [listView addSubview:attitudes];
    [listView addSubview:selectView];

    return listView;
}

-(void)repostsAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    selectView.frame = CGRectMake(20, 20, 40, 5);
    [UIView commitAnimations];
    
}

-(void)commentsAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    selectView.frame = CGRectMake(100, 20, 40, 5);
    [UIView commitAnimations];
}

-(void)attitudesAction:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    selectView.frame = CGRectMake(SCREENWIDTH-60, 20, 40, 5);
    [UIView commitAnimations];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha =0.75;
    
    comSelectView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH-40, SCREENHEIGHT/3)];
    comSelectView.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
    comSelectView.layer.cornerRadius = 8.0;
    comSelectView.layer.masksToBounds = YES;
    comSelectView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    
    UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replyBtn.backgroundColor = [UIColor whiteColor];
    replyBtn.frame = CGRectMake(0, 0, comSelectView.frame.size.width, comSelectView.frame.size.height/3-1);
    UILabel *replyL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, comSelectView.frame.size.width-20, comSelectView.frame.size.height/3)];
    [replyBtn addSubview:replyL];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.backgroundColor = [UIColor whiteColor];
    copyBtn.frame = CGRectMake(0, comSelectView.frame.size.height/3, comSelectView.frame.size.width, comSelectView.frame.size.height/3);
    UILabel *copyL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, comSelectView.frame.size.width-20, comSelectView.frame.size.height/3)];
    [copyBtn addSubview:copyL];
    
    
    UIButton *denounceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    denounceBtn.backgroundColor = [UIColor whiteColor];
    denounceBtn.frame = CGRectMake(0, comSelectView.frame.size.height/3*2+1, comSelectView.frame.size.width, comSelectView.frame.size.height/3);
    UILabel *denounceL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, comSelectView.frame.size.width-20, comSelectView.frame.size.height/3)];
    [denounceBtn addSubview:denounceL];
    
    replyL.text = @"回复";
    copyL.text = @"复制" ;
    denounceL.text = @"举报";
    
    [replyBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    [copyBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];
    [denounceBtn setBackgroundImage:[UIImage imageNamed:@"page_image_loading@2x.png"] forState:UIControlStateHighlighted];

    [comSelectView addSubview:replyBtn];
    [comSelectView addSubview:copyBtn];
    [comSelectView addSubview:denounceBtn];
    
    
    [self.superview addSubview:bgView];
    [self.superview addSubview:comSelectView];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backCom:)];
    tap.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:tap];
    
    [replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
    [denounceBtn addTarget:self action:@selector(denounceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    replyBtn.tag = 1000+indexPath.row;
    copyBtn.tag = 2000+indexPath.row;
    denounceBtn.tag = 3000+indexPath.row;
}

-(void)replyAction:(UIButton*)sender
{
    int num = sender.tag - 1000;
    NSDictionary *dict = @{@"commentID":[[commentsArr objectAtIndex:num] objectForKey:@"id"],@"weiboID":[theWeiboDict objectForKey:@"id"]};
    NSNotification *replyNoti = [[NSNotification alloc] initWithName:@"REPLYCOMMENT" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:replyNoti];
    [bgView removeFromSuperview];
    [comSelectView removeFromSuperview];
}

-(void)copyAction:(UIButton*)sender
{
    int num = sender.tag-2000;
    NSString *str = [NSString stringWithFormat:@"@%@:%@",[[[commentsArr objectAtIndex:num] objectForKey:@"user"] objectForKey:@"screen_name"],[[commentsArr objectAtIndex:num] objectForKey:@"text"]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已复制到剪贴板" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [bgView removeFromSuperview];
    [comSelectView removeFromSuperview];
}

-(void)denounceAction:(UIButton*)sender
{
    
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
