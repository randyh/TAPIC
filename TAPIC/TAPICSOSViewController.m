//
//  TAPICSOSViewController .m
//  TAPIC
//
//  Created by Randy Harper on 2/9/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICSOSViewController.h"

static int fileCount = 0;

@interface TAPICSOSViewController ()
{
    TAPICTabBarController *tabBarController;
    
    NSTimer *sosTimer;
    NSURL *sosURL;
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
    
    [sendButton setEnabled:NO];
    [recordButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordDown:(id)sender
{
    [tabBarController stopPlaying];
    
    sosURL = [TAPICSOSViewController getNewSOSURL:@"wav"];
    
    [tabBarController startRecording:sosURL fromSpeaker:YES];
}

- (IBAction)recordReleased:(id)sender
{
    [tabBarController finishRecording];
    
    [sendButton setEnabled:YES];
}

- (IBAction)recordReleasedOut:(id)sender
{
    [self recordReleased:sender];
}

- (IBAction)sendPressed:(id)sender
{
    if (sosTimer == nil)
    {
        [tabBarController playAudioFileFromURL:sosURL toSpeaker:NO];
        
        // Calculate timer period
        NSTimeInterval timerPeriod = [intervalStepper value] + [tabBarController getPlayerDuration] + 1;
        
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
    }
}

- (IBAction)intervalChanged:(UIStepper *)sender
{
    // Update UI
    [intervalValue setText:[NSString stringWithFormat:@"%d seconds", (int)[sender value]]];
}

- (void) sendSOS
{
    BOOL success = [tabBarController playAudioFileFromURL:sosURL toSpeaker:NO];
    if (!success) [self stopSOS];
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
        [recordButton setEnabled:YES];
    }
}

+ (NSURL*)getNewSOSURL:(NSString*)extension
{
    NSString *path =[[NSString alloc] initWithFormat:@"TAPICSOSMessage%d.%@",fileCount,extension];
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
