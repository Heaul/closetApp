//
//  ClosetDetailViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClosetDetailViewController.h"
#import "Networking+ClosetManager.h"
#import "ClosetDetailTableViewCell.h"
#import "Closet.h"
#import "ClothingTableViewController.h"
#import "CreateClosetViewController.h"
#import "AppDelegate.h"
#import "ClosetHeaderView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefresh.h"
#import "PRCloset.h"
#import "PRClothingItem.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ClosetDetailViewController()

@property (nonatomic, strong) PRCloset *cdCloset;

@property NSArray *closetData;
@property NSArray *closetKeys;
@property NSDictionary *closetDeafults;
@property Closet *closet;
@property NSString *selectedType;
@property NSArray *items;
@property NSDictionary *closetItems;
@property NSArray *sizes;
@property NSArray* closets;
@property UIView *headerView;
@property NSArray *headerViews;
@property BOOL initalLoad;
@end
@implementation ClosetDetailViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  /*  NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:self options:nil];
     ClosetHeaderView *view =  [nibContents firstObject];
     view.nameLabel.text = @"asdfasdfasdfasdf";
     [self.headerView addSubview:view];*/
    if (!self.initalLoad) {
        self.closets = [Closet loadClosetsFromCoreData];
        self.closet = self.closets[self.index];
        [self setupHeaders];
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
                    viewRect.size.height = 60;
                }
                viewRect.origin.y = 0;
                [view setFrame:viewRect];
                
            }
        }
    return self.headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    if(!self.notUpdated){
        self.index = 0;
        self.initalLoad = YES;
    }
    
    self.navigationController.navigationBar.translucent = NO;
      __weak ClosetDetailViewController *weakSelf = self;
        NSString *possibele_id = [NSString stringWithFormat:@"%@",[Closet currentCloset]] ;
/*
    [self.tableView addPullToRefreshWithActionHandler:^{
   
     [[Networking sharedInstance]GETClosetItemsWithId:possibele_id sucessHandler:^(NSHTTPURLResponse *response, GetClothingItemsResponse *data) {
                
                  
                    if(data.closetsExist){
                        if(data.closetArray){
                            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                            for (NSInteger i = 0;i< [data.closetArray count];i++){
                                Closet *closettemp = [[Closet alloc]initWithItems:data.closetArray[i]];
                                [tempArray addObject:closettemp];
                            }
                            weakSelf.closets = [tempArray copy];
                            weakSelf.closet = weakSelf.closets[weakSelf.index];
                        }else{
                            NSDictionary *dict = data.closetDict;
                            weakSelf.closet = [[Closet alloc]initWithItems:dict];
                        }
                        
                        [Closet changeCloset:weakSelf.closet.closet_id];
                        
                        
                        
                        NSInteger x = 0;
                        NSMutableArray *headerViewsTemp = [[NSMutableArray alloc]init];
                        
                        for (NSInteger i = 0; i< [weakSelf.closets count]; i++) {
                        
                            Closet *closetTemp = weakSelf.closets[i];
                            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:weakSelf options:nil];
                            ClosetHeaderView *view =  [nibContents firstObject];
                            view.translatesAutoresizingMaskIntoConstraints = YES;
                            view.autoresizingMask = UIViewAutoresizingNone;
                            view.nameLabel.text = [closetTemp.closetName capitalizedString];
                            view.sizeLabel.text = [NSString stringWithFormat:@"Size: %@", closetTemp.age];

                            if (i +1 < [weakSelf.closets count]) {
                                view.rightArrowView.hidden = NO;
                            }else{
                                 view.rightArrowView.hidden = YES;
                            }
                            if (i > 0) {
                                    view.leftArrowView.hidden = NO;
                            }else{
                                    view.leftArrowView.hidden = YES;
                            }
                            
                           [headerViewsTemp addObject:view];
                            x = x + weakSelf.tableView.frame.size.width;
                        }
                        
                        weakSelf.headerViews = [headerViewsTemp copy];
                        
                        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(headerSwipedLeft:)];
                        swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
                         [weakSelf.tableView addGestureRecognizer:swipeLeft];
                         
                           UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(headerSwipedRight:)];
                     swipeRight.direction = UISwipeGestureRecognizerDirectionLeft;
                     [weakSelf.tableView addGestureRecognizer:swipeRight];
                     
                      [weakSelf.tableView.pullToRefreshView stopAnimating];
                      [weakSelf.tableView reloadData];
                      
                      
                    [PRCloset updateCloests:weakSelf.closets];
                    weakSelf.initalLoad = NO;
                      
                    }else{
                        weakSelf.closet = [[Closet alloc]initWithItems:data.closetDict];
                        //CreateClosetViewController
                       CreateClosetViewController *vc = (CreateClosetViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CreateClosetViewController"];
                            vc.closet = weakSelf.closet;
                            vc.navigationItem.hidesBackButton = YES;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                        //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        //[app presentCreateCloset];
                    }

            } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
                    [weakSelf.tableView.pullToRefreshView stopAnimating];
            }];

   
    
    }];*/

    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    [self.navigationController setHidesNavigationBarHairline:YES];
    if(!self.notUpdated){
       // [self.tableView triggerPullToRefresh];
    }else{
        self.closets = [Closet loadClosetsFromCoreData];
        self.closet = self.closets[self.index];
        [self setupHeaders];
        [self.tableView reloadData];
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
    
    for (NSInteger i = 0; i< [self.closets count]; i++) {
        
            Closet *closetTemp = self.closets[i];
            NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomHeader" owner:self options:nil];
            ClosetHeaderView *view =  [nibContents firstObject];
            view.translatesAutoresizingMaskIntoConstraints = YES;
            view.autoresizingMask = UIViewAutoresizingNone;
            view.nameLabel.text = [closetTemp.closetName capitalizedString];
            view.sizeLabel.text = [NSString stringWithFormat:@"Size :%@", closetTemp.age];

            if (i +1 < [self.closets count]) {
                view.rightArrowView.hidden = NO;
            }else{
                 view.rightArrowView.hidden = YES;
            }
            if (i > 0) {
                    view.leftArrowView.hidden = NO;
            }else{
                    view.leftArrowView.hidden = YES;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedType = [self.closet clothingTypeAtIndex:indexPath.item];
    [self performSegueWithIdentifier:@"toItemDetail" sender:self];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.closet clothingTypeCount];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *colorArray  = @[[UIColor flatWatermelonColor],[UIColor flatTealColor],[UIColor flatSandColor],[UIColor flatNavyBlueColorDark],[UIColor flatMagentaColor],[UIColor flatSkyBlueColor],[UIColor flatWatermelonColorDark],[UIColor flatTealColor],[UIColor flatWatermelonColor],[UIColor flatMagentaColor],[UIColor flatMaroonColorDark],[UIColor flatNavyBlueColorDark],[UIColor flatSkyBlueColor],[UIColor flatWatermelonColorDark],[UIColor flatSkyBlueColor]];
    
    
    ClosetDetailTableViewCell  *cell =  (ClosetDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"clothingItem"forIndexPath:indexPath];
    cell.clothingDefaultAmountLabel.autoresizesSubviews = NO;
        NSString * clothingType = [self.closet clothingTypeAtIndex:indexPath.item];
        cell.clothingTypeLabel.text = [clothingType capitalizedString];
        if ([clothingType isEqualToString:@"dress_cloths"]) {
             cell.clothingTypeLabel.text = @"Dress Clothes";
        }
    
    
        cell.sizeLabel.text = [NSString stringWithFormat:@"%@",[self.closet clothingSizeForKey:clothingType]];
        NSNumber *val = [NSNumber numberWithInteger:[self.closet clothingItemsNeededForKey:clothingType]];

        cell.clothingDefaultAmountLabel.text =  [val stringValue];
        if ([self.closet mainClothingImageForKey:clothingType]) {
            NSString * image_url  = [self.closet mainClothingImageForKey:clothingType];
            NSURL *url = [[Networking sharedInstance] URLWithPath:image_url params:nil];
            
      
            [cell.iconView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"shirt"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }else{
        
            [cell customizeAppearance:colorArray[indexPath.item]];
            [cell.iconView setBackgroundColor:[UIColor colorWithRed:146/255.0 green:214/255.0 blue:216/255.0 alpha:1]];
            //[cell.iconView setBackgroundColor:[UIColor flatGrayColor]];
            cell.iconView.image = [UIImage imageNamed:@"shirt"];
        }
       // [cell setDuration:0.40]; //set the duration of the entrance animation
       // [cell addAnimation:kASTableViewCellAnimationSlideFromLeft];
       [cell layoutIfNeeded];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //[(ASTableViewCell *)cell animate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"toItemDetail"]) {
            ClothingTableViewController *vc = (ClothingTableViewController *) segue.destinationViewController;
            vc.type = self.selectedType;
            vc.closetId = self.closet_id;
            vc.closet = self.closet;
            vc.items = self.closetItems[self.selectedType];
    }else if([segue.identifier isEqualToString:@"createCloset"]){
         CreateClosetViewController *vc = (CreateClosetViewController *) segue.destinationViewController;
         vc.closet = self.closet;
         [self.navigationItem setHidesBackButton:YES animated:YES];
         
    }else if([segue.identifier isEqualToString:@"toCloset"]){
         CreateClosetViewController *vc = (CreateClosetViewController *) segue.destinationViewController;
         vc.closet = self.closet;         
    }

}


-(void)headerSwipedRight:(id)sender{
    __weak ClosetDetailViewController * weakSelf = self;
    
     ClosetHeaderView *onScreenheader =  self.headerViews[self.index];
    
    if (self.index + 1  < [self.closets count]){
        self.index++;
        self.closet = self.closets[self.index];
         [Closet changeCloset:self.closet.closet_id];
        ClosetHeaderView *header =  self.headerViews[self.index];
        
        CGRect frame = header.frame;
        frame.origin.x = self.tableView.frame.size.width;
        frame.origin.y = 0;
        header.frame = frame;
        header.leftArrowView.hidden = YES;
        [self.headerView addSubview:header];
        [UIView animateWithDuration:0.6 animations:^{
            onScreenheader.rightArrowView.hidden = YES;
             header.leftArrowView.hidden = NO;
            onScreenheader.frame = CGRectMake(0-weakSelf.tableView.frame.size.width,0, onScreenheader.frame.size.width, onScreenheader.frame.size.height);

             CGRect frameTo = weakSelf.headerView.frame;
             frameTo.origin.y = 0;
             header.frame = frameTo;


            [weakSelf.tableView reloadRowsAtIndexPaths: [self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationLeft];
            
        } completion:^(BOOL finished) {
            onScreenheader.rightArrowView.hidden = NO;
        }];
    }
    
    
}

-(void)headerSwipedLeft:(id)sender{
    CGRect frame = self.headerView.frame;
    frame.origin.x += self.view.bounds.size.width;
      __weak ClosetDetailViewController * weakSelf = self;
    if (self.index  > 0){
     ClosetHeaderView *onScreenheader =  self.headerViews[self.index];
    self.index--;
    self.closet = self.closets[self.index];
    [Closet changeCloset:self.closet.closet_id];
    ClosetHeaderView *header =  self.headerViews[self.index];
    CGRect frame = header.frame;
    frame.origin.x = 0 - self.tableView.frame.size.width;
     frame.origin.y = 0;
    header.frame = frame;
     header.rightArrowView.hidden = YES;
    [self.headerView addSubview:header];

        [UIView animateWithDuration:0.6 animations:^{
          onScreenheader.frame = CGRectMake(weakSelf.tableView.frame.size.width,0, onScreenheader.frame.size.width, onScreenheader.frame.size.height);
                    header.rightArrowView.hidden = NO;
                     onScreenheader.leftArrowView.hidden = YES;
                             CGRect frameTo = weakSelf.headerView.frame;
                             frameTo.origin.y = 0;
                             header.frame = frameTo;
            
                                   [weakSelf.tableView reloadRowsAtIndexPaths: [self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationRight];

            
        } completion:^(BOOL finished) {
            onScreenheader.leftArrowView.hidden = NO;
       
            

        }];
        
    }
    
}



@end
