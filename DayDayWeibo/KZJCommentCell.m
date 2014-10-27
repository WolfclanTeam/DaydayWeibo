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
        commentContent = [[UITextView alloc] initWithFrame:CGRectMake(45, 45, [UIScreen mainScreen].bounds.size.width-45, 0)];
        commentContent.editable = NO;
        commentContent.scrollEnabled = NO;
        commentContent.userInteractionEnabled = NO;
        commentContent.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:headImageView];
        [self addSubview:idLabel];
        [self addSubview:timeLbel];
        [self addSubview:commentContent];
    }
    return self;
}

-(void)setCellCommentData:(NSMutableArray *)commentArr indexPath:(NSIndexPath *)indexPath
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
    commentContent.text = [[commentArr objectAtIndex:indexPath.row] objectForKey:@"text"];
    
    CGFloat commentContentHeight =[[NSString stringWithFormat:@"%@",commentContent.text]
                                    boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-45, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil] context:nil].size.height;
    commentContent.frame = CGRectMake(45, 45, [UIScreen mainScreen].bounds.size.width-45, 20+commentContentHeight);
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40+10+commentContentHeight+20);
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
