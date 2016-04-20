//
//  ClosetSectionHeaderCollectionViewCell.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/8/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClosetSectionHeaderCollectionViewCell : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *closetNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *closetAgeLabel;

@end
