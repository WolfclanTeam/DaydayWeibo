//
//  DetailWeiboTableView.m
//  WeiboTest
//
//  Created by Ibokan on 14-10-23.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "DetailWeiboTableView.h"

@implementation DetailWeiboTableView
@synthesize commentDict;

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
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:[[weiboDict objectForKey:@"user"] objectForKey:@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"touxiang_40x40.png"]];
        //微博用户ID
        idLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, [UIScreen mainScreen].bounds.size.width-50, 30)];
        idLabel.text = [[weiboDict objectForKey:@"user"] objectForKey:@"screen_name"];
        //微博发布时间
//        NSLog(@"%@====%@",[weiboDict objectForKey:@"created_at"],[weiboDict objectForKey:@"source"]);
        
        //微博正文
        weiboConnent = [[UITextView alloc] init];
        weiboConnent.editable = NO;
        weiboConnent.scrollEnabled = NO;
        weiboConnent.text = [weiboDict objectForKey:@"text"];
        weiboConnent.font = [UIFont systemFontOfSize:15];
        CGFloat weiboContentHeight =[[NSString stringWithFormat:@"%@",weiboConnent.text]
                                   boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil].size.height+10;
        weiboConnent.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, weiboContentHeight);
        
        
        CGFloat weiboImageHeight;
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
        
        //转发
        repostsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        repostsBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-30, 106, 30);
        repostsBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        repostsBG.image = [UIImage imageNamed:@"toolbar_icon_retweet@2x.png"];
        repostsCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 106-50, 30)];
        repostsCount.text = @"转发";
        [repostsBtn addSubview:repostsCount];
        [repostsBtn addSubview:repostsBG];
        [self.superview addSubview:repostsBtn];
        
        //评论
        commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(106, [UIScreen mainScreen].bounds.size.height-30, 107, 30);
        commentBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        commentBG.image = [UIImage imageNamed:@"toolbar_icon_comment@2x.png"];
        commentCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 107-50, 30)];
        commentCount.text = @"评论";
        [commentBtn addSubview:commentBG];
        [commentBtn addSubview:commentCount];
        [self.superview addSubview:commentBtn];
        
        //表态
        attitudesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        attitudesBtn.frame = CGRectMake(213, [UIScreen mainScreen].bounds.size.height-30, 107, 30);
        attitudesBG = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
        attitudesBG.image = [UIImage imageNamed:@"toolbar_icon_unlike@2x.png"];
        attitudeCount = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 107-50, 30)];
        attitudeCount.text = @"赞";
        [attitudesBtn addSubview:attitudesBG];
        [attitudesBtn addSubview:attitudeCount];
        [self.superview addSubview:attitudesBtn];
        
        headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,weiboContentHeight+50+weiboImageHeight)];
        [headView addSubview:headImage];
        [headView addSubview:idLabel];
        [headView addSubview:weiboConnent];
        [headView addSubview:weiboSingleImage];
        [headView addSubview:weiboImages];
        
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
    return [[commentDict objectForKey:@"comments"] count];
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
    NSMutableArray *commentsArr = [commentDict objectForKey:@"comments"];
    [cell setCellCommentData:commentsArr indexPath:indexPath];
    
    return cell;
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
