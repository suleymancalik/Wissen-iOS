//
//  WPAppDelegate.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPAppDelegate.h"

@implementation WPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeApp:launchOptions];
    
    return YES;
}
							

-(void)initializeApp:(NSDictionary *)launchOptions
{
    [WPUser registerSubclass];
    [WPMessage registerSubclass];
    
    [Parse
     setApplicationId:@"AqhDmQC0j1WRZXwo4tR6q30C42d1ebZfBTYmgkC9"
     clientKey:@"sMg7dR63w6SPGfVtS1q1jdh06qEArbOPLBgqcQHC"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

@end
