//
//  HomeViewController.m
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "OldTrackingViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "UUDatePicker.h"
#import "OldTrackingViewController.h"
#import "AddKQXXViewController.h"
#import "ChangePwdViewController.h"
#import "AddKQXXModel.h"
#import "TimerUploadTableViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) FUIButton *historyButton;
@property (strong, nonatomic) FUIButton *reportButton;
@property (strong, nonatomic) FUIButton *timerUploadButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initView];
   //[self timerDeleteAction];
}

#pragma mark - 跳转到修改密码界面

- (void)changePwdViewControllerAction {
    
    ChangePwdViewController *  changePwdViewController = [[ ChangePwdViewController alloc]init];
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:changePwdViewController] animated:YES completion:nil];
}

#pragma mark - 跳转到考勤管理按钮事件

- (void)reportButtonAction:(UIButton *)button {
    
     [self.navigationController pushViewController:[[AddKQXXViewController alloc]init] animated:YES];
}

#pragma mark - 跳转到历史轨迹按钮事件

- (void)buttonAction:(UIButton *)button {
    
    [self.navigationController pushViewController:[[OldTrackingViewController alloc]init] animated:YES];
}

#pragma mark - 定时删除数据库考勤管理历史记录事件

- (void)timerDeleteAction {
    
    NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:interval];
    
    NSTimeInterval timeInterval= [date timeIntervalSinceReferenceDate];
    timeInterval -=3600*24*15;// 3600s *24 = 1天
    NSDate *beginDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
//    NSLog(@"date is %@",date);
//    NSLog(@"date is %f",timeInterval);
//    NSLog(@"date is %@",beginDate);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp >= %@", beginDate];
    NSFetchRequest *addKQXXModelRequest = [AddKQXXModel MR_requestAllWithPredicate:predicate];
    [addKQXXModelRequest setReturnsDistinctResults:NO];
    
    NSArray *addKQXXModelArray = [AddKQXXModel MR_executeFetchRequest:addKQXXModelRequest];
    
    for (AddKQXXModel *addKQXXModelId in addKQXXModelArray) {
        
        [addKQXXModelId MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];

}

- (void)initView {
    self.title = @"外勤通";
    
    self.historyButton = [[FUIButton alloc] initWithFrame:CGRectMake(50 ,200, 100, 40)];
    self.historyButton.buttonColor = [UIColor turquoiseColor];
    self.historyButton.shadowColor = [UIColor greenSeaColor];
    self.historyButton.shadowHeight = 3.0f;
    self.historyButton.cornerRadius = 6.0f;
    self.historyButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.historyButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.historyButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.historyButton setTitle:@"历史轨迹" forState:UIControlStateNormal];
    [self.historyButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.historyButton];
    
    self.reportButton = [[FUIButton alloc] initWithFrame:CGRectMake(50 ,260, 100, 40)];
    self.reportButton.buttonColor = [UIColor turquoiseColor];
    self.reportButton.shadowColor = [UIColor greenSeaColor];
    self.reportButton.shadowHeight = 3.0f;
    self.reportButton.cornerRadius = 6.0f;
    self.reportButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.reportButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.reportButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.reportButton setTitle:@"考勤管理" forState:UIControlStateNormal];
    [self.reportButton addTarget:self action:@selector(reportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reportButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改密码"
                                                                              style: UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(changePwdViewControllerAction)];
    
    
    self.timerUploadButton = [[FUIButton alloc] initWithFrame:CGRectMake(50 ,320, 100, 40)];
    self.timerUploadButton.buttonColor = [UIColor turquoiseColor];
    self.timerUploadButton.shadowColor = [UIColor greenSeaColor];
    self.timerUploadButton.shadowHeight = 3.0f;
    self.timerUploadButton.cornerRadius = 6.0f;
    self.timerUploadButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.timerUploadButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.timerUploadButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.timerUploadButton setTitle:@"定时上传记录" forState:UIControlStateNormal];
    [self.timerUploadButton addTarget:self action:@selector(timerUploadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.timerUploadButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改密码"
                                                                              style: UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(changePwdViewControllerAction)];
}

- (void)timerUploadButtonAction {
    
     [self.navigationController pushViewController:[[TimerUploadTableViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
