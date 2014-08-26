//
//  SecondViewController.h
//  kenspeckle
//
//  Created by karthik kadapa on 4/5/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SecondViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end
