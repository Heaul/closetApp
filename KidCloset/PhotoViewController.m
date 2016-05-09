//
//  PhotoViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "PhotoViewController.h"
#import "LLSimpleCamera.h"
#import "PickClothingTypeTableViewController.h"
#import "AddItemTableViewController.h"
#import "ClosetViewController.h"
@import Photos;

@interface PhotoViewController()
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property UIImage *currentImage;

@end
@implementation PhotoViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.camera start];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     if(!self.hasType){
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [self fetchPhotoFromEndAtIndex];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.camera stop];
}
-(void)libraryTapped:(id)sender{
    [self.snapButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    
    self.imagePicker.allowsEditing = false;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.navigationBar.translucent = false;
    self.imagePicker.navigationBar.barTintColor = [UIColor flatPowderBlueColorDark];
    
    __weak PhotoViewController *weakSelf = self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:^{
    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
   NSString *mediaType = info[UIImagePickerControllerMediaType];
   self.currentImage =  info[UIImagePickerControllerOriginalImage];
   
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:self.currentImage];
    cropController.delegate = self;
    cropController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
    cropController.aspectRatioLocked = YES;
    
   __weak PhotoViewController * weakSelf = self;
   
   [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf.navigationController presentViewController:cropController animated:YES completion:nil];
   }];
}

-(void)snapButtonHighlight:(id)sender{
    [self.snapButton setBackgroundColor:[UIColor redColor]];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *tapReconizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(libraryTapped:)];
    tapReconizer.enabled = YES;
    tapReconizer.numberOfTapsRequired = 1;
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    
    CGRect libaryFrame = self.libraryView.frame;
    libaryFrame.origin = CGPointMake(0, 0);
    self.libraryImage =  [[UIImageView alloc]initWithFrame:libaryFrame];
    [self.libraryView addSubview:self.libraryImage];
    self.libraryImage.userInteractionEnabled = YES;
    [self.libraryImage addGestureRecognizer:tapReconizer];
    
    // create camera with standard settings

    // camera with video recording capability
    self.camera =  [[LLSimpleCamera alloc] initWithVideoEnabled:NO];
    __weak typeof(self) weakSelf = self;
    [self.camera attachToViewController:self withFrame:self.view.frame];
    [self.view bringSubviewToFront:self.controlArea];
    
    
        [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                //label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, self.buttonView.frame.size.width, self.buttonView.frame.size.height);
    self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
   // self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.snapButton addTarget:self action:@selector(snapButtonHighlight:) forControlEvents:UIControlEventTouchDown];
    [self.buttonView addSubview:self.snapButton];
    

}
/* other lifecycle methods */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    //self.imageView.image = image;
   // [self layoutImageView];
    self.currentImage = image;
    self.navigationItem.rightBarButtonItem.enabled = YES;
      __weak typeof(self) weakSelf = self;
    
    //CGRect viewFrame = [self.view convertRect:self.imageView.frame toView:self.navigationController.view];
   // self.imageView.hidden = YES;
   
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:self.cameraArea.frame completion:^{
            [weakSelf.camera stop];
            if(weakSelf.shouldChooseCloset){
                 [weakSelf performSegueWithIdentifier:@"chooseCloset" sender:self];
            }else if (weakSelf.hasType) {
                [weakSelf performSegueWithIdentifier:@"imageChosenWithType" sender:self];
            }else if([weakSelf.type length] > 0 ){
                [weakSelf performSegueWithIdentifier:@"chooseCloset" sender:self];
            }
            else{
                [weakSelf performSegueWithIdentifier:@"chooseCloset" sender:self];
            }
    }];
}



- (void)snapButtonPressed:(UIButton *)button
{


    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
    if(!error) {    
        // we should stop the camera, since we don't need it anymore. We will open a new vc.
        // this very important, otherwise you may experience memory crashes
        [camera stop];
        self.currentImage = image;
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:self.currentImage];
        cropController.delegate = self;
        cropController.defaultAspectRatio = TOCropViewControllerAspectRatioSquare;
        cropController.aspectRatioLocked = YES;
        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
        [self presentViewController:cropController animated:YES completion:nil];
        
       // [self performSegueWithIdentifier:@"imageChosen" sender:self];
       }
    }];
    
    
}
-(void)fetchPhotoFromEndAtIndex{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.synchronous = YES;
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHFetchResult *photos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    if (photos) {
        [[PHImageManager defaultManager]requestImageForAsset:[photos objectAtIndex:photos.count -1]
         targetSize:self.libraryView.frame.size contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage *result, NSDictionary *info) {
             
                [self.libraryImage setImage:result];

        }];
    }


}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"imageChosen"]){
        ClosetViewController *vc = (ClosetViewController *)segue.destinationViewController;
        vc.chosenImage = self.currentImage;
    }else if([segue.identifier isEqualToString:@"imageChosenWithType"]){
         AddItemTableViewController *vc = (AddItemTableViewController *)segue.destinationViewController;
         vc.type = self.type;
         vc.imageUrl = self.currentImage;
         [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else if([segue.identifier isEqualToString:@"chooseCloset"]){
    
        ClosetViewController *vc = (ClosetViewController *)segue.destinationViewController;
        if (self.type && [self.type length] > 0) {
            vc.type = self.type;
        }
        vc.chosenImage = self.currentImage;
    }
}
@end
