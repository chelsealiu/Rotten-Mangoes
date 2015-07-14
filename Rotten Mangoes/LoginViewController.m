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
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"User"];
//    NSMutableArray *allObjects = [NSMutableArray array];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        
        if (!error) {
            
            for (User *user in objects) {
                if ([user.username isEqualToString:self.usernameLoginTextfield.text] && [user.password isEqualToString:self.passwordLoginTextfield.text]) {
                    self.currentUser = user;
                    self.loginIsValid = YES;
                }
                else {
                    self.loginIsValid = NO;
                }
            }
        }
    }];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        self.userObjects = [allObjects mutableCopy];
//        
//    });
//    
//}];

}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"segueLoginToSignUp"]) {
        return YES;
    }
    
    else if (self.loginIsValid == YES) {
        
        NSLog(@"%s", self.loginIsValid ? "true":"false");

        return YES;
    }
   
    else if ([identifier isEqualToString:@"segueLoginToMovies"]) {
        
        return YES;
        
    }
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                     message:@"The username and password combination is invalid."
                                                    delegate:self
                                           cancelButtonTitle:@"Go Back"
                                           otherButtonTitles: nil];
    [alert show];
    
    self.usernameLoginTextfield.text = nil;
    self.passwordLoginTextfield.text = nil; //clears textfields

    NSLog(@"%s", self.loginIsValid ? "true":"false");

    return NO;
        
}

//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(User*)user  {
//    
//    if ([[segue identifier] isEqualToString:@"segueToProfile"]) {
//        [[segue destinationViewController] setDetailItem: user];
//    }
//    
//}



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


@end
