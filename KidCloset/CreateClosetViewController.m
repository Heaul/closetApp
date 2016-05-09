//
//  CreateClosetViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/6/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "CreateClosetViewController.h"
#import "Networking+ClosetManager.h"
#import "ActionSheetStringPicker.h"
#import "Closet.h"
#import "ChangeClosetDefaultsTableViewController.h"
#import "AppDelegate.h"
#import "PRCloset.h"
@interface CreateClosetViewController()
@property ChangeClosetDefaultsTableViewController *tableViewController;
@property (strong,nonatomic)STPopupController *popupController;
@property BOOL hasCreated;
@end
@implementation CreateClosetViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    self.genderField.delegate = self;
    self.ageField.delegate =self;
    self.nameField.delegate = self;
    
    if (self.closet.closetName) {
        self.nameField.text = [self.closet.closetName capitalizedString];
    }
    if(self.closet.gender){
        self.genderField.text = [self.closet.gender capitalizedString];
    }
    if (self.closet.age) {
        self.ageField.text  = [self.closet age];
    }
    
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    if (!self.closet.itemKeys) {
         self.closet = [[Closet alloc]initWithKeys];
         self.closet.defaultSizes = [[NSDictionary alloc]init];
    }
    [self.navigationController.navigationBar setTintColor:[UIColor flatWhiteColor]];
    self.navigationController.navigationBar.barTintColor =  [UIColor flatPowderBlueColorDark];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor flatPowderBlueColorDark]];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isFirstRun) {
          AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            if (self.isMovingFromParentViewController && self.hasCreated) {
                [Closet clearCloset];
                [[Networking sharedInstance] clearToken];
                [delegate presentFirstScreen];
            }
    }
}
- (IBAction)editSizePushed:(id)sender {
    [self pushFor:YES];
}
- (IBAction)editQuanityPushed:(id)sender {
    [self pushFor:NO];
}
- (IBAction) dismissKeyboard:(id)sender {
    [self.view endEditing:NO];
}


- (BOOL) textFieldShouldReturn:(UITextField*)aTextField {

    
    return YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        //[background addSubview:bg];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     UITouch *touch = [touches anyObject];
     if((![touch.view isMemberOfClass:[PRMaterialTextField class]] &&  ![touch.view isMemberOfClass:[UITextField class]]) || [self.nameField isFirstResponder] ) {
         [touch.view endEditing:YES];
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushFor:(BOOL)forSize{

   self.tableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangeClosetDefaultsTableViewController"];
   if([self.closet.defaultSizes count] == 0){
   NSMutableDictionary *vals = [[NSMutableDictionary alloc]init];;
    for (NSInteger i = 0; i<[self.closet.itemKeys count]; i++  ) {
        if([self.ageField.text length] > 0){
            vals[self.closet.itemKeys[i]] = self.ageField.text;
        }else{
            vals[self.closet.itemKeys[i]] = @"NB";
        }
    }
    self.closet.defaultSizes = vals;
   
   }
   if ([self.closet.defaultAmounts count] == 0) {
        self.closet.defaultAmounts = [Closet standardAmounts];
    }
   self.tableViewController.closet = self.closet;
   
   if (forSize) {
        self.tableViewController.hasSize = YES;
            if ([self.ageField.text length] > 0){
                self.tableViewController.size = self.ageField.text;
            }else{
                self.tableViewController.size = @"1M";
            }
    }

    
    
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.tableViewController];
    //[popupController presentInViewController:self];*/
    
    //[STPopupNavigationBar appearance].barTintColor = [UIColor flatPowderBlueColorDark];
    [STPopupNavigationBar appearance].tintColor = [UIColor flatSkyBlueColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3], NSForegroundColorAttributeName: [UIColor flatSkyBlueColor] };
    
     [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[STPopupNavigationBar class]]]setTitleTextAttributes:@{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} forState:UIControlStateNormal];
     
    self.tableViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped:)];
    
    self.tableViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
;
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self completion:nil];
    
    self.popupController = popupController;
}
-(void)cancelButtonTapped:(id)sender{
    //[self.tagView clearTags];
   __weak CreateClosetViewController *weakSelf = self;
    [self.popupController dismissWithCompletion:^{
        weakSelf.popupController = nil;
    }];
}

-(void)doneButtonTapped:(id)sender{
    //[self.tagView clearTags];
    [self.tableViewController updateInfo];
   __weak CreateClosetViewController *weakSelf = self;
    [self.popupController dismissWithCompletion:^{
        weakSelf.popupController = nil;
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.nameField) {
         return  YES;
    }else if(textField == self.ageField){
        [self.nameField resignFirstResponder];
        [self.ageField setUserInteractionEnabled:YES];
        [self.ageField resignFirstResponder];
         NSArray * types = [Closet standardChoices];
        
         
        __weak CreateClosetViewController  *weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:@"Select Size"
                                                rows:types
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                self.ageField.text = types[selectedIndex];
                                                [self.ageField endEditing:YES];
                                                [self.ageField setHighlighted:NO];
                                                self.ageField.highlighted = NO;
                                                NSArray * keys = [weakSelf.closet.defaultSizes allKeys];
                                                NSMutableDictionary *sizesMutable = [weakSelf.closet.defaultSizes mutableCopy];
                                                for (NSInteger i = 0; i<[keys count]; i++) {
                                                    [sizesMutable setValue:types[selectedIndex] forKey:keys[i]];
                                                }
                                                weakSelf.closet.defaultSizes = [sizesMutable copy];
                                               
                                            }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             [weakSelf.ageField endEditing:YES];
                                             
                                            }
                                          origin:self.view];


            return NO;
    }else if(textField == self.genderField){
        [self.nameField resignFirstResponder];
        [self.genderField setUserInteractionEnabled:YES];
        [self.genderField resignFirstResponder];
        NSArray * types = @[@"Male",@"Female"];
        __weak CreateClosetViewController  *weakSelf = self;
        [ActionSheetStringPicker showPickerWithTitle:@"Select Gender"
                                                rows:types
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                self.genderField.text = types[selectedIndex];
                                                [self.genderField endEditing:YES];
                                                [self.genderField setHighlighted:NO];
                                                 self.genderField.highlighted = NO;
                                            }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             [weakSelf.genderField endEditing:YES];
                                             
                                            }
                                          origin:self.view];

        return NO;
    }
    return YES;

}

- (IBAction)donePushed:(id)sender {
    [self createOrEdit];
}


- (IBAction)editDefualtsPushed:(id)sender {
    
    
}

-(void)createOrEdit{
    if (!self.closet.closetName) {
    
        Closet *closet = [[Closet alloc]initWithDictionary:@{@"name":self.nameField.text,@"gender":self.genderField.text,@"age":self.ageField.text}];
        closet.defaultAmounts = self.closet.defaultAmounts;
        closet.defaultSizes = self.closet.defaultSizes;
        closet.closetName = self.nameField.text;
        closet.age= self.ageField.text;
        closet.gender = self.genderField.text;
        if([self.closet.defaultSizes count] == 0){
            NSMutableDictionary *vals = [[NSMutableDictionary alloc]init];;
            for (NSInteger i = 0; i<[self.closet.itemKeys count]; i++  ) {
                if([self.ageField.text length] > 0){
                    vals[self.closet.itemKeys[i]] = self.ageField.text;
                }else{
                    vals[self.closet.itemKeys[i]] = @"NB";
                }
            }
            closet.defaultSizes = vals;
        }
        if ([self.closet.defaultAmounts count] == 0) {
            self.closet.defaultAmounts = [Closet standardAmounts];
        }
        
        [[Networking sharedInstance]createClosetWithCloset:closet SucessHandler:^(NSHTTPURLResponse *response, NSDictionary *data) {
            if(self.closet.closet_id){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if(self.hasOtherClosets){
                
                 [PRCloset updateCloests:@[closet]];
                 [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else{
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [app presentMainApplication];
            }
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
     
        }];
    }else{
        self.closet.closetName = self.nameField.text;
        self.closet.age = self.ageField.text;
        self.closet.gender = self.genderField.text;
        [[Networking sharedInstance]createClosetWithCloset:self.closet SucessHandler:^(NSHTTPURLResponse *response, NSDictionary *data) {
            [PRCloset updateCloests:@[self.closet]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
     
        }];
        
    }


}

- (IBAction)createPushed:(id)sender {

    [self createOrEdit];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"defaultQuanity"]) {
        ChangeClosetDefaultsTableViewController *defaults =  (ChangeClosetDefaultsTableViewController *)segue.destinationViewController;
        defaults.closet = self.closet;
    }else if([segue.identifier isEqualToString:@"defaultSizes"]) {
        ChangeClosetDefaultsTableViewController *defaults =  (ChangeClosetDefaultsTableViewController *)segue.destinationViewController;
        defaults.closet = self.closet;
        defaults.hasSize = YES;
        if ([self.ageField.text length] > 0){
            defaults.size = self.ageField.text;
        }else{
            defaults.size = @"1M";
        }
    }
}

@end
