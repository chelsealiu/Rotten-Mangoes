//
//  Movies.h
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/1/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movies : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *reviewsAPI;
@property (nonatomic, strong) NSString *movieIcon;
@property (nonatomic, strong) NSArray *movieReviewsArray;
@property (nonatomic, strong) NSString *movieSynopsis;
@property (nonatomic, strong) NSNumber *criticsScore;
@property (nonatomic, strong) NSString *freshnessOfMovie;

@end