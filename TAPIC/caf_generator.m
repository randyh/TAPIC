//
//  caf_generator.m
//  D2A
//
//  Created by Joshua Ferguson on 2/24/14.
//  Copyright (c) 2014 Joshua Ferguson. All rights reserved.
//

#import "caf_generator.h"

@implementation caf_generator


NSString *filetype = @"6361 6666";
NSString *fileversion = @"0001";
NSString *fileflags = @"0000";

NSString *chunkType = @"6465 7363";
//64 bit chunks size TBD, which is specified as:
// The size, in bytes, of the data section for the chunk. This is the size of the chunk not including the header.
// Unless noted otherwise for a particular chunk type, mChunkSize must always be valid.
NSString *chunkSize;


//for the CAFAudioFormat -
//64 bit float samplerate = 32000 Hz
NSString *samplerate = @"40DF 4000 0000 0000";



//specifications which will not need to be changed as a part of the caf file header
NSString *formatID = @"D8E0 C6DA";
NSString *formatFlags = @"0000 0000";
NSString *bytesperpacket = @"0000 0004";
NSString *channelsPerFrame = @"0000 0001";
NSString *bitsPerChannel = @"0000 0010";
//our file will not be edited once we create it
NSString *editCount = @"0000 0000";

//to denote the high and low values (do not want to go too close to 0 values
// these translate into D = 13, and 4 = 4 (obviously)
NSString *high = @"DDDD";
NSString *low = @"4444";

NSString *file_info;

char newline = '\n';



@end
