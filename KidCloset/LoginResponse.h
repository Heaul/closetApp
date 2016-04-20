//
//  LoginResponse.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResponse : NSObject
@property NSDictionary *dict;

- (id) initWithJSONRepresentation:(NSDictionary*)aDictionary;
+ (id) responseWithJSON:(NSDictionary*)aDictionary;
@end
