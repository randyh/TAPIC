//
//  TAPICAudioFileGenerator.h
//  TAPIC
//
//  Created by Joshua Ferguson on 2/24/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAPICAudioFileGenerator : NSObject

+ (NSURL*) generateAudioFile:(NSString*)input;
+ (NSString*)getMessageData:(NSURL*)audioInput;

@end
