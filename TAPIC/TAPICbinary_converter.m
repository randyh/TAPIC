//
//  TAPICbinary_converter.m
//  TAPIC
//
//  Created by Joshua Ferguson on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICbinary_converter.h"

@implementation TAPICbinary_converter



//converts a binary array to a hexadecimal string
- (NSString*) convert2_hex:(NSMutableArray*) b {
    
    NSString* hex;
    
    int h_count = [b count]/4;
    
    for(int i = 0; i < h_count; i++){
        int k = i * 4;
        int bit = 0;
        int hvalue = 0;
        int exp = 8;
        for(int j = 0; j<4; j++){
            bit = (int)[b objectAtIndex:(k+j)];
            hvalue += bit*exp;
            exp = exp / 2;
        }
        NSString* c = @"0";
        //now need to find the hex character which corresponds to the hex value
        if(hvalue == 1){
            c = @"1";
        }
        else if(hvalue == 2)
            c = @"2";
        else if(hvalue == 3)
            c = @"3";
        else if(hvalue == 4)
            c = @"4";
        else if(hvalue == 5)
            c = @"5";
        else if(hvalue == 6)
            c = @"6";
        else if(hvalue == 7)
            c = @"7";
        else if(hvalue == 8)
            c = @"8";
        else if( hvalue == 9)
            c = @"9";
        else if(hvalue == 10)
            c = @"A";
        else if(hvalue == 11)
            c = @"B";
        else if(hvalue == 12)
            c = @"C";
        else if(hvalue == 13)
            c = @"D";
        else if(hvalue == 14)
            c = @"E";
        else if(hvalue == 15)
            c = @"F";

        hex = [NSString stringWithFormat:@"%@,%@", hex, c];
        
    }
    
    
    
    return hex;
}



//step 1 - concert to binary
//step 2 move radix to after first bit * 2^exp representation
// add 1023 to the exponent
// then combine sign(1):exponent(11):mantissa(52)
- (NSMutableArray*)convert_64bitfloat:(int) k {
    
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
    for(int i = index; i < 12; i++){
        NSNumber* bit = [binary objectAtIndex:(i-index)];
        [fbinary replaceObjectAtIndex:i withObject:(bit)];
        
    }
    
    return fbinary;
    
}



//for now I am going to assume we can write to an array
- (NSMutableArray*)text2binary:(NSString *)input {
    
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
