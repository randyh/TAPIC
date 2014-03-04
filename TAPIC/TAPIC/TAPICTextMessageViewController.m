//
//  TAPICTextMessageViewController.m
//  TAPIC
//
//  Created by Randy Harper on 3/1/14.
//  Copyright (c) 2014 Joshua Ferguson, Randy Harper, Pranay Rungta, and Jake Swartz. All rights reserved.
//

#import "TAPICTextMessageViewController.h"

@interface TAPICTextMessageViewController ()

@end

@implementation TAPICTextMessageViewController

@synthesize textField, sendButton, textFieldView, messages, messageTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    messages = [[NSMutableArray alloc] init];
    
    [messageTable setDelegate:self];
    [messageTable setDataSource:self];
    [messageTable setContentInset:UIEdgeInsetsZero];
    
    sendButton = [[UIButton alloc] init];
    [sendButton setOpaque:YES];
    [sendButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [sendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [sendButton setBackgroundColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
    [[sendButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sendButton setTitle:@"Send" forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateHighlighted];
    [sendButton setTitle:@"Send" forState:UIControlStateHighlighted];
    [sendButton setEnabled:NO];
    [sendButton addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton addTarget:self action:@selector(sendPressedOut:) forControlEvents:UIControlEventTouchUpOutside];
    [sendButton setFrame:CGRectMake(textFieldView.frame.size.width - (SEND_BUTTON_WIDTH + TEXT_ENTRY_BUFFER), TEXT_ENTRY_BUFFER, SEND_BUTTON_WIDTH, TEXT_ENTRY_HEIGHT)];
    
    textField = [[UITextView alloc] init];
    [textField setOpaque:YES];
    [textField setMultipleTouchEnabled:YES];
    [textField setShowsHorizontalScrollIndicator:NO];
    [textField setShowsVerticalScrollIndicator:NO];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setFont:[UIFont systemFontOfSize:16]];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [textField setDataDetectorTypes:UIDataDetectorTypeAll];
    [textField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [textField setFrame:CGRectMake(TEXT_ENTRY_BUFFER, TEXT_ENTRY_BUFFER, textFieldView.frame.size.width - (SEND_BUTTON_WIDTH + 3*TEXT_ENTRY_BUFFER), TEXT_ENTRY_HEIGHT)];

    [textFieldView addSubview:sendButton];
    [textFieldView addSubview:textField];
    
    [textField setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Keyboard Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    CGRect textFieldViewFrame = [textFieldView frame];
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.textFieldView.frame = CGRectMake(textFieldViewFrame.origin.x,
                                              textFieldViewFrame.origin.y - (kbHeight - 50),
                                              textFieldViewFrame.size.width,
                                              textFieldViewFrame.size.height);
    } completion:nil];
    
    [messageTable setContentInset:UIEdgeInsetsMake(0, 0, messageTable.frame.origin.y + messageTable.frame.size.height - textFieldView.frame.origin.y, 0)];
    
    [self scrollToBottomOfTable];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    CGRect textFieldViewFrame = [textFieldView frame];
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.textFieldView.frame = CGRectMake(textFieldViewFrame.origin.x,
                                              textFieldViewFrame.origin.y + (kbHeight - 50),
                                              textFieldViewFrame.size.width,
                                              textFieldViewFrame.size.height);
    } completion:nil];
    
    [messageTable setContentInset:UIEdgeInsetsZero];
    
    [self scrollToBottomOfTable];
}

- (IBAction)sendPressed:(id)sender
{
    [self addMessageToTable:[textField text] isSent:YES];
    [textField setText:@""];
    [self textViewDidChange:textField];
    [messageTable reloadData];
    
    [sendButton setEnabled:NO];
    [self scrollToBottomOfTable];
}

- (IBAction)sendPressedOut:(id)sender
{
    [self addMessageToTable:[textField text] isSent:NO];
    [textField setText:@""];
    [self textViewDidChange:textField];
    [messageTable reloadData];
    
    [sendButton setEnabled:NO];
    [self scrollToBottomOfTable];
}

- (void)addMessageToTable:(NSString*)text isSent:(BOOL)isSent
{
    if ([messages count] >= CACHED_MESSAGE_LIMIT)
        [messages removeObjectAtIndex:0];
    TAPICMessage *message = [[TAPICMessage alloc] init:text isSent:isSent];
    [messages addObject:message];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messages count];
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"";
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"TAPICMessageEntryCell";
    TAPICMessageEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[TAPICMessageEntryCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    TAPICMessage* message = [messages objectAtIndex:indexPath.row];
    [cell configureMessage:message tableWidth:tableView.frame.size.width];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TAPICMessage *message = [messages objectAtIndex:[indexPath row]];
    
    UITextView *textSizeView = [[UITextView alloc] init];
    [textSizeView setAttributedText:[message getText]];
    CGSize size = [textSizeView sizeThatFits:CGSizeMake(messageTable.frame.size.width*MSG_WIDTH_RATIO, FLT_MAX)];
    
    return size.height + (CELL_V_BUFFER * 2);
}

- (void)scrollToBottomOfTable
{
    if ([messages count] > 0)
    {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:[messages count]-1 inSection:0];
        [messageTable scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[textView text] isEqualToString:@""])
        [sendButton setEnabled:NO];
    else
        [sendButton setEnabled:YES];
    
    CGRect textViewFrame = textField.frame;
    CGRect textFieldViewFrame = textFieldView.frame;
    CGRect sendButtonFrame = sendButton.frame;
    
    CGSize adaptedSize = [textField sizeThatFits:CGSizeMake(textViewFrame.size.width, FLT_MAX)];
    int adaptedHeight = adaptedSize.height;
    if (adaptedSize.height > 175)
        adaptedHeight = 175;
    int adaptedHeightBuffer = adaptedHeight + TEXT_ENTRY_BUFFER*2;
    int deltaY = textFieldViewFrame.size.height - adaptedHeightBuffer;
    [textFieldView setFrame:CGRectMake(textFieldViewFrame.origin.x, textFieldViewFrame.origin.y + deltaY, textFieldViewFrame.size.width, adaptedHeightBuffer)];
    [textField setFrame:CGRectMake(TEXT_ENTRY_BUFFER, TEXT_ENTRY_BUFFER, textViewFrame.size.width, adaptedHeight)];
    [sendButton setFrame:CGRectMake(sendButtonFrame.origin.x, textFieldView.frame.size.height - (TEXT_ENTRY_HEIGHT + TEXT_ENTRY_BUFFER), SEND_BUTTON_WIDTH, TEXT_ENTRY_HEIGHT)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
