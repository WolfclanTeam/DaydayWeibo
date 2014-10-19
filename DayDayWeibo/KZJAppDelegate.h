//
//  KZJAppDelegate.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//彬楷
//elwflrgrfgcvx

#import <UIKit/UIKit.h>
#import "KZJMyTabBarController.h"
#import "KZJHomeController.h"
#import "KZJMessageController.h"

#import "KZJFindController.h"
#import "KZJMeController.h"
#import "KZJRequestData.h"
@interface KZJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
