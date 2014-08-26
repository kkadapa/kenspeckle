//
//  TextSearchViewController.m
//  kenspeckle
//
//  Created by Krishna Karthik Kadapa on 5/9/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import "TextSearchViewController.h"
#import "DetailViewController.h"


@interface TextSearchViewController ()

@end

@implementation TextSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
   // self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _masterTableViewController = [[MasterTableViewController alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

-(IBAction) submitButtonPressed{
    NSLog(@"submit button pressed %@",self.textView.text);
    self.masterTableViewController.flagText = @"textSearch";
    
   self.masterTableViewController.searchText = self.textView.text;
    NSLog(@"_masterTableViewController.searchText--- %@",self.masterTableViewController.searchText);
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
   self.masterTableViewController = [segue destinationViewController];
}

@end
