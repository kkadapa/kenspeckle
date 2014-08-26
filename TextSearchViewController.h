//
//  TextSearchViewController.h
//  kenspeckle
//
//  Created by Krishna Karthik Kadapa on 5/9/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "MasterTableViewController.h"

@interface TextSearchViewController : UIViewController<UITextFieldDelegate>

 @property (weak, nonatomic) IBOutlet UITextField *textView;
@property(nonatomic, weak) IBOutlet UIButton* submitButton;
@property(nonatomic,strong) NSMutableArray *searchObjects;
@property(nonatomic,strong) MasterTableViewController *masterTableViewController;
-(IBAction) submitButtonPressed;

@end
