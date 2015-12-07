//
//  OldTrackingViewController.h
//  waiqintong
//
//  Created by Apple on 11/10/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "Tracking.h"
#import "WzcLocObjectModel.h"
#import "WzcLocationModel.h"
#import "StartAnnotation.h"
#import "EndAnnotation.h"
#import "GlobalResource.h"
#import "CheckRusultsViewController.h"

@class WzcLocObjectModel;

@interface OldTrackingViewController : UIViewController<MAMapViewDelegate,TrackingDelegate>
{
   
    UIButton * zoomoutButton;
    UIButton * zoominButton;
    float zoomLevel;
}

@property (retain, nonatomic) NSOrderedSet *locations;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//查询结果数组
@property (strong, nonatomic) NSArray *runArray;

//当前数组
@property (strong, nonatomic) NSArray *firstRunArray;

@property (strong, nonatomic) FUIButton * rePlayButton;
@property (strong, nonatomic) FUIButton * checkButton;

@property (strong, nonatomic) UILabel * historylabel;
@property (strong, nonatomic) UILabel * tolabel;

@property (strong, nonatomic) FUITextField * startTimeTextField;
@property (strong, nonatomic) FUITextField * endTimeTextField;

@end
