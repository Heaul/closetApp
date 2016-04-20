//
//  SignUpResponse.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpResponse : NSObject

@property NSDictionary *dict;

- (id) initWithJSONRepresentation:(NSDictionary*)aDictionary;
+ (id) responseWithJSON:(NSDictionary*)aDictionary;

@end
