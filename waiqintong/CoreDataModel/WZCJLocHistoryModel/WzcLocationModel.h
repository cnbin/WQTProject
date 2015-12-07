//
//  WzcLoctionModel.h
//  waiqintong
//
//  Created by Apple on 11/20/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WzcLocaObjectModel;

@interface WzcLocationModel : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) WzcLocObjectModel *locObject;

@end


