//
//  AddItemTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRMaterialTextField.h"
#import <ChameleonFramework/Chameleon.h>
#import "Closet.h"
#import "ClothingItem.h"
#import "PRFlatButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <STPopup/STPopup.h>
#import <SVProgressHUD/SVProgressHUD.h>
@class TagGroupView;
@interface AddItemTableViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet TagGroupView *tagView;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) IBOutlet UIImageView *chosenImage;
@property (strong, nonatomic) IBOutlet PRMaterialTextField *sizeField;
@property (strong, nonatomic) IBOutlet PRMaterialTextField *typeField;
@property (strong,nonatomic) NSString *type;
@property (strong, nonatomic) IBOutlet PRFlatButton *deleteButton;
@property (strong, nonatomic) IBOutlet PRMaterialTextField *seasonField;
@property (strong,nonatomic) NSString *currentClosetId;
@property (strong,nonatomic) ClothingItem *clothingItem;
@property UIImage *imageUrl;
@property NSString *imageString;
@end
