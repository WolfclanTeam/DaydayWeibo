//
//  KZJPictureView.h
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJPhotoCell.h"
#import "KZJDetailWeiboViewController.h"
@interface KZJPictureView : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray*photoArray;
    NSArray*photoBiggerArray;
    int page;
}
@property(retain,nonatomic)UITableView*photoTable;
@end
