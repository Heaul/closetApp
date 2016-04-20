//
//  TagTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 4/13/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "TagTableViewController.h"
#import "Closet.h"
#import "ClothingItemTableViewCell.h"
#import "ClothingItem.h"
#import "Networking+ClosetManager.h"
@interface TagTableViewController ()
@property NSArray *tags;
@end

@implementation TagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tags = [Closet allItemsWithTag];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tags count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tags[section][@"items"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerViewForClost:section];

}
-(UIView *)headerViewForClost:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor flatMintColor]];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width/2 ,50)];
    nameLabel.text = [[self.tags[section][@"name"] valueForKey:@"name"] capitalizedString];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.numberOfLines = 1;
    
  
    
    [view addSubview:nameLabel];
       return view;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  ClothingItemTableViewCell *cell = (ClothingItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"tagCell" forIndexPath:indexPath];
    
    ClothingItem *item = self.tags[indexPath.section][@"items"][indexPath.item];
    
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

    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
   // return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
