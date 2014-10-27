//
//  KZJDealData.m
//  DayDayWeibo
//
//  Created by bk on 14-10-22.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJDealData.h"

@implementation KZJDealData
-(NSArray*)random:(int)length withNum:(int)num
{
    NSMutableArray*array  =[NSMutableArray arrayWithCapacity:num];
    [array removeAllObjects];
    for (int i=0; i<num; i++)
    {
//        NSLog(@"================%d",length);
        int a = arc4random_uniform(length);
//        NSLog(@"%d",[array count]);
//        NSLog(@"%d",a);       
        if ([array count]>0)
        {
            for (NSString*str in array)
            {
                if ([str intValue]==a)
                {
                    i--;
                    break;
                }else
                {
                    [array addObject:[NSString stringWithFormat:@"%d",a]];
                    break;
                }
            }
        }else
        {
            [array addObject:[NSString stringWithFormat:@"%d",a]];
        }
        
        
//        NSLog(@"%@",array);
    }
//            NSLog(@"%@",array);
    return array;
}



@end
