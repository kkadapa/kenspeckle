//
//  MasterTableViewController.m
//  kenspeckle
//
//  Created by karthik kadapa on 4/6/14.
//  Copyright (c) 2014 karthik kadapa. All rights reserved.
//

#import "MasterTableViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"

@interface MasterTableViewController ()
@property(nonatomic,strong) NSMutableArray *hotelNames;
@property(nonatomic,strong) CLLocation* currentLocation;

@end

@implementation MasterTableViewController

int latitude;
int longitude;
NSString* preamble = @"";


- (NSMutableArray *)objects
{
    if(!_objects){
        _objects = [[NSMutableArray alloc]init];
    }
    return _objects;
}

- (NSMutableArray *)results
{
    if(!_results){
        _results = [[NSMutableArray alloc]init];
    }
    return _results;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    _hotelNames = [[NSMutableArray alloc]init];
    self.objects = [[NSMutableArray alloc]init];
    NSLog(@"flag is %@",self.flagText);
    
    if([self.flagText isEqualToString:@"rootMaster"]){
    [self makeRestaurantRequests];
    }
    if ([self.flagText isEqualToString:@"textSearch"]) {
        [self textSearchRequest];
    }
    
    self.navigationItem.title = self.cellText;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    _currentLocation = [locations lastObject];
    NSLog(@"current location is %@",_currentLocation);
    if(_currentLocation!=nil){
        NSLog(@"longitude in diduploadlocation %8f",_currentLocation.coordinate.longitude);
        NSLog(@"latitude in diduploadlocation %8f",_currentLocation.coordinate.latitude);
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

-(void) textSearchRequest {
    NSLog(@"value is %@",self.searchText);
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=false&key=AIzaSyDORbU0ge1NTSk2odGUCMCofZYxp_2GY7c",self.searchText];
    NSURL *txturl = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"txt url is %@",txturl);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[txturl absoluteString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //   NSLog(@"JSON Result %@",responseObject);
        self.objects = [responseObject objectForKey:@"results"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Request Failed: %@, %@",error,error.userInfo);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) searchThroughData {
    self.results = nil;
    
    NSLog(@"self.searchBar.text--- %@",self.searchBar.text);
    
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@", self.searchBar.text];
    
    for(int j = 0; j < [_hotelNames count]; j++){
        for(int k = j+1;k < [_hotelNames count];k++){
            NSString *str1 = [_hotelNames objectAtIndex:j];
            NSString *str2 = [_hotelNames objectAtIndex:k];
            if([str1 isEqualToString:str2])
                [_hotelNames removeObjectAtIndex:k];
        }
    }
    
    NSLog(@"resultsPredicate-- %@",resultsPredicate);
    NSLog(@"-hotel names %@",_hotelNames);
    self.results = [[_hotelNames filteredArrayUsingPredicate:resultsPredicate] mutableCopy];
    
    NSLog(@"self.results-- %@",self.results);
}

- (void) searchBar:(UISearchBar *)searchBar co:(NSString *)searchText{
    [self searchThroughData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == self.tableView){
        return self.objects.count;
    }else {
        [self searchThroughData];
        return self.results.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier  = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    // Configure the cell...
   
    NSDictionary *tempDictionary = [self.objects objectAtIndex:indexPath.row];
    
    [_hotelNames addObject:[tempDictionary objectForKey:@"name"]];
    
    NSURL *url = [NSURL URLWithString:[tempDictionary objectForKey:@"icon"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  if(tableView == self.tableView){
      NSString* ratingStr;
      NSString* ratingVal;
      NSString *totalRating;
      
      ratingStr = @"Rating - ";
      NSLog(@"self.objects[indexPath.row] %@",[self.objects[indexPath.row] objectForKey:@"name"]);
      ratingVal = [self.objects[indexPath.row] objectForKey:@"rating"];
      
      if(ratingVal!=NULL){
          totalRating = [NSString stringWithFormat:@"%@ %@", ratingStr, ratingVal];
      }else {
          totalRating = [NSString stringWithFormat:@"%@ %@", ratingStr, @""];
      }
      NSLog(@"str %@",totalRating);
       cell.detailTextLabel.text = totalRating;
       cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
       cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
       cell.textLabel.text = [self.objects[indexPath.row] objectForKey:@"name"];
  }
  //Search Values
  else{
      cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
      cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
      cell.textLabel.text = self.results[indexPath.row];
   }
    return cell;
}


-(void) makeRestaurantRequests {
    
    NSLog(@"make latitude %f",self.locationManager.location.coordinate.latitude);
    NSLog(@"make longitude %f",self.locationManager.location.coordinate.longitude);

    NSString *searchString;
    if([self.cellText isEqualToString:@"Museum"]){
        searchString = @"museum";
    }if ([self.cellText isEqualToString:@"Food"]) {
        searchString = @"food";
    }if ([self.cellText isEqualToString:@"Pizza"]) {
        searchString = @"food";
    }if ([self.cellText isEqualToString:@"Casino"]) {
        searchString = @"casino";
    }if ([self.cellText isEqualToString:@"Gym"]) {
        searchString = @"gym";
    }if ([self.cellText isEqualToString:@"Nightclub"]) {
        searchString = @"night_club";
    }if ([self.cellText isEqualToString:@"Skateboarding"]) {
        searchString = @"amusement_park";
    }if ([self.cellText isEqualToString:@"Bowling"]) {
        searchString = @"bowling_alley";
    }if ([self.cellText isEqualToString:@"Acting"]) {
        searchString = @"movie_rental";
    }if ([self.cellText isEqualToString:@"Photography"]) {
        searchString = @"art_gallery";
    }if ([self.cellText isEqualToString:@"Movies"]) {
        searchString = @"movie_theater|movie_rental";
    }if ([self.cellText isEqualToString:@"Bank of America"]) {
        searchString = @"bank";
    }if ([self.cellText isEqualToString:@"Animals"]) {
         searchString = @"zoo";
    }if ([self.cellText isEqualToString:@"General"]) {
        searchString = @"";
    }if ([self.cellText isEqualToString:@"Cars"]) {
        searchString = @"car_dealer|car_rental";
    }
    

    NSLog(@"searchString is %@",searchString);
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=50000&types=%@&sensor=false&key=AIzaSyDORbU0ge1NTSk2odGUCMCofZYxp_2GY7c",self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,searchString];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlString is %@",url);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:[url absoluteString] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.objects = [responseObject objectForKey:@"results"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Request Failed: %@, %@",error,error.userInfo);
        }];
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row %2){
        cell.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 130.0/255.0 blue:171.0/255.0 alpha: 1.0];
    }else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.searchDisplayController.isActive){
        
        [self performSegueWithIdentifier:@"ShowDetail" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString : @"ShowDetail"]){
       // NSString *object = nil;
        NSIndexPath *indexPath; //= [self.tableView indexPathForSelectedRow];
        DetailViewController *detailViewController = (DetailViewController*)segue.destinationViewController;
        
        if(self.searchDisplayController.isActive){
        
            indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
          //  self.objects = self.results[indexPath.row];
        }else {
            indexPath = [self.tableView indexPathForSelectedRow];
           // self.objects = self.objects[indexPath.row];
        }
        detailViewController.restaurantDetail = [self.objects objectAtIndex:indexPath.row];
       // [[segue destinationViewController] setDetailLabelContents:object];
    }
}


@end
