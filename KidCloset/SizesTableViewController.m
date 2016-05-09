//
//  SizesTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 4/20/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "SizesTableViewController.h"
#import "Closet.h"
#import "ClosetHeaderView.h"
#import "ClothingTableViewController.h"
#import "FilterTableViewController.h"
#import "Networking+ClosetManager.h"
#import "PRCloset.h"
#import "SVPullToRefresh.h"
#import "HomeViewController.h"
@interface SizesTableViewController () <FilterControllerDelegate>

@property NSArray *sizes;
@property NSArray *clothingTypes;
@property NSArray *closets;
@property NSArray *headerViews;
@property UIView *headerView;
@property NSInteger index;
@property Closet *closet;
@property BOOL shouldShowAllItems;
@property REMenu *filterMenu;
@property RWBlurPopover *popover;
@property FilterTableViewController *filterController;
@property NSArray *clothingTypeSelected;
@property NSArray *sizesSelected;
@property NSArray *filterdSizeSelected;
@property NSArray *filterdClothingTypes;
@property NSArray *filteredTags;
@property NSArray *filterdSizes;

@end

@implementation SizesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.tableView.delegate = self;
    self.index = 0;
    __weak SizesTableViewController *weakSelf = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Closets" style:UIBarButtonItemStylePlain target:self action:@selector(closetsPushed:)];
    
     NSString *possibele_id = [NSString stringWithFormat:@"%@",[Closet currentCloset]] ;
    [self.tableView addPullToRefreshWithActionHandler:^{
      [[Networking sharedInstance]GETClosetItemsWithId:@"" sucessHandler:^(NSHTTPURLResponse *response, GetClothingItemsResponse *data) {
      
                if(data.closetsExist){
                    if(data.closetArray){
                        weakSelf.closets = [Closet sortedClosetFromData:data.closetArray];
                    }else{
                        #warning fail gracefully
                        return;
                    }
                    
                [PRCloset updateCloests:weakSelf.closets];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                  
                /*weakSelf.initialLoad = NO;
                weakSelf.closetAmountsNeeded = [Closet amountNeededForAllClosets:weakSelf.closets];
                weakSelf.amountNeededByItem = [Closet clothingItemsNeededForKeyForClosets:weakSelf.closets];
                weakSelf.tags = [Closet allTags];
                weakSelf.refreshing = NO;*/
                [weakSelf updateInformation];
                weakSelf.closet = weakSelf.closets[0];
                [weakSelf setupHeaders];
                if ([weakSelf.closets count] > 1) {
                     weakSelf.index = 1;
                    weakSelf.shouldShowAllItems = YES;
                }

                
                [weakSelf.tableView reloadData];
                }else{
                  /*   weakSelf.closet = [[Closet alloc]initWithItems:data.closetDict];
                    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                    NSLog(@"creating push");
                    weakSelf.refreshing = NO;
                    [delegate presentCreateCloset:weakSelf.closet];*/
                }

        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
               // weakSelf.refreshing = NO;
                [weakSelf.tableView.pullToRefreshView stopAnimating];
        }];
    }];
    [self.tableView triggerPullToRefresh];
}

-(void)updateInformation{
    self.sizes = [Closet standardChoices];
    self.clothingTypes = [[Closet standardAmounts] allKeys];
    self.filterdClothingTypes = [self.clothingTypes copy];
    self.filterdSizes = [self.sizes copy];
    self.closets = [Closet loadClosetsFromCoreData];
    if ([self.closets count] > 1) {
        self.shouldShowAllItems = YES;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    self.closets = [Closet loadClosetsFromCoreData];
    if ([self.closets count] > 1) {
        self.shouldShowAllItems = YES;
    }else{
        self.shouldShowAllItems = NO;
    }
    [self setupHeaders];
    [self.tableView reloadData];
    //self.closets = [Closet loadClosetsFromCoreData];

    //[self setupHeaders];
   //[self.tableView reloadData];
}

-(void)dismissFilter{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.filterButton setAction:@selector(filterPushed:)];
    [self.tableView reloadData];
}

-(void)updateFilter{
    self.clothingTypeSelected = [self.filterController.clothingTypeSelected copy];
    self.filterdSizeSelected = [self.filterController.sizesSelected copy];
    
    NSMutableArray *filteredClothingTypesTemp = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.clothingTypeSelected count]; i++) {
        if ([self.clothingTypeSelected[i] boolValue] == YES) {
            [filteredClothingTypesTemp addObject:self.clothingTypes[i]];
        }
    }
    self.filterdClothingTypes = [filteredClothingTypesTemp copy];
    
    NSMutableArray *filteredSizesTemp = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.filterdSizeSelected count]; i++) {
        if ([self.filterdSizeSelected[i] boolValue] == YES) {
            [filteredSizesTemp addObject:self.sizes[i]];
        }
    }
    
    self.filterdSizes = [filteredSizesTemp copy];
    if ([self.filterdSizes count] == 0) {
        self.filterdSizes = self.sizes;
    }
    if ([self.filterdClothingTypes count] == 0) {
        self.filterdClothingTypes = self.clothingTypes;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.filterButton setAction:@selector(filterPushed:)];
    [self.tableView reloadData];
}
- (IBAction)filterPushed:(id)sender {

    FilterTableViewController * filterController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FilterController"];
    
    [filterController setPreferredContentSize:CGSizeMake(self.tableView.frame.size.width-20, self.tableView.frame.size.height - self.tableView.frame.size.height/5)];
    
    filterController.cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissFilter:)];
    filterController.clothingTypeSelected = self.clothingTypeSelected;
    filterController.sizesSelected = self.filterdSizeSelected;
    filterController.delegate = self;
    RWBlurPopover *popoverTemp = [[RWBlurPopover alloc] initWithContentViewController:filterController];
    
    popoverTemp.throwingGestureEnabled = NO;
    popoverTemp.tapBlurToDismissEnabled = YES;
    [popoverTemp showInViewController:self.navigationController];
    self.filterController = filterController;
    self.popover = popoverTemp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.filterdSizes count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return [self.filterdClothingTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sizeCell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel *clothingTypeLabel = [cell viewWithTag:88];
    UILabel *amountTypeLabel = [cell viewWithTag:77];
    NSInteger amount;
    if (self.index == 0 && self.shouldShowAllItems) {
         amount = [[Closet allClothingItemsOfType:self.filterdClothingTypes[indexPath.item] withSize:self.filterdSizes[indexPath.section - 1]] count];
        }
    else{
        amount = [self.closet clothingCountForKey:self.self.filterdClothingTypes[indexPath.item] withSize:self.filterdSizes[indexPath.section -1]];
    }
    amountTypeLabel.text = [NSString stringWithFormat:@"%ld",amount];
    if([self.filterdClothingTypes[indexPath.item] isEqualToString:@"dress_cloths"]){
        clothingTypeLabel.text = @"Dress Clothes";
    }else{
        clothingTypeLabel.text = [self.filterdClothingTypes[indexPath.item] capitalizedString];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 70;
    }
    return  45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (!self.headerView) {
             self.headerView = [[UIView alloc]init];
             self.headerView.translatesAutoresizingMaskIntoConstraints = YES;
             self.headerView.autoresizingMask = UIViewAutoresizingNone;
        }
        if ([self.headerViews count] != 0) {
                
                ClosetHeaderView * view  =  (ClosetHeaderView *)self.headerViews[self.index];
                if (![view isDescendantOfView:self.headerView]) {
                    [view setBackgroundColor:[UIColor greenColor]];
                    [self.headerView addSubview:view];
                    CGRect viewRect = self.headerView.frame;
                     if (viewRect.size.width == 0) {
                        viewRect.size.width = self.tableView.frame.size.width;
                        viewRect.size.height = 70;
                    }
                    viewRect.origin.y = 0;
                    [view setFrame:viewRect];
                    
                }
            }
        return self.headerView;
    }else{
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"SizeHeaderView" owner:self options:nil];
        FZAccordionTableViewHeaderView *view =  [nibContents firstObject];
        UILabel *label = [view viewWithTag:99];
        label.text = self.filterdSizes[section-1];
        
        if ([self.filterdSizes[section-1] isEqualToString:self.closet.age]){
            [view setBackgroundColor:[UIColor flatMintColor]];
            [label setBackgroundColor:[UIColor flatMintColor]];
            [label setTextColor:[UIColor flatWhiteColor] ];
        }else{
            NSInteger a = 0;
            if(a != 0){
                [label setBackgroundColor:[UIColor flatWhiteColorDark]];
            }else{
                [label setBackgroundColor:[UIColor flatWhiteColor]];
            }
            
        }
        return view;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
ClothingTableViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClothingTableViewController"];
    vc.type = self.filterdClothingTypes[indexPath.item];
     vc.chosenSize = self.filterdSizes[indexPath.section - 1];
    if (self.shouldShowAllItems && self.index == 0) {
         [self.navigationController pushViewController:vc animated:YES];
    }else{
         vc.closetId = self.closet.closet_id;
        vc.closet = self.closet;
       // vc.items = [self.closet clothingItemForKey:self.clothingTypes[indexPath.item]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)setupHeaders{
    if (!self.headerView) {
        self.headerView = [[UIView alloc]init];
         self.headerView.translatesAutoresizingMaskIntoConstraints = YES;
         self.headerView.autoresizingMask = UIViewAutoresizingNone;
    }
    NSInteger x = 0;
    NSMutableArray *headerViewsTemp = [[NSMutableArray alloc]init];
     NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:self options:nil];
     if (self.shouldShowAllItems ) {
        ClosetHeaderView *view =  [nibContents firstObject];
        view.translatesAutoresizingMaskIntoConstraints = YES;
        view.autoresizingMask = UIViewAutoresizingNone;
        view.nameLabel.text = @"All Closets";
        view.sizeLabel.text = @"";
        [view.pageController setNumberOfPages:[self.closets count] + 1];
        [view.pageController setCurrentPage:0];
        [headerViewsTemp addObject:view];
    }
    
    for (NSInteger i = 0; i< [self.closets count]; i++) {
        
            Closet *closetTemp = self.closets[i];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:self options:nil];
            ClosetHeaderView *view =  [nibContents firstObject];
            view.translatesAutoresizingMaskIntoConstraints = YES;
            view.autoresizingMask = UIViewAutoresizingNone;
            view.nameLabel.text = [closetTemp.closetName capitalizedString];
            view.sizeLabel.text = [NSString stringWithFormat:@"%@", closetTemp.age];
            if ([self.closets count] > 1) {
                [view.pageController setNumberOfPages:[self.closets count] + 1];
            }else{
                [view.pageController setNumberOfPages:[self.closets count]];
            }
        
            if (self.shouldShowAllItems ) {
             [view.pageController setCurrentPage:i+1];
            }
        
           [headerViewsTemp addObject:view];
            x = x + self.tableView.frame.size.width;
        }
        
    self.headerViews = [headerViewsTemp copy];

    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerSwipedLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerSwipedRight:)];
     swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.tableView addGestureRecognizer:swipeRight];
}

-(void)headerSwipedRight:(id)sender{
    __weak SizesTableViewController * weakSelf = self;
    
     ClosetHeaderView *onScreenheader =  self.headerViews[self.index];
    
    if (self.index + 1  < [self.headerViews count]){
        self.index++;
        if (self.shouldShowAllItems) {
             self.closet = self.closets[self.index-1];
             [Closet changeCloset:self.closet.closet_id];

        }else{
             self.closet = self.closets[self.index];
             [Closet changeCloset:self.closet.closet_id];

        }
        ClosetHeaderView *header =  self.headerViews[self.index];
        [header.pageController setCurrentPage:self.index];
        CGRect frame = header.frame;
        frame.origin.x = self.tableView.frame.size.width;
        frame.origin.y = 0;
        header.frame = frame;
        [self.headerView addSubview:header];
        [UIView animateWithDuration:0.6 animations:^{
               onScreenheader.frame = CGRectMake(0-weakSelf.tableView.frame.size.width,0, onScreenheader.frame.size.width, onScreenheader.frame.size.height);

             CGRect frameTo = weakSelf.headerView.frame;
             frameTo.origin.y = 0;
             header.frame = frameTo;


            [weakSelf.tableView reloadRowsAtIndexPaths: [self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationLeft];
            
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
        }];
    }
    
    
}

-(void)headerSwipedLeft:(id)sender{
    CGRect frame = self.headerView.frame;
    frame.origin.x += self.view.bounds.size.width;
      __weak SizesTableViewController * weakSelf = self;
    if (self.index  > 0){
    
     ClosetHeaderView *onScreenheader =  self.headerViews[self.index];
    self.index--;
    if (self.shouldShowAllItems && self.index == 0) {
    
    }else if(self.shouldShowAllItems){
         self.closet = self.closets[self.index -1];
         [Closet changeCloset:self.closet.closet_id];
    }else{
        self.closet = self.closets[self.index];
        [Closet changeCloset:self.closet.closet_id];

    }
    ClosetHeaderView *header =  self.headerViews[self.index];
    [header.pageController setCurrentPage:self.index];
    CGRect frame = header.frame;
    frame.origin.x = 0 - self.tableView.frame.size.width;
     frame.origin.y = 0;
    header.frame = frame;
    [self.headerView addSubview:header];

        [UIView animateWithDuration:0.6 animations:^{
          onScreenheader.frame = CGRectMake(weakSelf.tableView.frame.size.width,0, onScreenheader.frame.size.width, onScreenheader.frame.size.height);
                             CGRect frameTo = weakSelf.headerView.frame;
                             frameTo.origin.y = 0;
                             header.frame = frameTo;
            
                                   [weakSelf.tableView reloadRowsAtIndexPaths: [self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationRight];

            
        } completion:^(BOOL finished) {
            [self.tableView reloadData];
            

        }];
        
    }
    
}
- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{
        if ([self.filterdSizes[section-1] isEqualToString:self.closet.age]) {
            return;
        }
    
        UILabel *label = [header viewWithTag:99];
         [label setBackgroundColor:[UIColor flatWhiteColorDark]];

}
- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{
}
- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{
        if ([self.filterdSizes[section-1] isEqualToString:self.closet.age]) {
            return;
        }
        [header setBackgroundColor:[UIColor flatWhiteColor]];
         UILabel *label = [header viewWithTag:99];
        [label setBackgroundColor:[UIColor flatWhiteColor]];

}
- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{

}
-(void)closetsPushed:(id)sender{
    HomeViewController *closetController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    /*CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];*/
    
    [self.navigationController pushViewController:closetController animated:YES];
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
