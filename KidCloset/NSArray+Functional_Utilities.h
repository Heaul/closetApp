//
//  NSArray+Functional_Utilities.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Functional_Utilities)

- (NSArray*) map:(id(^)(id obj, NSUInteger index))block;
- (NSArray*) flatMap:(id(^)(id obj, NSUInteger index))block;
- (NSArray*) filter:(BOOL(^)(id obj, NSUInteger index))block;

- (NSDictionary*) groupBy:(id<NSCopying>(^)(id obj, NSUInteger index))block;
- (id) select:(BOOL(^)(id obj, NSUInteger index))block;
- (void) select:(BOOL(^)(id obj, NSUInteger index))selectBlock andUpdate:(void(^)(id obj))updateBlock;

@end
