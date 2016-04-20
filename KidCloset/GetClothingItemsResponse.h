//
//  GetClothingItemsResponse.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetClothingItemsResponse : NSObject

@property NSDictionary *dict;
@property (readonly) NSArray *closets;
@property (readonly) NSArray *items;
@property (readonly) NSDictionary *defaults;
@property (readonly) NSArray *sizes;
@property BOOL closetsExist;
@property (readonly) NSDictionary *closetDict;
@property (readonly) NSArray * closetArray;
@property NSInteger primaryIndex;
- (id) initWithJSONRepresentation:(NSDictionary*)aDictionary;
+ (id) responseWithJSON:(NSDictionary*)aDictionary;


@end
