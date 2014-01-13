//
//  SaleGoal.h
//  CRM
//
//  Created by Sheetal's iMac on 23/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SaleGoal : NSManagedObject

@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * timePeriod;
@property (nonatomic, retain) NSString * termPeriod;
@property (nonatomic, retain) NSDate * saleDate;
@property (nonatomic, retain) NSDate * saleEndDate;

@end
