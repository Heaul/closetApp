//
//  LoginViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/2/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ViewController.h"
#import "Networking+Auth.h"
#import "Networking+Registration.h"
#import "PRFlatButton.h"
#import "PRMaterialTextField.h"
#import "PRFlatClearButton.h"
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.hidden = YES;
    self.loginField.delegate = self;
    self.passwordField.delegate = self;
    if (![self.shouldLogin boolValue]) {
        [self.loginButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.signUpButton setTitle:@"Login" forState:UIControlStateNormal];
        self.forgotLabel.hidden = YES;
    }else{
        self.forgotLabel.hidden = NO;
    
    }
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * blurEffectView;
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.frame;
    [self.view insertSubview:blurEffectView belowSubview:self.loginField];


       // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.errorLabel.layer.cornerRadius = 20.0f;
    self.errorLabel.layer.backgroundColor = [UIColor flatRedColor].CGColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
 UITouch *touch = [touches anyObject];
 if(![touch.view isMemberOfClass:[UITextField class]]) {
     if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }else if([self.loginField isFirstResponder]){
        [self.loginField resignFirstResponder];
    }
 }
}

-(void)dismissKeyboard :(id) sender
{
    [self.passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignUpPushed:(id)sender {
    [self signUp];
    
}


#pragma mark - Table View Data Source and Delegate
- (IBAction)loginPushed:(id)sender {
    [self login];
}

-(void)loginAfterSignUp{
     __weak ViewController *weakSelf = self;
        [[Networking sharedInstance] loginWithCredentials: self.loginField.text password:self.passwordField.text success:^(NSHTTPURLResponse *response, LoginResponse *data) {
                [[Networking sharedInstance] saveToken:data.dict[@"key"]];
                [weakSelf.view endEditing:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        
                [weakSelf.delegate loginViewControllerDidLogin:self];
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.errorLabel.hidden = NO;
                    
                        weakSelf.errorLabel.text = @"Wrong Credentials";
                    });
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        
     
        }];
}
-(void)login{
    //login
    if([self.shouldLogin boolValue]){
     __weak ViewController *weakSelf = self;
        [[Networking sharedInstance] loginWithCredentials: self.loginField.text password:self.passwordField.text success:^(NSHTTPURLResponse *response, LoginResponse *data) {
        
                [[Networking sharedInstance] saveToken:data.dict[@"key"]];
                [weakSelf.view endEditing:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    // time-consuming task
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                });
        
                [weakSelf.delegate loginViewControllerDidLogin:self];
            
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
        
                    weakSelf.errorLabel.hidden = NO;
            
                    dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.errorLabel.hidden = NO;
                        weakSelf.errorLabel.text = @"Wrong Credentials";
                    });
        }];
        
    }else{
    //sign up
        __weak ViewController *weakSelf = self;
        [SVProgressHUD showInfoWithStatus:@"Registering"];
        [[Networking sharedInstance] signUpWithCredentials:self.loginField.text password:self.passwordField.text success:^(NSHTTPURLResponse *response, SignUpResponse *data) {
            
             weakSelf.shouldLogin = [NSNumber numberWithBool:YES];
             [weakSelf.view endEditing:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showInfoWithStatus:@"Logining In"];
                });
            });
             [weakSelf loginAfterSignUp];
            
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error ) {
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        
             weakSelf.errorLabel.hidden = NO;
             dispatch_async(dispatch_get_main_queue(), ^{
              weakSelf.errorLabel.hidden = NO;
               weakSelf.errorLabel.text = @"Email Already Registered";
            });
        }];
    }
}

-(void)signUp{
    if (![self.shouldLogin boolValue]) {
          ViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
          controller.shouldLogin = [NSNumber numberWithBool:YES];
          [self presentViewController:controller animated:YES completion:nil];
        
    }else{
          ViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
          controller.shouldLogin = [NSNumber numberWithBool:NO];
          [self presentViewController:controller animated:YES completion:nil];

    }
}

#pragma mark - Text Field Delegate

- (BOOL) textFieldShouldReturn:(UITextField*)aTextField {
    if ( aTextField == self.loginField ) {
        [self.passwordField becomeFirstResponder];
    } else if ( aTextField == self.passwordField ) {
        [self.passwordField resignFirstResponder];
        [self login];
    }
    
    return YES;
}

// Text field and scroll view delegate methods implemented here in order to
// prevent the table view from scrolling when the keyboard appears, but
// otherwise retain scroll behavior




@end
