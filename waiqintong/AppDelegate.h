//
//  AppDelegate.h
//  waiqintong
//
//  Created by Apple on 11/9/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LoginViewController.h"
#import "TimerUploadModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,LoginViewControllerDelegate,CLLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

