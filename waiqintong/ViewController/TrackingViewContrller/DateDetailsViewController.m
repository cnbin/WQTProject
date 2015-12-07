//
//  DateDetailsViewController.m
//  waiqintong
//
//  Created by Apple on 11/11/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "DateDetailsViewController.h"

static float const mapPadding = 1.1f;

@interface DateDetailsViewController ()

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) Tracking *tracking;
@property (strong, nonatomic) MAPointAnnotation *startPointAnnotation;
@property (strong, nonatomic) MAPointAnnotation *endPointAnnotation;

@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *trackingArray;
@property (strong, nonatomic) NSOrderedSet *locations;

@property (strong, nonatomic) FUIButton * rePlayButton;
@property (strong, nonatomic) WzcLocObjectModel *run;

@end

@implementation DateDetailsViewController

@synthesize mapView  = _mapView;
@synthesize tracking = _tracking;
@synthesize annotations = _annotations;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.trackingArray = [GlobalResource sharedInstance].detailResultRunObject.locations.array;
    NSLog(@"self.tracking array is %@",self.trackingArray);
    NSMutableArray * latitudeArray =  [[NSMutableArray alloc]init];
    NSMutableArray * longitudeArray = [[NSMutableArray alloc]init];
    
    for (WzcLocationModel * location in self.trackingArray) {
        NSLog(@"latdetail is %@",location.latitude);
        NSLog(@"londetail is %@",location.longitude);

        [latitudeArray addObject:location.latitude];
        [longitudeArray addObject:location.longitude];
    }
    
    CLLocationCoordinate2D commuterLotCoords[self.trackingArray.count];
    
    for (int i=0; i<self.trackingArray.count; i++)
    {
        commuterLotCoords[i].latitude =[[latitudeArray objectAtIndex:i]doubleValue];
        commuterLotCoords[i].longitude =[[longitudeArray objectAtIndex:i]doubleValue];
    }
    
    self.tracking = [[Tracking alloc] initWithCoordinates:commuterLotCoords count:self.trackingArray.count];
    
    [self.mapView addOverlay:self.tracking.polyline];
    
    self.startPointAnnotation = [[StartAnnotation alloc]init];
    self.startPointAnnotation.coordinate =  commuterLotCoords[0];
    [self.mapView addAnnotation: self.startPointAnnotation];
    
    self.endPointAnnotation = [[EndAnnotation alloc] init];
    self.endPointAnnotation.coordinate =  commuterLotCoords[self.trackingArray.count-1];
    [self.mapView addAnnotation: self.endPointAnnotation];
    
    self.annotations = [NSMutableArray array];
    [self.annotations addObject:self.startPointAnnotation];
    [self.annotations addObject:self.endPointAnnotation];
    [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
    
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"轨迹回放";
    
    [MAMapServices sharedServices].apiKey = @"c771d23c3702ab978d9e174e71562b45";
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.rePlayButton = [[FUIButton alloc] initWithFrame:CGRectMake(Width-120 ,Height-250,60, 40)];
    self.rePlayButton.buttonColor = [UIColor turquoiseColor];
    self.rePlayButton.shadowColor = [UIColor greenSeaColor];
    self.rePlayButton.shadowHeight = 3.0f;
    self.rePlayButton.cornerRadius = 6.0f;
    self.rePlayButton.titleLabel.font = [UIFont boldFlatFontOfSize:12];
    [self.rePlayButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.rePlayButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.rePlayButton setTitle:@"回放" forState:UIControlStateNormal];
    [self.rePlayButton addTarget:self action:@selector(handleRunAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.rePlayButton];
    
}

- (MACoordinateRegion)mapRegion {
    MACoordinateRegion region;
    WzcLocationModel *initialLoc = self.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (WzcLocationModel *location in self.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * mapPadding;
    region.span.longitudeDelta = (maxLng - minLng) * mapPadding;
    
    return region;
}

#pragma mark - Handle Action

- (void)handleRunAction {
    self.mapView.showsUserLocation = NO;
    self.tracking.delegate = self;
    self.tracking.mapView  = self.mapView;
    self.tracking.duration = 5.f;
    self.tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    [self.mapView setRegion:[self mapRegion]];
    [self.tracking execute];
}

#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4.f;
        polylineView.strokeColor = [UIColor redColor];
        return  polylineView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if (annotation == self.tracking.annotation)
    {
        static NSString *trackingReuseIndetifier = @"trackingReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:trackingReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackingReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[StartAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"startReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"start"];
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[EndAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"endReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"end"];
        return annotationView;
    }
    
    return nil;
}

#pragma mark - TrackingDelegate

- (void)willBeginTracking:(Tracking *)tracking {
    
}

- (void)didEndTracking:(Tracking *)tracking {
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
