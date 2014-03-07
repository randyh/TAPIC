//
//  TAPICReceivedVoiceMessageTableViewController.m
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICReceivedVoiceMessageTableViewController.h"

@interface TAPICReceivedVoiceMessageTableViewController ()
{
    int messageCount;
}

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
    [super loadView];
    
    messageCount = 0;
    
    receivedMessages = [[NSMutableArray alloc] init];
    receivedMessagesTable.delegate = self;
    receivedMessagesTable.dataSource = self;
    
    [receivedMessagesTable setContentSize:CGSizeMake(self.tableView.frame.size.width, self.tableView.frame.size.height)];
    [receivedMessagesTable setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [receivedMessagesTable setSeparatorInset:UIEdgeInsetsZero];
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
    static NSString *cellIdentifier = @"ReceivedMessageCell";
    TAPICReceivedMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[TAPICReceivedMessageCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
    }
    [cell setReceivedMessage:[receivedMessages objectAtIndex:indexPath.row]];
    return cell;
}

- (void)addMessageToRecievedList:(NSURL*)url date:(NSDate*)date
{
    if ([receivedMessages count] >= CACHED_VOICE_MSG_MAX)
        [receivedMessages removeObjectAtIndex:0];
    [receivedMessages addObject:[[TAPICReceivedMessage alloc] init:url date:date]];
    [receivedMessagesTable reloadData];
    messageCount++;
}

- (NSURL*)getNewMessageURL:(NSString*)extension
{
    NSString *path =[[NSString alloc] initWithFormat:@"TAPICReceivedMessage%d.%@",messageCount,extension];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               path,
                               nil];
    return [NSURL fileURLWithPathComponents:pathComponents];
}

@end
