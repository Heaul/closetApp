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

NSString *const MFDemoErrorDomain = @"MFDemoErrorDomain";
NSInteger const MFDemoErrorCode = 100;
@interface ViewController()  <UITextFieldDelegate>

@end

@implementation ViewController

-(void)setupTextField:(MFTextField *)textFied{


    textFied.tintColor = [UIColor flatSkyBlueColor];
    textFied.textColor = [UIColor flatWhiteColor];
    textFied.defaultPlaceholderColor = [UIColor flatWhiteColor];
    textFied.placeholderAnimatesOnFocus = YES;
    textFied.textPadding = CGSizeMake(0, 5);
    NSError *error = nil;
  }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.hidden = YES;
    [self setupTextField:self.passwordField];
    [self setupTextField:self.loginField];
    self.loginButton.mBackgroundColor = [UIColor flatMintColor];
    [self.loginButton updateApperance];
    self.loginField.delegate = self;
    self.passwordField.delegate = self;
    if (![self.shouldLogin boolValue]) {
        [self.loginButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.signUpButton setTitle:@"Login" forState:UIControlStateNormal];
        self.forgotLabel.hidden = YES;
    }else{
        self.forgotLabel.hidden = NO;
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
   
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    UIBlurEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * blurEffectView;
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.frame;
    [self.view insertSubview:blurEffectView aboveSubview:[self.view viewWithTag:55]];


       // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.errorLabel.layer.cornerRadius = 20.0f;
    self.errorLabel.layer.backgroundColor = [UIColor flatRedColor].CGColor;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![self.shouldLogin boolValue]) {
        self.loginButton.mBackgroundColor = [UIColor flatSkyBlueColor];
        [self.loginButton updateApperance];
    }
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
/*
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.passwordField) {
        [self validatePasswordField];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        if (textField == self.passwordField && [self.passwordField.text length] > 0) {
        [self validatePasswordField];
    }
}
*/
- (BOOL)validatePasswordField
{
    NSError *error = nil;
    if ([self.passwordField.text length] < 8) {

        error = [self errorWithLocalizedDescription:@"Password must be atleast 8 characters."];
        [self.passwordField setError:error animated:YES];
        return  NO;
    }else if(![self containsUppercase:self.passwordField.text] ){
        error = [self errorWithLocalizedDescription:@"Password must contain atleast 1 uppercase character."];
        [self.passwordField setError:error animated:YES];
        return  NO;
    }else if(![self.passwordField.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location != NSNotFound){
         error = [self errorWithLocalizedDescription:@"Password must contain atleast 2 numbers."];
        [self.passwordField setError:error animated:YES];
        return  NO;
    }
    return  YES;
}
-(BOOL)containsUppercase:(NSString *)password{
    NSString *passwordChecker = [password lowercaseString];
    if ([passwordChecker isEqualToString:password]) {
        return NO;
    }
    return YES;
}
-(BOOL)passwordFieldValid{
    if ([self.passwordField.text length] > 8) {
        return YES;
    }

    return NO;
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

-(void)loginAfterSignUp:(NSString *)email password:(NSString *)password{
     __weak ViewController *weakSelf = self;
        [[Networking sharedInstance] loginWithCredentials: email password:password success:^(NSHTTPURLResponse *response, LoginResponse *data) {
                [[Networking sharedInstance] saveToken:data.dict[@"key"]];
                [weakSelf.view endEditing:YES];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
            
                if(!weakSelf.originalViewController){
                    [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:^{
                         [weakSelf.delegate transitionToAppAfterSignUp];
                    }];
                }else{
                    [weakSelf.delegate transitionToAppAfterSignUp];
                }
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
        
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError *error = nil;
                        NSError *otherError = nil;
                        error = [weakSelf errorWithLocalizedDescription:@"Wrong email/password combination."];
                        otherError = [weakSelf errorWithLocalizedDescription:@" "];
                        [weakSelf.loginField setError:otherError animated:YES];
                        [weakSelf.passwordField setError:error animated:YES];
                    });
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        
     
        }];
}

- (NSError *)errorWithLocalizedDescription:(NSString *)localizedDescription
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: localizedDescription};
    return [NSError errorWithDomain:MFDemoErrorDomain code:MFDemoErrorCode userInfo:userInfo];
}
-(void)login{
    if (![self validateEmailWithString:self.loginField.text]) {
        NSError *error =nil;
        error = [self errorWithLocalizedDescription:@"Must contain a valid email Address"];
        [self.loginField setError:error animated:YES];
        return;
    }else if(!self.shouldLogin && ![self validatePasswordField]){
        return;
    
    }
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
                if(!weakSelf.originalViewController){
                    [weakSelf.presentingViewController dismissViewControllerAnimated:NO completion:^{
                         [weakSelf.delegate loginViewControllerDidLogin:self];
                    }];
                }else{
                    [weakSelf.delegate loginViewControllerDidLogin:self];
                }
            
            
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
        
                   // weakSelf.errorLabel.hidden = NO;
            
                    dispatch_async(dispatch_get_main_queue(), ^{
                       NSError *error = nil;
                        NSError *otherError = nil;
                        error = [weakSelf errorWithLocalizedDescription:@"Wrong email/password combination."];
                        otherError = [weakSelf errorWithLocalizedDescription:@" "];
                        [weakSelf.loginField setError:otherError animated:YES];
                        [weakSelf.passwordField setError:error animated:YES];                    //weakSelf.errorLabel.hidden = NO;
                       // weakSelf.errorLabel.text = @"Wrong Credentials";
                    });
        }];
        
    }else{
    //sign up
        __weak ViewController *weakSelf = self;
        NSString *email = self.loginField.text;
        NSString *password = self.passwordField.text;
        [SVProgressHUD showInfoWithStatus:@"Registering"];
        [[Networking sharedInstance] signUpWithCredentials:self.loginField.text password:self.passwordField.text success:^(NSHTTPURLResponse *response, SignUpResponse *data) {
            
             weakSelf.shouldLogin = [NSNumber numberWithBool:YES];
             [weakSelf.view endEditing:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    
                });
            });

            [weakSelf loginAfterSignUp:email password:password];
            
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error ) {
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // time-consuming task
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        
            // weakSelf.errorLabel.hidden = NO;
             dispatch_async(dispatch_get_main_queue(), ^{
             // weakSelf.errorLabel.hidden = NO;
             //  weakSelf.errorLabel.text = @"Email Already Registered";
                        NSError *error = nil;
                        error = [weakSelf errorWithLocalizedDescription:@"Account with this email already registered."];
                        [weakSelf.loginField setError:error animated:YES];
            });
        }];
    }
}

-(void)signUp{
    if (![self.shouldLogin boolValue]) {
          ViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
          controller.shouldLogin = [NSNumber numberWithBool:YES];
          controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
          if(self.originalViewController){
            controller.originalViewController = NO;
            [self presentViewController:controller animated:YES completion:nil];
          }else{
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
          }
        
    }else{
        ViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"];
        controller.shouldLogin = [NSNumber numberWithBool:NO];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        //[self presentViewController:controller animated:YES completion:nil];
        if(self.originalViewController){
            controller.originalViewController = NO;
            [self presentViewController:controller animated:YES completion:nil];
          }else{
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
          }

    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
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
