//
//  ClosetHeaderView.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/23/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import "Arrow.h"

@interface ClosetHeaderView : UIView
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowView;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *leftArrowView;
-(void)loadArrows;
@end
