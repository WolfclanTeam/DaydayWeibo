//
//  KZJDealData.h
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//
//处理数据的类
#import <Foundation/Foundation.h>

@interface KZJDealData : NSObject
-(NSArray*)random:(int)length withNum:(int)num;//根据传入参数length从0开始的长度获取num个不同的随机数
@end
