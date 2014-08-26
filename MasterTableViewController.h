//
//  MasterTableViewController.h
//  kenspeckle
//
//  Created by karthik kadapa on 4/6/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MasterTableViewController : UITableViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong) NSMutableArray *objects;
@property(nonatomic,strong) NSMutableArray *results;
@property(nonatomic,strong) NSString* cellText;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) NSString* flagText;
@property(nonatomic,strong) NSString* searchText;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
