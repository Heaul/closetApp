//
//  PickClothingTypeTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/19/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "PickClothingTypeTableViewController.h"
#import "Closet.h"
#import "AddItemTableViewController.h"

@interface PickClothingTypeTableViewController()
@property NSArray *keys;
@property NSString *typeSelected;
@end
@implementation PickClothingTypeTableViewController
//pickClothingTypeCell
-(void)viewDidLoad{
    self.keys = @[@"tops",@"bottoms",@"socks",@"underwear",@"shoes",@"swimwear",@"outerwear",@"dress_clothes",@"onesies",@"pajamas"];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"pickClothingTypeCell"forIndexPath:indexPath];
    NSString *text = self.keys[indexPath.item];
    if([text isEqualToString:@"dress_clothes"]){
        text = @"dress clothes";
    }
    cell.textLabel.text = text;
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.typeSelected = self.keys[indexPath.item];
    [self performSegueWithIdentifier:@"fromTypeToImage" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.keys count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"fromTypeToImage"]) {
        AddItemTableViewController *vc = (AddItemTableViewController *)segue.destinationViewController;
        vc.type = self.typeSelected;
        vc.currentClosetId = [Closet currentCloset];
        vc.imageUrl = self.image;
    }
}
@end
