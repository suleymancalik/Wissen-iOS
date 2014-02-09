//
//  WPViewController.h
//  WissenProject
//
//  Created by Suleyman Calik on 02/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPViewController : UIViewController
<UINavigationControllerDelegate , UIImagePickerControllerDelegate>

-(void)showAlertWithTitle:(NSString *)title
                  message:(NSString *)message;

-(BOOL)isValidEmail:(NSString *)email;

-(void)openPhotoLibary;

-(void)openCamera;

-(void)imageSelected:(UIImage *)image;

@end
