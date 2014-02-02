//
//  WPMessage.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPMessage.h"
#import <Parse/PFObject+Subclass.h>

@implementation WPMessage

@dynamic text;
@dynamic image;
@dynamic location;
@dynamic from;
@dynamic to;
@dynamic isRead;

+ (NSString *)parseClassName
{
    return @"Message";
}


@end
