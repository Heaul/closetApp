//
//  TagGroupView.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/30/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>

@interface TagGroupView : UIView
@property NSArray *tags;
-(void)addTagWtihWord:(NSString *)tag;
-(void)addTagWtihWordMini:(NSString *)tag;
-(void)setupViews;
-(void)clearTags;
-(void)addBackView;
@end
