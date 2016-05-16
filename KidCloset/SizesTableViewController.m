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
#import "FZAccordionTableView.h"
@interface SizesTableViewController () <FilterControllerDelegate,FZAccordionTableViewDelegate>

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
@property NSArray *filterdSeasons;
@property NSArray *filterdTagsSelected;
@property NSArray *filterdSeasonsSelected;
@property BOOL scrolling;
@property BOOL shouldOpenSection;
@end

@implementation SizesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.index = 0;
    __weak SizesTableViewController *weakSelf = self;
     [(FZAccordionTableView *)self.tableView setAllowMultipleSectionsOpen:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Closets" style:UIBarButtonItemStylePlain target:self action:@selector(closetsPushed:)];
    
     NSString *possibele_id = [NSString stringWithFormat:@"%@",[Closet currentCloset]] ;
    [self.tableView addPullToRefreshWithActionHandler:^{
      [[Networking sharedInstance]GETClosetItemsWithId:@"" sucessHandler:^(NSHTTPURLResponse *response, GetClothingItemsResponse *data) {
      
                if(data.closetsExist){
                    if(data.closetArray){
                        weakSelf.closets = [Closet sortedClosetFromData:data.closetArray];
                    }else{
                        #warning fail gracefully
                        NSLog(@"ERROR");
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
                [weakSelf updateOpenSection];
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
/*-(void)openSectionForChosenSize:(NSString *)size{
    
      if ([self.filterdSizes containsObject:size]) {
        NSInteger index = [self.filterdSizes indexOfObject:size]+1 ;
        if ( ![(FZAccordionTableView *)self.tableView isSectionOpen:index]) {
            [(FZAccordionTableView *)self.tableView toggleSection:index];
        }
      }
}*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isEqual:self.tableView.panGestureRecognizer]) {
        return YES;
    }
    else if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

-(void)updateInformation{
    self.sizes = [Closet standardChoices];
    self.clothingTypes = [[Closet standardAmounts] allKeys];
    self.filterdClothingTypes = [self.clothingTypes copy];
    self.filterdSizes = [self.sizes copy];
    self.filterdSeasons = [Closet seasons];
    self.closets = [Closet loadClosetsFromCoreData];
    if ([self.closets count] > 1) {
        self.shouldShowAllItems = YES;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    self.closets = [Closet loadClosetsFromCoreData];
    if (self.index != 0) {
         self.closet = self.closets[self.index - 1];
    }
   
    if ([self.closets count] > 1) {
        self.shouldShowAllItems = YES;
    }else{
        self.shouldShowAllItems = NO;
    }
    
    [self setupHeaders];
    [self reload];
    
    //self.closets = [Closet loadClosetsFromCoreData];

    //[self setupHeaders];
    //[self.tableView reloadData];
}

-(void)dismissFilter{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.filterButton setAction:@selector(filterPushed:)];
    [self reload];
}

-(void)updateFilter{
    self.clothingTypeSelected = [self.filterController.clothingTypeSelected copy];
    self.filterdSizeSelected = [self.filterController.sizesSelected copy];
    self.filterdTagsSelected = [self.filterController.tagsSelected copy];
    self.filterdSeasonsSelected = [self.filterController.seasonsSelected copy];
    
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
    
    NSMutableArray *filteredTagsTemp = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.filterdTagsSelected count]; i++) {
        if ([self.filterdTagsSelected[i] boolValue] == YES) {
            [filteredTagsTemp addObject:self.filterController.tags[i]];
        }
    }
    self.filteredTags = [filteredTagsTemp copy];
    
    NSMutableArray *filteredSeasonsTemp = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<[self.filterdSeasonsSelected count]; i++) {
        if ([self.filterdSeasonsSelected[i] boolValue] == YES) {
            [filteredSeasonsTemp addObject:self.filterController.seasons[i]];
        }
    }
    self.filterdSeasons = [filteredSeasonsTemp copy];

    if ([self.filterdSizes count] == 0) {
        self.filterdSizes = self.sizes;
    }
    if ([self.filterdClothingTypes count] == 0) {
        self.filterdClothingTypes = self.clothingTypes;
    }
    if ([self.filteredTags count] == 0) {
        self.filteredTags = @[];
    }
    if ([self.filterdSeasons count] == 0) {
        self.filterdSeasons = [Closet seasons];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.filterButton setAction:@selector(filterPushed:)];
    [self updateNavBarFilterSymbol];
    [self reload];
    [self.tableView layoutIfNeeded];
}

- (IBAction)filterPushed:(id)sender {

    FilterTableViewController * filterController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"FilterController"];
    
    [filterController setPreferredContentSize:CGSizeMake(self.tableView.frame.size.width-20, self.tableView.frame.size.height - self.tableView.frame.size.height/5)];
    
    filterController.cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissFilter:)];
    filterController.clothingTypeSelected = self.clothingTypeSelected;
    filterController.sizesSelected = self.filterdSizeSelected;
    filterController.tagsSelected = self.filterdTagsSelected;
    filterController.seasonsSelected = self.filterdSeasonsSelected;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sizeCell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel *clothingTypeLabel = [cell viewWithTag:88];
    UILabel *amountTypeLabel = [cell viewWithTag:77];
    NSInteger amount;
    
    if (self.index == 0 && self.shouldShowAllItems) {
         amount = [[Closet allFilteredClothingItemsIn:self.closets ofType:self.filterdClothingTypes[indexPath.item]  withSize:self.filterdSizes[indexPath.section-1] withTags:self.filteredTags withSeasons:self.filterdSeasons] count];
         NSArray *amountNeeded = [[Closet loadClosetsFromCoreData] valueForKey:@"defaultAmounts"];
         NSInteger totalNeeded = 0;
         for (NSInteger i = 0; i<[amountNeeded count]; i++) {
            Closet *cl = self.closets[i];
            if ([cl.defaultSizes[self.filterdClothingTypes[indexPath.item]] isEqualToString:self.filterdSizes[indexPath.section -1]] ) {
            
                totalNeeded = totalNeeded +  [(NSNumber *) amountNeeded[i][self.filterdClothingTypes[indexPath.item]] integerValue];
            }
         }
         if (totalNeeded == 0) {
            amountTypeLabel.text = [NSString stringWithFormat:@"%ld",amount];
            amountTypeLabel.textAlignment = NSTextAlignmentCenter;

        }else{
            amountTypeLabel.text = [NSString stringWithFormat:@"%ld of %ld",amount,totalNeeded];
            amountTypeLabel.textAlignment = NSTextAlignmentCenter;

        }
    }else{
        amount = [[self.closet clothingForKey:self.filterdClothingTypes[indexPath.item] withSize:self.filterdSizes[indexPath.section - 1] withSeasons:self.filterdSeasons withTags:self.filteredTags] count];
            if ([self.filterdSizes[indexPath.section - 1] isEqualToString:[self.closet clothingSizeForKey:self.filterdClothingTypes[indexPath.item]]]) {
            
                
                 amountTypeLabel.text = [NSString stringWithFormat:@"%ld of %@",amount,self.closet.defaultAmounts[self.filterdClothingTypes[indexPath.item]]];
                 amountTypeLabel.textAlignment = NSTextAlignmentCenter;
                
            }else{
                amountTypeLabel.text = [NSString stringWithFormat:@"%ld",amount];
                amountTypeLabel.textAlignment = NSTextAlignmentCenter;
            }
    }

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

-(void)headerViewSwiped:(UIPanGestureRecognizer *)gestureRecognizer{

    CGPoint touchPoint = [gestureRecognizer locationInView:self.tableView];
    CGPoint trans =  [gestureRecognizer translationInView:self.tableView];
    NSInteger originalLocation = touchPoint.x - trans.x;
    if (originalLocation > self.tableView.frame.size.width/2 ) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        //self.tableView.scrollEnabled = NO;
    }
    ClosetHeaderView *view = (ClosetHeaderView *)gestureRecognizer.view;

    UIView *label = [view viewWithTag:99];
    CGRect xRect;

    if (trans.x > 0) {
        xRect = CGRectMake(trans.x, label.frame.origin.y, self.tableView.frame.size.width, label.frame.size.height);
    }else{
        xRect = CGRectMake(0, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    }

    [label setFrame:xRect];

    
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled ) {
             self.tableView.scrollEnabled = YES;
        }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.tableView.scrollEnabled = YES;
        if (touchPoint.x > self.view.frame.size.width/2) {
        
            ClosetHeaderView *view = (ClosetHeaderView *)gestureRecognizer.view;
            NSInteger section = view.tag - 100;
            NSMutableArray *tempFilterdSizes = [self.filterdSizes mutableCopy];
            NSMutableArray *tempFilterdSelected;
            if (self.filterdSizeSelected) {
                tempFilterdSelected = [self.filterdSizeSelected mutableCopy];
                tempFilterdSelected[section-1] = [NSNumber numberWithBool:NO];
            }else{
                tempFilterdSelected = [[NSMutableArray alloc]init];
                for (NSInteger i = 0; i<[self.sizes count]; i++) {
                    if (i == section - 1) {
                         [tempFilterdSelected addObject:[NSNumber numberWithBool:NO]];
                    }else{
                        [tempFilterdSelected addObject:[NSNumber numberWithBool:YES]];
                    }
                }
            }
            self.filterdSizeSelected = [tempFilterdSelected copy];
        
            [tempFilterdSizes removeObjectAtIndex:(section-1)];
            self.filterdSizes = [tempFilterdSizes copy];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationRight];
            
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(section, 10)];
            [self updateNavBarFilterSymbol];
            [self.tableView reloadSections:indexes withRowAnimation:UITableViewRowAnimationMiddle];
            
        }else{
          ClosetHeaderView *view = (ClosetHeaderView *)gestureRecognizer.view;
            UIView *label = [view viewWithTag:99];
            CGRect xRect = CGRectMake(0, label.frame.origin.y, self.tableView.frame.size.width + 5, label.frame.size.height);
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
                     [label setFrame:xRect];
            } completion:^(BOOL finished) {
                CGRect xRect = CGRectMake(0, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
                [label setFrame:xRect];
            }];
        }
    }

}
-(UIColor *)colorForPercent:(NSInteger)percetNeeded{
          UIColor *color;
          if (percetNeeded  >= 90) {
                color = [UIColor flatMintColor];
            }else if(percetNeeded >= 75 ){
                color = [UIColor flatYellowColor];
            }else if(percetNeeded >= 30 ){
                color = [UIColor flatOrangeColor];
            }else{
                color = [UIColor flatRedColor];
            }
            return color;

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
         view.tag = section + 100;
        UIPanGestureRecognizer* sgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewSwiped:)];
        sgr.delegate = self;
         // change direction accordingly
        [view addGestureRecognizer:sgr];
        view.userInteractionEnabled = YES;

        if (([self.filterdSizes[section-1] isEqualToString:self.closet.age] && self.index != 0 && self.shouldShowAllItems) ||([self.filterdSizes[section-1] isEqualToString:self.closet.age] && !self.shouldShowAllItems )){
            if (!self.shouldShowAllItems || (self.shouldShowAllItems && self.index != 0))  {
                NSInteger percetNeeded = [self.closet percentageNeededForSize:self.filterdSizes[section-1] withFilterdClothingTypes:self.filterdClothingTypes];
                UIColor *color = [self colorForPercent:percetNeeded];
                [view.contentView setBackgroundColor:color];
                [label setBackgroundColor:color];
                [label setTextColor:[UIColor flatWhiteColor]];
            }
            
        }else if(self.shouldShowAllItems  && self.index == 0){
            
            
              NSInteger percetNeeded = 0;
            
              NSInteger counter = 0;
              for(NSInteger j = 0;j<[self.closets count];j++){
                Closet *cl = self.closets[j];
                   for(NSInteger i = 0;i < [self.filterdClothingTypes count];i++){
                        if([[cl clothingSizeForKey:self.filterdClothingTypes[i]] isEqualToString:self.filterdSizes[section-1]]){
                            if (percetNeeded == 0) {
                                percetNeeded = 1;
                            }
                                NSInteger percentForType = [self.closet percentageNeededForSize:self.filterdSizes[section-1] withFilterdClothingTypes:@[self.filterdClothingTypes[i]]];
                                percetNeeded = percetNeeded + percentForType;
                                counter = counter + 1;
                        }
                       
                   }
               }
               
               if(counter != 0){
                    percetNeeded = percetNeeded/counter;
                }

                UIColor *color = [self colorForPercent:percetNeeded];


                if (counter != 0) {
                    [view.contentView setBackgroundColor:color];
                    [label setBackgroundColor:color];
                    [label setTextColor:[UIColor flatWhiteColor]];
                }else{
                    [label setBackgroundColor:[UIColor flatWhiteColor]];
                }
            
        }else if(self.shouldShowAllItems && self.index != 0 && [self.closet doesNeedClothingForSize:self.filterdSizes[section - 1]]){
            NSArray *clothingTypesNeeded = [self.closet clohtingTypesNeededForSize:self.filterdSizes[section - 1]];
            NSMutableSet *intersection = [NSMutableSet setWithArray:clothingTypesNeeded];
            [intersection intersectSet:[NSSet setWithArray:self.filterdClothingTypes]];
            NSArray *filterdClothingTypesNeeded = [intersection allObjects];
            NSInteger percetNeeded = [self.closet percentageNeededForSize:self.filterdSizes[section -1] withFilterdClothingTypes:filterdClothingTypesNeeded];
             UIColor *color = [self colorForPercent:percetNeeded];

                [view.contentView setBackgroundColor:color];
                [label setBackgroundColor:color];
                [label setTextColor:[UIColor flatWhiteColor]];

        }else{
            NSInteger a = 0;
            if(a != 0){
                [label setBackgroundColor:[UIColor flatWhiteColorDark]];
            }else{
                [label setBackgroundColor:[UIColor flatWhiteColor]];
            }
            
        }
        if(!view){
            return [[UIView alloc]init];
        }
        return view;
    }
}
-(void)reload{
    [UIView transitionWithView: self.tableView
                  duration: 0.35f
                   options: UIViewAnimationOptionTransitionCrossDissolve
                animations: ^(void)
 {
      [self.tableView reloadData];
 }
                completion: nil];
/*
    if([self.tableView numberOfSections] == [self numberOfSectionsInTableView:self.tableView] && [self numberOfSectionsInTableView:self.tableView] > 1){
        NSRange range = NSMakeRange(1, 5);
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.tableView reloadData];
    }
    */
}
-(void)updateNavBarFilterSymbol{
    NSInteger filterCount = 0;
    if ([self.sizes count] != [self.filterdSizes count]) {
        filterCount = [self.filterdSizes count];
    }
    if ([self.clothingTypes count] != [self.filterdClothingTypes count]) {
        filterCount += [self.filterdClothingTypes count];
    }
    if ([self.filteredTags count]!= 0 ) {
        filterCount += [self.filteredTags count];
    }
    if ([[Closet seasons]count] != [self.filterdSeasons count]) {
        filterCount += [self.filterdSeasons count];
    }
    if (filterCount == 0) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Filter"];

    }else{
        [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"Filter (%ld)",filterCount]];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClothingTableViewController *vc =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClothingTableViewController"];
     vc.type = self.filterdClothingTypes[indexPath.item];
     vc.chosenSize = self.filterdSizes[indexPath.section - 1];
     vc.filterdSeason = self.filterdSeasons;
     vc.filterdTags = self.filteredTags;
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
    self.closets = [Closet loadClosetsFromCoreData];
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
    
    for (NSInteger i = 0; i < [self.closets count]; i++) {
        
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
    [self.headerView addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerSwipedRight:)];
     swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.headerView addGestureRecognizer:swipeRight];
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

            [weakSelf updateOpenSection];
           
        }];
    }
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{

      if (self.shouldOpenSection) {
        NSInteger index = [self.filterdSizes indexOfObject:self.closet.age]+1 ;
        if (index == NSNotFound || index > [self.filterdSizes count]) {
            return;
        }else if (index == section && ![(FZAccordionTableView *)self.tableView isSectionOpen:index]) {
            [(FZAccordionTableView *)self.tableView toggleSection:section];
            self.shouldOpenSection = NO;
        }
      }
}


-(void)updateOpenSection{
           if (( self.shouldShowAllItems && self.index != 0 )|| !self.shouldShowAllItems) {
                    self.shouldOpenSection = YES;
            }
            [self reload];
            //[self.tableView layoutIfNeeded];

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
            [weakSelf updateOpenSection];

        }];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.filterdSizes count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return [self.filterdClothingTypes count];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.scrolling = YES;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.scrolling = NO;

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.scrolling = NO;
}
- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{
        if ([self.closet doesNeedClothingForSize:self.filterdSizes[section-1]]) {
            return;
        }
    
        for(NSInteger i = 0;i<[self.closets count];i++){
            Closet *cl = self.closets[i];
            if([cl doesNeedClothingForSize:self.filterdSizes[section-1]]){
                return;
            }
        }
    
        UILabel *label = [header viewWithTag:99];
         [label setBackgroundColor:[UIColor flatWhiteColorDark]];

}
- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{
}
- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{
        if ([self.closet doesNeedClothingForSize:self.filterdSizes[section-1]]) {
            return;
        }
    
        for(NSInteger i = 0;i<[self.closets count];i++){
            Closet *cl = self.closets[i];
            if([cl doesNeedClothingForSize:self.filterdSizes[section-1]]){
                return;
            }
        }
    
            [header setBackgroundColor:[UIColor flatWhiteColor]];
            UILabel *label = [header viewWithTag:99];
            [label setBackgroundColor:[UIColor flatWhiteColor]];
        

}
- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header{

}
-(void)closetsPushed:(id)sender{
    HomeViewController *closetController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self.navigationController pushViewController:closetController animated:YES];
}


@end
