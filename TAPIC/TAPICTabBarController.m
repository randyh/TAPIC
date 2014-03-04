//
//  TAPICTabBarController.m
//  TAPIC
//
//  Created by Randy Harper on 2/26/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICTabBarController.h"
#import "TAPICReceivedVoiceMessageTableViewController.h"

#define CHANNEL_TO_LISTEN 0

static BOOL isOverridden;

@interface TAPICTabBarController ()
{
    NSDictionary *listenerSettings;
}
@end

@implementation TAPICTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    listenerSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
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
    
    NSLog(@"View loaded");
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
    // record
    
    NSLog(@"Message Received");
    TAPICReceivedVoiceMessageTableViewController* tableViewController =
    (TAPICReceivedVoiceMessageTableViewController*)[self getViewController:RECEIVED_TAB_INDEX];
    NSURL* url = [NSURL fileURLWithPath:@"/dev/null"];
    [tableViewController addMessageToRecievedList:url date:[NSDate date]];
    // interpret
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

@end
