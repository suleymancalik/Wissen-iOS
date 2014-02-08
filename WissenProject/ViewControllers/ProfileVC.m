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

@end

@implementation ProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [WPUser logOut];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (IBAction)actLogout:(id)sender
{
    UIActionSheet * actionSheet =
    [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:@"Logout"
                       otherButtonTitles:nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}


@end
