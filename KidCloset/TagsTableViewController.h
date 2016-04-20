//
//  TagsTableViewController.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/29/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"

@interface TagsTableViewController : UITableViewController <MCSwipeTableViewCellDelegate, UITextFieldDelegate>
@property UIButton *addTagButton;
@property NSArray *tags;
@property CGSize contentSizeInPopup;
@property CGSize landscapeContentSizeInPopup;
- (instancetype)initWIthTags:(NSArray *)tags;
@end
