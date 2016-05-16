//
//  ClothingItem.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClothingItem.h"
#import "PRClothingItem+CoreDataProperties.h"

@interface ClothingItem()
@property (strong, nonatomic) NSDictionary *properties;
@property (strong,nonatomic) NSData *photoData;
@end

@implementation ClothingItem
-(void)deleteItem{
    
    [PRClothingItem deleteItemWithId:self.clothing_id];
}

-(void)saveItem:(NSString *)closet_id{

    [PRClothingItem saveItemWithId:self toCloset:closet_id];
}
- (id) initWithDictionary:(NSDictionary *)aDictionary
{
    if ( ![aDictionary isKindOfClass:[NSDictionary class]] ) {
        return nil;
    }

    // Preprocess: convert account_id to string
    
    if ((self = [super init])) {
        _properties = aDictionary;
    }
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
    return self;
}
- (NSDictionary *)dictionaryRepresentation
{
    return self.properties;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    // Preprocess
    
    /*if ( [key isEqualToString:@"board_id"] && [value isKindOfClass:[NSNumber class]] ) {
        value = [value stringValue];
    }*/
    // Safety check
    
    if ( value == nil ) {
        value = [NSNull null];
    }
    
    // Mutate
    NSMutableDictionary *dictionary = [self.properties mutableCopy];
    dictionary[key] = value;
    self.properties = dictionary;
}

- (id) valueForUndefinedKey:(NSString *)key
{
    return [self.properties valueForKey:key];
}

@end
