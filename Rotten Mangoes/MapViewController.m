//
//  MapViewController.m
//  Rotten Mangoes
//
//  Created by Chelsea Liu on 7/2/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "MapViewController.h"

@import MapKit;

@interface MapViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL setInitialLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *printTheatres;
@property (strong, nonatomic) NSString *zipCode;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MapViewController

//passing in Movies object as self.detailItem

- (void)setDetailItem:(Movies*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//initialize everything:

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.setInitialLocation = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; //must conform to protocol in HEADER as well as storyboard!!!
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

    //check user's current settings: enabled? -> allows access?
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization]; //only request for tracking when app opens

        }
    }
}

//changes made when user changes authorization status

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation = YES;
    }
}

//zoom to show user's current location when user didUpdateLocations

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject]; //most recent update
    
    if (!self.setInitialLocation) {
        self.setInitialLocation = YES; //make sure this is only called once
        MKCoordinateRegion region = MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
        [self.mapView setRegion:region animated:YES];
        
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        } else {
            CLPlacemark *placemark = [[CLPlacemark alloc] initWithPlacemark:[placemarks lastObject]];
            self.zipCode = [placemark postalCode];
            [self loadTheatreAddresses];
            
            }
        }];
    }
}

//show user's current location

-(void) showUserLocation {

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //if user wants to be tracked but denied permission to be tracked, make alert popup to open settings
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Denied" message:@"Please enable us to stalk where you are" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //opening settings
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (settingsURL) {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }];
        
        [alertController addAction:openAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    if (self.mapView.userLocation) {    //Check if user is already zoomed in to current location
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
    }
}

- (void) loadTheatreAddresses {
    
    //HTTP Request begins:
    NSString *modifiedZipCode = [self.zipCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlString = [NSString stringWithFormat: @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", modifiedZipCode, self.detailItem.title];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *fetchingError) {
        
        if (fetchingError) {
            NSLog(@"Fetching Error: %@", fetchingError);
        }
        
        NSError *jsonError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON Error: %@", jsonError);
        }
        
        NSArray *allTheatres = responseDictionary[@"theatres"];
        
        if (!allTheatres) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No theatres near you are playing this movie." message:@":(" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            NSMutableArray *theatresArray = [NSMutableArray array];
            NSMutableArray *namesArray = [NSMutableArray array];
            
            
            
            for (NSDictionary *theatreDict in allTheatres) {
                
                //add annotation for each movie theatre in view
                MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                marker.coordinate = CLLocationCoordinate2DMake([theatreDict[@"lat"] doubleValue], [theatreDict[@"lng"] doubleValue]);
                marker.title = theatreDict[@"name"];
                [namesArray addObject:marker.title];
                marker.subtitle = theatreDict[@"address"];
                [theatresArray addObject:marker];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotations:theatresArray];
                self.printTheatres = [namesArray mutableCopy];
                [self.tableView reloadData];
                NSLog(@"%@", self.printTheatres);

            }); //end main thread code
        }
        
    }];

    [task resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Movies*)sender {
    
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        sender = self.detailItem; //movie that clicked on in previous view controller
        [[segue destinationViewController] setDetailItem: sender];
    }
}

//customizing the view of the theatre pins

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"TheatrePin"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"TheatrePin"];
        //resize image
        CGSize tempSize = CGSizeMake(25, 32);
        UIImage *tempImage = [UIImage imageNamed:@"theatre_pin"];
        UIGraphicsBeginImageContext(tempSize);
        [tempImage drawInRect:CGRectMake(0,0,tempSize.width,tempSize.height)];
        annotationView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height/2);
        //account for size difference of custom image vs original pin
        //x coordinate is fine, change the placement for y coordinate
        annotationView.canShowCallout = YES;
    }
        
    return annotationView;
}

#pragma mark Table View

//must connect delegate and datasource in storyboard in order for tableviewcontroller methods to run
//note: sort by distance from current location

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.printTheatres count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    NSString *theatreName = self.printTheatres[indexPath.row];
    cell.textLabel.text = theatreName;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



@end
