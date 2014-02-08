//
//  WPUser.h
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import <Parse/PFFile.h>

@interface WPUser : PFUser
<PFSubclassing>


@property(strong) PFFile * photo;

+(WPUser *)user;

@end
