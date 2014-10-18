//
//  KZJAppDelegate.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJAppDelegate.h"

@implementation KZJAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@",NSHomeDirectory());
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    KZJHomeController*homeController = [[KZJHomeController alloc]init];
    UINavigationController*nav_home = [[UINavigationController alloc]initWithRootViewController:homeController];
    
    KZJMessageController *message = [[KZJMessageController alloc]init];
    UINavigationController*nav_message = [[UINavigationController alloc]initWithRootViewController:message];
    
    KZJShareController *share = [[KZJShareController alloc]init];
    
    KZJFindController *find = [[KZJFindController alloc]init];
    UINavigationController*nav_find = [[UINavigationController alloc]initWithRootViewController:find];
    
    KZJMeController *me = [[KZJMeController alloc]init];
    UINavigationController*nav_me = [[UINavigationController alloc]initWithRootViewController:me];
    
    
    NSMutableArray*image = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"tabbar_home@2x"],[UIImage imageNamed:@"tabbar_message_center@2x"],[UIImage imageNamed:@"tabbar_compose_button@2x"],[UIImage imageNamed:@"tabbar_discover@2x"],[UIImage imageNamed:@"tabbar_profile@2x"], nil];
    
    NSMutableArray*selectedImage = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"tabbar_home_selected@2x"],[UIImage imageNamed:@"tabbar_message_center_selected@2x"],[UIImage imageNamed:@"tabbar_compose_button_highlighted@2x"],[UIImage imageNamed:@"tabbar_discover_selected@2x"],[UIImage imageNamed:@"tabbar_profile_selected@2x"], nil];
    KZJMyTabBarController *myTabBar = [[KZJMyTabBarController alloc] initWithImage:image SeletedImage:selectedImage];
    myTabBar.titleArray = [NSArray arrayWithObjects:@"首页",@"消息",@"发现",@"我",nil];
    
    myTabBar.viewControllers = [NSArray arrayWithObjects:nav_home,nav_message,share,nav_find,nav_me, nil];
    
    
    
    
    self.window.rootViewController = myTabBar;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DayDayWeibo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DayDayWeibo.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark 微博返回信息
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess )
        {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"已登陆1" forKey:@"登陆状态"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSUserDefaults*user = [NSUserDefaults standardUserDefaults];
            [user setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"Token"];
            [user setObject:[(WBAuthorizeResponse *)response userID] forKey:@"UserID"];
            [user synchronize];
            
            [self startRequestData];
            
            NSNotification*notification= [NSNotification notificationWithName:@"login" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            
        }else
        {
            
            [[NSUserDefaults standardUserDefaults]setObject:@"未登陆" forKey:@"登陆状态"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
}
#pragma mark 微博请求信息
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}
-(void)startRequestData
{
    NSDictionary*params=[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"],@"uid",nil];
    [WBHttpRequest requestWithAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"Token"] url:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:params delegate:self withTag:@"991"];
}
#pragma mark 微博认证请求返回结果结束
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    //    NSLog(@"===");
    NSDictionary*dict = [result objectFromJSONString];
        NSLog(@"===%@",dict);
//        NSLog(@"===");
    KZJRequestData *requestData= [[KZJRequestData alloc]init];
    requestData.userInformation = dict;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    UserInformation*userInformation = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"UserInformation"
                                      inManagedObjectContext:context];
    userInformation.name = [dict objectForKey:@"name"];
    UIImageView*image = [[UIImageView alloc]init];
    [image sd_setImageWithURL:[dict objectForKey:@"avatar_hd"]];
    NSData*imageData = UIImagePNGRepresentation(image.image);
    userInformation.photo = imageData;
    userInformation.brief = [dict objectForKey:@"description"];
    userInformation.statuses = [dict objectForKey:@"statuses_count"];
    userInformation.care = [dict objectForKey:@"friends_count"];
    userInformation.fans = [dict objectForKey:@"followers_count"];
    userInformation.uid = [dict objectForKey:@"id"];
    [context save:nil];
    
    
    
    
    NSNotification*notification=nil;
    notification = [NSNotification notificationWithName:@"passValue" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}


@end
