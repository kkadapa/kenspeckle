//
//  DetailViewController.h
//  kenspeckle
//
//  Created by karthik kadapa on 4/6/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import "Favorites.h"

@interface DetailViewController : UIViewController<FBLoginViewDelegate,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;
@property(weak,nonatomic) IBOutlet UITextView *textView;
@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic) NSDictionary *restaurantDetail;
@property(nonatomic,strong) NSString* captionText;

@property (strong,nonatomic) NSString *detailLabelContents;
-(BOOL) saveChanges;
-(IBAction) clickShare;
@end
