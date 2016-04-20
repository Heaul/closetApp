//
//  Networking+PhotoUpload.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Networking.h"
#import "ClothingItem.h"

@interface Networking (PhotoUpload)

-(void)createClothingItem:(ClothingItem *)closet SucessHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failureHandler:(TWNFailureHandler)failure;

-(void)deleteClothingItem:(ClothingItem *)closet SucessHandler:(void(^)(NSHTTPURLResponse *response, NSDictionary *data))success failureHandler:(TWNFailureHandler)failure;
@end
