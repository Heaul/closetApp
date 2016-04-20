//
//  TagGroupView.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/30/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "TagGroupView.h"

@interface TagGroupView()
@property UILabel *label;
@property NSInteger x;
@property NSInteger y;
@end

@implementation TagGroupView


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tags = @[];
    }
    return self;
}

-(void)addBackView{
        self.layer.cornerRadius = 10.0f;
        self.layer.borderColor = [UIColor flatWhiteColor].CGColor;
        self.backgroundColor = [UIColor flatWhiteColor];
        self.layer.borderColor = [UIColor flatWhiteColor].CGColor;
        self.layer.masksToBounds = YES;
}
-(void)setupViews{
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2,  self.frame.size.height)];
        self.label.text = @"No Tags";
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
        [self addSubview:self.label];
}

-(void)addTagWtihWordMini:(NSString *)tag{
    [self.label setHidden:YES];
    CGRect labelFrame = CGRectMake(0, 0, 40, 20);
    NSInteger spacer = 20;
    labelFrame.origin.x = (([self.tags count]) * labelFrame.size.width);
    if ([self.tags count] == 0) {
          labelFrame.origin.x = 0;
    }
    if (labelFrame.origin.x + 50 > self.frame.size.width) {
        labelFrame.origin.x = 10;
        labelFrame.origin.y = labelFrame.origin.y + 30;
    }
    UILabel *a = [[UILabel alloc]initWithFrame:labelFrame];
    a.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    [a setBackgroundColor:[UIColor colorWithRed:114/255.0 green:170/255.0 blue:208/255.0 alpha:1]];
    [a setTextColor:[UIColor whiteColor]];
    a.textAlignment = NSTextAlignmentCenter;
    a.text = tag;
    a.layer.masksToBounds = YES;
    a.layer.cornerRadius = 7;
    NSMutableArray *tagCopy = [self.tags mutableCopy];
    [tagCopy addObject:a];
    self.tags = [tagCopy copy];
    [self addSubview:a];
}

-(void)addTagWtihWord:(NSString *)tag{
    [self.label setHidden:YES];
    CGRect labelFrame = CGRectMake(0, 10, 60, 17);
    NSInteger spacer = 10;

    labelFrame.origin.x = (([self.tags count]) * labelFrame.size.width) + 5;
    if ([self.tags count] == 0) {
       labelFrame.origin.x = 5;
    }
    if (labelFrame.origin.x + 90 > self.frame.size.width) {
        labelFrame.origin.x = 5;
        labelFrame.origin.y = labelFrame.origin.y + 20;
    }
    UILabel *a = [[UILabel alloc]initWithFrame:labelFrame];
    a.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
  //  [a setBackgroundColor:[UIColor colorWithRed:114/255.0 green:170/255.0 blue:208/255.0 alpha:1]];
    [a setTextColor:[UIColor flatGrayColorDark]];
    a.textAlignment = NSTextAlignmentCenter;
    a.text = tag;
    a.layer.masksToBounds = YES;
    a.layer.cornerRadius = 8;
    NSMutableArray *tagCopy = [self.tags mutableCopy];
    [tagCopy addObject:a];
    self.tags = [tagCopy copy];
    [self addSubview:a];
}
-(void)clearTags{
    NSMutableArray *tagTemp = [self.tags mutableCopy];
    [tagTemp removeAllObjects];
    self.tags = tagTemp;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
