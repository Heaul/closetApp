//
//  UIBezierPath+Arrow.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/24/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Arrow)

+ (UIBezierPath *)dqd_bezierPathWithArrowFromPoint:(CGPoint)startPoint
                                           toPoint:(CGPoint)endPoint
                                         tailWidth:(CGFloat)tailWidth
                                         headWidth:(CGFloat)headWidth
                                        headLength:(CGFloat)headLength;
@end
