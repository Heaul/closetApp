//
//  FilterTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 4/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
@class FZAccordionTableView;
@protocol FilterControllerDelegate <NSObject>
- (void) updateFilter;
- (void) dismissFilter;
@end
@interface FilterTableViewController : UIViewController <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *updateButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet FZAccordionTableView *tableView;
@property (assign, nonatomic) id <FilterControllerDelegate> delegate;
@property NSArray *clothingTypeSelected;
@property NSArray *sizesSelected;
@property NSArray *tagsSelected;
@property NSArray *seasonsSelected;
@property NSArray *tags;
@property NSArray *seasons;
@end
