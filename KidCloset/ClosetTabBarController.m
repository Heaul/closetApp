//
//  ClosetTabBarController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/18/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClosetTabBarController.h"


@implementation ClosetTabBarController
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UIImagePickerController class]] ) {
      /*  // Present image picker
        UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            pickerController.showsCameraControls = NO;
            pickerController.navigationBarHidden= YES;
            
            CGRect rect = self.view.frame;
            rect.size.height = rect.size.height/3;
            rect.origin.y = self.view.frame.size.height - rect.size.height/3;
            
           // UIView *view = [[UIView alloc]initWithFrame:rect];
          //  view.backgroundColor = [UIColor redColor];
            
            
           // pickerController.cameraOverlayView = view;
            
            [self presentViewController:pickerController animated:YES completion:nil];
            return NO;
    
        }*/
         return NO;
    }
    


    // All other cases switch to the tab
    return YES;
}
#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)viewDidLoad{
    [super viewDidLoad];
    [self setDelegate:self];
}
@end
