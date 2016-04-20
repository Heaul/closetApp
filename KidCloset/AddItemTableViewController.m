//
//  AddItemTableViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/7/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "AddItemTableViewController.h"
#import "ActionSheetStringPicker.h"
#import "Networking+PhotoUpload.h"
#import "TagsTableViewController.h"
#import "TagGroupView.h"

@interface AddItemTableViewController()
@property STPopupController *popupController;
@property TagsTableViewController *tableViewController;
@property NSArray *itemTags;
@end
@implementation AddItemTableViewController
- (IBAction)savePushed:(id)sender {

   [self createItem];
}
- (IBAction)deletePushed:(id)sender {
    __weak AddItemTableViewController *weakSelf = self;
    [[Networking sharedInstance]deleteClothingItem:self.clothingItem SucessHandler:^(NSHTTPURLResponse *response, NSDictionary *data) {
        [weakSelf.clothingItem deleteItem];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
     [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
          tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
        [self.tableView addGestureRecognizer:tap];
    
        [self.tagView addBackView];
    
        if (self.clothingItem.tags) {
            self.itemTags = self.clothingItem.tags;
            for(NSInteger i = 0;i < [self.itemTags count];i++){
                [self.tagView addTagWtihWord:self.itemTags[i]];
            }
        }else{
            [self.tagView setupViews];
        }
    
    
    
   // NSMutableArray *colorArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayOfColorsWithColorScheme:ColorSchemeComplementary  usingColor: [UIColor flatPowderBlueColor] withFlatScheme:YES]];
    
    //[Chameleon setGlobalThemeUsingPrimaryColor:[UIColor flatPowderBlueColor]withContentStyle:UIContentStyleContrast];
    
    //self.tableView.backgroundColor = GradientColor(UIGradientStyleTopToBottom, self.view.frame, colorArray);
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    self.chosenImage.image  = self.imageUrl;
    self.typeField.delegate = self;
    self.sizeField.delegate =self;
    self.seasonField.delegate = self;
    [self.navigationController setHidesNavigationBarHairline:YES];
    if (self.clothingItem) {
        self.typeField.text = [self.clothingItem.sex capitalizedString];
        self.sizeField.text = self.clothingItem.size;
        self.seasonField.text = [self.clothingItem.season capitalizedString];
        self.deleteButton.hidden = NO;
        
        NSURL *url = [[Networking sharedInstance] URLWithPath:self.imageString params:nil];
        [self.chosenImage sd_setImageWithURL:url];
    }else{
        NSString *CId = [Closet currentCloset];
        Closet *closet = [Closet loadClosetFromCoreData:CId];
         self.typeField.text = [closet.gender capitalizedString];
         self.sizeField.text = [closet clothingSizeForKey:self.type];
    
    }
    if ([self.type isEqualToString:@"dress_clothes"]) {
        self.title = [NSString stringWithFormat:@"Dress Clothes"];
    }else{
        self.title  = [self.type capitalizedString];
    
    }
    
    //[self.typeField setItemList:@[@"tops",@"bottoms",@"socks",@"underwear",@"shoes",@"swimwear",@"outerwear",@"dress_clothes",@"onsies",@"pajamas"]];
   // [self.sizeField setItemList:@[@"xs",@"s",@"m",@"l",@"xl"]];
   
}

- (IBAction) dismissKeyboard:(id)sender {
    [self.view endEditing:NO];
}



- (IBAction)donePushed:(id)sender {
    
    [self createItem];
    
}
- (IBAction)typeEditingDidEnd:(id)sender {
    [self.view endEditing:YES];
}

-(void)createItem{
    NSData *data = UIImageJPEGRepresentation(self.chosenImage.image , 1.0);
    NSString *dataString =  [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *CId = [Closet currentCloset];
    if ([self.seasonField.text length] < 1) {
        self.seasonField.text = @"All";
    }
    NSDictionary *dict = @{@"photoData":dataString,@"gender":self.typeField.text,@"closet_id":CId,@"type":self.type,@"size":self.sizeField.text,@"season":self.seasonField.text};
   
    ClothingItem *itemToUpload = [[ClothingItem alloc]initWithDictionary:dict];
    itemToUpload.tags = self.itemTags;
    if (self.clothingItem) {
        self.clothingItem.sex =self.typeField.text;
        self.clothingItem.size =self.sizeField.text;
        self.clothingItem.season =self.seasonField.text;
        self.clothingItem.tags = self.itemTags;
        itemToUpload.clothing_id = self.clothingItem.clothing_id;
        
    }

    __weak AddItemTableViewController * weakSelf = self;
    [SVProgressHUD show];
    
    [[Networking sharedInstance] createClothingItem:itemToUpload SucessHandler:^(NSHTTPURLResponse *response, NSDictionary *data) {
                [SVProgressHUD showSuccessWithStatus:@"Added"];
                [SVProgressHUD dismissWithDelay:3];
        
                if (!data) {
                    [weakSelf.clothingItem saveItem:CId];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    itemToUpload.clothing_id = data[@"item_id"];
                    itemToUpload.clothingType = weakSelf.type;
                    itemToUpload.imageURL = [NSString stringWithFormat:@"/media/item_%@",itemToUpload.clothing_id];
                    [itemToUpload saveItem:CId];
                    if (weakSelf.isViewLoaded && weakSelf.view.window){
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        NSLog(@"here");
                    }
                    
                }
        
        
            
        } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"Error"];
    }];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.typeField) {
        __weak AddItemTableViewController  *weakSelf = self;
        [self.typeField setUserInteractionEnabled:YES];
        [self.typeField resignFirstResponder];
        [self.typeField changeBarSelected];
         NSArray * types = @[@"Male",@"Female",@"All"];
         NSInteger initialSelection = 0;
        if (self.clothingItem && [types containsObject:self.clothingItem]) {
            initialSelection = [types indexOfObject:self.clothingItem.sex];
        }
        if([self.typeField.text length] > 0 && [types containsObject:self.typeField.text]){
            initialSelection = [types indexOfObject:self.typeField.text];
        }
        [ActionSheetStringPicker showPickerWithTitle:@"Select Gender"
                                                rows:types
                                    initialSelection:initialSelection
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                self.typeField.text = types[selectedIndex] ;
                                                [self.typeField endEditing:YES];
                                                [self.typeField setHighlighted:NO];
                                                self.typeField.highlighted = NO;
                                                [weakSelf.typeField changeBarDismissed];
                                            }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             [weakSelf.typeField endEditing:YES];
                                              [self.typeField endEditing:YES];
                                              [self.typeField setHighlighted:NO];
                                               self.typeField.highlighted = NO;
                                                [weakSelf.typeField changeBarDismissed];

                                            }
                                          origin:self.view];

         return  NO;
    }else if(textField == self.sizeField){
        //[self.seasonField becomeFirstResponder];
        __weak AddItemTableViewController  *weakSelf = self;
        [self.typeField endEditing:YES];
        [self.sizeField setUserInteractionEnabled:YES];
        [self.sizeField resignFirstResponder];
        [self.sizeField changeBarSelected];
         NSArray * types = [Closet standardChoices];
         NSInteger initialSelection = 0;
        if (self.clothingItem) {
            initialSelection = [types indexOfObject:self.clothingItem.size];
        }
        if([self.sizeField.text length] > 0){
            initialSelection = [types indexOfObject:self.sizeField.text];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select Size"
                                                rows:types
                                    initialSelection:initialSelection
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                self.sizeField.text = types[selectedIndex];
                                                [self.sizeField endEditing:YES];
                                                [self.sizeField setHighlighted:NO];
                                                self.sizeField.highlighted = NO;
                                                [weakSelf.sizeField changeBarDismissed];
                                            }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             [weakSelf.sizeField endEditing:YES];
                                              [self.sizeField endEditing:YES];
                                              [self.sizeField setHighlighted:NO];
                                               self.sizeField.highlighted = NO;
                                                [weakSelf.sizeField changeBarDismissed];

                                            }
                                          origin:self.view];

            return NO;
    }else if(textField == self.seasonField){
            [self.typeField resignFirstResponder];
            [self.seasonField setUserInteractionEnabled:YES];
            [self.seasonField resignFirstResponder];
             NSArray * types = @[@"all",@"winter",@"summer",@"fall",@"spring"];
             NSInteger initialSelection = 0;
            if (self.clothingItem) {
                initialSelection = [types indexOfObject:self.clothingItem.season];
            }
        
            if([self.sizeField.text length] > 0){
                initialSelection = [types indexOfObject:self.seasonField.text];
            }
            types = @[@"All",@"Winter",@"Summer",@"Fall",@"Spring"];

            __weak AddItemTableViewController  *weakSelf = self;
            [ActionSheetStringPicker showPickerWithTitle:@"Select Season"
                                                    rows:types
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                    self.seasonField.text = [types[selectedIndex] capitalizedString];
                                                    [self.seasonField endEditing:YES];
                                                    [self.seasonField setHighlighted:NO];
                                                    self.seasonField.highlighted = NO;
                                                }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 [weakSelf.seasonField endEditing:YES];
                                                  [self.seasonField endEditing:YES];
                                                    [self.seasonField setHighlighted:NO];
                                                    self.seasonField.highlighted = NO;
                                                 
                                                }
                                              origin:self.view];

        return NO;
    }
    return YES;

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.typeField) {
        [self.sizeField becomeFirstResponder];
    }else if(textField == self.sizeField){
        [self.seasonField becomeFirstResponder];
    }else if(textField == self.seasonField){
        [self createItem];
    }
    return YES;
}


-(void)backgroundViewDidTap:(id)sender{

[self.popupController popViewControllerAnimated:YES];
 self.popupController = nil;
}
-(void)doneButtonTapped:(id)sender{
    [self.tagView clearTags];
    NSString *tagString = [[NSString alloc]init];
    NSArray *tags = self.tableViewController.tags;
    self.clothingItem.tags = tags;
    for(NSInteger i = 0;i<[tags count];i++){
        tagString = tags[i];
       //tagString = [tagString stringByAppendingString:[@" " stringByAppendingString:tags[i]]] ;
       [self.tagView addTagWtihWord:tagString];
    }
    self.itemTags = tags;
  //  self.tagLabel.text = self.itemTags;
    [self.popupController popViewControllerAnimated:YES];
    self.popupController = nil;
}


- (IBAction)addButtonPushed:(id)sender {
    if (!self.itemTags) {
        self.itemTags = @[];
    }
     self.tableViewController = [[TagsTableViewController alloc]initWIthTags:self.itemTags];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:self.tableViewController];
    //[popupController presentInViewController:self];*/
    popupController = [[STPopupController alloc] initWithRootViewController:self.tableViewController];
    
    
    //[STPopupNavigationBar appearance].barTintColor = [UIColor flatPowderBlueColorDark];
    [STPopupNavigationBar appearance].tintColor = [UIColor flatSkyBlueColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3], NSForegroundColorAttributeName: [UIColor flatSkyBlueColor] };
    
     [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[STPopupNavigationBar class]]]setTitleTextAttributes:@{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]} forState:UIControlStateNormal];
     
    self.tableViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped:)];
    
       self.tableViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backgroundViewDidTap:)];
     
     
     
    
    
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    
     popupController.style = STPopupStyleFormSheet;
    [popupController presentInViewController:self completion:nil];
    self.popupController = popupController;
}



-(void)showTypeSheet{


}
@end
