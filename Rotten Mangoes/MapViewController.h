//
//  MapViewController.h
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/2/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movies.h"
#import "Reviews.h"


@interface MapViewController : UIViewController

@property (strong, nonatomic) Movies *detailItem;

@property (strong, nonatomic) NSString *zipCode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
