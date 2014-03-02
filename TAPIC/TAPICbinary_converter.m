//
//  TAPICbinary_converter.m
//  TAPIC
//
//  Created by Joshua Ferguson on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICbinary_converter.h"

@implementation TAPICbinary_converter


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
    for(int i = index; i < 12; i++){
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
