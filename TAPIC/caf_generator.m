//
//  caf_generator.m
//  D2A
//
//  Created by Joshua Ferguson on 2/24/14.
//  Copyright (c) 2014 Joshua Ferguson. All rights reserved.
//

#import "caf_generator.h"

@implementation caf_generator


NSString *filetype = @"63616666";
NSString *fileversion = @"0001";
NSString *fileflags = @"0000";

NSString *chunkType = @"64657363";
//64 bit chunks size TBD, which is specified as:
// The size, in bytes, of the data section for the chunk. This is the size of the chunk not including the header.
// Unless noted otherwise for a particular chunk type, mChunkSize must always be valid.
NSString *chunkSize;


//for the CAFAudioFormat -
//64 bit float samplerate = 32000 Hz
NSString *samplerate = @"40DF400000000000";



//specifications which will not need to be changed as a part of the caf file header
NSString *formatID = @"D8E0C6DA";
NSString *formatFlags = @"00000000";
NSString *bytesperpacket = @"00000004";
NSString *channelsPerFrame = @"00000001";
NSString *bitsPerChannel = @"00000010";
//our file will not be edited once we create it
NSString *editCount = @"00000000";

//to denote the high and low values (do not want to go too close to 0 values
// these translate into D = 13, and 4 = 4 (obviously)
NSString *high = @"DDDD";
NSString *low = @"4444";




//for now I am going to assume we can write to an array
 + (NSMutableArray*)text2binary:(NSString *)input {
     
     NSUInteger size = [input length];
     
     NSMutableArray *binary = [[NSMutableArray alloc] initWithCapacity: (size*8) ];

     
     for(int i = 0; i < size; i++){
         int c = (int)[input characterAtIndex:i];
         for(int j = 0; j < 8; j++){
             int k = (8*i) - 8 + (j + 1);
             int bit = (int)(c >> k) & 1;
             NSNumber *insert = [NSNumber numberWithInt:bit];
             [binary insertObject:insert atIndex:k ];
        }
    }
     return binary;
 }

@end
