//
//  PRCloset+CoreDataProperties.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PRCloset.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRCloset (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *closet_id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *prclothingitem;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *prdefaultsizes;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *prdefaultamounts;

@end

@interface PRCloset (CoreDataGeneratedAccessors)

- (void)addPrclothingitemObject:(NSManagedObject *)value;
- (void)removePrclothingitemObject:(NSManagedObject *)value;
- (void)addPrclothingitem:(NSSet<NSManagedObject *> *)values;
- (void)removePrclothingitem:(NSSet<NSManagedObject *> *)values;

- (void)addPrdefaultsizesObject:(NSManagedObject *)value;
- (void)removePrdefaultsizesObject:(NSManagedObject *)value;
- (void)addPrdefaultsizes:(NSSet<NSManagedObject *> *)values;
- (void)removePrdefaultsizes:(NSSet<NSManagedObject *> *)values;

- (void)addPrdefaultamountsObject:(NSManagedObject *)value;
- (void)removePrdefaultamountsObject:(NSManagedObject *)value;
- (void)addPrdefaultamounts:(NSSet<NSManagedObject *> *)values;
- (void)removePrdefaultamounts:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
