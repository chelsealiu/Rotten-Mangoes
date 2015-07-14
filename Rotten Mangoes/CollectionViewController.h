//
//  CollectionViewController.h
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "User.h"

@interface CollectionViewController : UICollectionViewController

@property (strong, nonatomic) User *detailItem;

@end
