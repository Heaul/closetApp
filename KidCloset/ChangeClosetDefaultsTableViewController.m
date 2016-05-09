//
//  ChangeClosetDefaultsTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/17/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ChangeClosetDefaultsTableViewController.h"
#import "ChangeDefaultClosetTableViewCell.h"
#import "Networking+ClosetManager.h"
@implementation ChangeClosetDefaultsTableViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super initWithCoder:aDecoder]) {
        self.title = @"Edit Defaults";
         self.contentSizeInPopup = CGSizeMake(300, 350);
         self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:NO animated:YES];
    if (self.hasSize) {
        self.sizes = [Closet standardChoices];
        NSInteger indexOfCurrentSize = [self.sizes indexOfObject:self.size];
        NSMutableArray * valuesTemp = [[NSMutableArray alloc]init];
        for(NSInteger i = 0;i<[self.closet.itemKeys count];i++){
            NSString *clothingType = [self.closet clothingTypeAtIndex:i];
            NSString *val = self.closet.defaultSizes[clothingType];
            [valuesTemp addObject:val];
        }
        self.values = [valuesTemp copy];
    }else{
        self.sizes = [Closet standardChoices];
        
        
        NSMutableArray * valuesTemp = [[NSMutableArray alloc]init];
        for(NSInteger i = 0;i<[self.closet.itemKeys count];i++){
            NSString *clothingType = [self.closet clothingTypeAtIndex:i];
            NSString *val = self.closet.defaultAmounts[clothingType];
            [valuesTemp addObject:val];
        }
        self.values = [valuesTemp copy];
    
    
    }
}
-(void)updateInfo{
    if (self.hasSize) {
        NSMutableDictionary *closetSizesTemp = [self.closet.defaultSizes mutableCopy];
        for (NSInteger i = 0; i<[self.closet.itemKeys count]; i++) {
            NSString *clothingType = [self.closet clothingTypeAtIndex:i];
            closetSizesTemp[clothingType] = self.values[i];
        }
        self.closet.defaultSizes = [closetSizesTemp copy];
    }else{
        NSMutableDictionary *closetAmountTemp = [self.closet.defaultAmounts mutableCopy];
        for (NSInteger i = 0; i<[self.closet.itemKeys count]; i++) {
            NSString *clothingType = [self.closet clothingTypeAtIndex:i];
            closetAmountTemp[clothingType] = self.values[i];
        }
        self.closet.defaultAmounts = [closetAmountTemp copy];
    }

}
- (IBAction)savePushed:(id)sender {


    [self updateInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.closet.itemKeys count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(!self.hasSize)
    {
        return @"Default Quanity";
    }
    else
    {
        return @"Default Sizes";
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)customCell forRowAtIndexPath:(NSIndexPath *)indexPath{
     ChangeDefaultClosetTableViewCell  *cell =  (ChangeDefaultClosetTableViewCell *)customCell;
      if (!self.hasSize) {
    
        float val = [self.values[indexPath.item] floatValue];
        NSLog(@"clothing Type %@ with number %f",[self.closet clothingTypeAtIndex:indexPath.item],val);
        cell.stepper.value = val;
        cell.stepper.countLabel.text = [NSString stringWithFormat:@"%ld",(long)val];
    }else{
        NSString *value = self.values[indexPath.item];
        cell.stepper.value = [self.sizes indexOfObject:value];;
        cell.stepper.countLabel.text = self.values[indexPath.item];
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ChangeDefaultClosetTableViewCell  *cell =  (ChangeDefaultClosetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"editDefaultsCell"forIndexPath:indexPath];
  
  
    NSString *clothingType = [self.closet clothingTypeAtIndex:indexPath.item ];
    
    
    cell.clothingTypeLabel.text = [clothingType capitalizedString];
    
    if ([clothingType isEqualToString:@"dress_cloths"]) {
        cell.clothingTypeLabel.text = @"Dress Clothes";
    }
    
    cell.stepper.hidesDecrementWhenMinimum = YES;
    cell.stepper.hidesIncrementWhenMaximum = YES;
    cell.stepper.stepInterval = 1.0f;
    
    if (!self.hasSize) {
    
      /*  float val = [self.values[indexPath.item] floatValue];
        cell.stepper.value = val;
        cell.stepper.countLabel.text = [NSString stringWithFormat:@"%ld",(long)val];*/
        
        __weak ChangeClosetDefaultsTableViewController * weakSelf = self;
        cell.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
        
            if ([weakSelf.tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound)
            {
                stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
            }
            
             NSMutableArray *val = [weakSelf.values mutableCopy];
             val[indexPath.item] = [NSNumber numberWithFloat:count];
             weakSelf.values = [val copy];
        };
        
    }else{
    
        cell.stepper.maximum = (float)[self.sizes count]-1;
        NSString *value = self.values[indexPath.item];
       // cell.stepper.value = [self.sizes indexOfObject:value];;
       // cell.stepper.countLabel.text = self.values[indexPath.item];
        
        __weak ChangeClosetDefaultsTableViewController * weakSelf = self;
        cell.stepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
            if ([weakSelf.tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound)
                {
                      stepper.countLabel.text =weakSelf.sizes[(NSInteger)count];
                }
            NSMutableArray *val = [weakSelf.values mutableCopy];
            val[indexPath.item] = weakSelf.sizes[(NSInteger)count];
            weakSelf.values = [val copy];
        };
    }
   return cell;

}



@end
