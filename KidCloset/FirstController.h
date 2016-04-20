//
//  FirstController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/29/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView/FXBlurView.h>
#import "PRFlatClearButton.h"
@interface FirstController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet PRFlatClearButton *loginButton;
@property (strong, nonatomic) IBOutlet PRFlatClearButton *signUpButton;
@end
