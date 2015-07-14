//
//  User.h
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface User : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic) NSInteger pickerDataIndex;
@property (nonatomic, strong) NSString *userType;
@property (nonatomic, strong) NSString *password;
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic, strong) PFFile *imageFile;


//+(id)currentUser;

@end
