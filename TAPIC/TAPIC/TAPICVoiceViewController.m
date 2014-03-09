//
//  TAPICVoiceViewController.m
//  TAPIC
//
//  Created by Randy Harper on 2/9/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICVoiceViewController.h"

static int fileCount = 0;

@interface TAPICVoiceViewController ()
{
    TAPICTabBarController *tabBarController;
    NSURL* voiceURL;
}

@end

@implementation TAPICVoiceViewController

@synthesize pushToTalkButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)pushToTalkDown:(id)sender
{
    voiceURL = [TAPICVoiceViewController getNewVoiceURL:@"wav"];
    [tabBarController startRecording:voiceURL fromSpeaker:YES];
}

- (IBAction)pushToTalkReleased:(id)sender
{
    [tabBarController finishRecording];
    [tabBarController playAudioFileFromURL:voiceURL toSpeaker:NO];
    voiceURL = nil;
}

- (IBAction)pushToTalkReleasedOut:(id)sender
{
    [self pushToTalkReleased:sender];
}

+ (NSURL*)getNewVoiceURL:(NSString*)extension
{
    NSString *path =[[NSString alloc] initWithFormat:@"TAPICVoiceMessage%d.%@",fileCount,extension];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               path,
                               nil];
    fileCount++;
    return [NSURL fileURLWithPathComponents:pathComponents];
}

- (void)setRootView:(TAPICTabBarController*)tabBarControl
{
    tabBarController = tabBarControl;
}

@end