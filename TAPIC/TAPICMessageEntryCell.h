//
//  TAPICMessageEntryCell.h
//  TAPIC
//
//  Created by Randy Harper on 2/27/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPICMessage.h"
#import "TAPICTextMessageViewController.h"

@interface TAPICMessageEntryCell : UITableViewCell

@property (nonatomic, strong) TAPICMessage *message;

-(void)configureMessage:(TAPICMessage*)msg tableWidth:(int)tableWidth;

@end
