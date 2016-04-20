//
//  LoginViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "LoginViewController.h"
#import "Networking.h"
@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIImageView *background = [[UIImageView alloc]initWithFrame:self.view.frame];
    [background setImage:[UIImage imageNamed:@"Closet"]];
    background.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:background];
    FXBlurView *bg = [[FXBlurView alloc]initWithFrame:self.view.frame];
    [bg setBlurEnabled:YES];
    bg.blurRadius = 20;
    [background addSubview:bg];

    
    [self.loginField addIcon:@"MailIcon"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignUpPushed:(id)sender {
    

    
}


#pragma mark - Table View Data Source and Delegate

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

-(void)signUp{

}

#pragma mark - Text Field Delegate

- (BOOL) textFieldShouldReturn:(UITextField*)aTextField {
    if ( aTextField == self.loginField ) {
        [self.passwordField becomeFirstResponder];
    } else if ( aTextField == self.passwordField ) {
        [self signUp];
    }
    
    return YES;
}

// Text field and scroll view delegate methods implemented here in order to
// prevent the table view from scrolling when the keyboard appears, but
// otherwise retain scroll behavior

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.tableView.scrollEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.scrollEnabled = YES;
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( !self.tableView.scrollEnabled ) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


@end
