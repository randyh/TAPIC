//
//  TAPICReceivedVoiceMessageTableViewController.m
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICReceivedVoiceMessageTableViewController.h"

static int messageCount = 0;

@interface TAPICReceivedVoiceMessageTableViewController ()
{
    TAPICTabBarController *tabBarController;
}

@end

@implementation TAPICReceivedVoiceMessageTableViewController

@synthesize receivedMessages, receivedMessagesTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)loadView
{
    [super loadView];
    
    receivedMessages = [[NSMutableArray alloc] init];
    receivedMessagesTable.delegate = self;
    receivedMessagesTable.dataSource = self;
    
    [receivedMessagesTable setContentSize:CGSizeMake(receivedMessagesTable.frame.size.width, receivedMessagesTable.frame.size.height)];
    [receivedMessagesTable setContentInset:UIEdgeInsetsZero];
    [receivedMessagesTable setSeparatorInset:UIEdgeInsetsZero];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TAPICReceivedMessage *messageToPlay = [receivedMessages objectAtIndex:indexPath.row];
    [tabBarController playAudioFileFromURL:[messageToPlay url] toSpeaker:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:[tabBarController getPlayerDuration]
                                     target:self
                                   selector:@selector(deselectRow:)
                                   userInfo:indexPath
                                    repeats:NO];
}

- (void)deselectRow:(NSTimer*)timer
{
    [receivedMessagesTable deselectRowAtIndexPath:[timer userInfo] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [receivedMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReceivedMessageCell";
    TAPICReceivedMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[TAPICReceivedMessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellIdentifier];
    }
    [cell setReceivedMessage:[receivedMessages objectAtIndex:indexPath.row]];
    return cell;
}

- (void)addMessageToRecievedList:(NSURL*)url date:(NSDate*)date
{
    if ([receivedMessages count] >= CACHED_VOICE_MSG_MAX)
    {
        NSURL *urlToDelete = [[receivedMessages objectAtIndex:0] url];
        [receivedMessages removeObjectAtIndex:0];
        [[NSFileManager defaultManager] removeItemAtURL:urlToDelete error:nil];
    }
    [receivedMessages addObject:[[TAPICReceivedMessage alloc] init:url date:date]];
    [receivedMessagesTable reloadData];
    messageCount++;
}

+ (NSURL*)getNewMessageURL:(NSString*)extension
{
    NSString *path =[[NSString alloc] initWithFormat:@"TAPICReceivedMessage%d.%@",messageCount,extension];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               path,
                               nil];
    return [NSURL fileURLWithPathComponents:pathComponents];
}

- (void)setRootView:(TAPICTabBarController*)tabBarControl
{
    tabBarController = tabBarControl;
}

@end
