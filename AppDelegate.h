//
//  AppDelegate.h
//  kenspeckle
//
//  Created by karthik kadapa on 4/5/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class FirstViewController;
@class DetailViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) FirstViewController *loginViewController;
@property BOOL isNavigatingAwayFromLogin;

- (void)resetMainViewController;
@end
