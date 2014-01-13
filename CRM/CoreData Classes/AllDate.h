//
//  AllDate.h
//  CRM
//
//  Created by Sheetal's iMac on 15/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook;

@interface AllDate : NSManagedObject

@property (nonatomic, retain) NSDate * dates;
@property (nonatomic, retain) NSString * dateTitle;

@property (nonatomic, retain) MyAddressBook *relMyAddressBook;

@end
