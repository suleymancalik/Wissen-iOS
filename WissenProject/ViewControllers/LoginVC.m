//
//  LoginVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtUsername.delegate = self;
    self.txtPassword.delegate = self;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.txtUsername])
        [self.txtPassword becomeFirstResponder];
    else if([textField isEqual:self.txtPassword])
        [self actLogin:nil];
    return YES;
}

#pragma mark - Utility Methods

-(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
{
    [SVProgressHUD show];
    [WPUser logInWithUsernameInBackground:username
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        [SVProgressHUD dismiss];
                                        if (error)
                                        {
                                            [self showAlertWithTitle:@"Login Error"
                                                             message:error.userInfo[@"error"]];
                                        }
                                        else
                                        {
                                            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                        }
                                    }];
}


#pragma mark - Action Methods

- (IBAction)actLogin:(id)sender
{
    NSString * username = self.txtUsername.text;
    NSString * password = self.txtPassword.text;
    if (username.length > 0)
    {
        if (password.length > 0)
        {
            [self loginWithUsername:username password:password];
        }
        else
        {
            [self showAlertWithTitle:@"Missing Info" message:@"Please enter your password."];
        }
    }
    else
    {
        [self showAlertWithTitle:@"Missing Info" message:@"Please enter your username."];
    }
}

@end
