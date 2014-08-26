//
//  FirstViewController.h
//  kenspeckle
//
//  Created by karthik kadapa on 4/5/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>

@interface FirstViewController : UIViewController<FBLoginViewDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet FBLoginView *FBLoginView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIImageView* referImage;
- (IBAction)showEmail:(id)sender;

@end
