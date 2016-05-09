 //
//  ClothingTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClothingTableViewController.h"
#import "AddItemTableViewController.h"
#import "ClothingItemTableViewCell.h"
#import "Networking.h"
#import "ClothingItem.h"
#import "PhotoViewController.h"

@interface ClothingTableViewController()
@property NSIndexPath * selectedIndex;
@property NSArray *smallerItems;
@property NSArray *largerItems;
@property NSDictionary *itemContainer;
@property BOOL isEmpty;
@end

@implementation ClothingTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.pickerController = [[UIImagePickerController alloc]init];
    self.pickerController.delegate = self;
    FZAccordionTableView *tableView = (FZAccordionTableView *)self.tableView;
    tableView.enableAnimationFix = YES;
    tableView.initialOpenSections = [[NSSet alloc]initWithObjects:@(0), nil];
    tableView.allowMultipleSectionsOpen = YES;
    if ([self.type isEqualToString: @"dress_cloths"]) {
        [self.navigationItem setTitle:@"Dress Clothes"];
    }else{
        [self.navigationItem setTitle:[self.type capitalizedString]];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *itemDict;
    if (!self.closet) {
        itemDict = [Closet allClothingItemsOfTypeSortedBySize:self.type];
    }else{
        self.closet = [Closet loadClosetFromCoreData:self.closet.closet_id];
        itemDict = [self.closet itemsDictForClothingTypeBySize:self.type];
    }
     NSMutableArray *keys = [[Closet sortKeys:[itemDict allKeys]] mutableCopy];
     NSMutableArray *itemTemp = [[NSMutableArray alloc]init];
    if (self.chosenSize && [keys containsObject:self.chosenSize]) {
        itemTemp[0] = itemDict[self.chosenSize];
        [keys removeObject:self.chosenSize];
    }else{
        itemTemp[0] = @[];
    }
     for(NSInteger i = 0;i<[keys count];i++){
        [itemTemp addObject:itemDict[keys[i]]];
     }
     self.items = [itemTemp copy];
     /*
     if (self.chosenSize && [self.chosenSize length] > 0) {
        self.itemContainer =  [self.closet itemsBySizeForType:self.type forSize:self.chosenSize];

    }else{
        self.itemContainer =  [self.closet itemsBySizeForType:self.type forSize:self.closet.age];
    }*/
    [self.tableView reloadData];
}

-(void)goToPhoto{
    
  [self performSegueWithIdentifier:@"toCamera" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addPushed:(id)sender {
    [self goToPhoto];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 0 && [self.items[section] count] == 0) {
            return 1;
        }
        if(self.items && self.items[section]){
            return [self.items[section] count];
        }
        return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];
}
/*
-(NSDictionary *)seasonCount{
    
    NSMutableDictionary *seasonsDict = [[NSMutableDictionary alloc]init];
    NSArray *items = self.itemContainer[@"matching"];
    for (NSInteger i = 0; i<[items count]; i++) {
            ClothingItem *currentItem = items[i];
            NSString *season = [currentItem.season lowercaseString];
            if (seasonsDict[season]){
                NSInteger temp = [seasonsDict[season] integerValue];
                temp = temp + 1;
                seasonsDict[season] = @(temp);
            }else{
                seasonsDict[season] = @(1);
            }
    }
    return [seasonsDict copy];
}*/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, tableView.frame.size.width, 40)];
            FZAccordionTableViewHeaderView *backView = [[FZAccordionTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 100)];
            //[topView setBackgroundColor:[UIColor colorWithRed:114/255.0 green:170/255.0 blue:208/255.0 alpha:1]];
            
            [view setBackgroundColor:[UIColor colorWithRed:114/255.0 green:170/255.0 blue:208/255.0 alpha:1]];

        
            if (self.closet) {
            
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/2,60)];
                nameLabel.text = [self.closet.closetName capitalizedString];
                nameLabel.textColor = [UIColor whiteColor];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                
                UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width/4, 0, tableView.frame.size.width/4,60)];
                amountLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.closet clothingItemsNeededForKey:self.type]];
                amountLabel.textColor = [UIColor flatWhiteColor];
                
                
                [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
                nameLabel.adjustsFontSizeToFitWidth = YES;
                nameLabel.numberOfLines = 1;
                
                [amountLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
                amountLabel.adjustsFontSizeToFitWidth = YES;
                amountLabel.numberOfLines = 1;
                
                [view addSubview:nameLabel];
               // [view addSubview:amountLabel];
                
                UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width/2, 0, tableView.frame.size.width/2,60)];
                ageLabel.text = [NSString stringWithFormat:@"Need %ld %@",(long)[self.closet clothingItemsNeededForKey:self.type], self.closet.defaultSizes[self.type]];
                [ageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
                ageLabel.textColor = [UIColor flatWhiteColor];
                ageLabel.textAlignment = NSTextAlignmentCenter;
                // [view addSubview:ageLabel];
            }else{
               UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,60)];
                nameLabel.text = @"All Closets";
                nameLabel.textColor = [UIColor whiteColor];
                nameLabel.textAlignment = NSTextAlignmentCenter;
               [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
                nameLabel.adjustsFontSizeToFitWidth = YES;
                nameLabel.numberOfLines = 1;
                [view addSubview:nameLabel];
            
            }

            UIView *subHeadView = [self smallerHeaderForSection:0];
            [topView addSubview:subHeadView];
        
            [backView addSubview:view];
            [backView addSubview:topView];
            return backView;
    }else{
        FZAccordionTableViewHeaderView * view;
        UIView *backView = [self smallerHeaderForSection:section];
        view = [[FZAccordionTableViewHeaderView alloc]initWithFrame:backView.frame];
        [view addSubview:backView];
        return view;
    }
}
-(UIView *)smallerHeaderForSection:(NSInteger)section{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1,self.tableView.frame.size.width,39)];
        if ( self.items[section] && [self.items[section] count] > 0) {
             nameLabel.text = [self.items[section][0] valueForKey:@"size"];
        }else if(self.chosenSize){
            nameLabel.text = self.chosenSize;
        }else{
             nameLabel.text = [self.closet clothingSizeForKey:self.type];

        }
        nameLabel.textColor = [UIColor flatNavyBlueColorDark];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel setBackgroundColor:[UIColor flatWhiteColor]];
        [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.numberOfLines = 1;

        /*UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/2 +self.tableView.frame.size.width/4, 0, self.tableView.frame.size.width/4,40)];
        ageLabel.text = [NSString stringWithFormat:@"%ld", [self.itemContainer[@"smaller"] count]];
        [ageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
        ageLabel.textColor = [UIColor flatWhiteColor];
        ageLabel.textAlignment = NSTextAlignmentCenter;*/
        [view setBackgroundColor:[UIColor flatWhiteColorDark]];
       // [view addSubview:ageLabel];
        [view addSubview:nameLabel];
        return view;
}

- (ClothingItemTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [self.items[0] count ]== 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCellItem" forIndexPath:indexPath];
        return cell;
    }

    ClothingItemTableViewCell  *cell =  (ClothingItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailedCell"forIndexPath:indexPath];
     ClothingItem *item;
    item = self.items[indexPath.section][indexPath.item];
    NSURL *url = [[Networking sharedInstance] URLWithPath:item.imageURL params:nil];
    
    [cell.currentImage sd_setImageWithURL:url];
    cell.itemName.text = [item.name capitalizedString];
    cell.itemSize.text = item.size ;
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
 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"here");
    
 }
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 100;
    }else{
        return  40;
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

  
   self.imageURL =  info[UIImagePickerControllerOriginalImage];
   __weak ClothingTableViewController * weakSelf = self;
   [self dismissViewControllerAnimated:YES completion:^{
          [weakSelf performSegueWithIdentifier:@"imageSelected" sender:self];
   }];
 

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath;
    [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toEditItem" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"imageSelected"]) {
        AddItemTableViewController *vc = (AddItemTableViewController *) segue.destinationViewController;
        vc.imageUrl = self.imageURL;
        vc.type = self.type;
    }   else if ([segue.identifier isEqualToString:@"toCamera"]) {
        PhotoViewController *vc = (PhotoViewController *) segue.destinationViewController;
        vc.type = self.type;
        vc.hasType = YES;
    }
      else if ([segue.identifier isEqualToString:@"toEditItem"]) {
        AddItemTableViewController *vc = (AddItemTableViewController *) segue.destinationViewController;
        vc.type = self.type;
        
         ClothingItem *itemSelected = self.items[self.selectedIndex.section][self.selectedIndex.item];
        vc.imageString = itemSelected.imageURL;
        vc.clothingItem = itemSelected;
    }
}

@end
