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
        [self setBackgroundColor:[UIColor clearColor]];
        timestamp = [[UILabel alloc] init];
        [timestamp setFont:[UIFont boldSystemFontOfSize:18]];
        CGRect cellFrame = [self frame];
        [timestamp setFrame:CGRectMake(5, 0, cellFrame.size.width, cellFrame.size.height)];
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
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateFormat:@"MMM dd, YYYY: HH:mm:ss a"];
    return [dateFormatter stringFromDate:date];
}

@end
