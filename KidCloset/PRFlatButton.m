//
//  PRFlatButton.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "PRFlatButton.h"

@interface PRFlatButton ()

@property (strong, nonatomic) CALayer *border;

@end

@implementation PRFlatButton
- (id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self customizeAppearance];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self customizeAppearance];
    }
    return self;
}

#pragma mark -

- (void) setMBackgroundColor:(UIColor *)mBackgroundColor {
    _mBackgroundColor = mBackgroundColor;
    self.backgroundColor = _mBackgroundColor;
}

- (void) setMBorderColor:(UIColor *)mBorderColor {
    _mBorderColor = mBorderColor;
    self.border.backgroundColor = _mBorderColor.CGColor;
}

- (void) setMTitleColor:(UIColor *)mTitleColor {
    _mTitleColor = mTitleColor;
    [self setTitleColor:_mTitleColor forState:UIControlStateNormal];
    // [self setTitleColor:[_mTitleColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
}

- (void) setMTitleShadowColor:(UIColor *)mTitleShadowColor {
    _mTitleShadowColor = mTitleShadowColor;
    [self setTitleShadowColor:_mTitleShadowColor forState:UIControlStateNormal];
    // [self setTitleShadowColor:[_mTitleShadowColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
}

#pragma mark -

- (void) customizeAppearance {
    self.adjustsImageWhenDisabled = NO;
    
    // Add custom bottom border
    
    self.border = [[CALayer alloc] init];
    self.border.frame = (CGRect) { 0, self.bounds.size.height-2, self.bounds.size.width, 2 };
    [self.layer addSublayer:self.border];
    
    // Initialize default colors
    
    self.mTitleColor = [UIColor whiteColor];
    self.mTitleShadowColor = [UIColor clearColor];
    self.mBackgroundColor = [UIColor colorWithRed:231./255. green:76./255. blue:60./255. alpha:1.0];
    self.mBorderColor = [UIColor colorWithRed:192./255. green:57./255. blue:43./255. alpha:1.0];
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if ( highlighted ) {
        self.backgroundColor = self.mBorderColor;
    } else {
        self.backgroundColor = self.mBackgroundColor;
    }
}

- (void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    self.backgroundColor = enabled ? self.mBackgroundColor : [self.mBackgroundColor colorWithAlphaComponent:0.3];
    self.border.backgroundColor = enabled ? self.mBorderColor.CGColor : [self.mBorderColor colorWithAlphaComponent:0.3].CGColor;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];

    self.border.frame = (CGRect) { 0, self.bounds.size.height-2, self.bounds.size.width, 2 };
    
    [CATransaction commit];
}


@end
