//
//  TAPICReceivedMessageCell.m
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICReceivedMessageCell.h"

@implementation TAPICReceivedMessageCell
{
    UILabel *timestamp;
}

@synthesize receivedMessage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        timestamp = [[UILabel alloc] init];
        [timestamp setFont:[UIFont boldSystemFontOfSize:18]];
        [self.contentView addSubview:timestamp];
    }
    return self;
}

- (void)setReceivedMessage:(TAPICReceivedMessage *)receivedMsg
{
    receivedMessage = receivedMsg;
    [timestamp setText:[TAPICReceivedMessageCell getTimestampString:[receivedMsg date]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)getTimestampString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"%d/%m/%Y: %H:%M:%S"];
    return [dateFormatter stringFromDate:date];
}

@end
