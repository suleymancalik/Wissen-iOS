//
//  MessageDetailVC.h
//  WissenProject
//
//  Created by Suleyman Calik on 15/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPViewController.h"

@interface MessageDetailVC : WPViewController

@property(strong,nonatomic) WPMessage * message;
@property(strong,nonatomic) NSString * messageId;

@end
