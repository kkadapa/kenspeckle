//
//  SecondViewController.m
//  kenspeckle
//
//  Created by karthik kadapa on 4/5/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import "SecondViewController.h"
#import "FavoritesTableViewController.h"

@interface SecondViewController ()
@property(nonatomic,strong) NSString* interests;
@property(nonatomic,strong) FavoritesTableViewController* favoritesTableView;
@property (strong, nonatomic) UIActionSheet *imagePickerActionSheet;
@property(strong,nonatomic) UIImagePickerController *imagePicker;
@end

@implementation SecondViewController

- (void)viewDidLoad
{
  //  [super viewDidLoad];
    self.imagePicker = [[UIImagePickerController alloc]init];
    [self populateUserDetails];

	// Do any additional setup after loading the view, typically from a nib.
}

// Displays the user's name and profile picture so they are aware of the Facebook
// identity they are logged in as.
- (void)populateUserDetails {
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 self.userNameLabel.text = user.name;
                 self.userProfileImage.profileID = [user objectForKey:@"id"];
             }
         }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier  = @"LocationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    _favoritesTableView = [segue destinationViewController];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    // If user presses cancel, do nothing
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (buttonIndex==0) {
        [[[UIAlertView alloc] initWithTitle:@"Camera not supported in simulator."
                                    message:@"(>'_')>"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        return;
    }
    
    if (buttonIndex==1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
               
        
        
        [self presentViewController:self.imagePicker animated:YES completion:NULL];
    }
}


-(IBAction) takePicture {
    
    if(!self.imagePickerActionSheet) {
        self.imagePickerActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    }
    [self.imagePickerActionSheet showInView:self.view];
}


@end
