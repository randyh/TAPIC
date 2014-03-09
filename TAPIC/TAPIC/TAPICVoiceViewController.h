//
//  TAPICVoiceViewController.h
//  TAPIC
//
//  Created by Randy Harper on 2/9/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPICTabBarController.h"

@interface TAPICVoiceViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pushToTalkButton;

- (IBAction)pushToTalkReleased:(id)sender;
- (IBAction)pushToTalkReleasedOut:(id)sender;
- (IBAction)pushToTalkDown:(id)sender;
- (void)setRootView:(TAPICTabBarController*)tabBarControl;

@end
