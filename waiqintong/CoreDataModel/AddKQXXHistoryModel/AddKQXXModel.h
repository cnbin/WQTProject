//
//  AddKQXXModel.h
//  waiqintong
//
//  Created by Apple on 11/19/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AddKQXXModel : NSManagedObject

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *bumen;
@property (nullable, nonatomic, retain) NSString *wz;
@property (nullable, nonatomic, retain) NSString *poi;
@property (nullable, nonatomic, retain) NSString *lx;
@property (nullable, nonatomic, retain) NSString *tp;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSNumber *x;
@property (nullable, nonatomic, retain) NSNumber *y;
@property (nullable, nonatomic, retain) NSNumber *isAddKQXXSuccess;

@end

