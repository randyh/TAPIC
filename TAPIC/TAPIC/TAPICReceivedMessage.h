//
//  TAPICReceivedMessage.h
//  TAPIC
//
//  Created by Randy Harper on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAPICReceivedMessage : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSDate *date;

- (id)init:(NSURL*)messageURL date:(NSDate*)messageDate;

@end
