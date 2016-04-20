//
//  ClothingItemCollectionViewCell.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/8/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClothingItemCollectionViewCell.h"

@implementation ClothingItemCollectionViewCell

-(void)customizeApperance{
        self.circleView.layer.cornerRadius = self.clothingImageView.frame.size.width / 2.0f;
        self.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4f, 0.4f);


}


@end
