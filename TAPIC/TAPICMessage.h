//
//  TAPICMessage.h
//  TAPIC
//
//  Created by Randy Harper on 3/1/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAPICMessage : NSObject

@property (nonatomic, strong) NSMutableAttributedString *text;
@property (nonatomic, assign) BOOL isSent;

- (id)init:(NSString*)textString isSent:(BOOL)sent;
- (NSMutableAttributedString*)getText;
- (BOOL)isSent;
@end
