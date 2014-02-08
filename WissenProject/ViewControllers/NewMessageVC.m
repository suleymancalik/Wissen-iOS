//
//  NewMessageVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "NewMessageVC.h"

@interface NewMessageVC ()
<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblToUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgToUser;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSend;

@end

@implementation NewMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtMessage.delegate = self;
    
    self.lblToUser.text = self.toUser.username;
}

-(void)sendMessage
{
    WPMessage * newMessage = [WPMessage object];
    newMessage.to = self.toUser;
    newMessage.from = [WPUser currentUser];
    newMessage.text = self.txtMessage.text;
    
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showAlertWithTitle:@"Oopps" message:@"Couldn't send message!"];
        }
    }];
}

#pragma mark - TextView Methods


-(void)textViewDidChange:(UITextView *)textView
{
    self.btnSend.enabled = (textView.text.length > 0);
        
}


#pragma mark - Action Methods

- (IBAction)actSend:(id)sender
{
    [self sendMessage];
}

@end
