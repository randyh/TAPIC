//
//  TAPICMessage.m
//  TAPIC
//
//  Created by Randy Harper on 3/1/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICMessage.h"

@implementation TAPICMessage

@synthesize text, isSent;

- (id)init:(NSString*)textString isSent:(BOOL)sent
{
    self = [super init];
    if (self)
    {
        text = [[NSMutableAttributedString alloc] initWithString:textString];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, textString.length)];
        isSent = sent;
    }
    return self;
}

- (NSMutableAttributedString*)getText
{
    return text;
}

- (BOOL)isSent
{
    return isSent;
}
@end
