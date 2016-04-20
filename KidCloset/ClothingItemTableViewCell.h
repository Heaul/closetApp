//
//  ClothingItemTableViewCell.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagGroupView.h"
@interface ClothingItemTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemSize;
@property (strong, nonatomic) IBOutlet UIImageView *currentImage;
@property (strong, nonatomic) IBOutlet TagGroupView *tagView;


@property (strong, nonatomic) IBOutlet UILabel *itemSeason;


@end
