//
//  RegisterVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswordAgain;

@end

@implementation RegisterVC


- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - Utility Methods


-(void)signupWithUsername:(NSString *)username
                    email:(NSString *)email
                 password:(NSString *)password
{
    WPUser * newUser = [WPUser user];
    newUser.username = username;
    newUser.email = email;
    newUser.password = password;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self showAlertWithTitle:@"Register Error" message:error.userInfo[@"error"]];
        }
    }];

}

-(void)checkFieldsAndRegister
{
    NSString * username = self.txtUsername.text;
    NSString * email = self.txtEmail.text;
    NSString * pass1 = self.txtPassword.text;
    NSString * pass2 = self.txtPasswordAgain.text;
    
    if (username.length > 0)
    {
        if (email.length > 0)
        {
            if (pass1.length > 0)
            {
                if (pass2.length > 0)
                {
                    if ([pass1 isEqualToString:pass2])
                    {
                        if ([self isValidEmail:email])
                        {
                            [self signupWithUsername:username email:email password:pass1];
                        }
                        else
                        {
                            [self showAlertWithTitle:@"Wrong email" message:@"Please check your email address"];
                        }
                    }
                    else
                    {
                        [self showAlertWithTitle:@"Passwords not match" message:@"Please check your password"];
                    }
                }
                else
                {
                    [self showAlertWithTitle:@"Missing Info" message:@"Please enter your password again"];
                }
            }
            else
            {
                [self showAlertWithTitle:@"Missing Info" message:@"Please enter your password"];
            }
        }
        else
        {
            [self showAlertWithTitle:@"Missing Info" message:@"Please enter your email"];
        }
    }
    else
    {
        [self showAlertWithTitle:@"Missing Info" message:@"Please enter your name and surname"];
    }
}


#pragma mark - Action Methods

- (IBAction)actBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actRegister:(id)sender
{
    [self checkFieldsAndRegister];
}

@end
