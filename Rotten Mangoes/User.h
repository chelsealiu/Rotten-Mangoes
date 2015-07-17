//
//  User.h
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface User : PFUser <PFSubclassing>


@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic) NSInteger pickerDataIndex;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) NSMutableArray *favouritesArray;


@end
