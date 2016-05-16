//
//  SizesTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 4/20/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import <REMenu/REMenu.h>
#import <DXPopover/DXPopover.h>
#import <RWBlurPopover/RWBlurPopover.h>
#import <Instabug/Instabug.h>

@class FZAccordionTableView;
@class FZAccordionTableViewDelegate;

@interface SizesTableViewController : UITableViewController < UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property BOOL initialLoad;
@end
