//
//  TimerUploadModel.h
//  waiqintong
//
//  Created by Apple on 11/21/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TimerUploadModel : NSManagedObject

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *bumen;
@property (nullable, nonatomic, retain) NSNumber *x;
@property (nullable, nonatomic, retain) NSNumber *y;
@property (nullable, nonatomic, retain) NSString *wz;
@property (nullable, nonatomic, assign) NSNumber *isupload;
@property (nullable, nonatomic, retain) NSDate *timestamp;

@end

