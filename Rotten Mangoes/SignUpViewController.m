//
//  SignUpViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SignUpViewController ()

@property NSMutableArray *objects;

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic, strong) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end


@implementation SignUpViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.pickerData = @[@"Casual Movie Fan", @"Movie Critic"];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    //configures the pickerview

    return self.pickerData[row];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    //connect to 'Cancel' button
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)selectPhoto:(id)sender {
    
    //connects to + button on UIImageView
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}


- (IBAction)saveUserInfo:(id)sender {
    
    User *newUser = [[User alloc] init];
    newUser.username = self.usernameTextfield.text;
    newUser.pickerDataIndex = [self.pickerView selectedRowInComponent:0];
    newUser.userType = self.pickerData[newUser.pickerDataIndex];
    newUser.password = self.passwordTextfield.text;
    
//    newUser.userImage = self.imageView.image;
    
    [newUser saveEventually];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"name: %@, user type: %@, profile image: %@", newUser.username, newUser.userType, newUser.userImage);
    
}

- (IBAction)cancelSignUp:(id)sender {
    NSLog(@"action cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
