//
//  ClosetDetailViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import <MagicalRecord/MagicalRecord.h>

@class PRCloset;
@interface ClosetDetailViewController : UITableViewController

@property NSString *closetTitle;

@property NSString * closet_id;
@property NSInteger index;
@property BOOL notUpdated;
@end
