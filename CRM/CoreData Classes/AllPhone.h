//
//  AllPhone.h
//  CRM
//
//  Created by Madhup Singh Yadav on 08/01/14.
//  Copyright (c) 2014 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook;

@interface AllPhone : NSManagedObject

@property (nonatomic, retain) NSString * phoneTitle;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) MyAddressBook *relMyAddressBook;

@end
