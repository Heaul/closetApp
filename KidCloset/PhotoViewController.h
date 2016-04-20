//
//  PhotoViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOCropViewController.h"

@interface PhotoViewController : UIViewController <TOCropViewControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *cameraArea;
@property (strong, nonatomic) IBOutlet UIView *controlArea;

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *libraryView;
@property UIImageView *libraryImage;
@property NSString *type;
@property BOOL hasType;
@property UIImagePickerController *imagePicker;
@property BOOL nocloset;
@end
