//
//  PRCloset.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN
@class Closet;
@interface PRCloset : NSManagedObject
+(void)updateCloests:(NSArray *)closets;
+(PRCloset *)closetForId:(NSString *)closet_id;
+(PRCloset *)closetForId:(NSString *)closet_id context:(NSManagedObjectContext *)context;
// Insert code here to declare functionality of your managed object subclass
+(NSArray *)currentClosets;
+(void)clean;
-(NSDictionary *)dictionaryRepresentation;
+(NSArray *)tags;
+(NSNumber *)numberOfItemsWithTag:(NSString *)tag;
+(NSArray *)allClothingItemsOfType:(NSString *)type;
+(NSArray *)allTags;
+(NSArray *)clothingItemsWithTag:(NSString*)tag;
@end

NS_ASSUME_NONNULL_END

#import "PRCloset+CoreDataProperties.h"
