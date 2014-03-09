//
//  TAPICTextMessageViewController.h
//  TAPIC
//
//  Created by Randy Harper on 3/1/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPICMessage.h"
#import "TAPICMessageEntryCell.h"

#define CELL_V_BUFFER 5
#define MSG_WIDTH_RATIO 0.80
#define CELL_X_MARGIN 0

#define TEXT_ENTRY_HEIGHT 35
#define TEXT_ENTRY_BUFFER 5
#define SEND_BUTTON_WIDTH 50

#define CACHED_MESSAGE_LIMIT 50

@interface TAPICTextMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (strong, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIView *textFieldView;
@property (strong, nonatomic) IBOutlet UITableView *messageTable;

- (void)setRootView:(UITabBarController*)tabBarController;
- (void)addMessageToTable:(NSString*)text isSent:(BOOL)isSent;

@end
