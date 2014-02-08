//
//  WPViewController.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPViewController.h"

@interface WPViewController ()

@end

@implementation WPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertview show];
}


@end
