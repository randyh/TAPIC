//
//  TAPICTextCorrection.m
//  TAPIC
//
//  Created by Joshua Ferguson on 3/8/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICTextCorrection.h"

@implementation TAPICTextCorrection

+ (NSString*)correctReceivedText:(NSString*)data
{
    UITextChecker* textChecker = [[UITextChecker alloc] init];
    
    NSInteger offset = 0;
    //NSInteger len = [data length];
    NSRange r = {0, [data length]};
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];

    NSRange mis = [textChecker rangeOfMisspelledWordInString:data range:r startingAt:offset wrap:NO language:lang];
    
    while(mis.length != 0)
    {
        NSString *misspelling  = [data substringWithRange:mis];
        
        NSArray *guesses = [textChecker guessesForWordRange:mis inString:data language:lang];
        
        int t = MIN([guesses count] , 10);
        
        NSUInteger replacement_index = 0;
        int min_distance = NSUIntegerMax;
        
        for(int i = 1; i < t; i++)
        {
            NSUInteger d = [self levenshteinDistanceToString:(misspelling) comparisonString:[guesses objectAtIndex:i ]];
            if(d < min_distance)
            {
                min_distance = d;
                replacement_index = i;
            }
        }
        
        data = [data stringByReplacingOccurrencesOfString:misspelling
                                               withString:[guesses objectAtIndex:replacement_index]];
        
        //update the range of which to search for replacements
        offset = mis.length  + mis.location;
        NSRange r = {offset, [data length]};
        mis = [textChecker rangeOfMisspelledWordInString:data range:r startingAt:offset wrap:NO language:lang];

        if(mis.location != NSNotFound && mis.length + mis.location > [data length])
        {
            goto BAIL;
        }
    }
    
    BAIL:
    return data;
}

+ (NSUInteger)levenshteinDistanceToString:(NSString *)inputString comparisonString:(NSString *) cstring
{
    NSUInteger sl = [inputString length];
    NSUInteger tl = [cstring length];
    NSUInteger *d = calloc(sizeof(*d), (sl+1) * (tl+1));
    
    #define d(i, j) d[((j) * sl) + (i)]
    for (NSUInteger i = 0; i <= sl; i++)
    {
        d(i, 0) = i;
    }
    for (NSUInteger j = 0; j <= tl; j++)
    {
        d(0, j) = j;
    }
    for (NSUInteger j = 1; j <= tl; j++)
    {
        for (NSUInteger i = 1; i <= sl; i++)
        {
            if ([inputString characterAtIndex:i-1] == [cstring characterAtIndex:j-1])
            {
                d(i, j) = d(i-1, j-1);
            }
            else
            {
                d(i, j) = MIN(d(i-1, j), MIN(d(i, j-1), d(i-1, j-1))) + 1;
            }
        }
    }
    
    NSUInteger r = d(sl, tl);
    #undef d
    
    free(d);
    
    return r;
}

@end
