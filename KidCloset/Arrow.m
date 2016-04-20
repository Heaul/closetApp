//
//  Arrow.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/24/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Arrow.h"
#import "UIBezierPath+Arrow.h"
@implementation Arrow
{
    CGPoint startPoint;
    CGPoint endPoint;
    CGFloat tailWidth;
    CGFloat headWidth;
    CGFloat headLength;
    UIBezierPath *path;

}
-(id)initWithFrame:(CGRect)frame left:(BOOL)left{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]initWithFrame:frame];
        if (left) {
             self.imageView.image = [UIImage imageNamed:@"leftArrow"];
        }else{
             self.imageView.image = [UIImage imageNamed:@"rightArrow"];
        }
        self.imageView.contentMode = UIViewContentModeScaleToFill;
       [self addSubview:self.imageView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


@end
