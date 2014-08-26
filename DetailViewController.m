//
//  DetailViewController.m
//  kenspeckle
//
//  Created by karthik kadapa on 4/6/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import "DetailViewController.h"
#import "AFNetworking.h"
#import "FirstViewController.h"
#import "Favorites.h"
#import "FavoritesTableViewController.h"

@interface DetailViewController ()
@property(strong,nonatomic) NSMutableArray* photosArray;
@property(strong,nonatomic) UIImage *image;
@property(strong,nonatomic) NSURL *imageUrl;
@property(nonatomic, strong) FavoritesTableViewController* favTableView;
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FirstViewController* firstVC = [[FirstViewController alloc]init];
    
    firstVC.FBLoginView.delegate = self;
    
    _favTableView = [[FavoritesTableViewController alloc]init];
      _favTableView.favNameList = [NSKeyedUnarchiver unarchiveObjectWithFile:[self toDoListItemsArchivePath]];
    
    NSLog(@"_favTableView.favNameList %@",_favTableView.favNameList);
    [self.detailLabel lineBreakMode];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.text = [self.restaurantDetail objectForKey:@"name"];
    
    
    [self getPriceLevelValue];
    
    self.detailLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    NSDictionary* openingHours = [self.restaurantDetail objectForKey:@"opening_hours"];
    
    if(openingHours !=NULL){
    NSString* openNow = [openingHours objectForKey:@"open_now"];
    
        if(openNow){
            self.isOpenLabel.text = @"YES";
        }else {
            self.isOpenLabel.text = @"NO";
        }
    }else {
        self.isOpenLabel.text = @"Unavailable";
    }
    
   // [self.imageView setImage:[NSURL URLWithString:[[self.restaurantDetail objectForKey:@"icon"]]];
    self.textView.text = [self.restaurantDetail objectForKey:@"formatted_address"];
    self.textView.textAlignment = NSTextAlignmentCenter;
    
    if([self.textView.text isEqualToString:@""]){
     self.textView.text = [self.restaurantDetail objectForKey:@"vicinity"];
     self.textView.textAlignment = NSTextAlignmentCenter;
    }
    
    //self.detailLabel.text = self.detailLabelContents;
    [self getImageForURL];
}

-(NSString*) toDoListItemsArchivePath {
    NSArray* docDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDirectory = [docDirs objectAtIndex:0];
    NSString* archiveFilePath = [documentDirectory stringByAppendingPathComponent:@"kenspeckle.archive"];
    return archiveFilePath;
    
}

-(IBAction) saveNameToFavorites {
    NSLog(@"count is %lu",(unsigned long)[_favTableView.favNameList count]);
    if(![_favTableView.favNameList count]){
       _favTableView.favNameList = [[NSMutableArray alloc]init];
    }
   
    Favorites* favoriteName = [[Favorites alloc] init];
    NSLog(@"inside favorites");
    [favoriteName setTitle:[NSMutableString stringWithString:self.detailLabel.text]];
    [favoriteName setAddressDetails:[NSMutableString stringWithString:self.textView.text]];
    favoriteName.title = self.detailLabel.text;
    favoriteName.addressDetails = self.textView.text;
    NSLog(@"title$$$ %@",favoriteName.title);
    NSLog(@"addressDetails#### %@",favoriteName.addressDetails);
   
    NSString* value =  [NSString stringWithFormat: @"%@  %@",favoriteName.title, favoriteName.addressDetails];
    NSLog(@"value-- %@",value);
    [_favTableView.favNameList addObject:value];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorites"
                                                    message:@"This has been added to favorites"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self saveChanges];
}

-(BOOL) saveChanges {
    NSString* path = [self toDoListItemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:_favTableView.favNameList toFile:path];
}

-(void) getPriceLevelValue {
    NSString* priceVal = [self.restaurantDetail objectForKey:@"price_level"];
    NSLog(@"price value ### %@",priceVal);
    
    if([priceVal isEqual:@0]){
        self.priceLevelLabel.text = @"Free";
    }if ([priceVal isEqual:@1]){
        self.priceLevelLabel.text = @"Inexpensive";
    }if ([priceVal isEqual:@2]){
        self.priceLevelLabel.text = @"Moderate";
    }if ([priceVal isEqual:@3]){
        self.priceLevelLabel.text = @"Expensive";
    }if ([priceVal isEqual:@4]){
        self.priceLevelLabel.text = @"Very Expensive";
    }
    if (priceVal == NULL){
        self.priceLevelLabel.text = @"Unavailable";
    }
    NSLog(@"price level is %@",self.priceLevelLabel.text);
}


-(void) getImageForURL{
    
   // NSDictionary *photoDict = [self.restaurantDetail objectForKey:@"photos"];
    NSDictionary *photoDict = [[self.restaurantDetail objectForKey:@"photos"] objectAtIndex:0];
  
    NSString *photoRef = [photoDict objectForKey:@"photo_reference"];
    
    //   NSString *photoRef = [photoDict valueForKeyPath:@"photo_reference"];
    
    NSLog(@"photoref -- %@",photoRef);
    
    
    NSMutableString *strUrl = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=190&photoreference=%@&sensor=true&key=AIzaSyDORbU0ge1NTSk2odGUCMCofZYxp_2GY7c",photoRef];
    
  //  NSURL *editedurl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    _imageUrl = [NSURL URLWithString:strUrl];
    NSLog(@"image url is %@",_imageUrl);
    NSURL *editedurl = [NSURL URLWithString:strUrl];

   // NSLog(@"strurl %@",editedurl);
   
   
    NSData *data = [NSData dataWithContentsOfURL:editedurl];
    
  
    
  //  NSLog(@"data inside json %@",data);
    _image = [UIImage imageWithData:data];
    [self.imageView setImage:_image];

}


- (IBAction) clickShare{
    
   NSString* captionStr = [NSString stringWithFormat:@"%@ %@", @"I am at ", self.detailLabel.text];
    
    NSURL *url = [NSURL URLWithString:[self.restaurantDetail objectForKey:@"icon"]];
    NSString* strUrl = [url absoluteString];
    NSMutableString* strVal = [[NSMutableString alloc]init];
   
    NSArray* typeOfObj = [self.restaurantDetail objectForKey:@"types"];

    for(int i=0;i<[typeOfObj count];i++){
        [strVal appendString:[typeOfObj objectAtIndex:i]];
        [strVal appendString:@","];
    }
    
        NSLog(@"strVal %@",strVal);
    
     NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/search?q=%@",self.detailLabel.text];
    NSLog(@"urlAddress %@",urlAddress);
    
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.detailLabel.text, @"name",
                                   captionStr, @"caption",
                                   strVal, @"description",
                                   urlAddress, @"link",
                                   strUrl, @"picture",
                                   nil];
    
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params
                    handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
            //   NSLog([NSString stringWithFormat:@"Error publishing story: %@",error.description]);
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // User cancelled.
                    NSLog(@"User cancelled.");
                    } else {
                        // Handle the publish feed callback
                        NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                        if (![urlParams valueForKey:@"post_id"]) {
                        // User cancelled.
                        NSLog(@"User cancelled.");
                                                              
                        } else {
                        // User clicked the Share button
                        NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
    
}

// A function for parsing URL parameters.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
