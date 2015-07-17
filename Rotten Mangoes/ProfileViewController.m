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


-(void)viewWillAppear:(BOOL)animated {

    [self.navigationController setToolbarHidden:YES];
    [self updateFavouritesArray];
    [self.tableView reloadData];
    
}


-(void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.delegate = self;
    
    [self updateFavouritesArray];
}

-(void) updateFavouritesArray {
    User *currentUser = [User currentUser];//implementing singleton method
    
    self.usernameLabel.text = currentUser.username;
    self.userTypeLabel.text = currentUser.userType;
    [currentUser.imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:data];
        }
    }];
    NSLog(@"username: %@, pswd: %@, fav: %@", currentUser.username, currentUser.userType, currentUser.favouritesArray);
    
}


- (IBAction)logoutAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [User logOutInBackground];
    
}
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"showMovies"]) {
//        [[segue destinationViewController] setDetailItem:self.userItem];
//    }
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];
    User *currentUser = [User currentUser];
    cell.textLabel.text = currentUser.favouritesArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
     

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    User *currentUser = [User currentUser];
    return [currentUser.favouritesArray count]; //change to number of movies favourited
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    User *currentUser = [User currentUser];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [currentUser.favouritesArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
}
}


-(IBAction)unwindToProfile:(UIStoryboardSegue*)sender {
    //unwind segue
}


@end
