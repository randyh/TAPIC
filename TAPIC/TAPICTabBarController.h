//
//  TAPICTabBarController.h
//  TAPIC
//
//  Created by Randy Harper on 2/26/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#define VOICE_TAB_INDEX 0
#define SOS_TAB_INDEX 1
#define TEXT_TAB_INDEX 2
#define RECEIVED_TAB_INDEX 3

@interface TAPICTabBarController : UITabBarController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *listener;
    NSTimer *listenTimer;
}

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *recorder;

+ (void)activateAudioSession;
+ (void)configureOutputOverride:(BOOL)toSpeaker;
- (void) playAudioFileFromURL:(NSURL*)url;

@end
