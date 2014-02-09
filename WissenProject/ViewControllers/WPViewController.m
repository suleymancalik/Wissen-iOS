//
//  WPViewController.m
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPViewController.h"

@interface WPViewController ()

@property(strong,nonatomic) UIImagePickerController * imagePicker;
@end

@implementation WPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


-(void)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message
{
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [alertview show];
}


-(BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - Photo/Video Methods

-(void)imageSelected:(UIImage *)image
{
    // Ihtiyaci olan class'lar bu methodu override edecek.
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self imageSelected:image];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


-(void)openImagePicker:(UIImagePickerControllerSourceType)type
{
    if([UIImagePickerController isSourceTypeAvailable:type])
    {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        [self.imagePicker setSourceType:type];
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        [self showAlertWithTitle:@"Oops" message:@"Operation not available"];
    }
}

-(void)openPhotoLibary
{
    [self openImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}


-(void)openCamera
{
    [self openImagePicker:UIImagePickerControllerSourceTypeCamera];
}




@end
