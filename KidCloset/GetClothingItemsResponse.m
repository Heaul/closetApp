 //
//  GetClothingItemsResponse.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "GetClothingItemsResponse.h"
#import "Closet.h"
#import "NSArray+Functional_Utilities.h"

@implementation GetClothingItemsResponse

- (id) initWithJSONRepresentation:(NSDictionary*)aDict {
        if ((self = [super init])) {

        NSError *e = nil;
        NSDictionary *aDictionary;
        NSArray *closets;
        NSNumber *primaryIndex = @(0);
        NSMutableArray *closetTempArray = [[NSMutableArray alloc]init];
        if (aDict[@"closetList"]) {
            primaryIndex = aDict[@"primaryIndex"];
            closets = aDict[@"closetList"];
            aDictionary = closets[[primaryIndex integerValue]];
            
            self.closetsExist = YES;
            for (NSInteger i = 0; i< [closets count]; i++) {
                 aDictionary = closets[i];
                if (aDictionary[@"closets"]) {
                    _closets = [NSJSONSerialization JSONObjectWithData:[aDictionary[@"closets"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableLeaves error: &e];
                }
                if (aDictionary[@"defaults"]) {
                    _defaults =[NSJSONSerialization JSONObjectWithData:[aDictionary[@"defaults"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableLeaves error: &e];
                }
                if (aDictionary[@"items"]) {
                    _items = [NSJSONSerialization JSONObjectWithData:[aDictionary[@"items"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableLeaves error: &e];
                }
                if (aDictionary[@"sizes"]) {
                    _sizes = [NSJSONSerialization JSONObjectWithData:[aDictionary[@"sizes"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableLeaves error: &e];
                }
                 NSMutableDictionary *closetTemp = [[NSMutableDictionary alloc]init];
                
                closetTemp[@"closet_id"] = _defaults[@"id"];
                closetTemp[@"name"] = _defaults[@"name"];
                closetTemp[@"age"] = _defaults[@"age"];
                closetTemp[@"sex"] = _defaults[@"sex"];
                closetTemp[@"items"] = _items;
                closetTemp[@"defaults"] = _closets[0];
                closetTemp[@"sizes"] = _sizes[0];
                if(closets[[primaryIndex integerValue]]){
                
                    [closetTempArray addObject:[closetTemp copy]];
                    
                }
                _closetDict = [closetTemp copy];
                
            }
            _primaryIndex = [primaryIndex integerValue];
            Closet *closetToMove = [closetTempArray objectAtIndex:_primaryIndex];
            [closetTempArray removeObjectAtIndex:[primaryIndex integerValue]];
            [closetTempArray insertObject:closetToMove atIndex:0];
            _closetArray = [closetTempArray copy];
            
        }else{
            aDictionary = aDict;
            closets = @[aDictionary];
            self.closetsExist = NO;
            NSMutableDictionary *closetTemp = [[NSMutableDictionary alloc]init];
            closetTemp[@"defaults"] = [NSJSONSerialization JSONObjectWithData:[aDictionary[@"closets"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableLeaves error: &e];
            
            _closets = [NSJSONSerialization JSONObjectWithData:[aDictionary[@"closets"] dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableLeaves error: &e];
            
            _closetDict = [closetTemp copy];
        }

        
        
    }
    return self;
}

+ (id) responseWithJSON:(NSDictionary *)aDictionary {
    return [[GetClothingItemsResponse alloc] initWithJSONRepresentation:aDictionary];
}
@end
