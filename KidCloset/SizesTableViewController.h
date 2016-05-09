//
//  SizesTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 4/20/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FZAccordionTableView/FZAccordionTableView.h>
#import <ChameleonFramework/Chameleon.h>
#import <REMenu/REMenu.h>
#import <DXPopover/DXPopover.h>
#import <RWBlurPopover/RWBlurPopover.h>

@interface SizesTableViewController : UITableViewController <FZAccordionTableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property BOOL initialLoad;
@end
