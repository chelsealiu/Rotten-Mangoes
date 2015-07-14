//
//  User.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "User.h"

@implementation User

@dynamic username;
@dynamic userImage;
@dynamic pickerDataIndex;
@dynamic userType;
@dynamic password;

+(NSString * __nonnull)parseClassName {
    
    return @"User";
}

+(void)load {
    
    [self registerSubclass];
}



@end
