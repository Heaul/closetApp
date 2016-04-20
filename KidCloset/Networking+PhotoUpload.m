//
//  Networking+PhotoUpload.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking+PhotoUpload.h"
#import "NSURLRequest+JSON.h"
#import "NSURL+Params.h"
#import "NSURLSession+JSONTask.h"

NSString * const kNetworkingTestURL = @"home/closet/";
NSString * const kNetworkingDeleteURL = @"home/delete/";

@implementation Networking (PhotoUpload)


-(void)createClothingItem:(ClothingItem *)closet SucessHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failureHandler:(TWNFailureHandler)failure{

    NSError *error;
    NSURLRequest *request = [self createClothingRequest:closet error:&error];
        
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self createClothingCompletionHandler:success failure:failure]];
    
    [task resume];

}

- (NSURLRequest*) createClothingRequest:(ClothingItem *)clothingItem error:(NSError**)error {
    // JSON data
    
    NSData *data = [self  createJSONDataWithItem:clothingItem];
    if ( !data ) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"NSJSONSerialization" code:0 userInfo:nil];
        }
        return nil;
    }
    
    // Build request
    
    NSURL *URL = [self URLWithPath:kNetworkingTestURL params:nil];
    NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data token:[self getToken]];
    //[NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data];
    
    return request;
}

- (NSData*) createJSONDataWithItem:(ClothingItem*)clothingItem{
    // Build request parameters
    
    NSMutableDictionary *params = [[self parametersWithEntriesFromDictionary:@{
        @"photoData": [clothingItem valueForUndefinedKey:@"photoData"],
        @"type" : [clothingItem valueForUndefinedKey:@"type"],
        @"size" : [clothingItem valueForUndefinedKey:@"size"],
         @"closet_id" : [clothingItem valueForUndefinedKey:@"closet_id"],
         @"gender" : [clothingItem valueForUndefinedKey:@"gender"],
        
    }] mutableCopy];
    
    if ([clothingItem.season length] > 0) {
        params[@"season"] = [clothingItem valueForKey:@"season"];
    }else{
         params[@"season"] = @"all";
    }
    if (clothingItem.tags) {
        params[@"tags"] = clothingItem.tags;
    }
    if (clothingItem.clothing_id) {
        params[@"clothing_id"] = clothingItem.clothing_id;
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

- (TWNSURLSessionJSONDataTaskCompletionHandler) createClothingCompletionHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failure:(TWNFailureHandler)failure {
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

-(void)deleteClothingItem:(ClothingItem *)closet SucessHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failureHandler:(TWNFailureHandler)failure{


    NSError *error;
    NSURLRequest *request = [self deleteClothingRequest:closet error:&error];
        
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self createClothingCompletionHandler:success failure:failure]];
    
    [task resume];


}
- (NSURLRequest*) deleteClothingRequest:(ClothingItem *)clothingItem error:(NSError**)error {
    // JSON data
    
    NSData *data = [self  deleteJSONDataWithItem:clothingItem];
    if ( !data ) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:@"NSJSONSerialization" code:0 userInfo:nil];
        }
        return nil;
    }
    
    // Build request
    
    NSURL *URL = [self URLWithPath:kNetworkingDeleteURL params:nil];
    NSURLRequest *request = [NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data token:[self getToken]];
    //[NSURLRequest JSONRequestWithURL:URL method:@"POST" body:data];
    
    return request;
}

- (NSData*) deleteJSONDataWithItem:(ClothingItem*)clothingItem{
    // Build request parameters
    
    NSMutableDictionary *params = [[self parametersWithEntriesFromDictionary:@{
         @"clothing_id" : clothingItem.clothing_id,
        
    }] mutableCopy];
    
    // De-encode the email for json data
    // Encode JSON
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    if ( !data ) {
        NSLog(@"[Networking+User loginJSONDataWithEmail]: Unable to serialize parameters: %@", error);
    }
    
    return data;
}


/*
-(void) uploadPhotoWithImage:(NSString *)email password:(NSString *)password success:(void(^)(NSHTTPURLResponse *response, SignUpResponse *data))success failureHandler:(TWNFailureHandler)failure {
    
    NSError *error;
   // NSURLRequest *request = [self signUpWithEmail:email password:password error:&error];
    
    if (!request) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(nil, error);
        });
    }
    
    //NSURLSessionTask *task = [self.session JSONDataTaskWithRequest:request completionHandler:[self signUpCompletionHandler:success failure:failure]];

   // [task resume];
}

- (NSURLRequest*) uploadImage:(NSString*)image password:(NSString*)password error:(NSError**)error {
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
}*/

@end
