//
//  PRFlatButton.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRFlatButton : UIButton

@property (strong, nonatomic) UIColor *mTitleColor;
@property (strong, nonatomic) UIColor *mTitleShadowColor;
@property (strong, nonatomic) UIColor *mBackgroundColor;
@property (strong, nonatomic) UIColor *mBorderColor;

- (void) customizeAppearance;

@end
