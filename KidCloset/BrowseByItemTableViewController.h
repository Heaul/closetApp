//
//  BrowseByItemTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 4/12/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import <SDWebImage/UIImageView+WebCache.h>
@class FZAccordionTableView;
@interface BrowseByItemTableViewController : UITableViewController
@property NSString *type;
@property NSArray * items;
@end
