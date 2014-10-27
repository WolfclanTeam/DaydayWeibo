//
//  KZJCommentCell.m
//  WeiboTest
//
//  Created by Ibokan on 14-10-23.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import "KZJCommentCell.h"

@implementation KZJCommentCell
@synthesize headImageView,idLabel,timeLbel,commentContent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //移除系统cell上原有的控件
        [self.imageView removeFromSuperview];
        [self.textLabel removeFromSuperview];
        [self.detailTextLabel removeFromSuperview];
        // Initialization code
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        idLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, [UIScreen mainScreen].bounds.size.width-65, 25)];
        timeLbel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, [UIScreen mainScreen].bounds.size.width-65, 15)];
        timeLbel.font = [UIFont systemFontOfSize:10];
        timeLbel.textColor = [UIColor grayColor];
        commentContent = [[RTLabel alloc] initWithFrame:CGRectMake(45, 45, SCREENWIDTH-45, 0)];
        commentContent.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
        commentContent.font = [UIFont systemFontOfSize:13];
        commentContent.userInteractionEnabled = YES;
        commentContent.delegate = self;
        
        [self addSubview:headImageView];
        [self addSubview:idLabel];
        [self addSubview:timeLbel];
        [self addSubview:commentContent];
    }
    return self;
}

-(void)setCellCommentData:(NSArray *)commentArr indexPath:(NSIndexPath *)indexPath
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[[[commentArr objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"touxiang_40x40.png"]];
    idLabel.text = [[[commentArr objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
    //日期转化
    NSString *timeStr = [[commentArr objectAtIndex:indexPath.row] objectForKey:@"created_at"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *getFormatter = [[NSDateFormatter alloc] init];
    [getFormatter setDateFormat:@"EEE MMM dd H:mm:ss Z yyyy"];
    [inputFormatter setDateFormat:@"MM-dd H:mm"];
    NSDate *inputDate = [getFormatter dateFromString:timeStr];
    NSString *inputTimeStr = [inputFormatter stringFromDate:inputDate];
    timeLbel.text = inputTimeStr;
    
    //评论内容
    NSString *commentText = [[commentArr objectAtIndex:indexPath.row] objectForKey:@"text"];
    commentContent.text = [self parseLink:commentText];
    
    CGFloat commentContentHeight =commentContent.optimumSize.height;
    commentContent.frame = CGRectMake(45, 45, SCREENWIDTH-45, 20+commentContentHeight);
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40+10+commentContentHeight+20);
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
        NSNotification *webNoti = [[NSNotification alloc] initWithName:@"WEBPUSH" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:webNoti];
    }
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
