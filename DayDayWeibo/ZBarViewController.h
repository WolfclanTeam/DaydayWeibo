//
//  ZBarViewController.h
//  QR code
//
//  Created by Ibokan on 14/10/30.
//  Copyright (c) 2014年 斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"


@interface ZBarViewController : UIViewController<ZBarReaderDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UILabel *label;

@property (retain, nonatomic) IBOutlet UIImageView *imageview;

- (IBAction)button:(id)sender;

@end
