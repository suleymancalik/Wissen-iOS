//
//  ProfileVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "ProfileVC.h"

@interface ProfileVC ()
<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) UIActionSheet * asLogout;
@property (strong, nonatomic) UIActionSheet * asPhotoOptions;
@property (strong, nonatomic) UIActionSheet * asNewPhoto;

@property (nonatomic) BOOL imageCheckDisabled;

@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WPUser * currentUser = [WPUser currentUser];
    if (!self.imageCheckDisabled)
    {
        [self.btnPhoto setImage:nil forState:UIControlStateNormal];
        PFFile * userPhoto = currentUser.photo;
        if(userPhoto)
        {
            [userPhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage * userImage = [UIImage imageWithData:data];
                [self.btnPhoto setImage:userImage forState:UIControlStateNormal];
            }];
        }
    }

    self.txtEmail.text = currentUser.email;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:self.asLogout])
    {
        if (buttonIndex == 0)
        {
            [WPUser logOut];
            [self.tabBarController setSelectedIndex:0];
        }
    }
    else if ([actionSheet isEqual:self.asNewPhoto])
    {
        switch (buttonIndex)
        {
            case 0:
                [self openCamera];
                break;
            case 1:
                [self openPhotoLibary];
                break;
            default:
                break;
        }
    }
    else if ([actionSheet isEqual:self.asPhotoOptions])
    {
        switch (buttonIndex)
        {
            case 0:
                [self removeUserPhoto];
                break;
            case 1:
                [self showASNewPhoto];
                break;
            default:
                break;
        }
    }
}


#pragma mark - Utility Methods


-(void)removeUserPhoto
{
    [[WPUser currentUser] setPhoto:nil];
    [[WPUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
        {
            [self.btnPhoto setImage:nil forState:UIControlStateNormal];
        }
        else
        {
            [self showAlertWithTitle:@"Oops" message:@"Can not remove photo"];
        }
    }];

}

-(void)imageSelected:(UIImage *)image
{
    self.imageCheckDisabled = YES;
    
    [self.btnPhoto setImage:image forState:UIControlStateNormal];
    
    NSData * imageData = UIImageJPEGRepresentation(image,0);
    PFFile * photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            [self showAlertWithTitle:@"Upload Error" message:@"Image not uploaded!"];
        }
        else
        {
            [[WPUser currentUser] setPhoto:photoFile];
            [[WPUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error)
                {
                    [self showAlertWithTitle:@"Save error" message:@"User not updated"];
                }
                else
                {
                    self.imageCheckDisabled = NO;
                    [self showAlertWithTitle:@"Upload Success" message:@"Your profile photo changed."];
                }
            }];
        }
    }];
}


- (void)showASLogout
{
    if (!self.asLogout)
    {
        self.asLogout =
        [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                    delegate:self
                           cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:@"Logout"
                           otherButtonTitles:nil];
    }
    [self.asLogout showFromTabBar:self.tabBarController.tabBar];
}

- (void)showASPhotoOptions
{
    if(!self.asPhotoOptions)
    {
        self.asPhotoOptions =
        [[UIActionSheet alloc] initWithTitle:nil
                                    delegate:self
                           cancelButtonTitle:@"Cancel"
                      destructiveButtonTitle:nil
                           otherButtonTitles:@"Remove Photo" , @"Change Photo", nil];
    }
    [self.asPhotoOptions showFromTabBar:self.tabBarController.tabBar];
}

- (void)showASNewPhoto
{
    if (!self.asNewPhoto)
    {
        self.asNewPhoto =
        [[UIActionSheet alloc] initWithTitle:@"Add Photo"
                                    delegate:self
                           cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                           otherButtonTitles:@"From Camera",@"From Library", nil];
    }
    [self.asNewPhoto showFromTabBar:self.tabBarController.tabBar];
}


#pragma mark - Action Methods

- (IBAction)actLogout:(id)sender
{
    [self showASLogout];
}

- (IBAction)actPhoto:(id)sender
{
    WPUser * currentUser = [WPUser currentUser];
    if (currentUser.photo)
    {
        [self showASPhotoOptions];
    }
    else
    {
        [self showASNewPhoto];
    }
   
}


- (IBAction)actUpdateEmail:(id)sender
{
    NSString * email = self.txtEmail.text;
    if ([self isValidEmail:email])
    {
        WPUser * currentUser = [WPUser currentUser];
        if(![email isEqualToString:currentUser.email])
        {
            currentUser.email = email;
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded)
                {
                    [self.txtEmail resignFirstResponder];
                }
                else
                {
                    [self showAlertWithTitle:@"Update error" message:@"Email not updated."];
                }
            }];
        }
    }
    else
    {
        [self showAlertWithTitle:@"Invalid Email" message:@"Please enter a valid email address."];
    }
}



@end
