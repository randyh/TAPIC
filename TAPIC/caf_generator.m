//
//  caf_generator.m
//  D2A
//
//  Created by Joshua Ferguson on 2/24/14.
//  Copyright (c) 2014 Joshua Ferguson. All rights reserved.
//

#import "caf_generator.h"
#import "TAPICbinary_converter.h"

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

NSString *file_info;

TAPICbinary_converter* bhelper;

char newline = '\n';


+ (void) gen_audiofile:(NSString*) input {
    NSString* header;
    
    
    
    header = [NSString stringWithFormat:@"%@,%@", filetype, fileversion];
    header = [NSString stringWithFormat:@"%@,%@", header, fileflags];
    header = [NSString stringWithFormat:@"%@,%@", header, chunkType];
    
    int input_bytesize = [input length];
    NSMutableArray* b = [bhelper convert_64bitfloat:input_bytesize];
    chunkSize = [bhelper convert2_hex:b];
    
    header = [NSString stringWithFormat:@"%@,%@", header, chunkSize];
    
    header = [NSString stringWithFormat:@"%@,%@", header, samplerate];
    
    header = [NSString stringWithFormat:@"%@,%@", header, formatID];
    header = [NSString stringWithFormat:@"%@,%@", header, formatFlags];
    header = [NSString stringWithFormat:@"%@,%@", header, bytesperpacket];
    header = [NSString stringWithFormat:@"%@,%@", header, channelsPerFrame];
    header = [NSString stringWithFormat:@"%@,%@", header, bitsPerChannel];
    header = [NSString stringWithFormat:@"%@,%@", header, editCount];
    
    NSMutableArray* input_binary = [bhelper text2binary:input];
    
    file_info = [[NSString alloc] init];
    
    
    for(int i = 0; i < [input_binary count]; i++){
        int f = [[input_binary objectAtIndex:i] intValue];
        if(f == 1 ){
            file_info =  [file_info stringByAppendingString: high];
        }
        else {
            file_info = [file_info stringByAppendingString: high];
        }
        
    }
    
    //now we put together the entire string for the file
    NSString* file_data =[header stringByAppendingString: file_info];
    
    //now only need to format the string with space and newline characters
    
    
    
    
    
    
    
    


    
    
    

    
    
    
    
    
}




@end
