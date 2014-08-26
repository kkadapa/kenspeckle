//
//  Favorites.m
//  kenspeckle
//
//  Created by Krishna Karthik Kadapa on 5/10/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import "Favorites.h"


@implementation Favorites

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.addressDetails forKey:@"details"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _title = [aDecoder decodeObjectForKey:@"title"];
        _addressDetails = [aDecoder decodeObjectForKey:@"details"];
    }
    return self;
}

@end
