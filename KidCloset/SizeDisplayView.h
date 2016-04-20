//
//  SizeDisplayView.h
//  KidCloset
//
//  Created by Patrick Ryan on 4/12/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>

@interface SizeDisplayView : UIView
@property NSArray *sizes;
@property NSArray *values;
@property NSArray *sizelabels;
@property NSArray *amountLabels;
-(void)createLabelsAmounts:(NSArray *)quantities withSizes:(NSArray *)sizes owned:(NSArray *)owned;
@end
