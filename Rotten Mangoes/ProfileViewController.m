//
//  ProfileViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Movies.h"
#import "CollectionViewController.h"
#import "HomeViewController.h"

@interface ProfileViewController ()

@property (nonatomic, strong) User *profileUser;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController


//pass in username as a string

- (void)setUserItem:(User*)newDetailItem {
    if (_userItem != newDetailItem) {
        _userItem = newDetailItem;
        
    }
}

- (void)setFavouritesItem:(NSMutableArray*)newDetailItem {
    if (_favouritesItem != newDetailItem) {
        _favouritesItem = newDetailItem;
        
    }
}


-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES];

    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    User *currentUser = [[User alloc] init];//implementing singleton method
    currentUser = self.userItem; //passed in User object from login screen
    
    self.usernameLabel.text = currentUser.username;
    self.userTypeLabel.text = currentUser.userType;
    [currentUser.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:data];
        }
    }];
    NSLog(@"username: %@, pswd: %@", currentUser.username, currentUser.userType);

}

- (IBAction)logoutAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.userItem.isLoggedIn = NO; //logged out
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMovies"]) {
        [[segue destinationViewController] setDetailItem:self.userItem];
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];
    
    Movies *tempMovieObject = [[Movies alloc] init];
    tempMovieObject = self.favouritesItem[indexPath.row];
    cell.textLabel.text = tempMovieObject.title;
    
    return cell;

}
     

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.favouritesItem.count; //change to number of movies favourited
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}



@end
