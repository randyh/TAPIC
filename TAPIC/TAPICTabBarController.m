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

#define CHANNEL_TO_LISTEN 0

static BOOL isOverridden;

@interface TAPICTabBarController ()
{
    TAPICReceivedVoiceMessageTableViewController *receivedMessageManager;
    TAPICVoiceViewController *voiceMessageManager;
    TAPICTextMessageViewController *textMessageManager;

    NSDictionary *listenerSettings;
    NSDictionary *recorderSettings;
}
@end

@implementation TAPICTabBarController

@synthesize player, recorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    receivedMessageManager =
    (TAPICReceivedVoiceMessageTableViewController*)[self getViewController:RECEIVED_TAB_INDEX];
    
    voiceMessageManager =
    (TAPICVoiceViewController*)[self getViewController:VOICE_TAB_INDEX];
    [voiceMessageManager setRootView:self];
    
    textMessageManager =
    (TAPICTextMessageViewController*)[self getViewController:TEXT_TAB_INDEX];
    [textMessageManager setRootView:self];
    
    // Define the recorder setting
    recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:kAudioFormatLinearPCM],     AVFormatIDKey,
                        [NSNumber numberWithFloat:44100.0],                 AVSampleRateKey,
                        [NSNumber numberWithInt: 1],                        AVNumberOfChannelsKey,
                        nil];
    
    listenerSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat: 32000.0],                 AVSampleRateKey,
                        [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                        [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                        [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                        nil];
    NSError *error;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    BOOL success = [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (!success)
    {
        NSLog(@"Error starting audio session: %@", error.description);
        return;
    }
    
    isOverridden = NO;
    
    [TAPICTabBarController activateAudioSession];
    
    [self startListening];
}

- (void)startListening
{
    NSError *error;
    listener = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"/dev/null"] settings:listenerSettings error:&error];
    
    if (listener)
    {
        [listener prepareToRecord];
        listener.meteringEnabled = YES;
        [listener record];
        
        listenTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target:self selector:@selector(checkForInput:) userInfo:nil repeats:YES];
    }
    else
    {
        NSLog(@"Error starting listener: %@", error.description);
        return;
    }
}

- (void)stopListening
{
    [listenTimer invalidate];
}

- (void)checkForInput:(NSTimer *)timer
{
    if (!isOverridden)
    {
        [listener updateMeters];
        
        float peakPower = [listener peakPowerForChannel:CHANNEL_TO_LISTEN];
        peakPower = (int)(peakPower*1000)/1000;
        if (peakPower == 0)
        {
            NSLog(@"Peak input: %f", peakPower);
            
            [self stopListening];
            
            // Respond to hardware
            
            [self receiveMessage];
            
            [self startListening];
        }
    }
}

- (void)receiveMessage
{
    NSLog(@"Message Received");
    NSURL *url = [receivedMessageManager getNewMessageURL:@"wav"];
    recorder = [self prepareRecorder:url];
    [receivedMessageManager addMessageToRecievedList:url date:[NSDate date]];
    
    [recorder record];
    
    //interpret
    [TAPICAudioFileGenerator getMessageData:[recorder url]];
}

- (AVAudioRecorder*)prepareRecorder:(NSURL*)outputFileURL
{
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recorderSettings error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    return recorder;
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
        isOverridden = YES;
    }
    else
    {
        success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone
                                             error:&error];
        isOverridden = NO;
    }
    
    if (!success)  NSLog(@"Unable to override output device: %@",error);
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    // Do nothing
}

- (void) playAudioFileFromURL:(NSURL*)url
{
    if (player == nil || !player.isPlaying )
    {
        NSLog(@"Trying to play...");
        NSError* error;
        [TAPICTabBarController activateAudioSession];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [player setVolume:1.0];
        [player setDelegate:self];
        BOOL success = [player play];
        if (!success)  NSLog(@"Unable to play: %@",error);
        if (success)
            NSLog(@"Successful!");
        else
            NSLog(@"Not Successful..");
    }
}

@end
