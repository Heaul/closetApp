//
//  Closet.h
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
@interface Closet : NSObject 
- (id) initWithDictionary:(NSDictionary*)aDictionary;
- (NSDictionary *)dictionaryRepresentation;
- (id) initWithDefaults:(NSDictionary *)aDictionary;
-(id)initWithItems:(NSDictionary *)itemDict;
-(id)initWithKeys;
-(NSInteger)clothingCountForKey:(NSString *)key withSize:(NSString *)size;
-(NSArray *)clothingItemForKey:(NSString *)key;
-(NSString *)clothingTypeAtIndex:(NSInteger)index;
-(NSString *)clothingSizeForKey:(NSString *)key;
-(NSString *)mainClothingImageForKey:(NSString *)key;
-(NSInteger)clothingItemsNeededForKey:(NSString *)key;
-(NSInteger)clothingTypeCount;
-(NSArray *)getClothingItemsForKey:(NSString *)key;
-(NSInteger)numberOfClothingItemDefaultForKey:(NSString *)key;
+(void)changeCloset:(NSString *)closet_id;
+(void)clearCloset;
+(NSString *)currentCloset;
+(NSArray *)standardChoices;
+(NSArray *)seasons;
+(Closet *)loadClosetFromCoreData:(NSString *)closet_id;
+(Closet *)loadClosetFromCoreDataWithItems:(NSString *)closet_id;
-(NSDictionary *)itemsBySizeForType:(NSString *)type;
+(NSArray *)loadClosetsFromCoreData;
+(NSDictionary *)standardAmounts;
+(NSArray *)amountNeededForAllClosets:(NSArray *)closets;
+(NSDictionary *)clothingItemsNeededForKeyForClosets:(NSArray *)closets;
+(NSArray *)allTags;
+(NSArray *)allItemsWithTag;
+(NSNumber *)numberOfItemsWithTags:(NSString*)tag;
+(NSArray *)allClothingItemsOfType:(NSString *)type;
-(NSDictionary *)clothingAmountsForKey:(NSString *)key;
+(NSArray*)sortKeys:(NSArray *)keys;
@property NSDictionary *clothingItems;
@property NSString *closetName;
@property NSString *closet_id;
@property NSString *age;
@property NSString *gender;
@property NSArray *itemKeys;
@property NSDictionary* defaultAmounts;
@property NSDictionary* defaultSizes;


@end
