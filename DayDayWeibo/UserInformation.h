//
//  UserInformation.h
//  DayDayWeibo
//
//  Created by bk on 14-10-19.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInformation : NSManagedObject

@property (nonatomic, retain) NSString * brief;
@property (nonatomic, retain) NSString * care;
@property (nonatomic, retain) NSString * fans;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * statuses;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * unread;
@property (nonatomic, retain) NSString *collectionNum;
@property (nonatomic, retain) NSString *photoNum;
@end
