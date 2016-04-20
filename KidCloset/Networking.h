//
//  Networking.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignUpResponse.h"
#import "LoginResponse.h"
#import "GetClothingItemsResponse.h"


typedef void (^TWNSURLSessionJSONDataTaskCompletionHandler)(id data, NSHTTPURLResponse *response, NSError *error);

// Custom Success and Failure Handlers

typedef void (^TWNSuccessHandler)(NSHTTPURLResponse *response, NSDictionary *json);
typedef void (^TWNFailureHandler)(NSHTTPURLResponse *response, NSError *error);
extern NSString * const kNetworkingBaseURLString;

@interface Networking : NSObject
@property (strong, nonatomic) NSURLSession *session;
+ (Networking*) sharedInstance;

- (NSURL*) URLWithPath:(NSString*)path params:(NSDictionary*)params;
- (NSDictionary*) parametersWithEntriesFromDictionary:(NSDictionary*)entries;
-(BOOL)userIsLoggedIn;
-(void)saveToken:(NSString *)token;
-(void)clearToken;
-(NSString *)getToken;
-(void)changeCloset:(NSString *)closet_id;
-(NSString *)currentCloset;
 @end
