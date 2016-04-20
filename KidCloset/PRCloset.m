//
//  PRCloset.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "PRCloset.h"
#import "Closet.h"
#import "ClothingItem.h"
#import "PRClothingItem+CoreDataProperties.h"
#import "PRDefaultSizes+CoreDataProperties.h"
#import "PRDefaultAmounts+CoreDataProperties.h"
#import "PRTag.h"
@implementation PRCloset

// Insert code here to add functionality to your managed object subclass

+(BOOL)closetExists:(NSString *)closet_id{

    NSString * c_id;
    if ([closet_id isKindOfClass:[NSNumber class]]) {
        c_id = [(NSNumber *)closet_id stringValue];
    }else{
        c_id = closet_id;
    }
    
    PRCloset *checker =  [PRCloset MR_findFirstByAttribute:@"closet_id"
                                       withValue:closet_id];
    if (checker) {
        return YES;
    }
    return NO;
}

+(void)updateCloests:(NSArray *)closets{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
        for(NSInteger i = 0;i<[closets count];i++){
            Closet *cl = closets[i];
            
            NSString *c_id;
            if ([cl.closet_id isKindOfClass:[NSNumber class]]) {
                c_id = [(NSNumber *)cl.closet_id stringValue];
            }else{
                c_id = cl.closet_id;
            }
            PRCloset *closet = [PRCloset closetForId:c_id context:localContext];
            if (!closet) {
                    closet = [PRCloset MR_createEntityInContext:localContext];
            }
            
            [closet closetUpdateCore:cl context:localContext];
        }
    }];
}

+(NSArray *)allClothingItemsOfType:(NSString *)type{
    return [PRClothingItem MR_findByAttribute:@"type" withValue:type andOrderBy:@"size" ascending:YES];
}

+(NSArray *)tags{
    NSArray *tags = [[PRTag MR_findAll] valueForKey:@"name"];
    NSSet *set = [[NSSet alloc]initWithArray:tags];
    return [[NSArray alloc]initWithArray:[set allObjects]];
}

+(NSArray *)currentClosets{
   NSArray * closets =  [PRCloset MR_findAllSortedBy:@"closet_id" ascending:YES];
   NSMutableArray *closetsArr = [[NSMutableArray alloc]init];
   for(NSInteger i = 0;i<[closets count];i++){
        PRCloset *closet  = closets[i];
        NSDictionary *dict = [closet dictionaryRepresentation];
        [closetsArr addObject:dict];
   }
   return closetsArr;
}
-(NSDictionary *)dictionaryRepresentation{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSArray *itemSet = [self.prdefaultamounts allObjects];
    NSMutableDictionary *amountDict = [[NSMutableDictionary alloc]init];
    for (NSInteger i = 0; i < [itemSet count] ; i++) {
        PRDefaultAmounts *amounts = itemSet[i];
                amountDict[amounts.type] = amounts.amount;
    }
    NSArray *itemSizeKeys = [self.prdefaultsizes allObjects];
    NSMutableDictionary *sizeDict = [[NSMutableDictionary alloc]init];
    for (NSInteger i = 0; i < [itemSizeKeys count] ; i++) {
        PRDefaultSizes *sizes = itemSizeKeys[i];
        sizeDict[sizes.type] = sizes.clothingSize;
    }
    NSMutableArray *itemArr = [[NSMutableArray alloc]init];
    NSArray *items = [self.prclothingitem allObjects];
    
    for (NSInteger i = 0; i < [items count] ; i++) {
        NSMutableDictionary *currentItemDict = [[NSMutableDictionary alloc]init];
        PRClothingItem *item = items[i];
        currentItemDict[@"clothing_type"] = item.type;
        currentItemDict[@"season"] = item.season;
        currentItemDict[@"gender"] = item.gender;
        currentItemDict[@"id"] = item.item_id;
        currentItemDict[@"item_image"] = item.imageUrl;
        currentItemDict[@"size"] = item.size;
        currentItemDict[@"sex"] = item.gender;
        NSArray *itemTags = [item.prtag allObjects];
        NSMutableArray *tagStrings = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i<[itemTags count]; i++) {
            PRTag *tag = itemTags[i];
            [tagStrings addObject:tag.name];
        }
        if ([tagStrings count] > 0) {
            currentItemDict[@"current_item"] = [tagStrings copy];
        }
        [itemArr addObject:currentItemDict];
    }
    
    dict[@"closet_id"] = self.closet_id;
    dict[@"age"] = self.age;
    dict[@"defaults"] = amountDict;
    dict[@"sizes"] = sizeDict;
    dict[@"sex"] = self.gender;
    dict[@"name"] = self.name;
    dict[@"items"] = itemArr;
    return dict;
}
/*
+(void)createClothingWithItem:(PRClothingItem){

}*/
+(PRCloset *)closetForId:(NSString *)closet_id{
    PRCloset *checker;
    if ([PRCloset closetExists:closet_id]) {
          checker =  [PRCloset MR_findFirstByAttribute:@"closet_id"
                                       withValue:closet_id];
            return  checker;
    }
    else{
        return nil;
    }
}


+(PRCloset *)closetForId:(NSString *)closet_id context:(NSManagedObjectContext *)context{
    PRCloset *checker;
    if ([PRCloset closetExists:closet_id]) {
          checker =  [PRCloset MR_findFirstByAttribute:@"closet_id"
                                       withValue:closet_id inContext:context];
            return  checker;
    }
    else{
        return nil;
    }
}

-(void)updateDefaultAmounts:(NSDictionary *)amounts withId:(NSString *)closet_id  context:(NSManagedObjectContext *)context{
    NSArray *keys = [amounts allKeys];
    NSMutableSet *sizesSet = [[NSMutableSet alloc]init];
    for (NSInteger i = 0; i< [keys count]; i++) {
        NSNumber *sizeNumber;
        if ([amounts[keys[i]] isKindOfClass:[NSNumber class]]){
            sizeNumber =  [NSNumber numberWithInteger:[(NSString *)amounts[keys[i]] integerValue]];
        }else{
            sizeNumber = amounts[keys[i]];
        }
        
       NSPredicate *sizeFilter = [NSPredicate predicateWithFormat:@"prcloset.closet_id == %@ AND type == %@ ", closet_id,  keys[i]];
       PRDefaultAmounts *defaultAmount = [PRDefaultAmounts MR_findFirstWithPredicate:sizeFilter inContext:context];
       
       if (!defaultAmount) {
            defaultAmount = [PRDefaultAmounts MR_createEntityInContext:context];
        }
       
        defaultAmount.amount = sizeNumber;
        defaultAmount.type = keys[i];
        [sizesSet addObject:defaultAmount];
    }
    
    [self addPrdefaultamounts:sizesSet];

}
+(void)clean{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){

        [PRCloset MR_truncateAllInContext:localContext];
        [PRClothingItem MR_truncateAllInContext:localContext];
        [PRTag MR_truncateAllInContext:localContext];
        [PRDefaultAmounts MR_truncateAllInContext:localContext];
        [PRDefaultSizes  MR_truncateAllInContext:localContext];
    }];
}
-(void)updateSizes:(NSDictionary *)sizes withId:(NSString *)closet_id  context:(NSManagedObjectContext *)context{
    NSArray *keys = [sizes allKeys];
    NSMutableSet *sizesSet = [[NSMutableSet alloc]init];
    for (NSInteger i = 0; i< [keys count]; i++) {
        NSString *sizeNumber;
        if ([sizes[keys[i]] isKindOfClass:[NSNumber class]]){
            sizeNumber = [(NSNumber *)sizes[keys[i]] stringValue];
        }else{
            sizeNumber =sizes[keys[i]];
        }
        
       NSPredicate *sizeFilter = [NSPredicate predicateWithFormat:@"prcloset.closet_id == %@ AND type == %@ ", closet_id,  keys[i]];
       PRDefaultSizes *defaultSizes = [PRDefaultSizes MR_findFirstWithPredicate:sizeFilter inContext:context];
       if (!defaultSizes) {
            defaultSizes = [PRDefaultSizes MR_createEntityInContext:context];
        }
       
        defaultSizes.clothingSize = sizeNumber;
        defaultSizes.type = keys[i];
        [sizesSet addObject:defaultSizes];
    }
    [self addPrdefaultsizes:sizesSet];

}
-(void)closetUpdateCore:(Closet *)closet context:(NSManagedObjectContext *)context{
   // PRCloset *cd_closet = [PRCloset MR_findFirstByAttribute:@"FirstName"
                                      // withValue:@"Forrest"];
        self.name = closet.closetName;
        self.age = closet.age;
        self.gender = closet.gender;
        self.closet_id = closet.closet_id;
    
        NSArray *keys =  closet.clothingItems.allKeys;
        NSMutableSet *itemArray = [[NSMutableSet alloc]init];
    
        for(NSInteger i = 0;i<[keys count];i++){
        
            NSArray *clothingItems = [closet clothingItemForKey:keys[i]];
            
            for (NSInteger j = 0; j < [clothingItems count]; j++) {
            
                ClothingItem *cItem = clothingItems[j];
                
                PRClothingItem *clothing;
                clothing = [PRCloset itemForId:cItem.clothing_id inContext:context];
                if (!clothing) {
                     clothing = [PRClothingItem MR_createEntityInContext:context];
                    [clothing createWithItem:clothingItems[j] inContext:context];
                    clothing.prcloset = self;
                    [itemArray addObject:clothing];
                }else{
                    [clothing createWithItem:clothingItems[j] inContext:context];
                }

            }
        }
        
        [self addPrclothingitem:itemArray];
        [self updateDefaultAmounts:closet.defaultAmounts withId:closet.closet_id context:context];
        [self updateSizes:closet.defaultSizes withId:closet.closet_id context:context];
    
}

+(NSArray *)allTags{
    NSArray *x =  [PRTag MR_findAll];
    PRTag *tag = x[0];
    NSLog(tag.name);
    return x;
}

+(NSArray *)clothingItemsWithTag:(NSString*)tag{

    NSArray *tags =  [PRTag MR_findByAttribute:@"name" withValue:tag];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    for (NSInteger i = 0;i < [tags count];i++){
        PRTag * tagItem = tags[i];
        ClothingItem *clothingItemWithTag =  [[ClothingItem alloc]initWithDictionary:[tagItem.prclothingitem dictionaryRepresentation]];
        [items addObject:clothingItemWithTag];
    }
    return [items copy];
}
+(PRClothingItem *)itemForId:(NSString *)item_id inContext:(NSManagedObjectContext *)context{

    NSString * c_id = item_id;
    if ([item_id isKindOfClass:[NSNumber class]]) {
        c_id = [(NSNumber *)item_id stringValue];
    }else{
        c_id = item_id;
    }
    PRClothingItem* checker =  [PRClothingItem MR_findFirstByAttribute:@"item_id" withValue:c_id inContext:context];
  
    return checker;
}

+(NSNumber *)numberOfItemsWithTag:(NSString *)tag{
   NSPredicate *tagFilter = [NSPredicate predicateWithFormat:@"name == %@ ",tag];
    return  [PRTag MR_numberOfEntitiesWithPredicate:tagFilter];
}



@end
