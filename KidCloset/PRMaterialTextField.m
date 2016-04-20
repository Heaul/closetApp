//
//  PRMaterialTextField.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "PRMaterialTextField.h"

@interface PRMaterialTextField ()

@property (strong, nonatomic) CALayer *border;

@end

#pragma mark -

@implementation PRMaterialTextField

- (id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self customizeAppearance];
        [self observeEditing];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self customizeAppearance];
        [self observeEditing];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
-(void)addIcon:(NSString *)iconName{


    
}
- (void) customizeAppearance {
    self.border = [CALayer layer];
    
    //self.border.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    self.border.backgroundColor = [UIColor flatWhiteColorDark].CGColor;
    self.border.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1.0f);
    
    [self.layer addSublayer:self.border];
}

- (void) observeEditing {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.border.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1.0f);
}

#pragma mark -

- (void) didBeginEditing:(NSNotification*)aNotification {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    colorAnimation.fromValue = (id)self.border.backgroundColor;
    colorAnimation.toValue = (id)self.tintColor.CGColor;
    colorAnimation.duration = 0.3;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    
    [self.border addAnimation:colorAnimation forKey:@"selectedAnimation"];
}
-(void)changeBarSelected{
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.fromValue = (id)self.border.backgroundColor;
    colorAnimation.toValue = (id)self.tintColor.CGColor;
    colorAnimation.duration = 0.3;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    [self.border addAnimation:colorAnimation forKey:@"selectedAnimation"];
    
}
-(void)changeBarDismissed{

    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    colorAnimation.fromValue = (id)self.tintColor.CGColor;
    colorAnimation.toValue = (id)[UIColor flatWhiteColorDark].CGColor;;
    colorAnimation.duration = 0.1;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    
    [self.border addAnimation:colorAnimation forKey:@"deselectedAnimation"];


}
- (void) didEndEditing:(NSNotification*)aNotification {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    colorAnimation.fromValue = (id)self.tintColor.CGColor;
    colorAnimation.toValue = (id)[UIColor flatWhiteColorDark].CGColor;;
    colorAnimation.duration = 0.1;
    colorAnimation.fillMode = kCAFillModeForwards;
    colorAnimation.removedOnCompletion = NO;
    
    [self.border addAnimation:colorAnimation forKey:@"deselectedAnimation"];
}
@end
