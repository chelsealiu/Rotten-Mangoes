//
//  DetailTableViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "DetailTableViewController.h"
#import "TableViewCell.h"

@interface DetailTableViewController ()


@property (weak, nonatomic) IBOutlet UILabel *freshLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailMovieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;

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
    
    if ([self.detailItem.movieReviewsArray count] != 0) {
        return;
        //exit early/no network request if reviews already exist
    }
    
    NSURL *reviewsURL = [NSURL URLWithString:self.detailItem.reviewsAPI];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:reviewsURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *jsonError) {
        
        NSError *error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *allReviews = responseDictionary[@"reviews"];
        
        if (!allReviews) {
            NSLog(@"ERROR! %@", jsonError);
        } else {
            
            NSMutableArray *reviewsArray = [NSMutableArray array];
            
            int counter = 0;
            
            for (NSDictionary *reviewsDict in allReviews) {
                
                if (counter < 4) {
                    
                    counter ++;
                    
                } else {

                    break;
                }

                Reviews *newReview = [[Reviews alloc] init];
                
                newReview.criticOfReview = [reviewsDict[@"critic"] stringByAppendingString:@", "];
                newReview.dateOfReview = reviewsDict[@"date"];
                newReview.linksOfReview = reviewsDict[@"links"][@"review"];
                newReview.publicationOfReview = reviewsDict[@"publication"];
                
                NSString *quoteString = [NSString stringWithFormat:@" '%@' ", reviewsDict[@"quote"]];
                newReview.quoteOfReview = quoteString;
                
                if ([reviewsDict[@"freshness"] isEqualToString:@"rotten"]) {
                    newReview.freshnessOfReview = @"ROTTEN";
                } else {
                    newReview.freshnessOfReview = @"FRESH";
                }
                
                [reviewsArray addObject: newReview];
                
            }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.detailItem.movieReviewsArray = [reviewsArray mutableCopy];
                    [self.tableView reloadData];

            });
            //end main thread code
        }
        
    }];
    
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.detailItem.movieReviewsArray count];
}


//will only run if the above methods do not return 0
- (TableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    Reviews *review = self.detailItem.movieReviewsArray[indexPath.row];
    
    customCell.criticLabel.text = [review.criticOfReview stringByAppendingString:review.publicationOfReview];
    customCell.dateLabel.text = review.dateOfReview;
    customCell.quoteLabel.text = review.quoteOfReview;
    customCell.linksLabel.text = review.linksOfReview;
 

    NSString *tempString = [NSString stringWithFormat:@"Score: %@",[self.detailItem.criticsScore stringValue]];
    self.scoreLabel.text = [tempString stringByAppendingString:@"%"];
    
    self.movieSynopsisLabel.text = self.detailItem.movieSynopsis;
    self.movieTitleLabel.text = self.detailItem.title;
    self.freshLabel.text = review.freshnessOfReview;

    if ([review.freshnessOfReview isEqualToString:@"CERTIFIED FRESH"]) {
        self.freshLabel.textColor = [UIColor greenColor];
        self.scoreLabel.textColor = [UIColor greenColor];
    } else {
        self.freshLabel.textColor = [UIColor redColor];
        self.scoreLabel.textColor = [UIColor redColor];
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        Movies *movie = self.detailItem;
        NSString *imageString = movie.movieIcon;
        NSURL *imageURL = [NSURL URLWithString:imageString];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        self.detailMovieImage.image = [UIImage imageWithData:imageData];
    });
    
    return customCell;
    
}

// Override to support conditional editing of the table view.
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
    
    return 450;
//    return UITableViewAutomaticDimension;
    //should set dynamically
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
