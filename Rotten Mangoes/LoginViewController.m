//
//  LoginViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "ProfileViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *usernameLoginTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordLoginTextfield;
@property (strong, nonatomic) NSArray *userObjects;

@end




@implementation LoginViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setToolbarHidden:YES];
    
    

//    PFQuery *query = [[PFQuery alloc] initWithClassName:@"User"];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        
//        NSLog(@"error: %@", error);
//        
//        if (!error) {
//            
//            NSLog(@"began query for objects");
//            self.userObjects = [objects mutableCopy];
//        } else if (error.code == 100) {
//            
//            NSLog(@"found error in network connection, %lu", error.code);
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]; //get another button that takes you to settings?
//                [alert show];
//            });
//            //end main thread code
//            
//        }
//    }];
    
}

//modal, pops up then down

- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)submitLoginInfo:(id)sender {
    [User logInWithUsernameInBackground:self.usernameLoginTextfield.text password:self.passwordLoginTextfield.text block:^(PFUser *user, NSError *error) {
        
        if (error) {
            self.usernameLoginTextfield.text = nil;
            self.passwordLoginTextfield.text = nil; //clears textfields
            
            NSLog(@"invalid login info");
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:@"The username and password combination is invalid."
                                                            delegate:self
                                                   cancelButtonTitle:@"Go Back"
                                                   otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [self performSegueWithIdentifier:@"showProfile" sender:self];
        
    }];

}

//    for (User *user in self.userObjects) {
//        
//        NSLog(@"%@", user);
//        if ([user.username isEqualToString:self.usernameLoginTextfield.text] && [user.password isEqualToString:self.passwordLoginTextfield.text]) {
//            
//            NSLog(@"username: %@\npassword:%@", user.username, user.password);
//            self.currentUser = user;
//            self.loginIsValid = YES;
//            return;
//            
//            //            self.currentUser.isLoggedIn = YES;
//            
//            
//        }
//    }
    

//
//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    
//    [self submitLoginInfo]; //check if self.loginIsValid is true
//    
//    if (!self.loginIsValid) { //if login info is NOT valid
//        
//        NSLog(@"assert false: %s", self.loginIsValid ? "true":"false");
//
//        return NO;
//    }
//   
//    NSLog(@"assert true: %s", self.loginIsValid ? "true":"false");
//
//    return YES; //if login info is valid
//}
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(User*)user  {
//    
//    //already going into segue and cannot cancel? must set yes/no in shouldPerformSegue method (aka whether or not to proceed)
//
//    if ([[segue identifier] isEqualToString:@"showProfile"]) {
//        [[segue destinationViewController] setUserItem: self.currentUser];
//    }
//    
//}

@end
