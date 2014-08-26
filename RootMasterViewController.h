//
//  RootMasterViewController.h
//  kenspeckle
//
//  Created by Krishna Karthik Kadapa on 5/6/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface RootMasterViewController : UITableViewController<FBLoginViewDelegate,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *objects;
@property(nonatomic,strong) NSMutableArray *finalObjects;
@property(nonatomic,strong) NSString* rowSelected;

@end
