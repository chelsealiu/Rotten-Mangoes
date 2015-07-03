//
//  DetailTableViewController.h
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movies;

@interface DetailTableViewController : UITableViewController

@property (strong, nonatomic) Movies *detailItem;

@end
