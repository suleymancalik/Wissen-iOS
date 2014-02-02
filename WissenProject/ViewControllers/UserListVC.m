//
//  UserListVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "UserListVC.h"

@interface UserListVC ()

@end

@implementation UserListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    WPUser * currentUser = [WPUser currentUser];
    if (currentUser)
    {
        // Uygulamaya devam et
    }
    else
    {
        [self performSegueWithIdentifier:SegueLogin sender:self];
    }
}


@end
