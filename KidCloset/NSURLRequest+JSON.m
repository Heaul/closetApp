//
//  NSURLRequest+JSON.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "NSURLRequest+JSON.h"

@implementation NSURLRequest (JSON)

+ (instancetype) JSONRequestWithURL:(NSURL*)URL method:(NSString*)method body:(NSData*)body
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    request.HTTPMethod = method;
    request.HTTPBody = body;
    
    return request;
}
+ (instancetype) JSONRequestWithURL:(NSURL*)URL method:(NSString*)method body:(NSData*)body token:(NSString *)token
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:[@"Token " stringByAppendingString:token] forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = method;
    request.HTTPBody = body;
    
    return request;
}



@end

