//
//  ClosetViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
@interface ClosetViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property NSArray *closetData;
@property NSString *type;
@property UIImage *chosenImage;
@end
