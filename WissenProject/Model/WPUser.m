//
//  WPUser.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation WPUser

@dynamic photo;

@synthesize image;

+(WPUser *)user
{
    WPUser * user = [[WPUser alloc] init];
    return user;
}


@end
