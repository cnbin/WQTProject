//
//  WzcLocObjectModel.h
//  waiqintong
//
//  Created by Apple on 11/20/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WzcLoctionModel;

@interface WzcLocObjectModel : NSManagedObject

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *bumen;
@property (nullable, nonatomic, retain) NSString *wz;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSString *timestring;
@property (nullable, nonatomic, retain) NSOrderedSet<WzcLoctionModel *> *locations;

@end


