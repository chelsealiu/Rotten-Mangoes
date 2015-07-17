//
//  DetailTableViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "DetailTableViewController.h"
#import "TableViewCell.h"
#import "MapViewController.h"
#import "Movies.h"
#import "Reviews.h"
#import "User.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface DetailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *freshLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailMovieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *heartButton;

@end

@implementation DetailTableViewController


- (void)setDetailItem:(Movies*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController setToolbarHidden:NO];
    
    if ([self.detailItem.movieReviewsArray count] != 0) {
        [self setTableViewLabel];
        return;
        //exit early/no network request if reviews already exist
    }
    
    NSURL *reviewsURL = [NSURL URLWithString:self.detailItem.reviewsAPI];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:reviewsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
                
        NSError *jsonError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        NSArray *allReviews = responseDictionary[@"reviews"];
        
        if (!allReviews) {
            NSLog(@"ERROR!");
        } else {
            
            NSMutableArray *reviewsArray = [NSMutableArray array];
            
            int counter = 0;
            
            for (NSDictionary *reviewsDict in allReviews) {
                if (counter < 3) {
                    counter ++;
                } else {
                    break;
                }

                Reviews *newReview = [[Reviews alloc] init];
                newReview.criticOfReview = [reviewsDict[@"critic"] stringByAppendingString:@", "];
                newReview.dateOfReview = reviewsDict[@"date"];
                newReview.linksOfReview = reviewsDict[@"links"][@"review"];
                newReview.publicationOfReview = reviewsDict[@"publication"];
                newReview.quoteOfReview = reviewsDict[@"quote"];
                newReview.freshnessOfReview = self.detailItem.freshnessOfMovie;
                
                [reviewsArray addObject: newReview];
            }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.detailItem.movieReviewsArray = [reviewsArray mutableCopy];
                    [self setTableViewLabel];
                    [self.tableView reloadData];
            });
            //end main thread code
        }
    }];
    
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.detailItem.movieReviewsArray count];
}


- (void)setTableViewLabel {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@ %%",[self.detailItem.criticsScore stringValue]];
    self.movieSynopsisLabel.text = self.detailItem.movieSynopsis;
    self.movieTitleLabel.text = self.detailItem.title;
    self.freshLabel.text = self.detailItem.freshnessOfMovie;
    
    if ([self.detailItem.freshnessOfMovie isEqualToString:@"Fresh"]) {
        self.freshLabel.textColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
        self.scoreLabel.textColor = [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.5];
    }
    
    else if ([self.detailItem.freshnessOfMovie isEqualToString:@"Certified Fresh"]) {
        
        self.freshLabel.textColor = [UIColor greenColor];
        self.scoreLabel.textColor = [UIColor greenColor];
    }
    
    else {
        self.freshLabel.textColor = [UIColor redColor];
        self.scoreLabel.textColor = [UIColor redColor];
        self.freshLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Movies *movie = self.detailItem;
        NSString *imageString = movie.movieIcon;
        NSURL *imageURL = [NSURL URLWithString:imageString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        self.detailMovieImage.image = [UIImage imageWithData:imageData];
    });
}

//will only run if the above methods do not return 0
- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    Reviews *review = self.detailItem.movieReviewsArray[indexPath.row];
    
    customCell.criticLabel.text = [review.criticOfReview stringByAppendingString:review.publicationOfReview];
    customCell.dateLabel.text = review.dateOfReview;
    customCell.quoteLabel.text = review.quoteOfReview;
    customCell.linksLabel.text = review.linksOfReview;
    
    return customCell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
//    return UITableViewAutomaticDimension;
//    should set dynamically
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Movies*)sender {
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        
        sender = self.detailItem; //movie that clicked on in previous view controller
        [[segue destinationViewController] setDetailItem: sender];
    }
}
- (IBAction)addToFavourites:(id)sender {
    
    User *currentUser = [User currentUser];
    
    if ([currentUser.favouritesArray containsObject:self.detailItem.title]) {
        [self.heartButton setTintColor:nil];
        [currentUser.favouritesArray removeObject:self.detailItem.title];

    } else {
        [self.heartButton setTintColor:[UIColor redColor]];
        [currentUser.favouritesArray addObject:self.detailItem.title];

    }
    
    [currentUser saveInBackground]; //save change to user item
}

- (IBAction)goToProfile:(id)sender {
    
    
    
}


@end
