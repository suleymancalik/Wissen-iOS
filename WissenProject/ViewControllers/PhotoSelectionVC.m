//
//  PhotoSelectionVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 15/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "PhotoSelectionVC.h"

@interface PhotoSelectionVC ()

@end

@implementation PhotoSelectionVC



- (void)viewDidLoad
{
    [super viewDidLoad];
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


@end
