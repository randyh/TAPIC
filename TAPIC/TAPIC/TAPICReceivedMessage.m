//
//  TAPICReceivedMessage.m
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICReceivedMessage.h"

@implementation TAPICReceivedMessage

@synthesize date, url;

- (id)init:(NSURL*)messageURL date:(NSDate*)messageDate
{
    self = [super init];
    if (self)
    {
        date = messageDate;
        url = messageURL;
    }
    return self;
}
@end
