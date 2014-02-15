//
//  MessageDetailVC.m
//  WissenProject
//
//  Created by Suleyman Calik on 15/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "MessageDetailVC.h"
#import "NewMessageVC.h"
#import <MapKit/MapKit.h>

@interface MessageDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation MessageDetailVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.lblFrom.text = self.message.from.username;
    self.lblDate.text = self.message.createdAt.description;
    self.textView.text = self.message.text;
    
    if(self.message.location)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.message.location.latitude, self.message.location.longitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate,1000,500);
        [self.mapView setRegion:region animated:YES];
        
        self.mapView.hidden = NO;
    }
    else
    {
        self.mapView.hidden = YES;
    }
    
    [self.message.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self.btnPhoto setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReplySegue"])
    {
            WPUser * selectedUser = self.message.from;
            NewMessageVC * newMessageVC = segue.destinationViewController;
            newMessageVC.toUser = selectedUser;
    }
}

#pragma mark - Action Methods


-(IBAction)actPhoto:(id)sender
{
    UIImage * image = self.btnPhoto.imageView.image;
    if (image)
    {
        // TODO: full screen goster
    }
}


-(IBAction)actReply:(id)sender
{
    
}



@end
