//
//  Networking.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking.h"
#import "NSURLRequest+JSON.h"
#import "NSURL+Params.h"
#import "NSURLSession+JSONTask.h"
NSString *const kNetworkingBaseURLString = @"http://kidcloset-basementpjr.rhcloud.com/";
//NSString *const kNetworkingBaseURLString = @"http://192.168.0.5:8000";
//NSString *const kNetworkingBaseURLString = @"http://localhost:8000/";
@implementation Networking

+ (Networking*)sharedInstance {
    static dispatch_once_t once;
    static Networking *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        // Default timeout interval of 60 seconds on session configuration object may be too long
    });
    return sharedInstance;
}

-(BOOL)userIsLoggedIn{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"closetToken"]) {
        return YES;
    }
    return NO;

}
- (NSDictionary*) parametersWithEntriesFromDictionary:(NSDictionary*)entries {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params addEntriesFromDictionary:entries];
    //params[@"signature"] = [self hashedStringWithParams:params];
    
    return [params copy];
}

- (NSURL*) URLWithPath:(NSString*)path params:(NSDictionary*)params {
    return [NSURL URLWithHost:kNetworkingBaseURLString path:path params:params];
    // return [NSURL URLWith8i889Host:alpha_kNetworkingBaseURLString path:path params:params];
}

-(NSString *)currentCloset{
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"PRClostId"];
}

-(void)changeCloset:(NSString *)closet_id{
 [[NSUserDefaults standardUserDefaults] setObject:closet_id forKey:@"PRClostId"];
}
-(void)saveToken:(NSString *)token{
 [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"closetToken"];
}

-(void)clearToken{
 [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"closetToken"];
}

-(NSString *)getToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"closetToken"];
}


@end
