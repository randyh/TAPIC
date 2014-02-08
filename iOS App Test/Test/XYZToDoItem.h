//
//  XYZToDoItem.h
//  Test
//
//  Created by Randy Harper on 2/6/14.
//  Copyright (c) 2014 Randy Harper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
