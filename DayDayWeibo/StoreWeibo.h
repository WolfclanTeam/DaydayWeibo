//
//  StoreWeibo.h
//  DayDayWeibo
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoreWeibo : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * textContent;

@end
