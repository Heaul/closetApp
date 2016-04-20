//
//  LoginViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRMaterialTextField.h"
#import <FXBlurView/FXBlurView.h>

@interface LoginViewController : UITableViewController
@property (strong, nonatomic) IBOutlet PRMaterialTextField *loginField;
- (IBAction)SignUpPushed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@property (strong, nonatomic) IBOutlet PRMaterialTextField *passwordField;

@end
