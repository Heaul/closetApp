//
//  CreateClosetViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRMaterialTextField.h"
#import "PRFlatButton.h"
#import "Closet.h"
#import <STPopup/STPopup.h>

@interface CreateClosetViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet PRMaterialTextField *nameField;
@property (strong, nonatomic) IBOutlet PRFlatButton *editButton;
@property (strong, nonatomic) IBOutlet PRFlatButton *creatButton;
@property (strong, nonatomic) IBOutlet PRMaterialTextField *genderField;
@property (strong, nonatomic) IBOutlet PRMaterialTextField *ageField;
@property Closet *closet;
@property BOOL isFirstRun;
@property BOOL hasOtherClosets;

@end
