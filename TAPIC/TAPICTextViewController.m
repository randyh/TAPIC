//
//  TAPICTextViewController.m
//  TAPIC
//
//  Created by Randy Harper on 2/16/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICTextViewController.h"
#import "TAPICTabBarController.h"

@interface TAPICTextViewController ()

@end

@implementation TAPICTextViewController

@synthesize textField, sendButton, messageView, textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardDidShow:(NSNotification*)aNotification
{
    NSLog(@"Entered");
    NSDictionary* info = [aNotification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    CGRect textViewFrame = [textView frame];
    textViewFrame.origin.y -= (kbHeight + 150);
    [messageView setFrame:textViewFrame];
    
//    CGRect messageViewFrame = [messageView frame];
//    messageViewFrame.size.height = 50;//(kbHeight + textViewFrame.size.height);
//    [messageView setFrame:messageViewFrame];
    
    CGRect bounds = [messageView bounds];
    [messageView setBounds:CGRectMake(bounds.origin.x,
                                    bounds.origin.y,
                                    bounds.size.width,
                                    50)];
}

//- (void)keyboardDidShow:(NSNotification *)note {
//    NSDictionary *userInfo = note.userInfo;
//    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    
//    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
//    
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
//        self.messagingView.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
//    } completion:nil];
//}
//

- (void)keyboardWillBeHidden:(NSNotification *)note {
//    NSDictionary *userInfo = note.userInfo;
//    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    
//    CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
//    
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
//        self.messagingView.frame = CGRectMake(0, 0, keyboardFrameEnd.size.width, keyboardFrameEnd.origin.y);
//    } completion:nil];
}

@end
