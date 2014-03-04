//
//  TAPICMessageEntryCell.m
//  TAPIC
//
//  Created by Randy Harper on 2/27/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICMessageEntryCell.h"

@implementation TAPICMessageEntryCell

@synthesize message;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0]];
        [self setOpaque:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)configureMessage:(TAPICMessage*)msg tableWidth:(int)tableWidth
{
    message = msg;
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UITextView* messageEntry = [[UITextView alloc]initWithFrame:CGRectMake(0,10,10,10)];
    [messageEntry setEditable:NO];
    [messageEntry setScrollEnabled:NO];
    [messageEntry setDataDetectorTypes:UIDataDetectorTypeAll];
    [messageEntry setContentInset:UIEdgeInsetsZero];
    [messageEntry setClipsToBounds:NO];
    [messageEntry setAttributedText:[message getText]];
    [self.contentView addSubview:messageEntry];
    
    int msgWidth = tableWidth*MSG_WIDTH_RATIO;
    
    // Compute the best size for the textview
    CGSize size = [messageEntry sizeThatFits:CGSizeMake(msgWidth, FLT_MAX)];
    if (msgWidth >size.width)
        msgWidth = size.width + 5;
    
    if ([message isSent])
    {
        [messageEntry setBackgroundColor:[UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.7]];
        [messageEntry setFrame:CGRectMake(tableWidth - msgWidth - CELL_X_MARGIN, CELL_V_BUFFER, msgWidth, size.height)];
    }
    else
    {
        [messageEntry setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0.2 alpha:0.7]];
        [messageEntry setFrame:CGRectMake(5 + CELL_X_MARGIN, CELL_V_BUFFER, msgWidth, size.height)];
    }
}

@end
