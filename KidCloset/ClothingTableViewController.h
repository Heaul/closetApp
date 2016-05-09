//
//  ClothingTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Closet.h"
#import <FZAccordionTableView/FZAccordionTableView.h>

@interface ClothingTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property NSString * clothingItemName;
@property UIImagePickerController *pickerController;
@property UIImage *imageURL;
@property NSString *type;
@property NSString *closetId;
@property NSArray *items;
@property Closet *closet;
@property NSString *chosenSize;
@end
