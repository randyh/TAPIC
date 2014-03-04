//
//  TAPICVoiceViewController.m
//  TAPIC
//
//  Created by Randy Harper on 2/9/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICVoiceViewController.h"
#import "TAPICTabBarController.h"

@interface TAPICVoiceViewController ()
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation TAPICVoiceViewController

@synthesize pushToTalkButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disable 'Push to Talk' button when application launches
    [pushToTalkButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"Voice.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    [pushToTalkButton setEnabled:NO];
}

- (IBAction)pushToTalkDown:(id)sender
{
    // Stop the audio player before recording
    if (player.playing)
    {
        [player stop];
    }
    
    if (!recorder.recording)
    {
        [TAPICTabBarController configureOutputOverride:YES];
        
        [recorder record];
    }
}

- (IBAction)pushToTalkReleased:(id)sender
{
    if (recorder.recording)
    {
        [recorder stop];
        
        [TAPICTabBarController configureOutputOverride:NO];
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (IBAction)pushToTalkReleasedOut:(id)sender
{
    [self pushToTalkReleased:sender];
}

@end