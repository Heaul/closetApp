    //
//  BrowseByItemTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 4/12/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "BrowseByItemTableViewController.h"
#import "ClothingItemTableViewCell.h"
#import "ClothingItem.h"
#import "Networking+ClosetManager.h"
#import "Closet.h"
#import "AllItemsFooter.h"
#import "AddItemTableViewController.h"
#import "ClosetViewController.h"
#import "PhotoViewController.h"
#import "FZAccordionTableView.h"
@interface BrowseByItemTableViewController ()
@property NSArray *closets;
@property NSIndexPath *selectedIndex;
@property BOOL initalLoad;
@property NSArray *allClosets;
@property BOOL isEmpty;
@end

@implementation BrowseByItemTableViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.initalLoad) {
        [self updateInfo];
    }else{
        self.initalLoad = NO;
    }
}

- (void)viewDidLoad {
   [super viewDidLoad];

   self.initalLoad = YES;
   NSString *typeDisplay = self.type;
   if ([typeDisplay isEqualToString:@"dress_cloths"]) {
    typeDisplay = @"Dress Clothes";
    }
   [self.navigationItem setTitle:[typeDisplay capitalizedString]];
   [self updateInfo];
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"emptyCell"];
}


-(void)updateInfo{
    self.closets = [Closet loadClosetsFromCoreData];
    self.allClosets = [Closet loadClosetsFromCoreData];
    NSMutableArray *allClothingItems = [[NSMutableArray alloc]init];
    NSMutableArray *closetsWithItem = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.closets count]; i++) {
        Closet *closet = self.closets[i];
        NSArray *clothingItems = [closet clothingItemForKey:self.type];
        if (clothingItems && [clothingItems count] != 0) {
            [allClothingItems addObject:clothingItems];
            [closetsWithItem addObject:closet];
        }
    }
    self.closets = [closetsWithItem copy];
    self.items = [allClothingItems copy];
    //self.items = [Closet allClothingItemsOfType:self.type];
    if ([self.items count] == 0) {
        self.isEmpty = YES;
    }else{
        self.isEmpty = NO;

    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isEmpty) {
        return 1;
    }
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isEmpty) {
        return 1;
    }
    return [self.items[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if (self.isEmpty) {
        return 0;
    }
    return  60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    Closet *closet = self.closets[section];
    return [self headerViewForClost:closet];
}

- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {

}

- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {

}

- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {

}

- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header {
    
}

-(FZAccordionTableViewHeaderView *)headerViewForClost:(Closet *)closet{
    if (self.isEmpty) {
        return [[FZAccordionTableViewHeaderView alloc]initWithFrame:CGRectZero];
    }
    FZAccordionTableViewHeaderView *view = [[FZAccordionTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    
    [view setBackgroundColor:[UIColor flatMintColor]];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.tableView.frame.size.width/2 ,60)];
    nameLabel.text = [closet.closetName capitalizedString];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 1;
    
    [view addSubview:nameLabel];
    
    UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/2, 0, self.tableView.frame.size.width/2,60)];
    
    ageLabel.text = [NSString stringWithFormat:@"Need: %ld  %@",(long)[closet clothingItemsNeededForKey:self.type],[closet clothingSizeForKey:self.type]];
    
    [ageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    ageLabel.textColor = [UIColor flatWhiteColor];
    ageLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:ageLabel];
    return view;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEmpty) {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        UILabel *emptyLabel = [[UILabel alloc]initWithFrame:cell.frame];
        emptyLabel.text = @"No Items";
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.textColor = [UIColor flatGrayColorDark];
        [cell addSubview:emptyLabel];
        return cell;
    }
    ClothingItemTableViewCell *cell = (ClothingItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"detailedCell" forIndexPath:indexPath];
    
    ClothingItem *item = self.items[indexPath.section][indexPath.item];
    NSURL *url = [[Networking sharedInstance] URLWithPath:item.imageURL params:nil];
    
    [cell.currentImage sd_setImageWithURL:url];
    cell.itemName.text = [item.name capitalizedString];
    cell.itemSize.text = item.size;
    cell.itemSeason.text = [item.season capitalizedString];
    if ([item.season isEqualToString:@"all"]) {
        cell.itemSeason.text = @"All Seasons";
    }
    if (item.tags) {
        cell.tagView.hidden = NO;
        for(NSInteger i = 0;i<[item.tags count];i++){
            [cell.tagView addTagWtihWordMini:item.tags[i]];
        }
    }else{
        cell.tagView.hidden = YES;
        [cell.tagView clearTags];
    
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (IBAction)addPushed:(id)sender {

    if ([self.allClosets count] > 1) {
        
    }else{
        Closet *closet = self.allClosets[0];
        [Closet changeCloset:closet.closet_id];
    }
    [self performSegueWithIdentifier:@"toPhoto" sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath;
    [self performSegueWithIdentifier:@"editItem" sender:self];

}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"editItem"]) {
    
        AddItemTableViewController *vc = (AddItemTableViewController *) segue.destinationViewController;
        vc.type = self.type;
        Closet *closet =  self.closets[self.selectedIndex.section];
       [Closet changeCloset:closet.closet_id];
        ClothingItem *itemSelected = self.items[self.selectedIndex.section][self.selectedIndex.item];
        vc.imageString = itemSelected.imageURL;
        vc.clothingItem = itemSelected;
    }else if([segue.identifier isEqualToString:@"toPhoto"] && [self.allClosets count] > 1){
    
            PhotoViewController *vc = (PhotoViewController *) segue.destinationViewController;
            vc.type = self.type;

    }else{
    
    
    }
}


@end
