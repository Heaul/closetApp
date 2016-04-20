//
//  ClosetDetailTableViewCell.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import <TableViewCellAnimations/ASTableViewCell.h>
@interface ClosetDetailTableViewCell : ASTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *clothingTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *clothingDefaultAmountLabel;
@property (strong, nonatomic) IBOutlet UIView *imageContainer;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
-(void)customizeAppearance:(UIColor*) color;
@end
