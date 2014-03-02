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




//step 1 - concert to binary
//step 2 move radix to after first bit * 2^exp representation
// add 1023 to the exponent
// then combine sign(1):exponent(11):mantissa(52)
+ (NSMutableArray*)convert_64bitfloat:(int) k {
    
    NSMutableArray *reverse;
    NSMutableArray *binary;
    
    NSMutableArray *fbinary = [[NSMutableArray alloc] initWithCapacity: (64) ];

    
    //creates a mutable array rep in reverse order
    while(k > 0){
        int bit = (int) (k & 1);
        NSNumber *insert = [NSNumber numberWithInt:bit];
        k = k>>1;
        [reverse addObject:insert];
    }
    //now we get the binary representation in regular order
    for(int i = [reverse count]; i > -1; i--){
        [binary addObject:[reverse objectAtIndex:i]];
    }
    
    [fbinary addObject:0];
    for(int i = 0; i < 11; i++){
        [fbinary addObject:0];
    }
    
    for(int i = 1; i < [binary count]; i++){
        [fbinary addObject:[binary objectAtIndex:i]];
    }
    
    
    //calculate the proper exponent and offset
    int exponent = (int) [binary count] - 1;
    exponent += 1023;
    
    [reverse removeAllObjects];
    [binary removeAllObjects];
    
    while(exponent > 0){
        int bit = (int) (k & 1);
        NSNumber *insert = [NSNumber numberWithInt:bit];
        exponent = exponent>>1;
        [reverse addObject:insert];
    }
    //now we get the binary representation in regular order
    for(int i = [reverse count]; i > -1; i--){
        [binary addObject:[reverse objectAtIndex:i]];
    }
    // to find the start index for where to put the mantissa
    int index = 12 - [binary count];
    for(i = index; i < 12; i++){
        NSNumber* bit = [binary objectAtIndex:(i-index)];
        [fbinary replaceObjectAtIndex:i withObject:(bit)];
        
    }
    
    return fbinary;
    
}




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
