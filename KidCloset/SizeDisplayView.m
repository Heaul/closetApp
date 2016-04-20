//
//  SizeDisplayView.m
//  KidCloset
//
//  Created by Patrick Ryan on 4/12/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "SizeDisplayView.h"

@implementation SizeDisplayView

-(void)createLabelsAmounts:(NSArray *)quantities withSizes:(NSArray *)sizes owned:(NSArray *)owned {

    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    NSInteger viewWidth = self.frame.size.width/6;
    NSInteger viewHeight = (self.frame.size.height/3)-5;
    UILabel *ownedCaption = [[UILabel alloc]initWithFrame:CGRectMake(0,2* (viewHeight+5), viewWidth,  viewHeight)];
    UILabel *needCaption = [[UILabel alloc]initWithFrame:CGRectMake(0, (viewHeight+5), viewWidth,  viewHeight)];
    ownedCaption.text = @"Have";
    needCaption.text = @"Need";
    ownedCaption.textAlignment = NSTextAlignmentRight;
    needCaption.textAlignment = NSTextAlignmentRight;
    [needCaption setTextColor:[UIColor flatGrayColorDark]];
    [ownedCaption setTextColor:[UIColor flatGrayColorDark]];
    [self addSubview:needCaption];
    [self addSubview:ownedCaption];
    
    for (NSInteger i = 0; i<[sizes count]; i++) {
        UILabel *sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake((i +1)*viewWidth, 0, viewWidth, viewHeight)];
        sizeLabel.text = sizes[i];
        UILabel *quantityLabel = [[UILabel alloc]initWithFrame:CGRectMake((i +1)*viewWidth, (viewHeight+5), viewWidth, viewHeight)];
        
        UILabel *ownedLabel = [[UILabel alloc]initWithFrame:CGRectMake((i +1)*viewWidth, (viewHeight+5)*2, viewWidth, viewHeight)];
        if ([quantities[i] isKindOfClass:[NSNumber class]]) {
            quantityLabel.text = [quantities[i] stringValue];
        }else{
            quantityLabel.text =[ NSString stringWithFormat:@"%ld",(long)quantities[i]];
        }
        if ([owned[i] isKindOfClass:[NSNumber class]]) {
            ownedLabel.text = [owned[i] stringValue];
        }else{
            ownedLabel.text =[ NSString stringWithFormat:@"%ld",(long)owned[i]];
        }
        
        sizeLabel.textAlignment = NSTextAlignmentCenter;
        quantityLabel.textAlignment = NSTextAlignmentCenter;
        ownedLabel.textAlignment = NSTextAlignmentCenter;
        
        [sizeLabel setTextColor:[UIColor flatTealColorDark]];
        quantityLabel.textColor = [UIColor flatRedColor];
        [ownedLabel setTextColor:[UIColor flatMintColor]];
        
        [self addSubview:sizeLabel];
        [self addSubview:quantityLabel];
        [self addSubview:ownedLabel];
        
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
