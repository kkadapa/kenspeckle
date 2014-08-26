//
//  Favorites.h
//  kenspeckle
//
//  Created by Krishna Karthik Kadapa on 5/10/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Favorites : NSObject<NSCoding>

@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* addressDetails;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;

@end
