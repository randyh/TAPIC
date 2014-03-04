//
//  TAPICReceivedMessageCell.h
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPICReceivedMessage.h"

@interface TAPICReceivedMessageCell : UITableViewCell

@property (nonatomic, strong) TAPICReceivedMessage *receivedMessage;

- (void)setReceivedMessage:(TAPICReceivedMessage *)receivedMsg;
+(NSString*)getTimestampString:(NSDate*)date;

@end
