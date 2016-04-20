//
//  ClosetDetailTableViewCell.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClosetDetailTableViewCell.h"
#import "Chameleon.h"
@implementation ClosetDetailTableViewCell

-(void)customizeAppearance:(UIColor *)color{
    self.imageContainer.backgroundColor = color;
    self.imageView.backgroundColor = color;
}
@end
