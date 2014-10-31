//
//  KZJShareController.m
//  DayDayWeibo
//
//  Created by Ibokan on 14-10-18.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJShareController.h"


@interface KZJShareController ()



@end
NSString *const CollectionViewCellIdentifier = @"Cell";
@implementation KZJShareController
@synthesize collectionView,weiboContentTextView,weiboVisibleScopeValue,weiboVisibleScopeTitle,managedObjectContext,myImage,weiboContent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	}
	
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    managedObjectContext = ((KZJAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    imageArr = [[NSMutableArray alloc] init];
    UIImage *addImage = [UIImage imageNamed:@"compose_pic_add"];
    [imageArr addObject:addImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelMethod)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    
   UIButton  *sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendBtn.frame=CGRectMake(0, 0, 30, 30);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.tintColor = [UIColor orangeColor];
    sendBtn.enabled = NO;
    [sendBtn addTarget:self action:@selector(sendMethod) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    
    
    UIView *titleView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    UILabel *sendWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 24)];
    sendWeiboLabel.text = @"发微博";
    [titleView addSubview:sendWeiboLabel];
    whoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 80, 20)];
    whoLabel.textAlignment = NSTextAlignmentCenter;
    whoLabel.textColor = [UIColor grayColor];
    whoLabel.adjustsFontSizeToFitWidth = YES;
    [titleView addSubview:whoLabel];

    self.navigationItem.titleView = titleView;
    
    
    weiboVisibleScopeTitle = @"对所有人可见";
    
    if (self.myImage)
    {
        [imageArr insertObject:self.myImage atIndex:0];
        [self addPhotoCollectionView];
        self.collectionView.hidden = NO;
    }
}
#pragma mark 插入图片
-(void)insertPic
{
    inputContent = weiboContentTextView.text;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        [self addPhotoCollectionView];
       
        
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage animated:YES completion:^{
            
        }];
        

    });
    
    whoDo = @"相机";
    
}
-(void)addPhotoCollectionView
{
    [self.collectionView removeFromSuperview];
    //添加collectionView放置图片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENHEIGHT-100-30-30) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource  =self;
    self.collectionView.hidden = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    [self.view addSubview:self.collectionView];
}
#pragma mark 打开相机
-(void)openCamera
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    imagePickerSourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            imagePickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = imagePickerSourceType;
    [self presentViewController:picker animated:YES completion:^{
        
    }];//进入照相界面
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)acollectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)acollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    UICollectionViewCell *cell = [acollectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    UIImageView *imageView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cell.contentView addSubview:imageView];
    [imageView setImage:[imageArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)acollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *insertImage =  [imageArr objectAtIndex:indexPath.row];
    
    if (insertImage ==[imageArr lastObject] )
    {
        [self insertPic];
    }
    else
    {
        [imageArr removeObjectAtIndex:indexPath.row];
        itemSelect = @"itemSelect";
        itemIndex = (int)indexPath.row;

        [self insertPic];
        
    }
   
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
    if ([itemSelect  isEqual: @"itemSelect"])
    {
        [self dismissViewControllerAnimated:YES completion:^{
            [imageArr insertObject:image atIndex:itemIndex];
            itemSelect = @"";
            [self.collectionView reloadData];
            self.collectionView.hidden = NO;
            
            if(imageArr.count>1)
            {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }];
    }
    else
    {
        int  index = (int)imageArr.count;
        UIImage *addImage = [UIImage imageNamed:@"compose_pic_add"];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            if(imagePickerSourceType==UIImagePickerControllerSourceTypeCamera)
            {
                [self addPhotoCollectionView];
                
            }
            
            [imageArr replaceObjectAtIndex:index-1 withObject:image];
            
            [imageArr addObject:addImage];
            [self.collectionView reloadData];
            self.collectionView.hidden = NO;
            
            if(imageArr.count>1)
            {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
           
            
            
        }];
        
    }
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [weiboContentTextView becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UserInformation*info =[[[KZJRequestData alloc]init]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    whoLabel.text =info.name;

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [toolBar removeFromSuperview];
    [weiboContentTextView removeFromSuperview];
    [shareScopeBtn removeFromSuperview];
    [locationBtn removeFromSuperview];
    
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 30, SCREENWIDTH, 30)];
        
        weiboContentTextView  = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 30)];

        weiboContentTextView.isScrollable = NO;
        weiboContentTextView.minNumberOfLines = 1;
        weiboContentTextView.maxNumberOfLines = 5;
        weiboContentTextView.font = [UIFont systemFontOfSize:12];
        weiboContentTextView.textColor = [UIColor orangeColor];
    
        weiboContentTextView.delegate  =self;
        weiboContentTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        weiboContentTextView.placeholder = @" 分享身边新鲜事";
    if (weiboContent.length >0)
    {
         weiboContentTextView.text = weiboContent;
    }
   
    
        [self.view addSubview:weiboContentTextView];
        
        [self.view addSubview:toolBar];
    
        
        //位置Button
   locationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    locationBtn.frame =CGRectMake(10, SCREENHEIGHT-60, 155, 25);
    [locationBtn addTarget:self action:@selector(insertLocation) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_icon_locate@2x"]];
    locationImageView.tag = 102;
    locationImageView.frame = CGRectMake(0, 0, 20, 25);
    [locationBtn addSubview:locationImageView];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 135, 25)];
    locationLabel.tag = 101;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"myLocation"])
    {
        locationLabel.text =[userDefaults stringForKey:@"myLocation"];
        locationLabel.textColor = [UIColor blueColor];
    }else
    {
        locationLabel.text =@"插入位置";
        locationLabel.textColor = [UIColor grayColor];
    }
    
    
    locationLabel.font = [UIFont systemFontOfSize:12];
    [locationBtn addSubview:locationLabel];
    [self.view addSubview:locationBtn];
    
    shareScopeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareScopeBtn.frame = CGRectMake(SCREENWIDTH-90, SCREENHEIGHT-60, 90, 25);
    [shareScopeBtn addTarget:self action:@selector(shareScopeMethod) forControlEvents:UIControlEventTouchUpInside];
    UILabel *scopeLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 2, 70, 21)];
    scopeLabel.text = weiboVisibleScopeTitle;
    scopeLabel.font = [UIFont systemFontOfSize:10];
    scopeLabel.textColor= [UIColor blueColor];
    scopeLabel.tag = 103;
    [shareScopeBtn addSubview:scopeLabel];
    UIImageView *scopeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 20, 21)];
    UIImage *image;
    if (weiboVisibleScopeValue==0)
    {
        image =[UIImage imageNamed:@"compose_publicbutton_background@2x"];
    }
    else if (weiboVisibleScopeValue ==1)
    {
       image =[UIImage imageNamed:@"无"];
    }
    else if (weiboVisibleScopeValue ==2)
    {
        
        image =[UIImage imageNamed:@"friendcircle_compose_friendcirclebutton@2x"];
        scopeLabel.text = @"对好友圈可见";
        scopeLabel.textColor = [UIColor redColor];
    }
    scopeImageView.image = image;
    scopeImageView.tag =104;
    [shareScopeBtn addSubview:scopeImageView];
    
    
    [self.view addSubview:shareScopeBtn];
    
        //插入图片
        UIButton *btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, 30, 30);
        [btn1 setImage:[UIImage imageNamed:@"compose_toolbar_picture"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"compose_toolbar_picture_highlighted"] forState:UIControlStateHighlighted];
        [btn1 addTarget:self action:@selector(insertPic) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
        //@谁
        UIButton *btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(0, 0, 30, 30);
        [btn2 setImage:[UIImage imageNamed:@"compose_mentionbutton_background"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] forState:UIControlStateHighlighted];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        
        //#
        UIButton *btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(0, 0, 30, 30);
        [btn3 setImage:[UIImage imageNamed:@"compose_trendbutton_background"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"compose_trendbutton_background_highlighted"] forState:UIControlStateHighlighted];
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:btn3];
        
        //表情
        UIButton *btn4 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(0, 0, 30, 30);
        [btn4 setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
        UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithCustomView:btn4];
        //+
        UIButton *btn5 =[UIButton buttonWithType:UIButtonTypeCustom];
        btn5.frame = CGRectMake(0, 0, 30, 30);
        [btn5 setImage:[UIImage imageNamed:@"message_add_background"] forState:UIControlStateNormal];
        [btn5 setImage:[UIImage imageNamed:@"message_add_background_highlighted"] forState:UIControlStateHighlighted];
        UIBarButtonItem *item5 = [[UIBarButtonItem alloc] initWithCustomView:btn5];
        
    
        
        
        UIBarButtonItem *item7 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyboard)];
        toolBar.items = @[item1,item2,item3,item4,item5,item7];
    
    if (weiboContent.length>0)
    {
        inputContent= weiboContent;
         weiboContentTextView.text = inputContent;
    }
    else
    {
         weiboContentTextView.text = inputContent;
    }
  
    [weiboContentTextView becomeFirstResponder];
    
   
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"zljImageScopeArr"];
    [weiboContentTextView resignFirstResponder];
}
#pragma mark 插入位置method
-(void)insertLocation
{
   
    KZJCheckInTableViewController *checkInTableView = [[KZJCheckInTableViewController alloc] init];
    checkInTableView.myNavigationController = self.navigationController;
    [self.navigationController pushViewController:checkInTableView animated:YES];
}
#pragma mark 分享范围 method
-(void)shareScopeMethod
{
    inputContent = weiboContentTextView.text;
   
    KZJShareScopeTableController *shareScopeVC = [[KZJShareScopeTableController alloc] initWithStyle:UITableViewStylePlain];
    shareScopeVC.scopeVisibleBlock = ^(NSString *str,int scopeValue)
    {
        weiboVisibleScopeTitle = str;
        weiboVisibleScopeValue = scopeValue;
    };
    [self.navigationController pushViewController:shareScopeVC animated:YES];
}
-(void)resignKeyboard
{
    [weiboContentTextView resignFirstResponder];
}
#pragma mark HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    
    CGRect frame =  self.collectionView.frame;
    if (height==31)
    {
         frame.origin.y =100;
        
    }else
    {
        
        if ([whoDo  isEqual: @"相机"])
        {
            frame.origin.y +=height-31;
            whoDo = @"";
        }
        else
        {
            frame.origin.y  = height+64+6;
        }
    }
   
    self.collectionView.frame = frame;
    
    
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    
    return YES;
}
 -(void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    
  
    if (weiboContentTextView.hasText||imageArr.count>1)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    }
}

#pragma mark 键盘show或hide的通知
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect shareScopeBtnFrame = shareScopeBtn.frame;
    shareScopeBtnFrame.origin.y =self.view.bounds.size.height -(keyboardBounds.size.height + shareScopeBtnFrame.size.height+toolBar.frame.size.height);
    
    CGRect locationBtnFrame = locationBtn.frame;
    locationBtnFrame.origin.y = self.view.bounds.size.height -(keyboardBounds.size.height + locationBtnFrame.size.height+toolBar.frame.size.height);
    CGRect toolBarFrame = toolBar.frame;
    toolBarFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + toolBarFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	toolBar.frame = toolBarFrame;
    locationBtn.frame= locationBtnFrame;
    shareScopeBtn.frame =shareScopeBtnFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
    CGRect shareScopeBtnFrame = shareScopeBtn.frame;
    shareScopeBtnFrame.origin.y =self.view.bounds.size.height -(shareScopeBtnFrame.size.height+toolBar.frame.size.height);
    
	CGRect toolBarFrame = toolBar.frame;
    toolBarFrame.origin.y = self.view.bounds.size.height - toolBarFrame.size.height;
	
    CGRect locationBtnFrame = locationBtn.frame;
    locationBtnFrame.origin.y = self.view.bounds.size.height -(locationBtnFrame.size.height+toolBar.frame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	toolBar.frame = toolBarFrame;
	locationBtn.frame = locationBtnFrame;
    shareScopeBtn.frame = shareScopeBtnFrame;
	// commit animations
	[UIView commitAnimations];
}
#pragma mark 取消方法
-(void)cancelMethod
{
    
    if(imageArr.count >1 || [weiboContentTextView hasText])
    {
        UIAlertView *isSaveAlert = [[UIAlertView alloc] initWithTitle:nil message:@"是否保存草稿" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        [isSaveAlert show];
    }
   else
   {
       [self dismissViewControllerAnimated:YES completion:^{
           
       }];
   }
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if(buttonIndex ==1)
    {
#warning 保存到草稿箱
        
        dispatch_async(dispatch_get_main_queue(), ^{
            StoreWeibo *storeWeibo = [NSEntityDescription insertNewObjectForEntityForName:@"StoreWeibo"
                                                                   inManagedObjectContext:managedObjectContext];
            storeWeibo.textContent = weiboContentTextView.text;
            storeWeibo.identifierName = @"微博";
            if ([imageArr count]>1)
            {
                storeWeibo.image = UIImagePNGRepresentation([imageArr objectAtIndex:0]);
            }
            
            NSError *error;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            
//            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//            NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoreWeibo"
//                                                      inManagedObjectContext:managedObjectContext];
//            [fetchRequest setEntity:entity];
//            
//            NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
//            for (StoreWeibo *weibo in fetchedObjects)
//            {
//                NSLog(@"content: %@", weibo.textContent);
//                NSLog(@"image: %@",weibo.image);
//            }

        });
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}
#pragma mark 发送方法
-(void)sendMethod
{
    KZJRequestData *request = [KZJRequestData  requestOnly];
   
    [request zljSendWeibo:self.weiboContentTextView.text picArr:imageArr visible:weiboVisibleScopeValue];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
