//
//  RootMasterViewController.m
//  kenspeckle
//
//  Created by Krishna Karthik Kadapa on 5/6/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import "RootMasterViewController.h"
#import "MasterTableViewController.h"
#import "DetailViewController.h"

@interface RootMasterViewController ()
@property(nonatomic,strong) NSString* apikey;
@property(nonatomic,strong) MasterTableViewController *masterTableViewController;

@end

@implementation RootMasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)objects
{
    if(!_objects){
        _objects = [[NSMutableArray alloc]init];
    }
    return _objects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.objects = [[NSMutableArray alloc]init];
    
    self.finalObjects = [[NSMutableArray alloc]init];
    [self getUserInterests];
    [self getUserPlacesTagged];
    _apikey = @"AIzaSyDORbU0ge1NTSk2odGUCMCofZYxp_2GY7c";
    
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Search By Text" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    self.toolbarItems = @[settingsButton];
    self.navigationController.toolbarHidden = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)showSettings
{
    [self performSegueWithIdentifier:@"showSettingsSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
  //  NSLog(@"no of rows in section %@",self.objects);
    if(tableView == self.tableView){
        return [self.objects count];
    }else {
        return 0;
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSMutableArray* newArray = [[NSMutableArray alloc]init];
    static NSString *CellIdentifier = @"InterestsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.lineBreakMode =  NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [self.objects objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row %2){
        cell.backgroundColor = [UIColor colorWithRed: 198.0/255.0 green: 226.0/255.0 blue:255.0/255.0 alpha: 1.0]; 	 	
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}



-(void) getUserPlacesTagged {
    [FBRequestConnection startWithGraphPath:@"/v2.0/me/tagged_places"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              
                              NSLog(@"result-- %@",result);
                              /* handle the result */
                              NSDictionary* data = [result objectForKey:@"data"];
                              NSUInteger nameCount = [[data valueForKey:@"name"] count];
                              
                              //   NSLog(@"nameCount-- %d",nameCount);
                              NSLog(@"value in namelist %@",[[data valueForKey:@"name"] objectAtIndex:0]);
                              
                              for (int i=0; i<nameCount; i++) {
                                  [self.objects = [data valueForKey:@"name"] objectAtIndex:i];
                              }
                              NSLog(@"tagged places are %@",self.objects);
                          }];
}

-(void) getUserInterests {
    /* make the API call */
    [FBRequestConnection startWithGraphPath:@"/me/likes"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              NSDictionary* likes = [result objectForKey:@"data"];
                              NSUInteger nameCount = [[likes valueForKey:@"name"] count];
                              
                           //   NSLog(@"nameCount-- %d",nameCount);
                              NSLog(@"value in namelist %@",[[likes valueForKey:@"name"] objectAtIndex:0]);
                              
                              for (int i=0; i<nameCount; i++) {
                                  [self.objects = [likes valueForKey:@"name"] objectAtIndex:i];
                              }
                              NSLog(@"LIkes are %@",self.objects);
                              [self.tableView reloadData];
                          }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.rowSelected = selectedCell.textLabel.text;
       _masterTableViewController.flagText = @"rootMaster";
     _masterTableViewController.cellText = self.rowSelected;
     NSLog(@"_masterTableViewController selected %@",_masterTableViewController.cellText);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    _masterTableViewController = [segue destinationViewController];
    

}

@end
