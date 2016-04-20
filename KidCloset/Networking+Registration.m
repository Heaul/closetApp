//
//  Networking+Registration.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking+Registration.h"
#import "NSURLRequest+JSON.h"
#import "NSURLSession+JSONTask.h"

NSString * const kNetworkingSignUPURLString = @"rest-auth/registration/";

@implementation Networking (Registration)


-(void)signUpWithCredentials:(NSString *)email password:(NSString *)password success:(void(^)(NSHTTPURLResponse *response, SignUpResponse *data))success failureHandler:(TWNFailureHandler)failure {
    
    NSError *error;
    NSURLRequest *request = [self signUpWithEmail:email password:password error:&error];
    
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self signUpCompletionHandler:success failure:failure]];

    [task resume];
}

- (NSURLRequest*) signUpWithEmail:(NSString*)email password:(NSString*)password error:(NSError**)error {
    // JSON data
    
    NSData *data = [self  signUpJSONDataWithEmail:email password:password];
    
    if ( !data ) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"NSJSONSerialization" code:0 userInfo:nil];
        }
        return nil;
    }
    
    // Build request
    
    NSURL *URL = [self URLWithPath:kNetworkingSignUPURLString params:nil];
    NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data];
    
    return request;
}

- (TWNSURLSessionJSONDataTaskCompletionHandler) signUpCompletionHandler:(void(^)(NSHTTPURLResponse *response, SignUpResponse *data))success failure:(TWNFailureHandler)failure {
    return ^(id json, NSHTTPURLResponse *response, NSError *error) {
        NSInteger statusCode = [response statusCode];
        if (statusCode == 400 || statusCode == 403) {
              failure(response,error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(response, [SignUpResponse responseWithJSON:json]);
            });
        }
        
    };
}


- (NSData*) signUpJSONDataWithEmail:(NSString*)email password:(NSString*)password {
    // Build request parameters
    
    NSMutableDictionary *params = [[self parametersWithEntriesFromDictionary:@{
        @"email": email,
        @"password1":password,
        @"password2":password,
        @"username":email
    }] mutableCopy];
    
    // De-encode the email for json data
    
    params[@"email"] = email;
    
    // Encode JSON
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if ( !data ) {
        NSLog(@"[Networking+User loginJSONDataWithEmail]: Unable to serialize parameters: %@", error);
    }
    
    return data;
}



@end
