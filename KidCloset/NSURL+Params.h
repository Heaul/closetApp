//
//  NSURL+NSURL_Params.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/3/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Params)

+ (instancetype) URLWithHost:(NSString*)host path:(NSString*)path params:(NSDictionary*)params;

@end