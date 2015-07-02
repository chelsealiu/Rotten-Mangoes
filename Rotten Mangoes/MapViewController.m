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
@property (strong, nonatomic) NSMutableArray *theatresArray;

@end

@implementation MapViewController


- (void)setDetailItem:(Movies*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//initialize everything:

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.setInitialLocation = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self; //must conform to protocol in HEADER as well as storyboard!!!
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;

    //check user's current settings: enabled? then-> allows access?
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
            //only request for tracking when app opens
        }
    }
    
//    [self loadTheatreAddresses];
    
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

    
    //reverse geocode to get postal code!
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return;
        } else {
            CLPlacemark *placemark = [[CLPlacemark alloc] initWithPlacemark:[placemarks lastObject]];
            self.zipCode = [placemark postalCode];
            //inside a block: why can you only assign values to properties and not local variables?
        
            [self loadTheatreAddresses];

        }
        
    }];
    
    }
    
}




//show user's current location

-(void) showUserLocation {

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //if user wants to be tracked but denied permission to be tracked, make alert popup to open settings
        //allows user to OPEN SETTINGS and change settings to allow app to track location
        
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
    //don't zoom if already zoomed
    //check if already zoomed:
    if (self.mapView.userLocation) {
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        
    }
    
}

- (void) loadTheatreAddresses {
    
    //HTTP Request begins:
    // add format like: address=V6B1E6&movie=Paddington
    NSString *modifiedZipCode = [self.zipCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlString = [NSString stringWithFormat: @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@", modifiedZipCode, self.detailItem.title];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *jsonError) {
        
        NSError *error;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *allTheatres = responseDictionary[@"theatres"];
        
        if (!allTheatres) {
            NSLog(@"ERROR! %@", jsonError);
            
        } else {
            NSMutableArray *theatresArray = [NSMutableArray array];
            for (NSDictionary *theatreDict in allTheatres) {
                
                //add annotation for each movie theatre in view
                MKPointAnnotation *marker = [[MKPointAnnotation alloc] init];
                
                marker.coordinate = CLLocationCoordinate2DMake([theatreDict[@"lat"] doubleValue], [theatreDict[@"lng"] doubleValue]);
                marker.title = theatreDict[@"name"];
                [self.theatresArray addObject:marker.title];
                marker.subtitle = theatreDict[@"address"];
                
                [theatresArray addObject:marker];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotations:theatresArray];
                NSLog(@"%@", url);
            });
            //end main thread code
        }
        
    }];
    
    [task resume];
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
    NSString *theatreName = self.theatresArray[indexPath.row];
    cell.textLabel.text = theatreName;
    
    return cell;
    
}

@end
