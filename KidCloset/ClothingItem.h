//
//  ClothingItem.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClothingItem : NSObject
- (id) initWithDictionary:(NSDictionary*)aDictionary;
- (NSDictionary *)dictionaryRepresentation;
@property NSString* defaultSize;
@property NSString* clothingType;
@property NSString *imageURL;
@property NSString *size;
@property NSString *sex;
@property NSString *season;
@property NSString *name;
@property NSString *clothing_id;
@property NSArray *tags;
-(void)deleteItem;
-(void)saveItem:(NSString *)closet_id;
@end
