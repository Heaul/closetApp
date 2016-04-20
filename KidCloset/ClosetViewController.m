//
//  ClosetViewController.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/4/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClosetViewController.h"
#import "ClothingItemTableViewCell.h"
#import "Networking+ClosetManager.h"
#import "ClosetDetailViewController.h"
#import "AddItemTableViewController.h"
#import "PickClothingTypeTableViewController.h"
@interface ClosetViewController()
@property NSString *closet_id;
@property NSString *closetName;
@end

@implementation ClosetViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setStatusBarStyle:UIStatusBarStyleContrast];
    [self.navigationController setHidesNavigationBarHairline:YES];
}
- (IBAction)addPushed:(id)sender {
    [self goToPhoto];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
        //[background addSubview:bg];
    __weak ClosetViewController *weakSelf = self;
    [[Networking sharedInstance]GETClosetWithSucessHandler:^(NSHTTPURLResponse *response, GetClothingItemsResponse *data) {
        weakSelf.closetData = data.closets;
        [weakSelf.tableView reloadData];
    } failureHandler:^(NSHTTPURLResponse *response, NSError *error) {
 
    }];
}


-(void)goToPhoto{
    [self performSegueWithIdentifier:@"createCloset" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.closetData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     self.closet_id = [NSString stringWithFormat:@"%@", self.closetData[indexPath.item][@"id"]];
    [Closet changeCloset:self.closet_id];
    if (self.type) {
      [self performSegueWithIdentifier:@"AddItem" sender:self];
    }else{
        [self performSegueWithIdentifier:@"AddType" sender:self];
    }
}
- (IBAction)createClosetPushed:(id)sender {
   [self performSegueWithIdentifier:@"toCreateCloset" sender:self];
}




- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"pickClosetCell"forIndexPath:indexPath];
    cell.textLabel.text = self.closetData[indexPath.item][@"name"];
    return cell;
}

 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,
                                       id> *)info{


                                    }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toImagePick"]) {
        UIImagePickerController *pickerController = segue.destinationViewController;
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else if([segue.identifier isEqualToString:@"DetailCloset"]){
    
        ClosetDetailViewController *vc = [segue destinationViewController];
        vc.closet_id = self.closet_id;
        //vc.closetTitle = self.closetName;
    
    }else if([segue.identifier isEqualToString:@"AddItem"]){
            AddItemTableViewController *vc = (AddItemTableViewController *) [segue destinationViewController];
            vc.type = self.type;
            vc.imageUrl = self.chosenImage;
    }else if([segue.identifier isEqualToString:@"AddType"]){
            PickClothingTypeTableViewController *vc = (PickClothingTypeTableViewController *) [segue destinationViewController];
            vc.image = self.chosenImage;
    }
}


@end
