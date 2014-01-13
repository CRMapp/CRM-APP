//
//  FollowUpdate.h
//  CRM
//
//  Created by Sheetal's iMac on 18/07/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook, ReminderList;

@interface FollowUpdate : NSManagedObject

@property (nonatomic, retain) NSDate * followDate;
@property (nonatomic, retain) NSString * followDesc;
@property (nonatomic, retain) NSString * followTitle;
@property (nonatomic, retain) NSString * followType;
@property (nonatomic, assign) double timeStamp;
@property (nonatomic, retain) NSNumber *  canShowInDashBoard;
@property (nonatomic, retain) MyAddressBook *relMyAddressBook;
@property (nonatomic, retain) ReminderList *relReminderList;

@end
