//
//  TAPICAudioFileGenerator.m
//  TAPIC
//
//  Created by Joshua Ferguson on 2/24/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICAudioFileGenerator.h"
#import "TAPICTextCorrection.h"

#define TOLERANCE 20
#define BIT_REPETITION 30

@interface TAPICAudioFileGenerator ()

@end

@implementation TAPICAudioFileGenerator

static int fileCount = 0;

static const int header_size = 44;

// To denote the high and low values (do not want to go too close to 0 values
static const Byte high[] = {0xDD};
static const Byte low[] = {0x44};

// Header to indicate that the file is digital data
static const Byte digital_data_size = 52;
static const Byte digital_data[] = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

+ (NSURL*) generateAudioFile:(NSString*)input
{
    if ([input length] == 0)
        return nil;
    
    NSData *inputData = [input dataUsingEncoding:NSUnicodeStringEncoding];
    long chunkSize = [inputData length]*(8*BIT_REPETITION) + digital_data_size;
    
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:[TAPICAudioFileGenerator constructFileHeader:chunkSize] length:header_size];
    
    [data appendBytes:digital_data length:digital_data_size];
    
    const Byte *dataArray = [inputData bytes];
    NSUInteger size = [inputData length];
    
    for(int i = 0; i < size; i++)
    {
        Byte c = dataArray[i];
        for(int j = 0; j < 8; j++)
        {
            Byte bit = {(Byte)((c >> j) & 1)};
            for (int k = 0; k < BIT_REPETITION; k++)
            {
                if (bit)
                    [data appendBytes:high length:1];
                else
                    [data appendBytes:low length:1];
            }
        }
    }
    
    Byte *data1 = (Byte*)malloc([data length]);
    [data getBytes:data1 length:[data length]];
    
    // need to figure out how to create audio file
    NSURL *audioFileURL = [self getNewMessageURL:@"wav"];
    [[NSFileManager defaultManager] createFileAtPath:[audioFileURL path] contents:data attributes:nil];

    return audioFileURL;
}

+ (BOOL)isDigitalMessage:(Byte*)inputData arraySize:(unsigned long)size
{
    BOOL b = YES;
    if( size < digital_data_size + header_size)
    {
        return NO;
    }
    
    // threshold value, NEED TO TEST later on & make possible changes
    int AMPLITUDE_GAP = 10;
    int count = 0;
    int within_gap_count = 0;
    
    for(int i = header_size; i < header_size + digital_data_size-1; i++)
    {
        if(inputData[i] < inputData[i+1])
        {
            count++;
        }
        else if((inputData[i] - AMPLITUDE_GAP) < inputData[i+1])
        {
            within_gap_count++;
        }
    }
    
    if(count < (digital_data_size / 2))
    {
        b = NO;
    }
    // 48 is also a threshold value we will need to test to change
    else if( count + within_gap_count < 48)
    {
        b = NO;
    }
    
    return b;
    
    /*
     int offset = 5;
     int avg = 0;
     int median = 0;
     //int AMPLITUDE_GAP = 20;
     //int count =  0;
     
     int avg_count = (2*offset)  + 1;
     
     // to initialize the averaging function
     for(int i = header_size; i < header_size + avg_count; i++)
     {
     avg += (int) inputData[i];
     }
     avg = avg / ( (2*offset)+1);
     median = inputData[header_size + offset + 1];
     if(median - AMPLITUDE_GAP < avg && median + AMPLITUDE_GAP > avg)
     {
     count++;
     }
     
     for(int i = header_size + avg_count; i < header_size + avg_count + digital_data_size; i++ )
     {
     avg = avg * (2*offset + 1);
     avg -= inputData[i - (2*offset + 1)];
     avg += inputData[i];
     avg = (avg / avg_count);
     median = inputData[i - offset];
     if(median - AMPLITUDE_GAP < avg && median + AMPLITUDE_GAP > avg)
     {
     count++;
     }
     }
     
     if(count > 48 - avg_count){
     return YES;
     }
     
     */
}

+ (NSString*)getMessageData:(NSURL*)audioInputURL
{
    NSData *inputData = [NSData dataWithContentsOfURL:audioInputURL];
    unsigned long dataLength = [inputData length];
    
    Byte *data = (Byte*)malloc(dataLength);
    [inputData getBytes:data length:[inputData length]];
    
    if (![TAPICAudioFileGenerator isDigitalMessage:data arraySize:dataLength])
    {
        return nil;
    }
    
    NSMutableData *decodedData = [[NSMutableData alloc] init];
    
    int totalHeaderSize = header_size + digital_data_size;
    int bitCount = 0;
    Byte byte[] = {0};
    
    int highCount = 0;
    int lowCount = 0;
    
    // Since there are multiple bytes for each bit, increment by BIT_REPETITION
    int highRangeLow = ((int)high[0]) - TOLERANCE;
    int highRangeHigh = ((int)high[0]) + TOLERANCE;
    int lowRangeLow = ((int)low[0]) - TOLERANCE;
    int lowRangeHigh = ((int)low[0]) + TOLERANCE;
    
    for (int i = totalHeaderSize; i < dataLength; i = i + BIT_REPETITION)
    {
        for (int j = 0; j < BIT_REPETITION; j++)
        {
            int currentData = ((int)(data[i+j]));
            if ((currentData > highRangeLow) && (currentData < highRangeHigh)) // is high
            {
                highCount++;
            }
            else if ((currentData > lowRangeLow) && (currentData < lowRangeHigh)) // is low
            {
                lowCount++;
            }
        }
        
        if (highCount >= lowCount)
        {
            byte[0] |= (1 << bitCount);
        }
        else if (lowCount > highCount)
        {
            byte[0] &= ~(1 << bitCount);
        }
        
        highCount = 0;
        lowCount = 0;
        bitCount++;
        
        if (bitCount == 8)
        {
            [decodedData appendBytes:byte length:1];
            byte[0] = 0;
            bitCount = 0;
        }
    }
    
    NSString *text = [[NSString alloc] initWithBytes:[decodedData bytes] length:[decodedData length] encoding:NSUnicodeStringEncoding];
    text = [TAPICTextCorrection correctReceivedText:text];
    
    [[NSFileManager defaultManager] removeItemAtURL:audioInputURL error:nil];
    free(data);
    
    return text;
}

+(Byte*)constructFileHeader:(long)totalAudioLength
{
    long totalDataLength = totalAudioLength + header_size;
    long longSampleRate = 11025.0;
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
