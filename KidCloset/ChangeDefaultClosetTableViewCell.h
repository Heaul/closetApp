//
//  ChangeDefaultClosetTableViewCell.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/17/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"
@interface ChangeDefaultClosetTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *clothingTypeLabel;
@property (strong, nonatomic) IBOutlet PKYStepper *stepper;

@end
