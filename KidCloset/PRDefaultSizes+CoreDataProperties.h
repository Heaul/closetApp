//
//  PRDefaultSizes+CoreDataProperties.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/27/16.
//  Copyright © 2016 pjr. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PRDefaultSizes.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRDefaultSizes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *clothingSize;
@property (nullable, nonatomic, retain) PRCloset *prcloset;

@end

NS_ASSUME_NONNULL_END
