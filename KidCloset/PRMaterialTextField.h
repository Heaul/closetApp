//
//  PRMaterialTextField.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>

@interface PRMaterialTextField : UITextField
-(void)addIcon:(NSString *)iconName;
-(void)changeBarSelected;
-(void)changeBarDismissed;
@end
