//
//  TAPICAudioFileGenerator.m
//  TAPIC
//
//  Created by Joshua Ferguson on 2/24/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICAudioFileGenerator.h"

#define TOLERANCE 20
#define BIT_REPETITION 10

@interface TAPICAudioFileGenerator ()

@end

@implementation TAPICAudioFileGenerator

static int fileCount = 0;

const int header_size = 44;

//64 bit chunks size TBD, which is specified as:
// The size, in bytes, of the data section for the chunk. This is the size of the chunk not including the header.
// Unless noted otherwise for a particular chunk type, mChunkSize must always be valid.
const int chunkSize_size = 8;

//to denote the high and low values (do not want to go too close to 0 values
// these translate into D = 13, and 4 = 4 (obviously)
Byte high[] = {0xDD};
Byte low[] = {0x44};

//8 bytes of data
// WILL NEED RIGOROUS TESTING TO ENSUR THAT THIS WORKS and does not mask an audio signal
const int digital_data_size = 10;
const char digital_data[] = {'T', 'A', 'P', 'I', 'C', 't', 'a', 'p', 'i', 'c'};

+ (NSURL*) generateAudioFile:(NSString*)input
{
    if ([input length] == 0)
        return nil;
    
    NSData *inputData = [input dataUsingEncoding:NSUTF8StringEncoding];
    long chunkSize = [inputData length]*(8*BIT_REPETITION) + digital_data_size;
    
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:[TAPICAudioFileGenerator constructFileHeader:chunkSize] length:header_size];
    
    [data appendBytes:digital_data length:digital_data_size];
    
    const char *dataArray = [inputData bytes];
    NSUInteger size = [input length];
    
    for(int i = 0; i < size; i++)
    {
        char c = dataArray[i];
        for(int j = 0; j < 8; j++)
        {
            char bit = {(char)((c >> j) & 1)};
            for (int k = 0; k < BIT_REPETITION; k++)
            {
                if (bit)
                    [data appendBytes:high length:2];
                else
                    [data appendBytes:low length:2];
            }
        }
    }
    
    
    // need to figure out how to create audio file
    NSURL *audioFileURL = [self getNewMessageURL:@"wav"];
    [[NSFileManager defaultManager] createFileAtPath:[audioFileURL path] contents:data attributes:nil];

    return audioFileURL;
}

+ (NSString*)getMessageData:(NSURL*)audioInput
{
    /*
    // need to figure out how to load data from file into byte array
    
    int dataLength = [inputData length];
    
    char data[dataLength];
    [inputData getBytes:data length:[inputData length]];
    
    int totalHeaderSize = header_size + chunkSize_size + format_header_size;
    
    for (int i = 0; i <  10; i++)
    {
        if (!(data[i + totalHeaderSize] > (digital_data[i]-TOLERANCE) &&
              data[i + totalHeaderSize] < (digital_data[i]+TOLERANCE)))
            return nil; // Is not digital data
    }
    
    NSMutableData *decodedData = [[NSMutableData alloc] init];
    
    totalHeaderSize += 10;
    int bitCount = 0;
    char byte[1] = {0};
    
    // Since there are multiple bytes for each bit, increment by BIT_REPETITION
    for (int i = totalHeaderSize; i < dataLength; i = i+BIT_REPETITION)
    {
        for (int j = 0; j < BIT_REPETITION; j++)
        {
            if ((data[i+j] > (high[0]- TOLERANCE)) && (data[i+j] < (high[0]+ TOLERANCE))) // is high
            {
                byte[0] |= (1 << bitCount);
                continue;
            }
            else if ((data[i+j] > (low[0]- TOLERANCE)) && (data[i+j] < (low[0]+ TOLERANCE))) // is low
            {
                // do nothing; bit is already 0
                continue;
            }
        }
        
        bitCount++;
        
        if (bitCount == 8)
        {
            [decodedData appendBytes:byte length:1];
            byte[0] = 0;
            bitCount = 0;
        }
    }
    
    NSString *text = [[NSString alloc] initWithBytes:[decodedData bytes] length:[decodedData length] encoding:NSUTF8StringEncoding];
    return text;*/
    return nil;
}

+(Byte*)constructFileHeader:(long)totalAudioLength
{
    long totalDataLength = totalAudioLength + header_size;
    long longSampleRate = 32000.0;
    int channels = 1;
    int bitsPerSample = 16;
    long byteRate = 16 * longSampleRate * (channels/8);
    
    Byte* header = (Byte*)malloc(44);
    header[0] = 'R';  // RIFF/WAVE header
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (Byte) (totalDataLength & 0xff);
    header[5] = (Byte) ((totalDataLength >> 8) & 0xff);
    header[6] = (Byte) ((totalDataLength >> 16) & 0xff);
    header[7] = (Byte) ((totalDataLength >> 24) & 0xff);
    header[8] = 'W';
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    header[12] = 'f';  // 'fmt ' chunk
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    header[16] = 16;  // 4 bytes: size of 'fmt ' chunk
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    header[20] = 1;  // format = 1
    header[21] = 0;
    header[22] = (Byte) channels;
    header[23] = 0;
    header[24] = (Byte) (longSampleRate & 0xff);
    header[25] = (Byte) ((longSampleRate >> 8) & 0xff);
    header[26] = (Byte) ((longSampleRate >> 16) & 0xff);
    header[27] = (Byte) ((longSampleRate >> 24) & 0xff);
    header[28] = (Byte) (byteRate & 0xff);
    header[29] = (Byte) ((byteRate >> 8) & 0xff);
    header[30] = (Byte) ((byteRate >> 16) & 0xff);
    header[31] = (Byte) ((byteRate >> 24) & 0xff);
    header[32] = (Byte) (channels * bitsPerSample / 8);  // block align
    header[33] = 0;
    header[34] = bitsPerSample;
    header[35] = 0;
    header[36] = 'd';
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (Byte) (totalAudioLength & 0xff);
    header[41] = (Byte) ((totalAudioLength >> 8) & 0xff);
    header[42] = (Byte) ((totalAudioLength >> 16) & 0xff);
    header[43] = (Byte) ((totalAudioLength >> 24) & 0xff);
    
    return header;
}

+ (NSURL*)getNewMessageURL:(NSString*)extension
{
    NSString *path =[[NSString alloc] initWithFormat:@"TAPICReceivedMessage%d.%@",fileCount,extension];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               path,
                               nil];
    fileCount++;
    return [NSURL fileURLWithPathComponents:pathComponents];
}

@end
