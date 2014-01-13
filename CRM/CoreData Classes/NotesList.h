//
//  NotesList.h
//  CRM
//
//  Created by Sheetal's iMac on 25/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook;

@interface NotesList : NSManagedObject

@property (nonatomic, retain) NSDate * noteDate;
@property (nonatomic, retain) NSString * noteDesc;
@property (nonatomic, assign) double timeStamp;
@property (nonatomic, retain) NSNumber *  canShowInDashBoard;
@property (nonatomic, retain) MyAddressBook *relMyAddressBook;

@end
