//
//  UserInformation.h
//  DayDayWeibo
//
//  Created by bk on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInformation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * statuses;
@property (nonatomic, retain) NSNumber * care;
@property (nonatomic, retain) NSNumber * fans;
@property (nonatomic, retain) NSString * brief;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * uid;

@end
