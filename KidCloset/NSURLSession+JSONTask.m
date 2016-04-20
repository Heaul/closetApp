//
//  NSURLSession+JSONTask.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "NSURLSession+JSONTask.h"

@implementation NSURLSession (JSONTask)

- (NSURLSessionTask *) JSONDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(id data, NSHTTPURLResponse *response, NSError *error))completionHandler
{
    NSURLSessionTask *task = [self dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // DEBUG:
        // NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        id json = nil;
        if (data && !error) {
            json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
        
        completionHandler(json, (NSHTTPURLResponse*)response, error);
    }];
    
    return task;
}

@end