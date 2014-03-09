//
//  TAPICTextCorrection.h
//  TAPIC
//
//  Created by Joshua Ferguson on 3/8/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextChecker.h>

@interface TAPICTextCorrection : NSObject

+ (NSString*)correctReceivedText:(NSString*)data;

@end
