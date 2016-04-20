//
//  PRTag+CoreDataProperties.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/30/16.
//  Copyright © 2016 pjr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PRTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) PRClothingItem *prclothingitem;

@end

NS_ASSUME_NONNULL_END
