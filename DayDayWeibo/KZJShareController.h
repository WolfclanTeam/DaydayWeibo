//
//  KZJShareController.h
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"UserInformation.h"

#import "HPGrowingTextView.h"
#import "KZJShareScopeTableController.h"
#import "KZJCheckInTableViewController.h"

#import "KZJAppDelegate.h"
#import "StoreWeibo.h"
@interface KZJShareController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,HPGrowingTextViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UIAlertViewDelegate>

{
    UILabel *whoLabel;
    
    UIToolbar *toolBar;
    HPGrowingTextView *weiboContentTextView;
    NSMutableArray *imageArr;
    NSString *inputContent;
    NSString *whoDo;
    int itemIndex ;
    NSString *itemSelect;
    UIImagePickerControllerSourceType imagePickerSourceType;
    
    UIButton *locationBtn;
    UIButton *shareScopeBtn;
    
    int  weiboVisibleScopeValue;
    NSString *weiboVisibleScopeTitle;
    
    
}
@property(retain,nonatomic)UICollectionView *collectionView;
@property(retain,nonatomic)HPGrowingTextView *weiboContentTextView;
@property(assign,nonatomic)int weiboVisibleScopeValue;
@property(copy,nonatomic)NSString *weiboVisibleScopeTitle;
@property(strong,nonatomic) NSManagedObjectContext* managedObjectContext;
-(void)insertPic;
-(void)openCamera;
@end
