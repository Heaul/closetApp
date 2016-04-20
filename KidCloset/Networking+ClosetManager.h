//
//  Networking+ClosetManager.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking.h"
#import "Closet.h"

@interface Networking (ClosetManager)
- (void) GETClosetWithSucessHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failureHandler:(TWNFailureHandler)failure;

-(void)createClosetWithCloset:(Closet*)closet SucessHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failureHandler:(TWNFailureHandler)failure;
- (void) GETClosetItemsWithId:(NSString *)closet_id sucessHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failureHandler:(TWNFailureHandler)failure;
- (void) GETClosetDefaultsWithSucessHandler:(void(^)(NSHTTPURLResponse *response, GetClothingItemsResponse *data))success failureHandler:(TWNFailureHandler)failure;
@end
