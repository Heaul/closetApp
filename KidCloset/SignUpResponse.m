//
//  SignUpResponse.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "SignUpResponse.h"

@implementation SignUpResponse

- (id) initWithJSONRepresentation:(NSDictionary*)aDictionary {
    if ((self = [super init])) {
        
        self.dict = aDictionary[@"key"];
            }
    return self;
}

+ (id) responseWithJSON:(NSDictionary *)aDictionary {
    return [[SignUpResponse alloc] initWithJSONRepresentation:aDictionary];
    
}

@end
