//
//  Networking+Auth.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking.h"

@interface Networking (Auth)

-(void) loginWithCredentials:(NSString *)email password:(NSString *)password success:(void(^)(NSHTTPURLResponse *response, LoginResponse *data))success failureHandler:(TWNFailureHandler)failure;

-(void) logoutWithCredential:(NSString *)token Success:(void(^)(NSHTTPURLResponse *response, LoginResponse *data))success failureHandler:(TWNFailureHandler)failure;
@end
