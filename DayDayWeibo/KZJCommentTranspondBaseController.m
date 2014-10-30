//
//  KZJCommentTranspondBaseController.m
//  DayDayWeibo
//
//  Created by apple on 14-10-29.
//  Copyright (c) 2014年 KZJ. All rights reserved.
//

#import "KZJCommentTranspondBaseController.h"

@interface KZJCommentTranspondBaseController ()

@end

@implementation KZJCommentTranspondBaseController
@synthesize whoLabel,titleLabel,growingTextView,myToolBar,commentTranspondBtn,commentTranspondLabel,commentTranspondImageView,atItem,searchHuaTiItem,moreItem,faceItem,spaceButtonItem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide)
                                                 name:
     UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    
    UIView *titleView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 24)];
    [titleView addSubview:titleLabel];
    
    

    self.whoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 80, 20)];
    self.whoLabel.textAlignment = NSTextAlignmentCenter;
    self.whoLabel.textColor = [UIColor grayColor];
    self.whoLabel.adjustsFontSizeToFitWidth = YES;
    UserInformation*info =[[[KZJRequestData alloc]init]searchEntityName:@"UserInformation" uid:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"]];
    whoLabel.text =info.name;
    
    [titleView addSubview:whoLabel];
    
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelMethod)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendMethod)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    self.growingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    self.growingTextView.delegate = self;
    [self.view addSubview:self.growingTextView];
    
    
  self.myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 30, SCREENWIDTH, 30)];
    [self.view addSubview:self.myToolBar];
    
    [self addToolbarBtn];//给toolbar 添加一些按钮
    
  
    
    
    self.commentTranspondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentTranspondBtn.frame = CGRectMake(10, SCREENHEIGHT-60, 60, 20);
    [self.commentTranspondBtn addTarget:self action:@selector(commentTranspondMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.commentTranspondBtn];
    
   self.commentTranspondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diaglog_recommended_check_highlighted"]];
    self.commentTranspondImageView.frame = CGRectMake(0, 0, 20, 20);
    [self.commentTranspondBtn addSubview:self.commentTranspondImageView];
    
    self.commentTranspondLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 1, 40, 15)];
    self.commentTranspondLabel.adjustsFontSizeToFitWidth = YES;
    [self.commentTranspondBtn addSubview:self.commentTranspondLabel];
}

-(void)addToolbarBtn
{
    //@
    UIButton *atBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    atBtn.frame = CGRectMake(0, 0, 30, 30);
    [atBtn addTarget:self action:@selector(atMethod) forControlEvents:UIControlEventTouchUpInside];
    [atBtn setImage:[UIImage imageNamed:@"compose_mentionbutton_background"] forState:UIControlStateNormal];
    [atBtn setImage:[UIImage imageNamed:@"compose_mentionbutton_background_highlighted"] forState:UIControlStateHighlighted];
    atItem = [[UIBarButtonItem alloc] initWithCustomView:atBtn];
    
    //#
    UIButton *searchHuaTi = [UIButton buttonWithType:UIButtonTypeCustom];
    searchHuaTi.frame = CGRectMake(0, 0, 30, 30);
    [searchHuaTi addTarget:self action:@selector(searchHuaTiMethod) forControlEvents:UIControlEventTouchUpInside];
    [searchHuaTi setImage:[UIImage imageNamed:@"compose_trendbutton_background"] forState:UIControlStateNormal];
    [searchHuaTi setImage:[UIImage imageNamed:@"compose_trendbutton_background_highlighted"] forState:UIControlStateHighlighted];
    searchHuaTiItem = [[UIBarButtonItem alloc] initWithCustomView:searchHuaTi];

    //表情
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.frame = CGRectMake(0, 0, 30, 30);
    [faceBtn addTarget:self action:@selector(faceMethod) forControlEvents:UIControlEventTouchUpInside];
    [faceBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
    [faceBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    faceItem = [[UIBarButtonItem alloc] initWithCustomView:faceBtn];
    
    //更多
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 30, 30);
    [moreBtn addTarget:self action:@selector(moreMethod) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:[UIImage imageNamed:@"message_add_background"] forState:UIControlStateNormal];
    [moreBtn setImage:[UIImage imageNamed:@"message_add_background_highlighted"] forState:UIControlStateHighlighted];
    moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    
    //空白按钮
    
      spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
}
#pragma mark @
-(void)atMethod
{
    
}
#pragma mark #
-(void)searchHuaTiMethod
{
    
}
#pragma mark faceMethod
-(void)faceMethod
{
    
}
#pragma mark moreMethod
-(void)moreMethod
{
    
}
#pragma mark commentTranspondMethod
-(void)commentTranspondMethod
{
    static BOOL isSelected = NO;
    if (isSelected)
    {
       
        self.commentTranspondImageView.image = [UIImage imageNamed:@"diaglog_recommended_check_highlighted"];
        isSelected = NO;
    }
    else
    {
        self.commentTranspondImageView.image = [UIImage imageNamed:@"diaglog_recommended_check"];
        isSelected = YES;
    }
}
-(void)cancelMethod
{
    
    [self.growingTextView resignFirstResponder];
    
}
-(void)sendMethod
{
    [self.growingTextView resignFirstResponder];
}
-(void) keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	//CGRect shareScopeBtnFrame = shareScopeBtn.frame;
    //shareScopeBtnFrame.origin.y =self.view.bounds.size.height -(keyboardBounds.size.height + shareScopeBtnFrame.size.height+toolBar.frame.size.height);
    
    CGRect commentTranspondBtnFrame = self.commentTranspondBtn.frame;
    commentTranspondBtnFrame.origin.y = self.view.bounds.size.height -(keyboardBounds.size.height + commentTranspondBtnFrame.size.height+myToolBar.frame.size.height+6);
    CGRect toolBarFrame = myToolBar.frame;
    toolBarFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + toolBarFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	myToolBar.frame = toolBarFrame;
    commentTranspondBtn.frame= commentTranspondBtnFrame;
    //shareScopeBtn.frame =shareScopeBtnFrame;
	
	// commit animations
	[UIView commitAnimations];

}
-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
   // CGRect shareScopeBtnFrame = shareScopeBtn.frame;
   // shareScopeBtnFrame.origin.y =self.view.bounds.size.height -(shareScopeBtnFrame.size.height+toolBar.frame.size.height);
    
	CGRect toolBarFrame = myToolBar.frame;
    toolBarFrame.origin.y = self.view.bounds.size.height - toolBarFrame.size.height;
	
    CGRect commentTranspondBtnFrame = self.commentTranspondBtn.frame;
    commentTranspondBtnFrame.origin.y = self.view.bounds.size.height -(commentTranspondBtnFrame.size.height +6 +myToolBar.frame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	myToolBar.frame = toolBarFrame;
	commentTranspondBtn.frame = commentTranspondBtnFrame;
    //shareScopeBtn.frame = shareScopeBtnFrame;
	// commit animations
	[UIView commitAnimations];

}
-(void)keyboardDidHide
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.growingTextView becomeFirstResponder];
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
