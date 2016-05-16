//
//  HomeViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 4/9/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "HomeViewController.h"
#import "AllItemsFooter.h"
#import "Closet.h"
#import "HomeTableViewCell.h"
#import "Networking+ClosetManager.h"
#import "PRCloset.h"
#import "SVPullToRefresh.h"
#import "ClosetDetailViewController.h"
#import "CreateClosetViewController.h"
#import "AppDelegate.h"
#import "BrowseByItemTableViewController.h"
#import "SizeDisplayView.h"
#import "FZAccordionTableView.h"

@interface HomeViewController ()
@property NSArray *closetAmountsNeeded;
@property BOOL initialLoad;
@property NSArray *itemKeys;
@property NSDictionary *amountNeededByItem;
@property NSInteger selectedIndex;
@property NSArray *tags;
@property Closet *closet;
@property NSArray *sizes;
@property BOOL refreshing;
@end

@implementation HomeViewController

-(void)viewDidAppear:(BOOL)animated{
    if (!self.initialLoad) {
        self.closets = [Closet loadClosetsFromCoreData];
        self.initialLoad = NO;
        self.closetAmountsNeeded = [Closet amountNeededForAllClosets:self.closets];
        self.amountNeededByItem = [Closet clothingItemsNeededForKeyForClosets:self.closets];
        self.tags = [Closet allTags];
    }
    if ([self.closets count] == 0) {
        [self.tableView triggerPullToRefresh];
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.initialLoad = YES;
    self.itemKeys = [Closet standardChoices];
        self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"Home";
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    // self.clearsSelectionOnViewWillAppear = NO;
    
    __weak HomeViewController *weakSelf = self;
     NSString *possibele_id = [NSString stringWithFormat:@"%@",[Closet currentCloset]] ;
      [self.tableView addPullToRefreshWithActionHandler:^{
      if (!weakSelf.refreshing) {
        weakSelf.refreshing = YES;
      [[Networking sharedInstance]GETClosetItemsWithId:possibele_id sucessHandler:^(NSHTTPURLResponse *response, GetClothingItemsResponse *data) {
          
                    if(data.closetsExist){
                        if(data.closetArray){
                            weakSelf.closets = [Closet sortedClosetFromData:data.closetArray];
                        }else{
                            #warning fail gracefully
                            return;
                        }
                        
                        [weakSelf.tableView.pullToRefreshView stopAnimating];
                          
                        [PRCloset updateCloests:weakSelf.closets];
                        weakSelf.closetAmountsNeeded = [Closet amountNeededForAllClosets:weakSelf.closets];
                        weakSelf.amountNeededByItem = [Closet clothingItemsNeededForKeyForClosets:weakSelf.closets];
                        weakSelf.tags = [Closet allTags];
                        weakSelf.refreshing = NO;
                        [weakSelf.tableView reloadData];
                    }else{
                         weakSelf.closet = [[Closet alloc]initWithItems:data.closetDict];
                        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                        NSLog(@"creating push");
                        weakSelf.refreshing = NO;
                        [delegate presentCreateCloset:weakSelf.closet];
                    }

            } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
                    weakSelf.refreshing = NO;
                    [weakSelf.tableView.pullToRefreshView stopAnimating];
            }];
        }
      }];
     [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(!self.tags || [self.tags count] == 0){
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

#warning Incomplete implementation, return the number of rows
  if (section == 0) {

    if ( !self.closets || [self.closets count] == 0) {
        return 0;
    }else{
        return [self.closets count]+1;
    
    }
  }else if(section == 1){
        return  [[Closet standardChoices] count];
    
  }else{
    if ([self.tags count] == 0) {
        return 0;
    }
    return [self.tags count]+1;
  }
}
- (IBAction)createClosetPushed:(id)sender {
    [self performSegueWithIdentifier:@"toCreateCloset" sender:self];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell;
    if (indexPath.item == [self.closets count] && indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
         UIButton *button = (UIButton *)[cell viewWithTag:77];
         [button setTitle:@"Create Closet" forState:UIControlStateNormal];
        return cell;
    }else if(indexPath.item ==  [self.amountNeededByItem.allKeys count] && indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
            UIButton *button = (UIButton *)[cell viewWithTag:77];
            [button setTitle:@"Browse by Clothing Type" forState:UIControlStateNormal];
        return cell;
    }else if(indexPath.section == 2 && indexPath.item == [self.tags count]){
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagButtonCell" forIndexPath:indexPath];
         return cell;
    }
    else if(indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"allItemCell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    }
    
    if (indexPath.section == 0) {
        Closet *closet = self.closets[indexPath.item];
        cell.mainLabel.text = [closet.closetName capitalizedString];
        cell.amountLabel.text = closet.age;
        cell.sizeLabel.text = [NSString stringWithFormat:@"Need: %@", [self.closetAmountsNeeded[indexPath.item] stringValue]];
    }else if (indexPath.section == 1){
        cell.bottomSizeView.hidden = NO;
        NSMutableDictionary *sizes = [[NSMutableDictionary alloc]init];
        
        for (NSInteger i = 0; i<[self.closets count]; i++) {
        
             Closet *closet = self.closets[i];
             NSString *key  = [closet clothingTypeAtIndex:indexPath.item];
            
             NSDictionary *amountsOwned = [closet clothingAmountsForKey:key];
            
             for (NSInteger j = 0; j<[[amountsOwned allKeys] count]; j++) {
                 NSString *size = [amountsOwned allKeys][j];
                 if (sizes[size]) {
                    sizes[size][@"owned"] = @([sizes[size][@"owned"] integerValue] + [amountsOwned[size][@"owned"] integerValue]);
                    sizes[size][@"need"] = @([sizes[size][@"need"] integerValue] + [amountsOwned[size][@"need"] integerValue]);
                 }else{
                    sizes[size] = [[NSMutableDictionary alloc]init];
                    sizes[size][@"owned"] =  amountsOwned[size][@"owned"];
                    sizes[size][@"need"] =  amountsOwned[size][@"need"];
                    
                 }
             }
        }
        
        NSMutableArray *keys = [[NSMutableArray alloc]init];
        NSMutableArray *amounts = [[NSMutableArray alloc]init];
        NSMutableArray *owned = [[NSMutableArray alloc]init];
        
        NSArray *keyArray = [Closet sortKeys:[sizes allKeys]];
        
        for(NSInteger i = 0;i<[keyArray count];i++){
            [keys addObject:keyArray[i]];
            [amounts addObject:sizes[keyArray[i]][@"need"]];
            [owned addObject:sizes[keyArray[i]][@"owned"]];
        }
        
        Closet *closet = self.closets[0];
        NSString *type = [closet clothingTypeAtIndex:indexPath.item];
        cell.amountLabel.text = [self.amountNeededByItem[type] stringValue];
        if([type isEqualToString:@"dress_cloths"]){
            cell.mainLabel.text = @"Dress Clothes";
        }else{
            cell.mainLabel.text = [type capitalizedString];
        }
        cell.sizeLabel.text = @"";
            
        [cell.bottomSizeView createLabelsAmounts:[amounts copy] withSizes:[keys copy] owned:[owned copy]];
        
    }else if(indexPath.section == 2){
         cell.bottomSizeView.hidden = YES;
         cell.mainLabel.text = self.tags[indexPath.item];
         cell.amountLabel.text = [[Closet numberOfItemsWithTags:self.tags[indexPath.item]] stringValue];
         cell.sizeLabel.text = @"";
    }
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ItemsFooterView" owner:self options:nil];
     AllItemsFooter *headerView =  [nibContents firstObject];
    if (!headerView.headerTitleLabel) {
        headerView.headerTitleLabel = [[UILabel alloc]init];
    }
   if (section == 0) {
        headerView.headerTitleLabel.text = @"Closets";
    }else if (section == 1){
        headerView.headerTitleLabel.text = @"Clothing Items";
    }else if (section == 2){
        headerView.headerTitleLabel.text = @"Tags";
    }
    return  headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

  if(indexPath.item == [self.closets count] && indexPath.section == 0  )
  {
    return 45.0f;
  }else if(indexPath.item == [self.amountNeededByItem count] && indexPath.section == 1 ){
    return 45.0f;
  }else if(indexPath.section == 0)
  {
    return 45.0f;
  }else if(indexPath.section == 1){
    return 120.0f;
  }else{
    return 55.0f;
  }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.item;
    if (indexPath.section == 0 ) {
    
        Closet *selectedCloset = self.closets[self.selectedIndex];
        [Closet changeCloset:selectedCloset.closet_id];
        CreateClosetViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateClosetViewController"];
        vc.closet = selectedCloset;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(indexPath.section == 1){
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClothingTableViewController"];
        [self performSegueWithIdentifier:@"viewByItem" sender:self];
    }else if(indexPath.section == 2){
        [self performSegueWithIdentifier:@"toTagView" sender:self];
    }
}
- (IBAction)browseBytagPushed:(id)sender {
    [self performSegueWithIdentifier:@"toTagView" sender:self];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toClosets"]) {
        ClosetDetailViewController *vc = (ClosetDetailViewController *)segue.destinationViewController;
        vc.notUpdated = YES;
        vc.index = self.selectedIndex;
    }else if ([segue.identifier isEqualToString:@"viewByItem"]){
        BrowseByItemTableViewController *vc = (BrowseByItemTableViewController *)segue.destinationViewController;
        Closet *closet = self.closets[0];
        vc.type = [closet clothingTypeAtIndex:self.selectedIndex];
    }else if([segue.identifier isEqualToString:@"toCreateCloset"]){
        CreateClosetViewController *vc = (CreateClosetViewController *)[segue destinationViewController];
        vc.hasOtherClosets = YES;
    }
}

@end
