//
//  WPMessage.h
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import <Parse/PFFile.h>
#import <Parse/PFGeoPoint.h>

@interface WPMessage : PFObject
<PFSubclassing>

@property(strong) NSString * text;
@property(strong) PFFile * image;
@property(strong) PFGeoPoint * location;
@property(strong) WPUser * from;
@property(strong) WPUser * to;
@property BOOL isRead;

@end
