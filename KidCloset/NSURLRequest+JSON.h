//
//  NSURLRequest+JSON.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (JSON)

+ (instancetype) JSONRequestWithURL:(NSURL*)URL method:(NSString*)method body:(NSData*)body;
+ (instancetype) JSONRequestWithURL:(NSURL*)URL method:(NSString*)method body:(NSData*)body token:(NSString *)token;
@end
