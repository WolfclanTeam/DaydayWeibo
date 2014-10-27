//
//  KZJWeiboTableView.h
//  WeiboTest
//
//  Created by Ibokan on 14-10-24.
//  Copyright (c) 2014年 Ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh/MJRefresh.h"
#import "KZJWeiboCell.h"
#import"KZJPhotoCell.h"

@interface KZJWeiboTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    int page;
    UIView *theView;
    NSMutableArray *newData;
    int flag;
}
- (id)initWithFrame:(CGRect)frame view:(UIView*)view;
@property(nonatomic,retain)NSArray *dataArr;

@property(nonatomic,retain)NSArray *photoArray;
@property(nonatomic,retain)NSString*kind;
@property (nonatomic, weak) UIButton *selectedBtn;


@end
