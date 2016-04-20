//
//  NSArray+Functional_Utilities.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "NSArray+Functional_Utilities.h"

@implementation NSArray (Functional_Utilities)


- (NSArray*) map:(id(^)(id obj, NSUInteger index))block {
    NSMutableArray *results = [NSMutableArray array];
    NSUInteger i = 0;
    
    for ( id obj in self ) {
        id result = block(obj, i++);
        [results addObject:result ? result : [NSNull null]];
    }
    
    return results;
}

- (NSArray*) flatMap:(id(^)(id obj, NSUInteger index))block {
    NSMutableArray *results = [NSMutableArray array];
    NSUInteger i = 0;
    
    for ( id obj in self ) {
        id result = block(obj, i++);
        if (result) {
            [results addObjectsFromArray:result];
        }
    }
    
    return results;
}

- (NSArray*) filter:(BOOL(^)(id obj, NSUInteger index))block {
    NSMutableArray *results = [NSMutableArray array];
    NSUInteger i = 0;
    
    for ( id obj in self ) {
        BOOL result = block(obj, i++);
        if (result) {
            [results addObject:obj];
        };
    }
    
    return results;
}

- (NSDictionary*) groupBy:(id<NSCopying>(^)(id obj, NSUInteger index))block {
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    NSUInteger i = 0;
    
    for ( id obj in self ) {
        id result = block(obj, i++);
        if ( !result ) {
            result = [NSNull null];
        }
        if ( !results[result] ) {
            results[result] = [NSMutableArray array];
        }
        [results[result] addObject:obj];
    }
    
    return results;
}

- (id) select:(BOOL(^)(id obj, NSUInteger index))block {
    id selected = nil;
    NSUInteger i = 0;
    
    for ( id obj in self ) {
        if ( block(obj, i++) ) {
            selected = obj;
            break;
        }
    }
    
    return selected;
}

- (void) select:(BOOL(^)(id obj, NSUInteger index))selectBlock andUpdate:(void(^)(id obj))updateBlock {
    id selected = [self select:selectBlock];
    if ( selected ) {
        updateBlock(selected);
    }
}


@end
