//
//  ClothingItemCollectionViewCell.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/8/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClothingItemCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *clothingTypeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *clothingImageView;
@property (strong, nonatomic) IBOutlet UILabel *clothingAmountLabel;
@property (strong, nonatomic) IBOutlet UIView *circleView;
-(void)customizeApperance;
@end
