//
//  Networking+Auth.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking+Auth.h"
#import "NSURLRequest+JSON.h"
#import "NSURLSession+JSONTask.h"

NSString * const kNetworkingLoginURLString = @"rest-auth/login/";
NSString * const kNetworkingLogoutURLString = @"rest-auth/logout/";

@implementation Networking (Auth)

-(void) loginWithCredentials:(NSString *)email password:(NSString *)password success:(void(^)(NSHTTPURLResponse *response, LoginResponse *data))success failureHandler:(TWNFailureHandler)failure {
    
    NSError *error;
    NSURLRequest *request = [self loginWithEmail:email password:password error:&error];
    
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self loginCompletionHandler:success failure:failure]];

    [task resume];
}

- (NSURLRequest*)loginWithEmail:(NSString*)email password:(NSString*)password error:(NSError**)error {
    // JSON data
    
    NSData *data = [self  loginJSONDataWithEmail:email password:password];
    
    if ( !data ) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"NSJSONSerialization" code:0 userInfo:nil];
        }
        return nil;
    }
    
    // Build request
    
    NSURL *URL = [self URLWithPath:kNetworkingLoginURLString params:nil];
    NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data];
    
    return request;
}


- (TWNSURLSessionJSONDataTaskCompletionHandler) loginCompletionHandler:(void(^)(NSHTTPURLResponse *response, LoginResponse *data))success failure:(TWNFailureHandler)failure {
    return ^(id json, NSHTTPURLResponse *response, NSError *error) {
        NSInteger statusCode = [response statusCode];
        if (statusCode == 400 || statusCode == 403) {
              failure(response,error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(response, [LoginResponse responseWithJSON:json]);
            });
        }
        
    };
}
- (NSData*) loginJSONDataWithEmail:(NSString*)email password:(NSString*)password {
    // Build request parameters
    
    NSMutableDictionary *params = [[self parametersWithEntriesFromDictionary:@{
        @"username" : email,
        @"email" : email,
        @"password" :password,
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


-(void) logoutWithCredential:(NSString *)token Success:(void(^)(NSHTTPURLResponse *response, LoginResponse *data))success failureHandler:(TWNFailureHandler)failure {
 
    NSError *error;
    NSURLRequest *request = [self logoutWithToken:token error:&error];
    
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self logoutCompletionHandler:success failure:failure]];

    [task resume];
    
}


- (NSURLRequest*)logoutWithToken:(NSString*)token error:(NSError**)error {
    // JSON data
    
    NSData *data = [self  logoutJSONDataWithToken:token];
    
    if ( !data ) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"NSJSONSerialization" code:0 userInfo:nil];
        }
        return nil;
    }
    
    // Build request
    
    NSURL *URL = [self URLWithPath:kNetworkingLogoutURLString params:nil];
    NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data];
    
    return request;
}

- (NSData*) logoutJSONDataWithToken:(NSString*)token{
    // Build request parameters
    
    NSMutableDictionary *params = [[self parametersWithEntriesFromDictionary:@{
        @"token" : token,
    }] mutableCopy];
    
    // Encode JSON
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if ( !data ) {
        NSLog(@"[Networking+User loginJSONDataWithEmail]: Unable to serialize parameters: %@", error);
    }
    
    return data;
}
- (TWNSURLSessionJSONDataTaskCompletionHandler) logoutCompletionHandler:(void(^)(NSHTTPURLResponse *response, LoginResponse *data))success failure:(TWNFailureHandler)failure {
    return ^(id json, NSHTTPURLResponse *response, NSError *error) {
        NSInteger statusCode = [response statusCode];
        if (statusCode == 400 || statusCode == 403) {
              failure(response,error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(response, [LoginResponse responseWithJSON:json]);
            });
        }
        
    };
}



@end
