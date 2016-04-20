//
//  NSURLSession+JSONTask.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (JSONTask)
- (NSURLSessionTask *) JSONDataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(id data, NSHTTPURLResponse *response, NSError *error))completionHandler;

@end
