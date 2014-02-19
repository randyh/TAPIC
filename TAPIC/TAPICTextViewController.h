//
//  TAPICTextViewController.h
//  TAPIC
//
//  Created by Randy Harper on 2/16/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAPICTextViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIView *textView;
@property (strong, nonatomic) IBOutlet UIView *messageView;

@end
