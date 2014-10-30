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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UIImageView*image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if (SCREENHEIGHT==480)
    {
        image1.image = [UIImage imageNamed:@"ad_background@2x"];
    }else if (SCREENHEIGHT==568)
    {
        image1.image = [UIImage imageNamed:@"ad_background-568h@2x"];
    }
    UIImageView*subImage = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, SCREENWIDTH-120, 100)];
    subImage.image = [UIImage imageNamed:@"compose_slogan@2x"];
    subImage.tag = 10001;
    [image1 addSubview:subImage];
    image1.tag = 10000;
    [self.window addSubview:image1];
    
    [self performSelector:@selector(action1) withObject:nil afterDelay:1.5];
    [self performSelector:@selector(action2) withObject:nil afterDelay:3];
    
    return YES;
}
-(void)action1
{

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Token"]!=nil)
    {

        UIImageView*image = (UIImageView*)[self.window viewWithTag:10000];
        UIImageView*subImage = (UIImageView*)[self.window viewWithTag:10001];
        [subImage removeFromSuperview];
        UserInformation*info = [[KZJRequestData requestOnly]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];

        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(60, 100, SCREENWIDTH-120, 100)];
        UIImageView*photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(75, 60, 50, 50)];
        photoImage.image = [UIImage imageWithData:info.photoData];
        photoImage.layer.cornerRadius = 25;
        photoImage.layer.masksToBounds = YES;
        photoImage.layer.shouldRasterize = YES;
//        photoImage.backgroundColor = [UIColor redColor];
        [label addSubview:photoImage];
//        label.backgroundColor = [UIColor whiteColor];
        label.tag = 10002;
        [image addSubview:label];
        
        [UIView beginAnimations:@"translAnimation" context:nil];
        [UIView setAnimationDuration:0.8];
        [UIView setAnimationDelegate:self];//设置代理监视是否结束,不设不会进行方法
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [photoImage setTransform:CGAffineTransformMakeTranslation(0, -50)];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView commitAnimations];
    }
}
-(void)animationDidStop:(NSString *)animationName finished:(NSNumber*)number context:(void *)context
{
    UILabel*label = (UILabel*)[self.window viewWithTag:10002];
    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 70, 60, 30)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"欢迎回来";
    [label addSubview:label1];
}
-(void)action2
{
    UIImageView*image1 = (UIImageView*)[self.window viewWithTag:10000];
    [image1 removeFromSuperview];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Token"]!=nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"启动" forKey:@"标示启动"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[KZJRequestData requestOnly] startRequestData1];
    }
    NSLog(@"%@",NSHomeDirectory());
    
    
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


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    KZJRequestData*requestData = [KZJRequestData requestOnly];
    return [WeiboSDK handleOpenURL:url delegate:requestData];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    KZJRequestData*requestData = [KZJRequestData requestOnly];
    return [WeiboSDK handleOpenURL:url delegate:requestData];
}


@end
