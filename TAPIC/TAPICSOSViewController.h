//
//  TAPICSOSViewController .h
//  TAPIC
//
//  Created by Randy Harper on 2/9/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPICTabBarController.h"

@interface TAPICSOSViewController  : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UILabel *intervalValue;
@property (strong, nonatomic) IBOutlet UIStepper *intervalStepper;

- (IBAction)recordReleased:(id)sender;
- (IBAction)recordReleasedOut:(id)sender;
- (IBAction)recordDown:(id)sender;
- (IBAction)sendPressed:(id)sender;
- (IBAction)intervalChanged:(UIStepper *)sender;
- (void)setRootView:(TAPICTabBarController*)tabBarControl;

@end
