//
//  NewMessageVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "NewMessageVC.h"
#import <CoreLocation/CoreLocation.h>

@interface NewMessageVC ()
<UITextViewDelegate , CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblToUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgToUser;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;

@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) UIImage * selectedImage;
@property (strong, nonatomic) PFGeoPoint * selectedGeopoint;

@end

@implementation NewMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtMessage.delegate = self;
    
    self.lblToUser.text = self.toUser.username;
}

#pragma mark - Utility Methods

-(void)sendMessage
{
    [SVProgressHUD show];
    
    WPMessage * newMessage = [WPMessage object];
    newMessage.to = self.toUser;
    newMessage.from = [WPUser currentUser];
    newMessage.text = self.txtMessage.text;
    newMessage.location = self.selectedGeopoint;
    if(self.selectedImage)
    {
        NSData * imageData = UIImageJPEGRepresentation(self.selectedImage,0);
        newMessage.image = [PFFile fileWithData:imageData];
        
        [newMessage.image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error)
            {
                [self showAlertWithTitle:@"Image error" message:@"Image can not be uploaded!"];
                [SVProgressHUD dismiss];
            }
            else
            {
                [self savePreparedMessage:newMessage];
            }
        }];
    }
    else
    {
        [self savePreparedMessage:newMessage];
    }
    
}

-(void)savePreparedMessage:(WPMessage *)newMessage
{
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [SVProgressHUD dismiss];
        if (succeeded)
        {
            PFQuery *innerQuery = [WPUser query];
            [innerQuery whereKey:@"username" equalTo:newMessage.to.username];
            
            PFQuery * pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" matchesQuery:innerQuery];

            
            NSDictionary *data = @{
                                   @"alert" : newMessage.text ,
                                   @"id"    : newMessage.objectId};
            
            [PFPush sendPushDataToQueryInBackground:pushQuery withData:data block:^(BOOL succeeded, NSError *error) {
                NSLog(@"%@", error);
            }];
            
//            [PFPush sendPushMessageToQueryInBackground:pushQuery withMessage:newMessage.text block:^(BOOL succeeded, NSError *error) {
//                NSLog(@"%@", error);
//            }];
//            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showAlertWithTitle:@"Oopps" message:@"Couldn't send message!"];
        }
    }];

}

-(void)openLocationManager
{
    if(!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    [self.locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = [locations firstObject];
    self.selectedGeopoint = [PFGeoPoint geoPointWithLocation:location];
    [self.btnLocation setImage:[UIImage imageNamed:@"locationSelected"] forState:UIControlStateNormal];
    
    [self.locationManager stopUpdatingLocation];
    [SVProgressHUD dismiss];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString * errorMessage = @"Location error";
    if(error.code == kCLErrorDenied)
    {
        errorMessage = @"Please enable location services to use this feature.";
    }
    
    [self showAlertWithTitle:@"Location Error" message:errorMessage];
    
    [self.locationManager stopUpdatingLocation];
    [SVProgressHUD dismiss];
}


#pragma mark  - Photo Methods

-(void)imageSelected:(UIImage *)image
{
    self.selectedImage = image;
    [self.btnPhoto setImage:[UIImage imageNamed:@"photoSelected"] forState:UIControlStateNormal];
}

-(void)removeSelectedPhoto
{
    self.selectedImage = nil;
    [self.btnPhoto setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet isEqual:self.asNewPhoto])
    {
        switch (buttonIndex)
        {
            case 0:
                [self openCamera];
                break;
            case 1:
                [self openPhotoLibary];
                break;
            default:
                break;
        }
    }
    else if ([actionSheet isEqual:self.asPhotoOptions])
    {
        switch (buttonIndex)
        {
            case 0:
                [self removeSelectedPhoto];
                break;
            case 1:
                [self showASNewPhoto];
                break;
            default:
                break;
        }
    }
}

#pragma mark - TextView Methods


-(void)textViewDidChange:(UITextView *)textView
{
    self.btnSend.enabled = (textView.text.length > 0);
        
}



#pragma mark - Action Methods

- (IBAction)actSend:(id)sender
{
    [self sendMessage];
}

- (IBAction)actLocation:(id)sender
{
    if (self.selectedGeopoint)
    {
        [self.btnLocation setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        self.selectedGeopoint = nil;
    }
    else
    {
        [SVProgressHUD show];
        [self openLocationManager];
    }
}

- (IBAction)actPhoto:(id)sender
{
    if (self.selectedImage)
    {
        [self showASPhotoOptions];
    }
    else
    {
        [self showASNewPhoto];
    }
}


@end
