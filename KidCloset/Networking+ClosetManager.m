//
//  Networking+ClosetManager.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking+ClosetManager.h"
#import "GetClothingItemsResponse.h"
#import "NSURLRequest+JSON.h"
#import "NSURLSession+JSONTask.h"
NSString * const kNetworkingInvetoryString = @"home/create/";
NSString * const kNetworkingCreateClosetString = @"home/create/";
NSString * const kNetworkingClosetItems = @"/home/closet/";
NSString * const kNetworkingClosetItemDefaults = @"/home/defaults/";

@implementation Networking (ClosetManager)



- (void) createClosetWithCloset:(Closet*)closet SucessHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failureHandler:(TWNFailureHandler)failure {

        NSError *error;
        NSURLRequest *request = [self createClosetRequest:closet error:&error];
        NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self createClosetCompletionHandler:success failure:failure]];
    
   
    
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    [task resume];
}
- (NSURLRequest*) createClosetRequest:(Closet*)closet error:(NSError**)error{
    // Default paging values
 
    // Build request
    
    NSData *data = [self  closetJSONDataWithCloset:closet];
    
    if ( !data ) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"NSJSONSerialization" code:0 userInfo:nil];
        }
        return nil;
    }
    
    // Build request
    
    NSURL *URL = [self URLWithPath:kNetworkingCreateClosetString params:nil];
    NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data token:[self getToken]];

    return request;
}
- (NSData*) closetJSONDataWithCloset:(Closet*)closet{

    NSMutableDictionary *defaults = [closet.defaultSizes mutableCopy];

    if ([[defaults allKeys] containsObject:@"id"]) {
        [defaults removeObjectForKey:@"id"];
    }
    NSMutableDictionary *defaultsAmounts = [closet.defaultAmounts mutableCopy];

    if ([[defaultsAmounts allKeys] containsObject:@"id"]) {
        [defaultsAmounts removeObjectForKey:@"id"];
    }
    if ([[defaultsAmounts allKeys] containsObject:@"current_closet"]) {
            [defaultsAmounts removeObjectForKey:@"current_closet"];
    }
    if ([[defaults allKeys] containsObject:@"current_closet"]) {
            [defaults removeObjectForKey:@"current_closet"];
    }
    
    
    // Build request parameters
    NSMutableDictionary *params;
    if (closet.closet_id) {
    
    
        params= [[self parametersWithEntriesFromDictionary:@{
            @"name": closet.closetName,
            @"gender" : closet.gender,
             @"age" : closet.age,
             @"closet_id" : closet.closet_id,
             @"defaultSizes":[defaults copy],
              @"defaultAmounts":[defaultsAmounts copy],
        }] mutableCopy];
        
    }else{
       params= [[self parametersWithEntriesFromDictionary:@{
            @"name": [closet valueForUndefinedKey:@"name"],
            @"gender" : [closet valueForUndefinedKey:@"gender"],
            @"age" : [closet valueForUndefinedKey:@"age"],
            @"defaultSizes":[defaults copy],
            @"defaultAmounts":[defaultsAmounts copy],
        }] mutableCopy];
    }

    
    // De-encode the email for json data
    // Encode JSON
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if ( !data ) {
        NSLog(@"[Networking+User loginJSONDataWithEmail]: Unable to serialize parameters: %@", error);
    }
    
    return data;
}




- (TWNSURLSessionJSONDataTaskCompletionHandler) createClosetCompletionHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failure:(TWNFailureHandler)failure {
    return ^(id json, NSHTTPURLResponse *response, NSError *error) {
        NSInteger statusCode = [response statusCode];
        if (statusCode == 400 || statusCode == 403) {
              failure(response,error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(response, json);
            });
        }
        
    };
}

- (void) GETClosetDefaultsWithSucessHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failureHandler:(TWNFailureHandler)failure {

    NSURLRequest *request = [self GETclothingItemDefaults];
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self GETClosetCompletionHandler:success failure:failure]];
    [task resume];
}

- (NSURLRequest*) GETclothingItemDefaults {
    // Default paging values
 
    
    // Build request
    
    //NSDictionary *params = [self GETPinsParameters];
    
    NSURL *URL = [self URLWithPath:kNetworkingClosetItems params:nil];
     NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"GET" body:nil token:[self getToken]];

    return request;
}

- (void) GETClosetWithSucessHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failureHandler:(TWNFailureHandler)failure {

    NSURLRequest *request = [self GETclothingItems];
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self GETClosetCompletionHandler:success failure:failure]];
    
    [task resume];
}

- (NSURLRequest*) GETclothingItems {
    // Default paging values
 
    
    // Build request
    
    //NSDictionary *params = [self GETPinsParameters];
    
    NSURL *URL = [self URLWithPath:kNetworkingInvetoryString params:nil];
     NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"GET" body:nil token:[self getToken]];

    return request;
}

- (void) GETClosetItemsWithId:(NSString *)closet_id sucessHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failureHandler:(TWNFailureHandler)failure {

    NSURLRequest *request = [self GETClosetItemRequestWith:closet_id];
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self GETClosetItemsCompletionHandler:success failure:failure]];
    
    [task resume];
}

- (NSURLRequest*) GETClosetItemRequestWith:(NSString *)closet_id {
    // Default paging values
 
    NSMutableDictionary *params;
    // Build request
    if (closet_id) {
        params = [[self parametersWithEntriesFromDictionary:@{
            @"id": closet_id,
        }] mutableCopy];
    }else{
            params = [[self parametersWithEntriesFromDictionary:@{
        }] mutableCopy];
    }
    
    //NSDictionary *params = [self GETPinsParameters];
     NSError *error;
     NSURL *URL = [self URLWithPath:kNetworkingClosetItems params:params];

     NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"GET" body:nil token:[self getToken]];

    return request;
}

- (TWNSURLSessionJSONDataTaskCompletionHandler) GETClosetItemsCompletionHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failure:(TWNFailureHandler)failure {
    return ^(id json, NSHTTPURLResponse *response, NSError *error) {
        NSInteger statusCode = [response statusCode];
        if (statusCode != 200) {
              failure(response,error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(response, [GetClothingItemsResponse responseWithJSON:json]);
            });
        }
        
    };
}

- (TWNSURLSessionJSONDataTaskCompletionHandler) GETClosetCompletionHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failure:(TWNFailureHandler)failure {
    return ^(id json, NSHTTPURLResponse *response, NSError *error) {
        NSInteger statusCode = [response statusCode];
        if (statusCode  != 200) {
              failure(response,error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                success(response, [GetClothingItemsResponse responseWithJSON:json]);
            });
        }
        
    };
}


- (NSDictionary*) createClosetParameters {
    return [self parametersWithEntriesFromDictionary:@{
        
    }];
}
- (NSDictionary*) GETPinsParameters {
    return [self parametersWithEntriesFromDictionary:@{
        @"token" : [self getToken]
    }];
}

@end
