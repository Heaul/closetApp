//
//  PRClothingItem+CoreDataProperties.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PRClothingItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRClothingItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *size;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *item_id;
@property (nullable, nonatomic, retain) NSString *season;
@property (nullable, nonatomic, retain) PRCloset *prcloset;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *prtag;


- (void)addPrtagObject:(NSManagedObject *)value;
- (void)removePrtagObject:(NSManagedObject *)value;
- (void)addPrtag:(NSSet<NSManagedObject *> *)values;
- (void)removePrtag:(NSSet<NSManagedObject *> *)values;


@end

NS_ASSUME_NONNULL_END
