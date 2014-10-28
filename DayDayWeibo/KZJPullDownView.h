//
//  KZJPullDownView.h
//  DayDayWeibo
//
//  Created by bk on 14/10/28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZJPullDownViewProtocol.h"

@interface KZJPullDownView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    int height;
    NSArray*titleArr;
}
@property(retain,nonatomic)NSString*type;
@property(assign,nonatomic)id<KZJPullDownViewProtocol>delegate;

-(KZJPullDownView*)initWithFrame:(CGRect)frame withTitles:(NSArray*)titleArray;

@end
