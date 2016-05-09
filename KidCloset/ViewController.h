//
//  ViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FXBlurView/FXBlurView.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MaterialTextField/MaterialTextField.h>
@class PRFlatButton;
@class PRMaterialTextField;
@class PRFlatClearButton;
@class ViewController;

@protocol LoginViewControllerDelegate <NSObject>

- (void) loginViewControllerDidLogin:(ViewController *)aController;
- (void) loginViewControllerDidCancel:(ViewController *)aController;
- (void)transitionToAppAfterSignUp;

@end

@interface ViewController : UIViewController
@property BOOL originalViewController;

@property (copy, nonatomic) void (^loginBlock)(ViewController *aController);
@property (copy, nonatomic) void (^cancelBlock)(ViewController *aController);

@property (assign, nonatomic) id<LoginViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet PRFlatClearButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotLabel;

@property  NSNumber * shouldLogin;

@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet MFTextField *loginField;

- (IBAction)SignUpPushed:(id)sender;

@property (strong, nonatomic) IBOutlet PRFlatButton *signUpButton;

@property (weak, nonatomic) IBOutlet MFTextField *passwordField;

- (void) dimsissFilter;

@end

