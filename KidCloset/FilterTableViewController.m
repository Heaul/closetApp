//
//  FilterTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 4/25/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "FilterTableViewController.h"
#import "Closet.h"
#import "BEMCheckBox.h"
#import "FZAccordionTableView.h"

@interface FilterTableViewController ()
@property NSArray *clothingTypes;
@property NSArray *sizes;
@property NSArray *headers;
@property BOOL updateChecks;
@end



@implementation FilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headers = @[[self headerSetupForSection:0],[self headerSetupForSection:1],[self headerSetupForSection:2],[self headerSetupForSection:3]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor flatWhiteColor]];
    self.clothingTypes = [[Closet standardAmounts] allKeys];
    self.sizes = [Closet standardChoices];
    self.tags = [Closet allTags];
    self.seasons = [Closet seasons];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.clothingTypes count]; i++) {
        [array addObject:[NSNumber numberWithBool:NO]];
    }
    NSMutableArray *sizeArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.sizes count]; i++) {
        [sizeArray addObject:[NSNumber numberWithBool:NO]];
    }
    NSMutableArray *tagArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.tags count]; i++) {
        [tagArray addObject:[NSNumber numberWithBool:NO]];
    }
    NSMutableArray *seasonArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.seasons count]; i++) {
        [seasonArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    if ([self.clothingTypeSelected count] == 0) {
    self.clothingTypeSelected = [array copy];
    }
    if ([self.sizesSelected count] == 0) {
        self.sizesSelected = [sizeArray copy];
    }
    if ([self.tagsSelected count] == 0) {
        self.tagsSelected = [tagArray copy];
    }
    if ([self.seasonsSelected count] == 0) {
        self.seasonsSelected = [seasonArray copy];
    }
    
    
   /* UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [tableHeaderView setBackgroundColor:[UIColor flatGrayColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/4, 5, self.tableView.frame.size.width/2, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor  = [UIColor flatWhiteColor];
    label.text = @"Filter";
    [tableHeaderView addSubview:label];
    self.tableView.tableHeaderView = tableHeaderView;*/
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.clothingTypes count] + 1;
    }else if(section == 1){
        return [self.sizes count] + 1;
    
    }else if(section == 2){
        return [self.tags count] + 1;
    }else if(section == 3){
        return  [self.seasons count] + 1;
    }
    else {return 5;}
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  45;
}
-(UIView *)headerSetupForSection:(NSInteger)section{
    FZAccordionTableViewHeaderView *view = [[FZAccordionTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, self.tableView.frame.size.width-300, 44)];
    BEMCheckBox *checkbox  =   [[BEMCheckBox alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/2.5, 5, 30, 40)];
    
    if (section == 0) {
        label.text = @"Filter by Clothing Types";
        if ([self.clothingTypeSelected containsObject:[NSNumber numberWithBool:YES]]) {
            [checkbox setOn:YES animated:NO];
        }
    }else if(section == 1){
        label.text = @"Filter by Size";
        if ([self.sizesSelected containsObject:[NSNumber numberWithBool:YES]]) {
            [checkbox setOn:YES animated:NO];
        }
    }else if(section == 2){
        if ([self.tagsSelected containsObject:[NSNumber numberWithBool:YES]]) {
            [checkbox setOn:YES animated:NO];
        }
        label.text = @"Filter by Tags";
    }else if(section == 3){
        if ([self.seasonsSelected containsObject:[NSNumber numberWithBool:YES]]) {
            [checkbox setOn:YES animated:NO];
        }
        label.text = @"Filter by Season";
    }
    
    [label setTextColor:[UIColor flatNavyBlueColorDark]];
    checkbox.tag = 66;
    checkbox.userInteractionEnabled = NO;
    [checkbox setOnFillColor:[UIColor whiteColor]];
    [checkbox setOnCheckColor:[UIColor flatMintColor]];
    [checkbox setOnTintColor:[UIColor whiteColor]];
    [checkbox setHideBox:YES];
    [view addSubview:label];
    [view addSubview:checkbox];
    [view setBackgroundColor:[UIColor flatWhiteColor]];
    [label setBackgroundColor:[UIColor whiteColor]];
    return view;


}
-(FZAccordionTableViewHeaderView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   /* if (!self.headers || [self.headers count] == 0 ) {
        self.headers = @[[self headerSetupForSection:0],[self headerSetupForSection:1],[self headerSetupForSection:2],[self headerSetupForSection:3]];
    }*/

    
    return self.headers[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   

    if (indexPath.item == 0) {
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell" forIndexPath:indexPath];
        UIButton *button = [cell viewWithTag:44];
        UIButton *cancelButton = [cell viewWithTag:33];
        [button addTarget:self action:@selector(selectAllForSection:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton addTarget:self action:@selector(clearSection:) forControlEvents:UIControlEventTouchUpInside];
        return  cell;
    }
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:44];
    if (indexPath.section == 0) {
        if ([self.clothingTypes[indexPath.item -1] isEqualToString:@"dress_cloths"]) {
            label.text = @"Dress Clothes";
        }else{
            label.text = [self.clothingTypes[indexPath.item-1] capitalizedString];
        }
    }else if(indexPath.section == 1){
        label.text = self.sizes[indexPath.item-1];
    }else if(indexPath.section == 2){
          label.text = self.tags[indexPath.item-1];
    }else{
        label.text = self.seasons[indexPath.item-1];
    }
    
    [label setBackgroundColor:[UIColor flatWhiteColor]];
    [cell.contentView setBackgroundColor:[UIColor flatWhiteColor]];
    [cell setBackgroundColor:[UIColor flatWhiteColor]];
    BEMCheckBox *checkbox = [cell viewWithTag:88];
    checkbox.onAnimationType = BEMAnimationTypeBounce;
    checkbox.offAnimationType = BEMAnimationTypeFill;
    checkbox.userInteractionEnabled = NO;
    if(indexPath.section == 0 && [self.clothingTypeSelected[indexPath.item-1] boolValue] == YES){
        [checkbox setOn:YES animated:self.updateChecks];
    }else if(indexPath.section == 0){
        [checkbox setOn:NO animated:self.updateChecks];

    }else if(indexPath.section == 1 && [self.sizesSelected[indexPath.item-1] boolValue] == YES){
        [checkbox setOn:YES animated:self.updateChecks];

    }else if(indexPath.section == 1){
        [checkbox setOn:NO animated:self.updateChecks];

    }else if(indexPath.section == 2 && [self.tagsSelected[indexPath.item-1] boolValue] == YES){
        [checkbox setOn:YES animated:self.updateChecks];
    }else if(indexPath.section == 2){
        [checkbox setOn:NO animated:self.updateChecks];

    }else if(indexPath.section == 3 && [self.seasonsSelected[indexPath.item-1] boolValue] == YES){
        [checkbox setOn:YES animated:self.updateChecks];
    }else if(indexPath.section == 3){
        [checkbox setOn:NO animated:self.updateChecks];

    }
    checkbox.hidden = NO;
    return cell;
}

-(void)shouldUpdateHeaderAtSection:(NSInteger)section toShow:(BOOL)show{
    UIView *view = self.headers[section];
    BEMCheckBox *box = [view viewWithTag:66];
    NSNumber *checker = [NSNumber numberWithBool:YES];
    if (section == 0 &&  [self.clothingTypeSelected containsObject:checker]) {
        BOOL shouldAnimate = !box.on;
        [box setOn:YES animated:shouldAnimate];
    }else if(section == 1 &&  [self.sizesSelected containsObject:checker]){
        BOOL shouldAnimate = !box.on;
        [box setOn:YES animated:shouldAnimate];
    }else if(section == 2 &&  [self.tagsSelected containsObject:checker]){
        BOOL shouldAnimate = !box.on;
        [box setOn:YES animated:shouldAnimate];
    }else if(section == 3 &&  [self.seasonsSelected containsObject:checker]){
        BOOL shouldAnimate = !box.on;
        [box setOn:YES animated:shouldAnimate];
    }else{
        BOOL shouldAnimate = box.on;
        [box setOn:NO animated:shouldAnimate];
    }
}

-(UITableViewCell *)parentCellForView:(id)theView 
{
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        }
        else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

-(void)clearSection:(id)sender{
    UIButton *butn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:butn];
    if (!cell) {
        return;
    }
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     [self updateSection:indexPath.section withValue:NO];
    [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];
    self.updateChecks = YES;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.updateChecks = NO;

    

}
-(void)updateSection:(NSInteger)section withValue:(BOOL)value{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
     if(section == 0){
        for (NSInteger i = 0; i<[self.clothingTypeSelected count]; i++) {
            [tempArray addObject:[NSNumber numberWithBool:value]];
        }
      self.clothingTypeSelected = [tempArray copy];
     }else if(section == 1){
        for (NSInteger i = 0; i<[self.sizesSelected count]; i++) {
            [tempArray addObject:[NSNumber numberWithBool:value]];
        }
        self.sizesSelected = [tempArray copy];
     
     }else if(section == 2){
        for (NSInteger i = 0; i<[self.tagsSelected count]; i++) {
            [tempArray addObject:[NSNumber numberWithBool:value]];
        }
        self.tagsSelected = [tempArray copy];
     }else if(section == 3){
        for (NSInteger i = 0; i<[self.seasonsSelected count]; i++) {
            [tempArray addObject:[NSNumber numberWithBool:value]];
        }
        self.seasonsSelected = [tempArray copy];
     }
    
}
-(void)selectAllForSection:(id)sender{
    UIButton *butn = (UIButton *)sender;
    UITableViewCell *cell = [self parentCellForView:butn];
    if (!cell) {
        return;
    }
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self updateSection:indexPath.section withValue:YES];
    [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];
    self.updateChecks = YES;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.updateChecks = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
   
    if (indexPath.item == 0) {
        //[self selectAllForSection:indexPath.section];
        [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];
        self.updateChecks = YES;
        [self.tableView reloadData];
        [self.tableView layoutIfNeeded];
        self.updateChecks = NO;
        return;
    }
    
    
    
    BEMCheckBox *checkbox  =  [cell viewWithTag:88];
    if (indexPath.section == 0 && [self.clothingTypeSelected[indexPath.item-1] boolValue] == NO) {
    
         NSMutableArray *tempArray = [self.clothingTypeSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:YES];
         self.clothingTypeSelected = [tempArray copy];
         [checkbox setOn:YES animated:YES];
         [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];

    }else if(indexPath.section == 0){
         NSMutableArray *tempArray = [self.clothingTypeSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:NO];
         self.clothingTypeSelected = [tempArray copy];
        [self shouldUpdateHeaderAtSection:indexPath.section toShow:NO];

         [checkbox setOn:NO animated:YES];
    }else if(indexPath.section == 1 && [self.sizesSelected[indexPath.item-1] boolValue] == NO) {
         NSMutableArray *tempArray = [self.sizesSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:YES];
         self.sizesSelected = [tempArray copy];
         [checkbox setOn:YES animated:YES];
        [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];

    }else if(indexPath.section == 1){
         NSMutableArray *tempArray = [self.sizesSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:NO];
         self.sizesSelected = [tempArray copy];
         [checkbox setOn:NO animated:YES];
         [self shouldUpdateHeaderAtSection:indexPath.section toShow:NO];
    }else if(indexPath.section == 2 && [self.tagsSelected[indexPath.item-1] boolValue] == NO) {
         NSMutableArray *tempArray = [self.tagsSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:YES];
         self.tagsSelected = [tempArray copy];
         [checkbox setOn:YES animated:YES];
        [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];

    }else if(indexPath.section == 2){
         NSMutableArray *tempArray = [self.tagsSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:NO];
         self.tagsSelected = [tempArray copy];
         [checkbox setOn:NO animated:YES];
         [self shouldUpdateHeaderAtSection:indexPath.section toShow:NO];
    }else if(indexPath.section == 3 && [self.seasonsSelected[indexPath.item-1] boolValue] == NO) {
         NSMutableArray *tempArray = [self.seasonsSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:YES];
         self.seasonsSelected = [tempArray copy];
         [checkbox setOn:YES animated:YES];
        [self shouldUpdateHeaderAtSection:indexPath.section toShow:YES];

    }else if(indexPath.section == 3){
         NSMutableArray *tempArray = [self.seasonsSelected mutableCopy];
         tempArray[indexPath.item-1] = [NSNumber numberWithBool:NO];
         self.seasonsSelected = [tempArray copy];
         [checkbox setOn:NO animated:YES];
         [self shouldUpdateHeaderAtSection:indexPath.section toShow:NO];
    }
   
}
- (IBAction)cancelButtonPushed:(id)sender {
    [self.delegate dismissFilter];
}
- (IBAction)updateButtonPushed:(id)sender {
    [self.delegate updateFilter];
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
