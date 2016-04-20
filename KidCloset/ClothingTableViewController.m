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
@end

@implementation ClothingTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.pickerController = [[UIImagePickerController alloc]init];
    self.pickerController.delegate = self;
    if ([self.type isEqualToString: @"dress_cloths"]) {
        [self.navigationItem setTitle:@"Dress Clothes"];
    }else{
        [self.navigationItem setTitle:[self.type capitalizedString]];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     self.closet = [Closet loadClosetFromCoreData:self.closet.closet_id];
     self.items = [self.closet clothingItemForKey:self.type];
      self.itemContainer =  [[self.closet itemsBySizeForType:self.type] copy];
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
-(NSArray *)itemArrayForSection:(NSInteger)section{
    if (section == 0) {
       return self.itemContainer[@"matching"];
    }else if (section == 1 && self.itemContainer[@"larger"]){
       return self.itemContainer[@"larger"];
    }else if (section == 1 && self.itemContainer[@"smaller"]){
       return self.itemContainer[@"smaller"];
    }else if (section == 2 && self.itemContainer[@"smaller"]){
       return self.itemContainer[@"smaller"];
    }else{
        return @[];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.itemContainer[@"matching"] count];
    }else{
        return [[self itemArrayForSection:section] count];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger counter = 1;
    if (self.itemContainer[@"larger"]) {
        counter++;
    }
    if (self.itemContainer[@"smaller"]) {
        counter++;
    }
    return  counter;
}

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
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60, tableView.frame.size.width, 60)];
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
            UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 120)];
            [topView setBackgroundColor:[UIColor colorWithRed:114/255.0 green:170/255.0 blue:208/255.0 alpha:1]];
            
            [view setBackgroundColor:[UIColor flatMintColor]];
            
            
            UILabel *seasonLabel;
            UILabel *seasonNumber;
            NSDictionary *seasons = [self seasonCount];
            NSArray *seasonKeys = [Closet seasons];
            for (NSInteger i = 0; i<[seasonKeys count] ; i++) {
                 seasonLabel = [[UILabel alloc]initWithFrame:CGRectMake((tableView.frame.size.width/5) * i, 0, tableView.frame.size.width/5,30)];
                seasonNumber = [[UILabel alloc]initWithFrame:CGRectMake((tableView.frame.size.width/5) * i, 30, tableView.frame.size.width/5,30)];

                 seasonLabel.text = [seasonKeys[i] capitalizedString];
                 seasonLabel.textColor = [UIColor flatWhiteColor];
                 seasonLabel.textAlignment = NSTextAlignmentCenter;
                  [seasonLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
                NSString *se = seasonKeys[i];
                if ([[seasons allKeys]containsObject:se]) {
                     seasonNumber.text = [seasons[seasonKeys[i]] stringValue];
                }else{
                    seasonNumber.text = @"0";
                }
                 seasonNumber.textColor = [UIColor flatWhiteColor];
                 seasonNumber.textAlignment = NSTextAlignmentCenter;
                [seasonNumber setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
                
                 [topView addSubview:seasonLabel];
                 [topView addSubview:seasonNumber];
            }
                seasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/4,60)];
            
            if (self.closet) {
            
                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width/4,60)];
                nameLabel.text = @"Need: ";
                nameLabel.textColor = [UIColor whiteColor];
                nameLabel.textAlignment = NSTextAlignmentRight;
                
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
                [view addSubview:amountLabel];
                
                UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width/2 +tableView.frame.size.width/4, 0, tableView.frame.size.width/4,60)];
                ageLabel.text = [NSString stringWithFormat:@"%@", self.closet.defaultSizes[self.type]];
                [ageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
                ageLabel.textColor = [UIColor flatWhiteColor];
                ageLabel.textAlignment = NSTextAlignmentCenter;
                [view addSubview:ageLabel];
            }
            [backView addSubview:topView];
            [backView addSubview:view];
            return backView;
    }else{
        UIView * view;
        if (section == 1 && self.itemContainer[@"larger"]) {
            view = [self largerHeader];
        }else if(section == 1 && self.itemContainer[@"smaller"]){
            view = [self smallerHeader];
        }else if(section == 2){
            view = [self smallerHeader];
        }
        return view;
    
    }
}

-(UIView *)largerHeader{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width/4,40)];
        nameLabel.text = @"Large";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentRight;

       /* UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/4, 0, self.tableView.frame.size.width/4,60)];
        amountLabel.text = [NSString stringWithFormat:@"%ld",(long)[self.closet clothingItemsNeededForKey:self.type]];
        amountLabel.textColor = [UIColor flatWhiteColor];*/
        
        
        [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.numberOfLines = 1;
        
        /*[amountLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
        amountLabel.adjustsFontSizeToFitWidth = YES;
        amountLabel.numberOfLines = 1;*/



        UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/2 +self.tableView.frame.size.width/4, 0, self.tableView.frame.size.width/4,40)];
        ageLabel.text = [NSString stringWithFormat:@"%ld", [self.itemContainer[@"smaller"] count]];
        [ageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
        ageLabel.textColor = [UIColor flatWhiteColor];
        ageLabel.textAlignment = NSTextAlignmentCenter;
        [view setBackgroundColor:[UIColor flatPowderBlueColorDark]];
        [view addSubview:ageLabel];
        [view addSubview:nameLabel];
        return view;
}
-(UIView *)smallerHeader{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width/4,40)];
        nameLabel.text = @"Small";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentRight;
    
        [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.numberOfLines = 1;


        UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/2 +self.tableView.frame.size.width/4, 0, self.tableView.frame.size.width/4,40)];
        ageLabel.text = [NSString stringWithFormat:@"%ld", [self.itemContainer[@"smaller"] count]];
        [ageLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1]];
        ageLabel.textColor = [UIColor flatWhiteColor];
        ageLabel.textAlignment = NSTextAlignmentCenter;
        [view setBackgroundColor:[UIColor flatPowderBlueColorDark]];
        [view addSubview:ageLabel];
        [view addSubview:nameLabel];
        return view;
}

- (ClothingItemTableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClothingItemTableViewCell  *cell =  (ClothingItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailedCell"forIndexPath:indexPath];
     ClothingItem *item;
     if (indexPath.section == 0) {
       item = self.itemContainer[@"matching"][indexPath.item];
    }else{
        item = [self itemArrayForSection:indexPath.section][indexPath.item];
    }
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
        return 120;
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
        
         ClothingItem *itemSelected = [self itemArrayForSection:self.selectedIndex.section][self.selectedIndex.item];

        vc.imageString = itemSelected.imageURL;
        vc.clothingItem = itemSelected;
    }
}

@end
