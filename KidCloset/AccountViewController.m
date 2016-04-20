//
//  AccountViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "AccountViewController.h"
#import "Networking+Auth.h"
#import "Closet.h"
@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        //[background addSubview:bg];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutPushed:(id)sender {
    NSString *token = [[Networking sharedInstance]getToken];
    [[Networking sharedInstance] logoutWithCredential:token Success:^(NSHTTPURLResponse *response, LoginResponse *data) {

        
    } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
 
    }];
}

@end
