//
//  ReportViewController.m
//  waiqintong
//
//  Created by Apple on 11/13/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "AddKQXXViewController.h"
#import "UserInformationModel.h"
#import "AddKQXXModel.h"
#import "AddKQXXHistoryViewController.h"

@interface AddKQXXViewController ()<FUIAlertViewDelegate>

@property (strong, nonatomic) MAMapView *mapView;

@property (assign, nonatomic) double longitudeX; //经度
@property (assign, nonatomic) double latitudeY;  //纬度

@property (strong, nonatomic) NSString *username;      //姓名
@property (strong, nonatomic) NSString *bumen;         //部门
@property (strong, nonatomic) NSString *poi;           //位置
@property (strong, nonatomic) NSString *wz;            //位置
@property (strong, nonatomic) NSString *lx;            //类型
@property (strong, nonatomic) NSString *tp;            //图片

@property (strong, nonatomic) FUIButton *reportButton;
@property (strong, nonatomic) FUISwitch *isLocationSwitch;
@property (strong, nonatomic) UILabel *locationLabel;

@property (strong, nonatomic) NSArray *userInfoArray; //用户信息数组：用户名和部门
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (assign, nonatomic) Boolean isAddKQXXSuccess;
@property (strong, nonatomic) id imgBase64BinaryObject;
@property (strong, nonatomic) NSString *imgName; //拍照图片

@property (strong, nonatomic) AMapLocationManager *  addKQXXAMapLocationManager;

@end

@implementation AddKQXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"考勤上报";
    
    [MAMapServices sharedServices].apiKey        =  @"c771d23c3702ab978d9e174e71562b45";
    [AMapLocationServices sharedServices].apiKey =  @"c771d23c3702ab978d9e174e71562b45";
   
    [self initView];
    [self sqlresult];
    [self mapViewLocation];
}

#pragma mark - 初始化 AMapLocationManager 对象

- (void)mapViewLocation {
    
    __weak AddKQXXViewController *wSelf = self;
    
    self.addKQXXAMapLocationManager = [[AMapLocationManager alloc] init];
    [self.addKQXXAMapLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.addKQXXAMapLocationManager setPausesLocationUpdatesAutomatically:NO];
    [self.addKQXXAMapLocationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self.addKQXXAMapLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
//        if (location.coordinate.latitude >0 && location.coordinate.longitude>0)
        if (location)
        {
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setCoordinate:location.coordinate];
            
            if (regeocode)
            {
                [annotation setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
                [annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
            }
            else
            {
                [annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
                [annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
            }
            
            AddKQXXViewController * addKQXXVSelf = wSelf;
            addKQXXVSelf.poi = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
            addKQXXVSelf.wz = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
            addKQXXVSelf.longitudeX = location.coordinate.longitude;
            addKQXXVSelf.latitudeY  = location.coordinate.latitude;
            [addKQXXVSelf addAnnotationToMapView:annotation];
        }
        else {
             //重新定位
             [self mapViewLocation];
        }
    }];
}

#pragma mark - 添加 MAAnnotation 标注

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation {
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:15.1 animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

#pragma mark - 执行SQL查询,获取用户名和部门信息

- (void)sqlresult {
    
    //查询用户信息
    self.userInfoArray = [UserInformationModel MR_findAllSortedBy:@"timestamp" ascending:NO];
    
    if (self.userInfoArray != nil && ![self.userInfoArray isKindOfClass:[NSNull class]] && self.userInfoArray.count != 0) {
        
        UserInformationModel * userObject = [self.userInfoArray objectAtIndex:0];
        
        self.username = userObject.userName;
        self.bumen = userObject.department;
    }
}

#pragma mark - 签到记录按钮事件

- (void)addKQXXHistoryViewControllerAction {
    
    AddKQXXHistoryViewController * addKQXXHistoryViewController = [[AddKQXXHistoryViewController alloc]init];
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:addKQXXHistoryViewController] animated:YES completion:nil];
    
}

#pragma mark - 开关事件

- (void)switchAction:(FUISwitch *)ActionSwitch {
    
    BOOL isButtonOn=[ActionSwitch isOn];
    if (isButtonOn) {
        
        NSLog(@"on");
  
    }else {
        
        NSLog(@"close");
    }
}

#pragma mark - 考勤上报按钮事件

- (void)addKQXXButtonAction:(UIButton *)button {
    
    FUIAlertView *alertReportView = [[FUIAlertView alloc] initWithTitle:@"请选择"
                                                          message:@"考勤上报"
                                                         delegate:self cancelButtonTitle:@"下班"
                                                otherButtonTitles:@"上班", nil];
    alertReportView.titleLabel.textColor = [UIColor cloudsColor];
    alertReportView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertReportView.messageLabel.textColor = [UIColor cloudsColor];
    alertReportView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertReportView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertReportView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertReportView.defaultButtonColor = [UIColor cloudsColor];
    alertReportView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertReportView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertReportView.defaultButtonTitleColor = [UIColor asbestosColor];
    alertReportView.tag= 1;
    
    [alertReportView show];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(FUIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag ==1 ) {
        
        if (buttonIndex == 0) {
            
            NSLog(@"结束定位");
            self.lx = @"下班";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLocationNotification" object:self userInfo:nil];
            
        }else if (buttonIndex ==1)
        {
            NSLog(@"开始定位");
            self.lx = @"上班";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setupLocationNotification" object:self userInfo:nil];
        
        }
        
        FUIAlertView *photoAlertView = [[FUIAlertView alloc] initWithTitle:@"请选择"
                                                                   message:@"拍照上传"
                                                                  delegate:self cancelButtonTitle:@"取消"
                                                         otherButtonTitles:@"上传", nil];
        photoAlertView.titleLabel.textColor = [UIColor cloudsColor];
        photoAlertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
        photoAlertView.messageLabel.textColor = [UIColor cloudsColor];
        photoAlertView.messageLabel.font = [UIFont flatFontOfSize:14];
        photoAlertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
        photoAlertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
        photoAlertView.defaultButtonColor = [UIColor cloudsColor];
        photoAlertView.defaultButtonShadowColor = [UIColor asbestosColor];
        photoAlertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
        photoAlertView.defaultButtonTitleColor = [UIColor asbestosColor];
        photoAlertView.tag = 2;
        [photoAlertView show];
        
    }
    
    if (alertView.tag == 2) {
        
        if (buttonIndex == 0) {
            
            NSLog(@"直接上传");
            [self setupRequest];
            [self saveAddKQXXDataAction];
        }
        else if (buttonIndex ==1) {
            
            NSLog(@"打开相机");
            
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            //UIImagePickerControllerSourceTypePhotoLibrary UIImagePickerControllerSourceTypeCamera
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
    }
}

#pragma mark - 选择图片delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.imgName = [self timeStringRecord];  // 保存图片至本地，方法见下文
    [self saveImage:image withName:[NSString stringWithFormat:@"%@.jpg",self.imgName]];
    [self setupFJload];
    [self setupRequest];
    [self saveAddKQXXDataAction];
}

#pragma mark - 取消选择图片delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 保存图片至沙盒

- (BOOL)imageHasAlpha:(UIImage *)image {
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark - 图片转换成Base64Binary

- (void)image2DataURL:(UIImage *)image {
    
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 0.5f);
        mimeType = @"image/jpg";
    }
    self.imgBase64BinaryObject = [imageData base64EncodedStringWithOptions:0];
}

#pragma mark - 保存图片到文件

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    NSLog(@"保存图片");
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.01);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
}

#pragma mark - 上传图片

- (void)setupFJload {
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.imgName]];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    [self image2DataURL: savedImage];
    
    self.tp = [NSString stringWithFormat:@"%@.jpg",self.imgName];

    NSString *strURL = [[NSString alloc] initWithFormat:webserviceURL];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<FJUpload xmlns=\"http://tempuri.org/\">"
                               "<fs>%@</fs>"
                               "<fileName>%@</fileName>"
                               "</FJUpload>"
                               "</soap:Body>"
                               "</soap:Envelope>",
                               self.imgBase64BinaryObject,
                               self.tp];

    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request
                       returningResponse: &response
                       error: &error];
}

#pragma mark - 上传信息:用户名 部门 经度 纬度 位置 类型 图片

- (void)setupRequest {
    
    NSLog(@"name is %@",self.username);
    NSLog(@"bumen is %@",self.bumen);
    NSLog(@"poi is %@",self.poi);
    NSLog(@"wz is %@",self.wz);
    NSLog(@"x is %lf",self.longitudeX);
    NSLog(@"y is %lf",self.latitudeY);
    NSLog(@"lx is %@",self.lx);
    NSLog(@"tp is %@",self.tp);
    
    if (self.poi == nil || [self.poi isKindOfClass:[NSNull class]]) {
        self.poi = @" ";
    }
    if (self.wz == nil || [self.wz isKindOfClass:[NSNull class]]) {
        self.wz = @" ";
    }
    if (self.tp == nil || [self.tp isKindOfClass:[NSNull class]]) {
        self.tp = @" ";
    }
    
    NSString *strURL = [[NSString alloc] initWithFormat:webserviceURL];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<AddKQXX xmlns=\"http://tempuri.org/\">"
                               "<username>%@</username>"
                               "<bumen>%@</bumen>"
                               "<poi>%@</poi>"
                               "<wz>%@</wz>"
                               "<lx>%@</lx>"
                               "<x>%f</x>"
                               "<y>%f</y>"
                               "<tp>%@</tp>"
                               "</AddKQXX>"
                               "</soap:Body>"
                               "</soap:Envelope>",
                               
                               self.username,
                               self.bumen,
                               self.poi,
                               self.wz,
                               
                               self.lx,
                               self.longitudeX,
                               self.latitudeY,
                               self.tp];
    
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    
    
//    NSURLConnection *connection = [[NSURLConnection alloc]
//                                    initWithRequest:request delegate:self];
//    
//    if (connection) {
//        
//        if (connection) {
//            NSLog(@"连接成功");
//            self.isAddKQXXSuccess = YES;
//        }else {
//            NSLog(@"连接失败");
//            self.isAddKQXXSuccess = NO;
//        }
//    }

    
        NSError *error = nil;
        NSHTTPURLResponse *response = nil;
    
        NSData * data = [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
        if (data) {
    
            NSLog(@"连接成功");
            self.isAddKQXXSuccess = YES;
        }else {
            NSLog(@"连接失败");
            self.isAddKQXXSuccess = NO;
        }
}

#pragma mark - 保存信息到数据库：定时上传数据-经纬度，是否上传标志，所在位置，保存时间

- (void)saveAddKQXXDataAction {
    
    AddKQXXModel * addKQXXModelObject = [AddKQXXModel MR_createEntity];
    
    addKQXXModelObject.username = self.username; //用户名
    addKQXXModelObject.bumen    = self.bumen;       //部门
    addKQXXModelObject.poi      = self.poi;
    addKQXXModelObject.wz       = self.wz;
    addKQXXModelObject.lx       = self.lx;
    NSLog(@"self.longitudeXXXX is %f",self.longitudeX);
    NSLog(@"self.longitudeXXXX is %@",[NSNumber numberWithDouble:self.longitudeX]);
    
    addKQXXModelObject.x        = [NSNumber numberWithDouble:self.longitudeX];  //经度
    addKQXXModelObject.y        = [NSNumber numberWithDouble:self.latitudeY]; //纬度
    addKQXXModelObject.tp       = self.tp;
    
    [self saveNowDate];
    
    addKQXXModelObject.timestamp = [self.datePicker date];
    addKQXXModelObject.isAddKQXXSuccess = [NSNumber numberWithBool:self.isAddKQXXSuccess];
    
    NSLog(@"addKQXXModelObject.username is %@",addKQXXModelObject.username);
    NSLog(@"addKQXXModelObject.bumen is %@",addKQXXModelObject.bumen);
    NSLog(@"addKQXXModelObject.poi  is %@",addKQXXModelObject.poi);
    NSLog(@"addKQXXModelObject.lx is %@",addKQXXModelObject.lx);
    NSLog(@"addKQXXModelObject.x   is %@",addKQXXModelObject.x);
    NSLog(@"addKQXXModelObject.y   is %@",addKQXXModelObject.y );
    NSLog(@"addKQXXModelObject.tp is %@",addKQXXModelObject.tp);
    NSLog(@"addKQXXModelObject.isQianDaoSuccess  is %@",[NSNumber numberWithBool:self.isAddKQXXSuccess]);

    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
}

#pragma mark - 时间转数字

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
    NSString * secondString = [NSString stringWithFormat:@"%ld",(long)[comps second]];
    
    //时间拼成数字形式：20151116170511 2015-11-16 17:05:11
    NSString * timeNumberString = [[[[[yearString stringByAppendingString:monthString]stringByAppendingString: dayString]stringByAppendingString: hourString]stringByAppendingString:minuteString]stringByAppendingString: secondString];
    
    return timeNumberString ;
}

#pragma mark - 当前时间

- (void)saveNowDate {
    
    NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
    NSDate *nowDate=[NSDate dateWithTimeIntervalSinceNow:interval];
    
    self.datePicker=[[UIDatePicker alloc] init];
    [self.datePicker setDate:nowDate];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}

#pragma mark - connect连接成功

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化View

- (void)initView {
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(20, 110, Width-40, Height-200)];
    self.mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70,60, 30)];
    self.locationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.locationLabel.text = @"位置采集";
    self.locationLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.locationLabel];
    
    self.isLocationSwitch = [[FUISwitch alloc]initWithFrame:CGRectMake(95, 70, 60, 30)];
    self.isLocationSwitch.onColor = [UIColor turquoiseColor];
    self.isLocationSwitch.offColor = [UIColor cloudsColor];
    self.isLocationSwitch.onBackgroundColor = [UIColor midnightBlueColor];
    self.isLocationSwitch.offBackgroundColor = [UIColor silverColor];
    self.isLocationSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    self.isLocationSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    self.isLocationSwitch.on = NO;
    [self.isLocationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.isLocationSwitch];
    
    self.reportButton = [[FUIButton alloc] initWithFrame:CGRectMake(110 ,Height-50, 100, 40)];
    self.reportButton.buttonColor = [UIColor turquoiseColor];
    self.reportButton.shadowColor = [UIColor greenSeaColor];
    self.reportButton.shadowHeight = 3.0f;
    self.reportButton.cornerRadius = 6.0f;
    self.reportButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.reportButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.reportButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.reportButton setTitle:@"签到" forState:UIControlStateNormal];
    [self.reportButton  addTarget:self action:@selector(addKQXXButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reportButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"签到记录"
                                                                              style: UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(addKQXXHistoryViewControllerAction)];
}

@end
