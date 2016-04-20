//
//  ClosetCollectionViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/8/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClosetCollectionViewController.h"
#import "ClothingItemCollectionViewCell.h"
#import "ClosetSectionHeaderCollectionViewCell.h"
#import "Closet.h"
#import "Networking+ClosetManager.h"
@interface ClosetCollectionViewController()
@property Closet *closet;
@property BOOL loaded;
@property NSArray *closetData;
@property NSArray *closetKeys;
@property NSDictionary *closetDeafults;
@end
@implementation ClosetCollectionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
     __weak ClosetCollectionViewController *weakSelf = self;
    
 [[Networking sharedInstance]GETClosetItemsWithId:@"1" sucessHandler:^(NSHTTPURLResponse *response, GetClothingItemsResponse *data) {
 
            NSDictionary *dict = data.closetDict;
     
            weakSelf.closet = [[Closet alloc]initWithItems:dict];
     
     
     
     
            weakSelf.closetKeys = weakSelf.closet.itemKeys;
     
            weakSelf.closetDeafults = data.closets[0];
            weakSelf.loaded = YES;
            [weakSelf.collectionView reloadData];
        
    } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
 
    }];

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection: (NSInteger)section
{
    if (self.loaded){
        return  [self.closet.itemKeys count];
    }
    return 0;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return  CGSizeMake(self.view.frame.size.width/2 -2, self.view.frame.size.width/2 -2 );
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
            ClothingItemCollectionViewCell  * cell = (ClothingItemCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"clothingItemIdentifier" forIndexPath:indexPath];
            
             cell.clothingTypeLabel.text =  self.closetKeys[indexPath.item];
             cell.clothingImageView.image = [UIImage imageNamed:@"shirt"];
             cell.clothingAmountLabel.text =  [self.closetDeafults[self.closetKeys[indexPath.item]] stringValue];
             [cell customizeApperance];
            return cell;
        
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ClosetSectionHeaderCollectionViewCell *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ClosetSectionHeaderCollectionViewCell *headerView =  (ClosetSectionHeaderCollectionViewCell *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeaderIdentifier" forIndexPath:indexPath];
        if (self.loaded) {
    
            headerView.closetNameLabel.text = @"Patrick";
            headerView.closetAgeLabel.text = @"1 Year";
        }
        reusableview = headerView;
    }
    return reusableview;
 }

@end
