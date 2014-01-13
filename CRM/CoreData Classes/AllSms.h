//
//  AllSms.h
//  CRM
//
//  Created by Sheetal's iMac on 15/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook;

@interface AllSms : NSManagedObject

@property (nonatomic, retain) NSString * sms;
@property (nonatomic, retain) MyAddressBook *relMyAddressBook;

@end
