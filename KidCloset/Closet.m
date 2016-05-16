//
//  Closet.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "Closet.h"
#import "ClothingItem.h"
#import "PRCloset.h"
#import "PRClothingItem.h"
#import "Networking+ClosetManager.h"
@interface Closet()
@property (strong, nonatomic) NSDictionary *properties;
@property NSDictionary *defaults;
@property NSDictionary *itemAmounts;
@property NSDictionary *itemSizes;
@property NSDictionary *clothingTypes;


@end

@implementation Closet
- (id) initWithKeys
{
    
    // Preprocess: convert account_id to string
    
    if ((self = [super init])) {
        _itemKeys =
            @[@"tops",@"bottoms",@"socks",@"underwear",@"shoes",@"swimwear",@"outerwear",@"dress_cloths",@"onesies",@"pajamas"];
        _defaultAmounts =            @{@"tops":@(10),@"bottoms":@(14),@"socks":@(14),@"underwear":@(14),@"shoes":@(3),@"swimwear":@(2),@"outerwear":@(2),@"dress_cloths":@(3),@"onesies":@(14),@"pajamas":@(10)};
        
    }
    
    return self;
}

+(NSDictionary *)standardAmounts{
    return @{@"tops":@(10),@"bottoms":@(14),@"socks":@(14),@"underwear":@(14),@"shoes":@(3),@"swimwear":@(2),@"outerwear":@(2),@"dress_cloths":@(3),@"onesies":@(14),@"pajamas":@(10)};

}


- (id) initWithDictionary:(NSDictionary *)aDictionary
{
    if ( ![aDictionary isKindOfClass:[NSDictionary class]] ) {
        return nil;
    }
    
    // Preprocess: convert account_id to string
    if ((self = [super init])) {
        _properties = aDictionary;
        _itemKeys =
            @[@"tops",@"bottoms",@"socks",@"underwear",@"shoes",@"swimwear",@"outerwear",@"dress_clothes",@"onesies",@"pajamas"];
    }
    return self;
}

-(id)initWithItems:(NSDictionary *)itemDict{
    if ((self = [super init])) {
    
        NSMutableArray *keys = [[itemDict[@"defaults"] allKeys] mutableCopy];
        [keys removeObject:@"id"];
        [keys removeObject:@"current_closet"];
        _itemKeys = [keys copy];
        
        NSMutableDictionary *items = [itemDict mutableCopy];
        if (items[@"closet_id"]) {
            if ([items[@"closet_id"] isKindOfClass:[NSNumber class]]) {
                self.closet_id = [(NSNumber*)items[@"closet_id"] stringValue];
            }else{
                self.closet_id = items[@"closet_id"];
            }
            [items removeObjectForKey:@"current_closet"];
        }
        
        if (items[@"name"]) {
            self.closetName = items[@"name"];
            [items removeObjectForKey:@"name"];
        }
        if (items[@"age"]) {
            self.age = items[@"age"];
        }
        if (items[@"sex"]) {
            self.gender = items[@"sex"];
        }
        
        _defaultAmounts = items[@"defaults"];
        _defaultSizes = items[@"sizes"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        for (NSInteger i = 0; i<[itemDict[@"items"] count]; i++) {
        
            NSDictionary *item = items[@"items"][i];
            ClothingItem *clothingItem = [[ClothingItem alloc]initWithDictionary:item];
            if (dict[clothingItem.clothingType]) {
                NSMutableArray * itemTemp = [dict[clothingItem.clothingType] mutableCopy];
                [itemTemp addObject:[[ClothingItem alloc]initWithDictionary:item]];
                dict[clothingItem.clothingType] = [itemTemp copy];
            }else{
                NSMutableArray * itemTemp = [[NSMutableArray alloc]init];
                [itemTemp addObject:[[ClothingItem alloc]initWithDictionary:item]];
                 dict[clothingItem.clothingType] = [itemTemp copy];
            }
            
        }
        
        _clothingItems = [dict copy];
    }
  return self;
}
+(NSArray *)allFilteredClothingItemsIn:(NSArray *)closets ofType:(NSString *)type withSize:(NSString *)size withTags:(NSArray *)tags withSeasons:(NSArray *)seasons{
    NSMutableArray *tempItemArray = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0; i<[closets count]; i++) {
        Closet *cl  = closets[i];
        [tempItemArray addObjectsFromArray:[cl clothingForKey:type withSize:size withSeasons:seasons withTags:tags]];
    }
    return [tempItemArray copy];
}

+(NSDictionary *)allClothingItemsOfTypeSortedBySize:(NSString *)type{
    NSArray *items = [Closet allClothingItemsOfType:type];
    
    
     NSMutableDictionary *itemsToReturn = [[NSMutableDictionary alloc]init];
    NSArray *sizes = [[[NSSet alloc]initWithArray:[items valueForKey:@"size"]] allObjects];
    
    for(NSInteger i = 0;i<[sizes count];i++){
        itemsToReturn[sizes[i]] = [[NSArray alloc]init];
    }
    
    for (NSInteger i = 0; i<[items  count]; i++) {
        ClothingItem *item = items[i];
        if (itemsToReturn[item.size]) {
            NSMutableArray *temp = [itemsToReturn[item.size] mutableCopy];
            [temp addObject:item];
            itemsToReturn[item.size] = [temp copy];
        }else{
             NSMutableArray *temp = [[NSMutableArray alloc]init];
             [temp addObject:item];
             itemsToReturn[item.size] = [temp copy];
        }
    }
    return [itemsToReturn copy];
    
    
}


+(NSArray *)allClothingItemsOfType:(NSString *)type withSize:(NSString *)size{
    NSArray *clothes = [Closet allClothingItemsOfType:type];
    NSMutableArray *clothesWithSize = [[NSMutableArray alloc]init];
    for(NSInteger i = 0;i<[clothes count];i++){
        if ([[clothes[i] valueForKey:@"size"] isEqualToString:size]) {
            [clothesWithSize addObject:clothes[i]];
        }
    }
    return [clothesWithSize copy];
}

+(NSArray *)allClothingItemsOfType:(NSString *)type{
    NSArray *cdClothes =  [PRCloset allClothingItemsOfType:type];
    NSMutableArray * normalClothes = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[cdClothes count]; i++) {
        PRClothingItem *cdItem = cdClothes[i];
        ClothingItem *item =  [[ClothingItem alloc]initWithDictionary:[cdItem dictionaryRepresentation]];
        [normalClothes addObject:item];
    }
    return normalClothes;
}

-(NSArray *)clothingItemForKey:(NSString *)key{

    return self.clothingItems[key];
}
-(NSInteger)clothingTypeCount{

    return [self.itemKeys count];
}

-(NSArray *)clothingForKey:(NSString *)key withSize:(NSString *)size withSeasons:(NSArray *)seasons withTags:(NSArray *)tags{
    
    NSMutableArray *filterdItems = [[NSMutableArray alloc]init];
    
    for(NSInteger i = 0;i< [self.clothingItems[key] count]; i++) {
        ClothingItem *item = self.clothingItems[key][i];
        if ([seasons containsObject:[item.season lowercaseString] ] && size && [size caseInsensitiveCompare:item.size] == NSOrderedSame) {
            if ([tags count] > 0) {
                BOOL hasTag= NO;
                for (NSInteger j = 0; j < [tags count]; j++) {
                    if (hasTag == YES) {
                        break;
                    }
                    for(NSInteger u = 0; u < [item.tags count];u++){
                        if ([[tags[j] lowercaseString] isEqualToString:[item.tags[u] lowercaseString]]) {
                            hasTag = YES;
                            break;
                        }
                    }
                }
                if (hasTag == YES) {
                    [filterdItems addObject:item];
                }
            }else{//no tags to filter by just add the item
                [filterdItems addObject:item];
            }
        }
    }
    if ([filterdItems count] > 0) {
        return [filterdItems copy];
    }
    return @[];
}

-(NSInteger)clothingCountForKey:(NSString *)key withSize:(NSString *)size{

    NSArray *clothingArray = [self.clothingItems[key] valueForKey:@"size"];
    NSInteger counter = 0;
    for (NSInteger i =0; i<[clothingArray count]; i++) {
        if ([clothingArray[i] isEqualToString:size]) {
            counter++;
        }
    }
    return counter;
}
-(NSInteger)clothingCountForSize:(NSString *)size{

    NSArray *clothingArray = [[self.clothingItems allValues] valueForKey:@"size"];
    NSInteger counter = 0;
    for (NSInteger i =0; i<[clothingArray count]; i++) {
        if ([clothingArray[i] isEqualToString:size]) {
            counter++;
        }
    }
    return counter;
    
}
-(NSDictionary *)clothingAmountsForKey:(NSString *)key{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSArray * sizes =[[[NSSet alloc]initWithArray:[self.clothingItems[key] valueForKey:@"size"]] allObjects];
    NSString *sizeNeededForItem = [self clothingSizeForKey:key];
    
    if (![sizes containsObject:sizeNeededForItem]) {
        NSMutableArray *sizeTemp = [sizes mutableCopy];
        [sizeTemp addObject:sizeNeededForItem];
        sizes = [sizeTemp copy];
    }
    
    NSNumber *amountNeeded = @([self clothingItemsNeededForKey:key]);
    
    for(NSInteger i = 0;i<[sizes count];i++){
    
        NSString *sizeDictKey = sizes[i];
        if ([sizeDictKey isEqualToString:sizeNeededForItem]) {
        
            NSInteger owned = [self clothingCountForKey:key withSize:sizeDictKey];
            dict[sizeDictKey] = @{ @"owned":@(owned),@"need":amountNeeded};
            
        }else{
            NSInteger owned = [self clothingCountForKey:key withSize:sizeDictKey];
            dict[sizeDictKey] = @{ @"owned":@(owned),@"need":@(0)};
        }
    }
    return [dict copy];
}
+(NSArray *)allItemsWithTag{
    NSArray *tags = [[ NSArray alloc]initWithArray:[[NSSet setWithArray:[PRCloset allTags]] allObjects]];
    
    NSMutableArray *tagsDict = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[tags count]; i++) {
        NSArray *itemsForTag = [PRCloset clothingItemsWithTag:[tags[i] valueForKey:@"name"]];
        NSArray *itemTagNames = [itemsForTag valueForKey:@"name"];
        [tagsDict addObject: @{@"name":tags[i],@"items":itemsForTag}];
    }
    return [tagsDict copy];

}
-(NSString *)clothingTypeAtIndex:(NSInteger)index{
    
    return [self.itemKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)][index];
}
-(NSString *)clothingSizeForKey:(NSString *)key{
    if (![self.defaultSizes[key] isKindOfClass:[NSString class]]) {
        return self.defaultSizes[key];
    }
    return [NSString stringWithFormat:@"%@", self.defaultSizes[key]];
    
}
-(NSString *)mainClothingImageForKey:(NSString *)key{
    if ([self.clothingItems[key] count] < 1) {
        return nil;
    }
    ClothingItem *item = self.clothingItems[key][0];
    return item.imageURL;
}

+(NSDictionary *)clothingItemsNeededForKeyForClosets:(NSArray *)closets{
    
    NSMutableDictionary *itemNeededValue = [[NSMutableDictionary alloc]init];
    for (NSInteger i = 0; i<[closets count]; i++) {
        Closet *closet = closets[i];
        for (NSInteger j = 0; j < [closet.itemKeys count];j++) {
            if(itemNeededValue[closet.itemKeys[j]]){
                itemNeededValue[closet.itemKeys[j]] = @([itemNeededValue[closet.itemKeys[j]] integerValue] +[closet clothingItemsNeededForKey:closet.itemKeys[j]]);
            }else{
                itemNeededValue[closet.itemKeys[j]] = @([closet clothingItemsNeededForKey:closet.itemKeys[j]]);
            }
        }
    }
    return itemNeededValue;
}
-(BOOL)doesNeedClothingForSize:(NSString *)size{
    if ([[self.defaultSizes allKeysForObject:size] count] > 0 ) {
        return YES;
    }
    return NO;
}
-(NSArray *)clohtingTypesNeededForSize:(NSString *)size{
    return [self.defaultSizes allKeysForObject:size];
}

-(NSInteger)percentageNeededForSize:(NSString *)size withFilterdClothingTypes:(NSArray*)typeFilter{
    NSInteger needed = 0;
    NSInteger owned = 0;
    for (NSInteger i = 0; i<[typeFilter count]; i++) {
        NSString *type = typeFilter[i];
        if(![self.defaultSizes[type] isEqualToString:size]){
           continue;
        }
        else if([[self clothingSizeForKey:type] isEqualToString:size]){
            NSInteger amountNeeded = [self.defaultAmounts[type] integerValue];
            NSInteger amoundOwned = [self clothingCountForKey:type withSize:size];
            needed = needed + amountNeeded;
            owned = owned + amoundOwned;
        }
    }
    owned = owned * 100;
    if (needed == 0) {
        return 0;
    }else{
        return (owned/needed);
    }
}
-(NSInteger)clothingItemsNeededForKey:(NSString *)key{
    if (!self.clothingItems[key]) {
        return [self.defaultAmounts[key] integerValue];
    }
    NSArray *items = [self.clothingItems[key] valueForKey:@"size"];
    NSString *size =self.defaultSizes[key];
    NSInteger counter = 0;
    for (NSInteger i = 0; i<[items count]; i++) {
        NSString *sizeString = items[i];
        if ([sizeString isEqualToString:size] ) {
            counter++;
        }
    }
    NSInteger valToRet = [self.defaultAmounts[key] integerValue] -  counter;
    return valToRet ;
}
+(NSArray *)allTags{
    return  [PRCloset tags];
}
-(NSInteger)numberOfClothingItemDefaultForKey:(NSString *)key{
    return [self.defaultAmounts[key] integerValue];
}
+(void)changeCloset:(NSString *)closet_id{
 [[NSUserDefaults standardUserDefaults] setObject:closet_id forKey:@"PRClostId"];
}

- (id) initWithDefaults:(NSDictionary *)aDictionary
{
    if ( ![aDictionary isKindOfClass:[NSDictionary class]] ) {
        return nil;
    }
    
    // Preprocess: convert account_id to string
    
    if ((self = [super init])) {
        _properties = aDictionary;
        _itemKeys =
            @[@"tops",@"bottoms",@"socks",@"underwear",@"shoes",@"swimwear",@"outerwear",@"dress_clothes",@"onesies",@"pajamas"];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    return self.properties;
}

-(NSArray *)getClothingItemsForKey:(NSString *)key{
    return self.clothingItems[key];
}
- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    // Preprocess
    
    
    
    if ( [key isEqualToString:@"board_id"] && [value isKindOfClass:[NSNumber class]] ) {
        value = [value stringValue];
    }
    
    // Safety check
    
    if ( value == nil ) {
        value = [NSNull null];
    }
    
    // Mutate
    
    NSMutableDictionary *dictionary = [self.properties mutableCopy];
    dictionary[key] = value;
    self.properties = dictionary;
}

+(NSArray*)sortKeys:(NSArray *)keys{
    NSArray *allSizes = [self standardChoices];
    NSMutableArray *orderedKeys = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[allSizes count]; i++) {
        if ([keys containsObject:allSizes[i]]) {
            [orderedKeys addObject:allSizes[i]];
        }
    }
    return [orderedKeys copy];
}
-(NSArray *)filterClothingTypesBySeasons:(NSArray *)season andTags:(NSArray *)tags forType:(NSString *)type{
    NSMutableArray *clothingItems = [[NSMutableArray alloc]init];
    for (NSInteger i =0; i<[self.clothingItems[type] count]; i++) {
        ClothingItem *item = self.clothingItems[type][i];
        BOOL hasSeason = NO;
        if ([season containsObject:[item.season lowercaseString]]) {
            hasSeason = YES;
        }
        
        BOOL hasTag = NO;
        for (NSInteger j = 0; j< [item.tags count]; j++) {
            for (NSInteger u = 0; u < [tags count]; u++) {
                if (hasTag ) {
                    break;
                }
                if ([[tags[u] lowercaseString] isEqualToString:[item.tags[j] lowercaseString]]) {
                    hasTag = YES;
                    break;
                }
            }
        }
        
        if ([tags count] > 0 && hasTag && [season count] > 0 && hasSeason) {
            [clothingItems addObject:item];
        }else if((!tags && hasSeason) ||( [tags count] == 0 && hasSeason)){
            [clothingItems addObject:item];
        }
    }
    return [clothingItems copy];
}

+(NSDictionary *)itemsDictForAllCloests:(NSArray *)closets ByClothingType:(NSString *)type bySize:(NSString *)size filteredBySeason:(NSArray *)seasons tags:(NSArray *)tags{
        NSMutableDictionary *itemBySizeDict = [[NSMutableDictionary alloc]init];
        for(NSInteger i = 0; i< [closets count]; i++){
            Closet *cl = closets[i];
            [itemBySizeDict addEntriesFromDictionary:[cl itemsDictForClothingTypeBySize:type filteredBySeason:seasons tags:tags]];
            
        }
        return itemBySizeDict;
}
-(NSDictionary *)itemsDictForClothingTypeBySize:(NSString *)type filteredBySeason:(NSArray *)seasons tags:(NSArray *)tags{

    NSArray *items;
    if ([tags count] > 0 || [seasons count] > 0) {
        items = [self filterClothingTypesBySeasons:seasons andTags:tags forType:type];
    }else{
        items = self.clothingItems[type];
    }
    NSMutableDictionary *itemsToReturn = [[NSMutableDictionary alloc]init];
    NSArray *sizes = [[[NSSet alloc]initWithArray:[items valueForKey:@"size"]] allObjects];
    
    for(NSInteger i = 0;i<[sizes count];i++){
        itemsToReturn[sizes[i]] = [[NSArray alloc]init];
    }
    for (NSInteger i = 0; i<[items  count]; i++) {
        ClothingItem *item = items[i];
        if (itemsToReturn[item.size]) {
            NSMutableArray *temp = [itemsToReturn[item.size] mutableCopy];
            [temp addObject:item];
            itemsToReturn[item.size] = [temp copy];
        }else{
             NSMutableArray *temp = [[NSMutableArray alloc]init];
             [temp addObject:item];
             itemsToReturn[item.size] = [temp copy];
        }
    }
    return [itemsToReturn copy];

}
-(NSDictionary *)itemsBySizeForType:(NSString *)type forSize:(NSString *)chosenSize{
    NSArray *items = [self clothingItemForKey:type];
    NSString *size = chosenSize;
    NSArray *sizeLookup = [Closet standardChoices];
    NSMutableArray *matchingSizeItems = [[NSMutableArray alloc]init];
    NSMutableArray *largerSizeItems = [[NSMutableArray alloc]init];
    NSMutableArray *smallerSizeItems = [[NSMutableArray alloc]init];
    NSMutableArray *allItems =[[NSMutableArray alloc]init];
    NSInteger matchingSizeIndex = [sizeLookup indexOfObject:size];
    for (NSInteger i = 0; i< [items count]; i++) {
        ClothingItem *item = items[i];
        if (size && item.size && [item.size caseInsensitiveCompare:size] == NSOrderedSame ) {
             [matchingSizeItems addObject:item];
        }else{
            NSInteger indexOfSize = [sizeLookup indexOfObject:item.size];
            if (indexOfSize > matchingSizeIndex) {
                [largerSizeItems addObject:item];
            }else{
                [smallerSizeItems addObject:item];
            }
        }
        [allItems addObject:item];
    }
    NSMutableDictionary *itemDictionary = [[NSMutableDictionary alloc]init];
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"clothing_id" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    itemDictionary[@"all"] = [allItems copy];
    itemDictionary[@"matching"] = [[matchingSizeItems copy] sortedArrayUsingDescriptors:descriptors];
    if ([largerSizeItems count] > 0) {
        itemDictionary[@"larger"] = [[largerSizeItems copy] sortedArrayUsingDescriptors:descriptors];
    }
    if ([smallerSizeItems count] > 0) {
        itemDictionary[@"smaller"] = [[smallerSizeItems copy] sortedArrayUsingDescriptors:descriptors];
    }
    return itemDictionary;
}

+(NSArray *)sortedClosetFromData:(NSArray *)closetDataArray{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0;i< [closetDataArray count];i++){
        Closet *closettemp = [[Closet alloc]initWithItems:closetDataArray[i]];
        [tempArray addObject:closettemp];
    }
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"closet_id" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    return [tempArray sortedArrayUsingDescriptors:descriptors];
}
+(Closet *)loadClosetFromCoreDataWithItems:(NSString *)closet_id{
    PRCloset *closetCd = [PRCloset closetForId:closet_id];
    Closet *closet = [[Closet alloc]initWithItems:[closetCd dictionaryRepresentation]];
    return closet;
}
+(Closet *)loadClosetFromCoreData:(NSString *)closet_id{
    PRCloset *closetCd = [PRCloset closetForId:closet_id];
    Closet *closet = [[Closet alloc]initWithItems:[closetCd dictionaryRepresentation]];
    return closet;
}
+(NSArray *)loadClosetsFromCoreData{
    NSArray *closets = [PRCloset currentClosets];
    NSMutableArray *closetsToReturn = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i< [closets count]; i++) {
        NSDictionary *closetDict = closets[i];
        Closet *closet = [[Closet alloc]initWithItems:closetDict];
        [closetsToReturn addObject:closet];
    }
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"closet_id" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];

    return [[closetsToReturn copy] sortedArrayUsingDescriptors:descriptors];
}


+(NSString *)currentCloset{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"PRClostId"];
}

-(BOOL)updateItemsInCore:(NSString *)item_id{
    return YES;

}

- (id) valueForUndefinedKey:(NSString *)key
{
    return [self.properties valueForKey:key];
}
+(NSArray *)amountNeededForAllClosets:(NSArray *)closets{
    NSMutableArray *amounts = [[NSMutableArray alloc]init];
    for(NSInteger j = 0;j<[closets count];j++){
        Closet *closet = closets[j];
        [amounts addObject:[Closet amountNeededForCloset:closet]];
    }
    return [amounts copy];
}
/*
+(NSArray *)calculateAmountNeedeForAllClosets:(NSArray *)closets{
    NSArray *closetAmounts = [Closet amountNeededForAllClosets:closets];
    NSMutableArray *sumForclosets = [[NSMutableArray alloc]init]
}*/

+(NSNumber *)amountNeededForCloset:(Closet *)closet{
    NSNumber *amountNeeded = @(0);
   for (NSInteger i = 0; i<[closet.itemKeys count]; i++) {
       NSNumber *amountQuanitity = [NSNumber numberWithInteger:[closet clothingItemsNeededForKey:closet.itemKeys[i]]];
       amountNeeded = @([amountNeeded integerValue] + [amountQuanitity integerValue]);
    }
    return amountNeeded;
}
+(void)loadClosetsFromBackend:(NSString *)possibele_id completion:(KCDataTaskCompletionSuccessHandler)completion failure:(KCDataTaskFailureHandler)failure{

     [[Networking sharedInstance]GETClosetItemsWithId:possibele_id sucessHandler:completion failureHandler:failure];
}

+(void)clearCloset{
    [PRCloset clean];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PRClosetId"];
}
+(NSArray *)standardChoices{
    return @[@"P",@"NB",@"3M",@"6M",@"9M",@"12M",@"18M",@"24M",@"2T",@"3T",@"4T",@"5T",@"3.5",@"4",@"4.5",@"5",@"5.5",@"6",@"6.5",@"7",@"7.5",@"8",@"8.5",@"9",@"9.5",@"10"];

}
+(NSNumber *)numberOfItemsWithTags:(NSString*)tag{
    return [PRCloset numberOfItemsWithTag:tag];

}
-(void)saveCloset{



}
+(NSArray *)seasons{
    return @[@"all",@"winter",@"spring",@"summer",@"fall"];
}
@end
