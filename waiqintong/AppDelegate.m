//
//  AppDelegate.m
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "OldTrackingViewController.h"
#import "UserInformationModel.h"
#import "WzcLocObjectModel.h"
#import "WzcLocationModel.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSMutableArray *timeLocationsArray; //保存定时上传的经纬度到数组
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) AMapLocationManager *amaplocationManager;
@property (assign, nonatomic) BOOL isNetworkConnnect;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSNumber *tempLatitude; //定时上传的经纬度,数字类型用于后面历史轨迹查询
@property (strong, nonatomic) NSNumber *tempLongitude;

@property (assign, nonatomic) CGFloat searchLatitude; //定时上传的经纬度
@property (assign, nonatomic) CGFloat searchLongitude;

@property (strong, nonatomic) NSString *userName;//用户名
@property (strong, nonatomic) NSString *bumen;//部门
@property (strong, nonatomic) NSString *wz;//位置

@property (strong, nonatomic) NSArray *userInfoArray;
@property (assign, nonatomic) Boolean isUploadSuccess;

@property (strong, nonatomic) AMapSearchAPI *search;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MAMapServices sharedServices].apiKey        = @"c771d23c3702ab978d9e174e71562b45";
    [AMapLocationServices sharedServices].apiKey = @"c771d23c3702ab978d9e174e71562b45";
    [AMapSearchServices sharedServices].apiKey   = @"c771d23c3702ab978d9e174e71562b45";
    
    //创建MagicalRecord外勤通数据库
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"WQTong.sqlite"];
    
   // [self isConnectionAvailable];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BOOL isLogined = [[NSUserDefaults standardUserDefaults] boolForKey:@"key_isLogined"];

    if (isLogined) {
        
        [self showHome];
//        [self AddWZCJLocation];
    }
    else
    {
        [self showLogin];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupLocation:)
                                                 name:@"setupLocationNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopLocation:)
                                                 name:@"stopLocationNotification"
                                               object:nil];
    //禁止自动休眠可以通过这一句话搞定
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
     self.timeLocationsArray = [NSMutableArray array]; //初始化数组,用来定时上传的经纬度
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 视图切换

- (void)showHome {
    
    HomeViewController * homeViewController=[[HomeViewController alloc]init];
    UINavigationController * homeNavigationController = [[UINavigationController
                                                          alloc] initWithRootViewController:homeViewController];
    self.window.rootViewController = homeNavigationController;
}

#pragma mark - 根控制器为LoginViewController

- (void)showLogin {
    
    LoginViewController * loginViewController=[[LoginViewController alloc]init];
    loginViewController.delegate=self;
    self.window.rootViewController= loginViewController;
}

#pragma mark - LoginViewControllerDelegate

- (void)LoginViewController:(LoginViewController *)loginViewController {
    
    [self showHome];
}

#pragma mark - 定时器执行方法

- (void)timerAction {
    
    //[self AddWZCJLocation];
    [self saveNowDate];//记录当前时间

    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:self.searchLatitude longitude:self.searchLongitude];
    
    regeo.requireExtension = YES;
    
    //添加保存坐标
    [self.timeLocationsArray addObject:regeo.location];
    
    //发起逆地理编码
    [self.search AMapReGoecodeSearch:regeo];
   
}

#pragma mark - 逆地理编码,获取定时上传的坐标点,用户当前位置

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    __weak AppDelegate *wAppself = self;
    
    if (response.regeocode != nil)
    {
      self.wz = response.regeocode.formattedAddress;
        NSLog(@"self.wz is %@",self.wz);
    }
    
    [wAppself uploadRecordLocation];
}

#pragma mark - MALocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
//    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    self.searchLatitude  = location.coordinate.latitude;
    self.searchLongitude = location.coordinate.longitude;
    self.tempLatitude  =  [NSNumber numberWithDouble:location.coordinate.latitude];
    self.tempLongitude =  [NSNumber numberWithDouble:location.coordinate.longitude];
}

#pragma mark - 上传信息:用户名 部门 经度 纬度 位置 时间

- (void)uploadRecordLocation {
    
    //查询用户信息
    self.userInfoArray = [UserInformationModel MR_findAllSortedBy:@"timestamp" ascending:NO];
    
    if (self.userInfoArray != nil && ![self.userInfoArray isKindOfClass:[NSNull class]] && self.userInfoArray.count != 0) {

        UserInformationModel * userObject = [UserInformationModel MR_findFirst];
        self.userName = userObject.userName;
        self.bumen = userObject.department;
    }
    NSLog(@"upload is %@",self.wz);

    NSString *strURL = [[NSString alloc] initWithFormat:webserviceURL];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];

    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<AddWZCJLoc xmlns=\"http://tempuri.org/\">"
                               "<username>%@</username>"
                               "<bumen>%@</bumen>"
                               "<x>%@</x>"
                               "<y>%@</y>"
                               "<wz>%@</wz>"
                               "<jq>%@</jq>"
                               "</AddWZCJLoc>"
                               "</soap:Body>"
                               "</soap:Envelope>",
                               
                               self.userName,
                               self.bumen,
                               self.tempLongitude,
                               self.tempLatitude,
                               self.wz,
                               [self.datePicker date]
                              ];
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    if (data) {
        
        NSLog(@"连接成功");
        self.isUploadSuccess = YES;
        
    }else {
        
        NSLog(@"连接失败");
        self.isUploadSuccess = NO;
    }

    TimerUploadModel *timerUploadModel = [TimerUploadModel MR_createEntity];
    
    timerUploadModel.userName  = self.userName;
    timerUploadModel.bumen     = self.bumen;
    timerUploadModel.x         = self.tempLongitude;
    timerUploadModel.y         = self.tempLatitude;
    timerUploadModel.wz        = self.wz;
    timerUploadModel.timestamp = [self.datePicker date];
    timerUploadModel.isupload  = [NSNumber numberWithBool:self.isUploadSuccess];
    
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    
}

#pragma mark - 点击下班时候,保存定时上传的全部数据:经纬度数组,是否上传标志,所在位置,保存时间,用于历史轨迹查询

- (void)saveUploadDataAction {
    
    WzcLocObjectModel *newRun = [WzcLocObjectModel MR_createEntity];

    newRun.userName = self.userName;
    newRun.bumen = self.bumen;
    newRun.wz = self.wz;
    
    newRun.timestamp  =  [self.datePicker date];
    newRun.timestring =  [self timeStringRecord];
    
    NSMutableArray *locationArray = [NSMutableArray array];
    
    if (self.timeLocationsArray != nil && ![self.timeLocationsArray isKindOfClass:[NSNull class]] && self.timeLocationsArray.count != 0)
    {
        for (CLLocation *location in self.timeLocationsArray) {
            
            WzcLocationModel *locationObject = [WzcLocationModel MR_createEntity];
            locationObject.timestamp = [self.datePicker date];
            locationObject.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
            locationObject.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
            [locationArray addObject:locationObject];
            
//            NSLog(@"latitudeapp is %@",locationObject.latitude);
//            NSLog(@"longgggeapp is %@",locationObject.longitude);
        }
        newRun.locations = [NSOrderedSet orderedSetWithArray:locationArray];
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
    }
    NSLog(@"app newRun is %@",newRun);
}

#pragma mark - 设置当前时间

- (void)saveNowDate {
    
    NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:interval];
    
    self.datePicker=[[UIDatePicker alloc] init];
    [self.datePicker setDate:date];
}

#pragma mark - 处理开启定位通知

- (void)setupLocation:(NSNotification *)notification {
    NSLog(@"定时器开启定位");
    
    self.amaplocationManager = [[AMapLocationManager alloc] init]; //初始化一次定位
    self.amaplocationManager.delegate = self;
    [self.amaplocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters]; //精确度100米
    [self.amaplocationManager setPausesLocationUpdatesAutomatically:NO]; //后台不停止更新位置
    [self.amaplocationManager setAllowsBackgroundLocationUpdates:YES]; //适配iOS9要加上这句
    [self.amaplocationManager startUpdatingLocation];

    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:(600.0) target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

#pragma mark - 处理停止定位通知

- (void)stopLocation:(NSNotification *)notification {
    NSLog(@"stop定位");
    [self.amaplocationManager stopUpdatingLocation];
    
    [self.timer invalidate];
    self.timer = nil;
    [self saveUploadDataAction];
}

#pragma mark - 时间格式化为数字

- (NSString *)timeStringRecord {
    
    NSDate *dateNow;
    dateNow=[NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear  | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    comps = [calendar components:unitFlags fromDate:dateNow];
    
    NSString * yearString   = [NSString stringWithFormat:@"%ld",(long)[comps year]];
    NSString * monthString  = [NSString stringWithFormat:@"%ld",(long)[comps month]];
    NSString * dayString    = [NSString stringWithFormat:@"%ld",(long)[comps day]];
    NSString * hourString   = [NSString stringWithFormat:@"%ld",(long)[comps hour]];
    NSString * minuteString = [NSString stringWithFormat:@"%ld",(long)[comps minute]];
    
    //时间拼成数字形式：201511161705  2015-11-16 17:05
    NSString * timeNumberString = [[[[yearString stringByAppendingString:monthString]stringByAppendingString: dayString]stringByAppendingString: hourString]stringByAppendingString:minuteString];
    
    return timeNumberString ;
}

#pragma mark - 判断网络状态

- (BOOL)isConnectionAvailable {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        
        //[self.window makeToast:@"当前网络不可用,请检查网络连接" duration:1.0 position:@"center"];

        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//        hud.removeFromSuperViewOnHide =YES;
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = NSLocalizedString(@"当前网络不可用,请检查网络连接", nil);
//        hud.minSize = CGSizeMake(132.f, 108.0f);
//        [hud hide:YES afterDelay:3];
        return NO;
    }
    
    return isExistenceNetwork;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"setupLocationNotification"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"stopLocationNotification"];
}

@end
