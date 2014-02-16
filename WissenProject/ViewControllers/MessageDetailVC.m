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

@property (strong, nonatomic) UIView * fullScreenView;


@end

@implementation MessageDetailVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (!self.message)
    {
        WPMessage * message = [WPMessage objectWithoutDataWithObjectId:self.messageId];
        [message fetch];
        
        [message.from fetch];
        
        self.message = message;
    }
    
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

-(void)openImageFullScreen:(UIImage *)image
{
    if (!self.fullScreenView)
    {
        self.fullScreenView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.fullScreenView.backgroundColor = [UIColor blackColor];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.tag = 1000;
        [self.fullScreenView addSubview:imageView];

        
        UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeFullScreen) forControlEvents:UIControlEventTouchUpInside];
        float btnWidth = 100;
        float btnHeight = 50;
        closeButton.frame =
        CGRectMake(self.fullScreenView.frame.size.width - btnWidth,0,btnWidth,btnHeight);
        [self.fullScreenView addSubview:closeButton];

    }
    
    UIImageView * imageView = (UIImageView *)[self.fullScreenView viewWithTag:1000];
    [imageView setImage:image];
    
    CGSize imageSize = image.size;
    CGFloat newWitdh = 0;
    CGFloat newHeight = 0;
    if(imageSize.width > imageSize.height)
    {
        newWitdh = self.fullScreenView.frame.size.width;
        float ratio = newWitdh / imageSize.width;
        newHeight = imageSize.height * ratio;
    }
    else
    {
        newHeight = self.fullScreenView.frame.size.height;
        float ratio = newHeight / imageSize.height;
        newWitdh = imageSize.width * ratio;
    }
    
    imageView.frame = CGRectMake(0,0,newWitdh,newHeight);
    imageView.center = self.fullScreenView.center;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.fullScreenView];
    
}

#pragma mark - Action Methods

-(void)closeFullScreen
{
    [self.fullScreenView removeFromSuperview];
}

-(IBAction)actPhoto:(id)sender
{
    UIImage * image = self.btnPhoto.imageView.image;
    if (image)
    {
        [self openImageFullScreen:image];
        // TODO: full screen goster
    }
}


-(IBAction)actReply:(id)sender
{
    
}



@end
