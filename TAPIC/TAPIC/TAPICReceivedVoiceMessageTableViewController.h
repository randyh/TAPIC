//
//  TAPICReceivedVoiceMessageTableViewController.h
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPICReceivedMessage.h"
#import "TAPICReceivedMessageCell.h"

#define CACHED_VOICE_MSG_MAX 10

@interface TAPICReceivedVoiceMessageTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *receivedMessagesTable;
@property (nonatomic, strong) NSMutableArray *receivedMessages;

- (void)addMessageToRecievedList:(NSURL*)url date:(NSDate*)date;

@end
