//
//  FavoritesTableViewController.h
//  kenspeckle
//
//  Created by karthik kadapa on 4/8/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorites.h"

@interface FavoritesTableViewController : UITableViewController

@property(nonatomic, weak) Favorites* favoritesItem;
@property(nonatomic, strong) NSMutableArray* favNameList;
@property(nonatomic, strong) NSMutableArray* favDetailsList;
@end
