//
//  WPAppDelegate.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPAppDelegate.h"
#import "MessageDetailVC.h"

@implementation WPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    [self initializeApp:launchOptions];
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", userInfo);
    [self handlePushNotification:userInfo];
    // handle push noti
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
    [currentInstallation saveInBackground];
}


-(void)initializeApp:(NSDictionary *)launchOptions
{
    [WPUser registerSubclass];
    [WPMessage registerSubclass];
    
    [Parse
     setApplicationId:@"AqhDmQC0j1WRZXwo4tR6q30C42d1ebZfBTYmgkC9"
     clientKey:@"sMg7dR63w6SPGfVtS1q1jdh06qEArbOPLBgqcQHC"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if (launchOptions)
    {
        NSDictionary * pushDict = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handlePushNotification:pushDict];
//        NSArray * allkeys = [pushDict allKeys];
    }
//    NSLog(@"%@" , launchOptions);
    // handle push noti
}


-(void)handlePushNotification:(NSDictionary *)pushDict
{
    
    if ([WPUser currentUser])
    {
        NSDictionary * aps = pushDict[@"aps"];
        NSString * messageId = aps[@"id"];
        WPMessage * message = [WPMessage objectWithoutDataWithObjectId:messageId];
        [message fetch];
        
        UINavigationController * navCont = [self.tabbar.viewControllers firstObject];
        
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessageDetailVC * messageDetail = [storyboard instantiateViewControllerWithIdentifier:@"MessageDetailVC"];
        messageDetail.message = message;
        [navCont pushViewController:messageDetail animated:YES];
        
        
        // message detail ac
        
        
        
        
        /*
        [self.tabbar setSelectedIndex:2];
        
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"curent user var"
                               message:@"mesajlara gitti"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
        [alert show];
        */
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"curent user yok"
                               message:@"birsey yapmadi"
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
        [alert show];

        NSLog(@"push geldi fakat login olmadigi icin birsey yapmadik");
    }
    
}

@end
