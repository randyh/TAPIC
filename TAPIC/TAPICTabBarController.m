//
//  TAPICTabBarController.m
//  TAPIC
//
//  Created by Randy Harper on 2/26/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICTabBarController.h"
#import "TAPICReceivedVoiceMessageTableViewController.h"
#import "TAPICTextMessageViewController.h"
#import "TAPICVoiceViewController.h"
#import "TAPICAudioFileGenerator.h"
#import "TAPICSOSViewController.h"

#define RECEIVE_MESSAGE_LENGTH_SEC 30

@interface TAPICTabBarController ()
{
    TAPICReceivedVoiceMessageTableViewController *receivedMessageManager;
    TAPICVoiceViewController *voiceMessageManager;
    TAPICTextMessageViewController *textMessageManager;
    TAPICSOSViewController *sosMessageManager;
    
    NSDictionary *recorderSettings;
    int receiveTimerCount;
}
@end

@implementation TAPICTabBarController

@synthesize player, recorder, receiveTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    voiceMessageManager =
    (TAPICVoiceViewController*)[self getViewController:VOICE_TAB_INDEX];
    [voiceMessageManager setRootView:self];
    
    sosMessageManager =
    (TAPICSOSViewController*)[self getViewController:SOS_TAB_INDEX];
    [sosMessageManager setRootView:self];
    
    textMessageManager =
    (TAPICTextMessageViewController*)[self getViewController:TEXT_TAB_INDEX];
    [textMessageManager setRootView:self];
    
    receivedMessageManager =
    (TAPICReceivedVoiceMessageTableViewController*)[self getViewController:RECEIVED_TAB_INDEX];
    [receivedMessageManager setRootView:self];
    
    // Define the recorder setting
    recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:kAudioFormatLinearPCM],     AVFormatIDKey,
                        [NSNumber numberWithFloat:44100.0],                 AVSampleRateKey,
                        [NSNumber numberWithInt: 1],                        AVNumberOfChannelsKey,
                        nil];
    
    NSError *error;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    BOOL success = [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (!success)
    {
        NSLog(@"Error starting audio session: %@", error.description);
        return;
    }
    
    [TAPICTabBarController activateAudioSession];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"View did appear");
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl &&
        receivedEvent.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
    {
        if ([receiveTimer isValid])
        {
            [self finishReceivingMessage];
        }
        else
        {
            [self receiveMessage];
        }
        
    }
}

- (void)receiveMessage
{
    NSLog(@"Message Received");
    receiveTimerCount = 0;
    NSURL *url = [TAPICReceivedVoiceMessageTableViewController getNewMessageURL:@"wav"];
    [self startRecording:url fromSpeaker:NO];
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(checkIfRecievedMessageComplete) userInfo:nil repeats:YES];
}

- (void)checkIfRecievedMessageComplete
{
    if (receiveTimerCount == RECEIVE_MESSAGE_LENGTH_SEC)
    {
        [self finishReceivingMessage];
    }
    else
    {
        receiveTimerCount++;
    }
}

- (void)finishReceivingMessage
{
    NSLog(@"Finishing");
    if ([receiveTimer isValid])
    {
        [receiveTimer invalidate];
        [self finishRecording];
        NSURL *messageURL = [recorder url];
        NSString *message = [TAPICAudioFileGenerator getMessageData:messageURL];
        if (message == nil)
        {
            NSLog(@"Message does not contain text");
            [self playAudioFileFromURL:messageURL toSpeaker:YES];
            [receivedMessageManager addMessageToRecievedList:messageURL date:[NSDate date]];
        }
        else
        {
            [textMessageManager addMessageToTable:message isSent:NO];
        }
    }
}

- (void)finishRecording
{
    if ([recorder isRecording])
    {
        [recorder stop];
    }
}

- (void)startRecording:(NSURL*)outputFileURL fromSpeaker:(BOOL)speaker
{
    [self finishRecording];
    
    if (player.isPlaying)
        [self stopPlaying];
    
    // Initiate and prepare the recorder
    [TAPICTabBarController configureOutputOverride:speaker];
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recorderSettings error:NULL];
    recorder.delegate = self;
    [recorder prepareToRecord];
    [recorder record];
}

- (UIViewController*)getViewController:(int)index
{
    return [self.viewControllers objectAtIndex:index];
}

+ (void)activateAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error;
    
    if (![session setActive:YES error:&error])
    {
        NSLog(@"Unable to activate the audio session: %@", error.description);
        return;
    }
}

+ (void)configureOutputOverride:(BOOL)toSpeaker
{
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    BOOL success;
    NSError* error;
    
    //set the audioSession override
    if (toSpeaker)
    {
        success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                             error:&error];
    }
    else
    {
        success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone
                                             error:&error];
    }
    
    if (!success)  NSLog(@"Unable to override output device: %@",error);
}

- (BOOL) playAudioFileFromURL:(NSURL*)url toSpeaker:(BOOL)speaker
{
    if ((player == nil || !player.isPlaying ) && !recorder.isRecording)
    {
        [TAPICTabBarController configureOutputOverride:speaker];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [player setVolume:1.0];
        [player setDelegate:self];
        return [player play];
    }
    else
    {
        return NO;
    }
}

- (NSTimeInterval)getPlayerDuration
{
    return [player duration];
}

- (void)stopPlaying
{
    if ([player isPlaying])
    {
        [player stop];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
