//
//  ChangeClosetDefaultsTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/17/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Closet.h"
@interface ChangeClosetDefaultsTableViewController : UITableViewController
@property NSDictionary *defaultSizes;
@property NSDictionary *defaultQuanity;
@property NSString *defaultSize;
@property NSArray *defaultKeys;
@property Closet *closet;
@property BOOL hasSize;
@property NSString *size;
@property NSArray * values;
@property NSArray * sizes;
@property CGSize contentSizeInPopup;
@property CGSize landscapeContentSizeInPopup;

-(void)updateInfo;
@end
