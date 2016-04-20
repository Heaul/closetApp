//
//  PRClothingItem.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class PRCloset;

NS_ASSUME_NONNULL_BEGIN
@class ClothingItem;
@interface PRClothingItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(void)createWithItem:(ClothingItem *)item inContext:(NSManagedObjectContext *)context;
+(void)deleteItemWithId:(NSString *)clothing_id;
+(void)saveItemWithId:(ClothingItem *)clothing_id toCloset:(NSString *)closet_id;
-(NSDictionary *)dictionaryRepresentation;
@end

NS_ASSUME_NONNULL_END

#import "PRClothingItem+CoreDataProperties.h"
