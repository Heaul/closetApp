//
//  FirstController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/29/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "FirstController.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface FirstController ()

@end

@implementation FirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   /*  UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * blurEffectView;
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.frame;
    [self.view insertSubview:blurEffectView aboveSubview:self.backImageView];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"signUp"]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ViewController *vc = (ViewController *)segue.destinationViewController;
        vc.delegate = appDelegate;
        vc.shouldLogin = [NSNumber numberWithBool:NO];
    }else{
        ViewController *vc = (ViewController *)segue.destinationViewController;
        vc.shouldLogin = [NSNumber numberWithBool:YES];
    
    }
}


@end
