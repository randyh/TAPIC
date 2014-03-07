//
//  TAPICSOSViewController .m
//  TAPIC
//
//  Created by Randy Harper on 2/9/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICSOSViewController.h"

@interface TAPICSOSViewController ()
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    NSTimer *sosTimer;
    BOOL sosInProgress;
}

@end

@implementation TAPICSOSViewController

@synthesize recordButton, sendButton, intervalValue, intervalStepper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        sosInProgress = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Disable 'Record' and 'Send' button when application launches
    [recordButton setEnabled:NO];
    [sendButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"SOS.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    [recordButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordDown:(id)sender
{
    // Stop the audio player before recording
    if (player.playing)
    {
        [player stop];
    }
    
    if (!recorder.recording)
    {
        // Start recording
        [recorder record];
        
        // Update UI
        //[recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    }
}

- (IBAction)recordReleased:(id)sender
{
    if (recorder.recording)
    {
        // Stop recording
        [recorder stop];
        
        // Update UI
        //[recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [sendButton setEnabled:YES];
    }
}

- (IBAction)recordReleasedOut:(id)sender
{
    [self recordReleased:sender];
}

- (IBAction)sendPressed:(id)sender
{
    if (recorder.recording)
    {
        // Stop recording
        [recorder stop];
    }
    
    if (sosTimer == nil)
    {
        // Create player
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setVolume:1.0];
        [player setDelegate:self];
        
        // Calculate timer period
        NSTimeInterval timerPeriod = [intervalStepper value] + player.duration;
        
        // Send first SOS (timer doesn't start sending until the period has elapsed)
        [self sendSOS];
        
        // Start timer, calls 'sendSOS' every period
        sosTimer = [NSTimer scheduledTimerWithTimeInterval:timerPeriod
                                                    target:self
                                                  selector:@selector(sendSOS)
                                                  userInfo:nil
                                                   repeats:YES];
        
        // Update UI
        [intervalStepper setEnabled:NO];
        [intervalStepper setSelected:NO];
        [sendButton setTitle:@"Stop" forState:UIControlStateNormal];
        [recordButton setEnabled:NO];
    }
    else
    {
        // Stop timer
        [self stopSOS];
        
        // Update UI
        [recordButton setEnabled:YES];
    }
}

- (IBAction)intervalChanged:(UIStepper *)sender
{
    // Update UI
    [intervalValue setText:[NSString stringWithFormat:@"%d seconds", (int)[sender value]]];
}

- (void) sendSOS
{
    // If the player is currently playing, stop it
    if (player.isPlaying)
    {
        [player stop];
    }
    
    [player play];
}

- (void) stopSOS
{
    // If the sos timer is currently active, stop it
    if(sosTimer)
    {
        [sosTimer invalidate];
        sosTimer = nil;
        
        // Update UI
        [intervalStepper setEnabled:YES];
        [intervalStepper setSelected:YES];
        [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    }
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    // Do nothing
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // Do nothing
}

@end
