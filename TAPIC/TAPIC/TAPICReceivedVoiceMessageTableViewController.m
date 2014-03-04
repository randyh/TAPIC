//
//  TAPICReceivedVoiceMessageTableViewController.m
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICReceivedVoiceMessageTableViewController.h"

@interface TAPICReceivedVoiceMessageTableViewController ()

@end

@implementation TAPICReceivedVoiceMessageTableViewController

@synthesize receivedMessages, receivedMessagesTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)loadView
{
    receivedMessages = [[NSMutableArray alloc] init];
    receivedMessagesTable.delegate = self;
    receivedMessagesTable.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    NSLog(@"Loading message...");
    static NSString *CellIdentifier = @"ReceievedMessageCell";
    TAPICReceivedMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[TAPICReceivedMessageCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    [cell setReceivedMessage:[receivedMessages objectAtIndex:indexPath.row]];
    NSLog(@"Message loaded.");
    return cell;
}

- (void)addMessageToRecievedList:(NSURL*)url date:(NSDate*)date
{
    if ([receivedMessages count] >= CACHED_VOICE_MSG_MAX)
        [receivedMessages removeObjectAtIndex:0];
    [receivedMessages addObject:[[TAPICReceivedMessage alloc] init:url date:date]];
    NSLog(@"Message Added number %d", [receivedMessages count]);
    [receivedMessagesTable reloadData];
}

@end
