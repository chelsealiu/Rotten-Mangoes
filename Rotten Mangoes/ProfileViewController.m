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

@interface ProfileViewController ()

@property (nonatomic, strong) User *currentUser;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProfileViewController


//
//- (void)setDetailItem:(User*)newDetailItem {
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        
//    }
//}


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    User *user = [User objectWithClassName:@"User"]; //refers to existing user object
    
    self.usernameLabel.text = user.username;
    self.userTypeLabel.text = user.userType;
    self.profileImageView.image = user.userImage; // (?) probably need to fix something here later

}


- (IBAction)finishedViewingProfile:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    User *user = [User objectWithClassName:@"User"]; //refers to existing user object

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell" forIndexPath:indexPath];
    
    Movies *tempMovieObject = [[Movies alloc] init];
    tempMovieObject = user.favouriteMoviesArray[indexPath.row];
    cell.textLabel.text = tempMovieObject.title;
    
    return cell;

}
     

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    User *user = [User objectWithClassName:@"User"]; //refers to existing user object

    return user.favouriteMoviesArray.count; //change to number of movies favourited
    
}



@end
