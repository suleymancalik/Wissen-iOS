//
//  PhotoSelectionVC.h
//  WissenProject
//
//  Created by Suleyman Calik on 15/02/14.
//  Copyright (c) 2014 Wissen. All rights reserved.
//

#import "WPViewController.h"

@interface PhotoSelectionVC : WPViewController
<UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet * asPhotoOptions;
@property (strong, nonatomic) UIActionSheet * asNewPhoto;


- (void)showASPhotoOptions;
- (void)showASNewPhoto;

@end
