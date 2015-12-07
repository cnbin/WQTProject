//
//  OldTrackingViewController.m
//  waiqintong
//
//  Created by Apple on 11/10/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "OldTrackingViewController.h"
#import "DateCheckViewController.h"
#import "UUDatePicker.h"
#import "FindEndAnnotation.h"
#import "FindStartAnnotation.h"
#import "AppDelegate.h"

#define SystemThemeColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]

static float const mapPadding = 1.1f;

static NSString * const checkSegueName = @"checkSegue";


@interface OldTrackingViewController ()

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) Tracking *tracking;
@property (nonatomic, strong) MAPointAnnotation *startPointAnnotation;
@property (nonatomic, strong) MAPointAnnotation *endPointAnnotation;
@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) NSString * startString;
@property (nonatomic, strong) NSString * endString;

@property (nonatomic, strong) MAPointAnnotation *FindstartPointAnnotation;
@property (nonatomic, strong) MAPointAnnotation *FindendPointAnnotation;

@property (nonatomic, strong) Tracking *Findtracking;
@property (nonatomic, assign) BOOL rePlay;
@property (nonatomic, strong) WzcLocObjectModel * findRunObject;

@end

@implementation OldTrackingViewController

@synthesize mapView  = _mapView;
@synthesize tracking = _tracking;
@synthesize annotations = _annotations;
@synthesize Findtracking = _Findtracking;

#pragma mark - 初始化SQL查询

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
     self.firstRunArray = [WzcLocObjectModel MR_findAllSortedBy:@"timestamp" ascending:NO];
    
      NSLog(@"self.frstarray is %@",self.firstRunArray);
     if (self.firstRunArray != nil && ![self.firstRunArray isKindOfClass:[NSNull class]] && self.firstRunArray.count != 0) {
        
        WzcLocObjectModel * firstRunObject = [self.firstRunArray objectAtIndex:0];
        
        NSMutableArray * latitudeArray =  [[NSMutableArray alloc]init];
        NSMutableArray * longitudeArray = [[NSMutableArray alloc]init];
        
        for (WzcLocationModel * location in firstRunObject.locations.array) {
            NSLog(@"location is %@",location.latitude);
            NSLog(@"location is %@",location.longitude);
            [latitudeArray addObject:location.latitude];
            [longitudeArray addObject:location.longitude];
        }
        
        CLLocationCoordinate2D commuterLotCoords[firstRunObject.locations.array.count];
        
        for (int i=0; i<firstRunObject.locations.array.count; i++)
        {
            commuterLotCoords[i].latitude =[[latitudeArray objectAtIndex:i]doubleValue];
            commuterLotCoords[i].longitude =[[longitudeArray objectAtIndex:i]doubleValue];
        }
        
        self.tracking = [[Tracking alloc] initWithCoordinates:commuterLotCoords count:firstRunObject.locations.array.count];
        
        [self.mapView addOverlay:self.tracking.polyline];
        
        self.startPointAnnotation = [[StartAnnotation alloc]init];
        self.startPointAnnotation.coordinate =  commuterLotCoords[0];
        [self.mapView addAnnotation: self.startPointAnnotation];
        
        self.endPointAnnotation = [[EndAnnotation alloc] init];
        self.endPointAnnotation.coordinate =  commuterLotCoords[firstRunObject.locations.array.count-1];
        [self.mapView addAnnotation: self.endPointAnnotation];
        
        self.annotations = [NSMutableArray array];
        [self.annotations addObject:self.startPointAnnotation];
        [self.annotations addObject:self.endPointAnnotation];
        [self.mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(50, 50, 50,50) animated:YES];
        
    }
}

#pragma mark - 初始化视图

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史轨迹";
    self.view.backgroundColor = [UIColor cloudsColor];
    [MAMapServices sharedServices].apiKey = @"c771d23c3702ab978d9e174e71562b45";
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(20, 150, Width-40, Height-120)];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    self.historylabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 75,75, 30)];
    self.historylabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.historylabel.text = @"历史轨迹查询";
    self.historylabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.historylabel];
    
    self.startTimeTextField = [[FUITextField alloc]initWithFrame:CGRectMake(85, 75, 120, 30)];
    self.startTimeTextField.font = [UIFont flatFontOfSize:10];
    self.startTimeTextField.backgroundColor = [UIColor clearColor];
    self.startTimeTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.startTimeTextField.textFieldColor = [UIColor whiteColor];
    self.startTimeTextField.borderColor = [UIColor turquoiseColor];
    self.startTimeTextField.borderWidth = 2.0f;
    self.startTimeTextField.cornerRadius = 3.0f;
    [self.view addSubview:self.startTimeTextField];
    
    self.tolabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 115, 15, 30)];
    self.tolabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.tolabel.text = @"至";
    self.tolabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.tolabel];
    
    self.endTimeTextField = [[FUITextField alloc]initWithFrame:CGRectMake(85, 115, 120, 30)];
    self.endTimeTextField.font = [UIFont flatFontOfSize:10];
    self.endTimeTextField.backgroundColor = [UIColor clearColor];
    self.endTimeTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.endTimeTextField.textFieldColor = [UIColor whiteColor];
    self.endTimeTextField.borderColor = [UIColor turquoiseColor];
    self.endTimeTextField.borderWidth = 2.0f;
    self.endTimeTextField.cornerRadius = 3.0f;
    [self.view addSubview:self.endTimeTextField];
    
    self.checkButton = [[FUIButton alloc] initWithFrame:CGRectMake(Width-100 ,75,60, 40)];
    self.checkButton.buttonColor = [UIColor turquoiseColor];
    self.checkButton.shadowColor = [UIColor greenSeaColor];
    self.checkButton.shadowHeight = 3.0f;
    self.checkButton.cornerRadius = 6.0f;
    self.checkButton.titleLabel.font = [UIFont boldFlatFontOfSize:12];
    [self.checkButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.checkButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.checkButton setTitle:@"查询" forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkButton];
    
    self.rePlayButton = [[FUIButton alloc] initWithFrame:CGRectMake(Width-120 ,Height-250,60, 40)];
    self.rePlayButton.buttonColor = [UIColor turquoiseColor];
    self.rePlayButton.shadowColor = [UIColor greenSeaColor];
    self.rePlayButton.shadowHeight = 3.0f;
    self.rePlayButton.cornerRadius = 6.0f;
    self.rePlayButton.titleLabel.font = [UIFont boldFlatFontOfSize:12];
    [self.rePlayButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.rePlayButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.rePlayButton setTitle:@"回放" forState:UIControlStateNormal];
    [self.rePlayButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.rePlayButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日期查询"
                                                                              style: UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dateRunAction)];
    NSDate *now = [NSDate date];
    UUDatePicker *startDatePicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, Width, 200)
                             PickerStyle: UUDateStyle_YearMonthDayHourMinute
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 self.startTimeTextField.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
                                 self.startString = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
                                 
                             }];
    
    startDatePicker.maxLimitDate = [now dateByAddingTimeInterval:2222];
    
    UUDatePicker *endDatePicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, Width, 200)
                             PickerStyle: UUDateStyle_YearMonthDayHourMinute
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 self.endTimeTextField.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
                                 
                                 self.endString = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
                             }];
    
    endDatePicker.maxLimitDate = [now dateByAddingTimeInterval:2222];
    
    self.startTimeTextField.inputView = startDatePicker;
    self.endTimeTextField.inputView = endDatePicker;
    
}

- (void)checkbuttonAction:(UIButton *)button {
    
    self.runArray = [WzcLocObjectModel MR_findAllSortedBy:@"timestamp" ascending:NO];
    
    if (self.runArray != nil && ![self.runArray isKindOfClass:[NSNull class]] && self.runArray.count != 0)
    {
        if (self.startString != nil && self.endString!= nil && ![self.startString isKindOfClass:[NSNull class]]
            && ![self.endString isKindOfClass:[NSNull class]]) {
            
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                               @"(timestring >=%@) AND (timestring <=%@)",self.startString,self.endString];
            
        NSFetchRequest *fetchRequest = [WzcLocObjectModel MR_requestAllWithPredicate:predicate];
        fetchRequest.fetchBatchSize = 20;
        NSArray *listData = [WzcLocObjectModel MR_executeFetchRequest:fetchRequest];
        self.findRunObject = [listData lastObject];
            
        [GlobalResource sharedInstance].resultRunObject = self.findRunObject;
        CheckRusultsViewController * check = [[CheckRusultsViewController alloc]init];
        [self presentViewController: [[UINavigationController alloc] initWithRootViewController:check] animated:YES completion:nil];
        }
    }
    
}

- (void)buttonAction:(UIButton *)button {
    
    self.mapView.showsUserLocation = NO;
    self.tracking.delegate = self;
    self.tracking.mapView  = self.mapView;
    self.tracking.duration = 5.f;
    self.tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
    [self.mapView setRegion:[self mapRegion]];
    [self.tracking execute];
}

- (void)dateRunAction {
    
    DateCheckViewController * datecheck = [[DateCheckViewController alloc]init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:datecheck] animated:YES completion:nil];
    
}

#pragma mark - 显示地图范围

- (MACoordinateRegion)mapRegion {
    MACoordinateRegion region;
    
    WzcLocationModel *initialLoc = self.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (WzcLocationModel *location in self.locations) {
        NSLog(@"location is %@",location.latitude);
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

#pragma mark - 日期选择器关闭事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)zoom {
    zoomoutButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [zoomoutButton setTitle:@"放大" forState:UIControlStateNormal];
    [zoomoutButton setBackgroundColor:SystemThemeColor];
    [zoomoutButton sizeToFit];
    zoomoutButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
    [zoomoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zoomoutButton addTarget:self action:@selector(zoomoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    zoomoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:zoomoutButton];
    
    zoominButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [zoominButton setTitle:@"缩小" forState:UIControlStateNormal];
    [zoominButton setBackgroundColor:SystemThemeColor];
    [zoominButton sizeToFit];
    zoominButton.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:12];
    [zoominButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zoominButton.translatesAutoresizingMaskIntoConstraints = NO;
    [zoominButton addTarget:self action:@selector(zoominButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoominButton];
    
    //zoomoutButton布局
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:zoomoutButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    constraint = [NSLayoutConstraint constraintWithItem:zoomoutButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    //右边距
    constraint = [NSLayoutConstraint
                  constraintWithItem:zoomoutButton
                  attribute:NSLayoutAttributeTrailing
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeTrailing
                  multiplier:1.0f
                  constant:-30.0f];
    [self.view addConstraint:constraint];
    
    //下边距
    constraint = [NSLayoutConstraint
                  constraintWithItem:zoomoutButton
                  attribute:NSLayoutAttributeBottom
                  relatedBy:NSLayoutRelationEqual
                  toItem:self.view
                  attribute:NSLayoutAttributeBottom
                  multiplier:1.0f
                  constant:-80.0f];
    [self.view addConstraint:constraint];
    
    //zoominButton布局
    NSLayoutConstraint *constraintZoomIn;
    
    constraintZoomIn = [NSLayoutConstraint constraintWithItem:zoominButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    constraintZoomIn = [NSLayoutConstraint constraintWithItem:zoominButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30.0f];
    
    //右边距
    constraintZoomIn = [NSLayoutConstraint
                        constraintWithItem:zoominButton
                        attribute:NSLayoutAttributeTrailing
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.view
                        attribute:NSLayoutAttributeTrailing
                        multiplier:1.0f
                        constant:-30.0f];
    [self.view addConstraint:constraintZoomIn];
    
    //下边距
    constraintZoomIn = [NSLayoutConstraint
                        constraintWithItem:zoominButton
                        attribute:NSLayoutAttributeBottom
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.view
                        attribute:NSLayoutAttributeBottom
                        multiplier:1.0f
                        constant:-55.0f];
    [self.view addConstraint:constraintZoomIn];
}

- (void)zoomoutButtonAction:(UIButton *)button {
    
    zoomLevel = zoomLevel*0.5;
    
}

- (void)zoominButtonAction:(UIButton *)button {
    
    zoomLevel = zoomLevel*1.5;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
