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
@property (nonatomic) BOOL loginIsValid;

@end




@implementation LoginViewController


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setToolbarHidden:YES];

    PFQuery *query = [[PFQuery alloc] initWithClassName:@"User"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (!error) {
            self.userObjects = [objects mutableCopy];
        
        }
    }];
    
}

//modal, pops up then down

- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)submitLoginInfo:(id)sender {
    
    [self checkComboValidity];

}

-(BOOL) checkComboValidity {
    
    for (User *user in self.userObjects) {
        
        NSLog(@"%@", user);
        if ([user.username isEqualToString:self.usernameLoginTextfield.text] && [user.password isEqualToString:self.passwordLoginTextfield.text]) {
            
            NSLog(@"%@, %@", user.username, user.password);
            self.currentUser = user;
//            self.loginIsValid = YES;
//            self.currentUser.isLoggedIn = YES;
            
            return YES;

        }
    }
    
    self.usernameLoginTextfield.text = nil;
    self.passwordLoginTextfield.text = nil; //clears textfields
    
    NSLog(@"invalid login info");
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                     message:@"The username and password combination is invalid."
                                                    delegate:self
                                           cancelButtonTitle:@"Go Back"
                                           otherButtonTitles: nil];
    [alert show];
    
    NSLog(@"%s", self.loginIsValid ? "true":"false");

    return NO;
   
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    return [self checkComboValidity];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(User*)user  {
    
    if ([[segue identifier] isEqualToString:@"showProfile"]) {
        [[segue destinationViewController] setUserItem: self.currentUser];
    }
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
//    if ([[segue identifier] isEqualToString:@"segueLoginToSignUp"]) {
//        
//        LoginViewController *loginVC = [segue destinationViewController];
//        [self.navigationController pushViewController:loginVC animated:YES];
//
//    } else if ([[segue identifier] isEqualToString:@"segueToProfile"]) {
//        
//        
//        
//    }
//    
//}


//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//
//    if ([identifier isEqualToString:@"showSignUp"]) {
//
//        NSLog(@"showSignUp");
//        return YES; //always allows the user to sign up if no account
//    }
//
//    if (self.loginIsValid == YES && [identifier isEqualToString:@"showProfile"]) {
//
//        NSLog(@"%s", self.loginIsValid ? "true":"false");
//
//        return YES; //only shows user profile if login information is valid
//    }
//
//    if ([identifier isEqualToString:@"showMovies"]) {
//
//        NSLog(@"showMovies");
//        return YES; //always allows the user to view movies, regardless of whether or not they have an account
//
//    }
//
//    if (self.loginIsValid == NO && [identifier isEqualToString:@"showProfile"]) {
//
//        //do not show user profile if login information is invalid
//
//        NSLog(@"invalid login info");
//        self.usernameLoginTextfield.text = nil;
//        NSLog(@"%@", self.usernameLoginTextfield.text);
//
//        self.passwordLoginTextfield.text = nil; //clears textfields
//
//        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
//                                                         message:@"The username and password combination is invalid."
//                                                        delegate:self
//                                               cancelButtonTitle:@"Go Back"
//                                               otherButtonTitles: nil];
//        [alert show];
//
//        NSLog(@"%s", self.loginIsValid ? "true":"false");
//
//        return NO;
//
//    }
//
//    return NO;
//}


@end
