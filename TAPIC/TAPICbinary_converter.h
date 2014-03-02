//
//  TAPICbinary_converter.h
//  TAPIC
//
//  Created by Joshua Ferguson on 3/2/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAPICbinary_converter : NSObject


    //add constructor method, but there are no constuctors in objective c...

    + (NSString*) convert2_hex:(NSMutableArray*) b;
    + (NSMutableArray*)convert_64bitfloat:(int) k;
    + (NSMutableArray*)text2binary:(NSString *)input;

@end
