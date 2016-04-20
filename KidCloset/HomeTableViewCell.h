//
//  HomeTableViewCell.h
//  KidCloset
//
//  Created by Patrick Ryan on 4/10/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SizeDisplayView;
@interface HomeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet SizeDisplayView *sizesView;
@property (strong, nonatomic) IBOutlet SizeDisplayView *bottomSizeView;

@end
