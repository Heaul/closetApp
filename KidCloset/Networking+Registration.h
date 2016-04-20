//
//  Networking+Registration.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking.h"

@interface Networking (Registration)

-(void) signUpWithCredentials:(NSString *)email password:(NSString *)password success:(void(^)(NSHTTPURLResponse *response, SignUpResponse *data))success failureHandler:(TWNFailureHandler)failure;

@end
