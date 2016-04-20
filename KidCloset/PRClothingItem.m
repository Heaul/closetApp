//
//  PRClothingItem.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "PRClothingItem.h"
#import "ClothingItem.h"
#import  "PRTag.h"
#import "PRCloset+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation PRClothingItem

-(id)initWithDictionary{
    self = [super init];
    if (self) {
    
    }
    return self;
}
/*

    if(aDictionary[@"current_item"]){
        NSArray *tagsArray = aDictionary[@"current_item"];
        if ([tagsArray count] > 0){
            self.tags = tagsArray;
        }
    }
    _clothingType = aDictionary[@"clothing_type"];
    _imageURL = aDictionary[@"item_image"];
    _sex = aDictionary[@"gender"];
    _season = aDictionary[@"season"];
    _size = aDictionary[@"size"];
    if ([aDictionary[@"id"] isKindOfClass:[NSNumber class]]) {
        _clothing_id = [aDictionary[@"id"] stringValue];
    }else{
        _clothing_id = aDictionary[@"id"];
    }
    
    */
-(NSDictionary *)dictionaryRepresentation{

    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    dict[@"clothing_type"] = self.type;
    dict[@"item_image"] = self.imageUrl;
    dict[@"gender"] = self.gender;
    dict[@"id"] = self.item_id;
    dict[@"size"] = self.size;
    dict[@"season"] = self.season;
    if (self.prtag && [self.prtag count] > 0) {
        NSArray *tags = [[self.prtag allObjects] valueForKey:@"name"];
        dict[@"current_item"] = tags;
    }
    return [dict copy];
}
-(void)createWithItem:(ClothingItem *)item inContext:(NSManagedObjectContext *)context{
    self.type = item.clothingType;
    self.size = item.size;
    self.season = item.season;
    self.imageUrl = item.imageURL;
    if ([item.clothing_id isKindOfClass:[NSNumber class]]) {
        self.item_id = [(NSNumber *)item.clothing_id stringValue];
    }else{
        self.item_id = item.clothing_id;
    }
    self.gender = item.sex;
    NSMutableSet *tempSet = [[NSMutableSet alloc]init];
    
    NSPredicate *toDelete = [NSPredicate predicateWithFormat:@"prclothingitem.item_id == %@", self.item_id];
    
    [PRTag MR_deleteAllMatchingPredicate:toDelete inContext:context];
    if(item.tags && [item.tags count] > 0){
        for (NSInteger i = 0; i<[item.tags count]; i++) {
            PRTag *tag = [PRTag MR_createEntityInContext:context];
            tag.name = item.tags[i];
            tag.prclothingitem = self;
            [tempSet addObject:tag];
            
        }
        [self addPrtag:[tempSet copy]];
    }
    
}
+(void)saveItemWithId:(ClothingItem *)clothing toCloset:(NSString *)closet_id{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        PRCloset *closet = [PRCloset MR_findFirstByAttribute:@"closet_id" withValue:closet_id inContext:localContext];
        PRClothingItem *item =  [PRClothingItem MR_findFirstByAttribute:@"item_id" withValue:clothing.clothing_id inContext:localContext];
        if (!item) {
            item = [PRClothingItem MR_createEntityInContext:localContext];
            [item createWithItem:clothing inContext:localContext];
            item.prcloset = closet;
            [closet addPrclothingitemObject:item];
        }else{
            [item createWithItem:clothing inContext:localContext];
        }

    }];
}

+(void)deleteItemWithId:(NSString *)clothing_id{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        PRClothingItem *item =  [PRClothingItem MR_findFirstByAttribute:@"item_id" withValue:clothing_id inContext:localContext];
        [item MR_deleteEntity];
    }];
}
// Insert code here to add functionality to your managed object subclass

@end
