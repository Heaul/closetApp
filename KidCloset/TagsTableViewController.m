//
//  TagsTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/29/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "TagsTableViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "PRMaterialTextField.h"
@interface TagsTableViewController ()
@property UIView *headerView;
@property PRMaterialTextField *textField;
@property TagsTableViewController *tableViewController;
@end

@implementation TagsTableViewController

- (instancetype)initWIthTags:(NSArray *)tags;
{
    if (self = [super init]) {
        self.title = @"Tags";

        self.contentSizeInPopup = CGSizeMake(300, 350);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        self.tags = tags;
    }
    return self;
}
- (IBAction) dismissKeyboard:(id)sender {
    [self.view endEditing:NO];
}
-(void)addTagPushed:(id)sender{
    NSString *tag = self.textField.text;
    if ([tag length] > 0) {
        NSMutableArray *tagTemp = [self.tags mutableCopy];
        [tagTemp addObject:tag];
        self.tags = [tagTemp copy];
        self.textField.text = @"";
        [self.tableView reloadData];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        [self addTagPushed:nil];
        [self dismissKeyboard:nil];
        self.textField.text = @"";
    }
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MCSwipeTableViewCell class] forCellReuseIdentifier:@"Cell"];
             UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
          tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [self.tableView addGestureRecognizer:tap];
    
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
        [self.headerView setBackgroundColor:[UIColor flatWhiteColor]];
    
    
         self.textField = [[PRMaterialTextField alloc]initWithFrame:CGRectMake(10, 10, self.tableView.frame.size.width - 20, 40)];
        self.textField.delegate = self;

        self.textField.placeholder = @"Tag Name";
        [self.textField setReturnKeyType:UIReturnKeyDone];
        self.addTagButton = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width/4,60, self.tableView.frame.size.width/2, 40)];
        self.tableView.tableFooterView = [UIView new]; // to hide empty cells
    
        [self.addTagButton setTitle:@"Add Tag" forState:UIControlStateNormal];
        [self.addTagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [self.addTagButton setBackgroundColor:[UIColor flatMintColor]];
       [self.addTagButton addTarget:self action:@selector(addTagPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:self.addTagButton];
        [self.headerView addSubview:self.textField];
    
    //    //self.view.frame.size == self.contentSizeInPopup
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.tags count] != 0){
        return [self.tags count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 105;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        self.addTagButton = [[UIButton alloc]initWithFrame:self.headerView.frame];
        [self.addTagButton setTitle:@"Add Tag" forState:UIControlStateNormal];
        [self.addTagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addTagButton setBackgroundColor:[UIColor flatMintColor]];
        [self.headerView addSubview:self.addTagButton];
    }
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCSwipeTableViewCell *cell = (MCSwipeTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if ([self.tags count] == 0) {
         cell.textLabel.text = @"No Tags";
         cell.textLabel.textAlignment = NSTextAlignmentCenter;
         [cell.textLabel setTextColor:[UIColor flatGrayColor]];
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        UIView *crossView = [self viewWithImageName:@"cross"];
        cell.textLabel.text = self.tags[indexPath.item];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        [cell.textLabel setTextColor:[UIColor flatBlackColor]];
        
        [cell setSwipeGestureWithView:crossView color:[UIColor flatRedColor] mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                NSLog(@"Did swipe \"Checkmark\" cell");
        }];
        cell.delegate = self;
    }
    // Configure the cell...
   
    return cell;
}
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell{

}

// Called when the user ends swiping the cell.
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell{
     NSParameterAssert(cell);
     NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *tempTags = [self.tags mutableCopy];
    [tempTags removeObjectAtIndex:indexPath.row];
    if ([tempTags count] == 0 ) {
        self.tags = @[];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        
    }else{
        self.tags = [tempTags copy];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

// Called during a swipe.
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage{


}


- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
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
