//
//  LoginResponse.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "LoginResponse.h"

@implementation LoginResponse

- (id) initWithJSONRepresentation:(NSDictionary*)aDictionary {
    if ((self = [super init])) {
        if (aDictionary[@"key"]) {
            self.dict = @{@"key":aDictionary[@"key"]};
        }
    }
    return self;
}

+ (id) responseWithJSON:(NSDictionary *)aDictionary {
    return [[LoginResponse alloc] initWithJSONRepresentation:aDictionary];
    
}


@end
