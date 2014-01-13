//
//  AllUrl.h
//  CRM
//
//  Created by Madhup Singh Yadav on 13/01/14.
//  Copyright (c) 2014 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook;

@interface AllUrl : NSManagedObject

@property (nonatomic, retain) NSString * urlTitle;
@property (nonatomic, retain) NSString * urlAddress;
@property (nonatomic, retain) MyAddressBook *relMyAddressBook;

@end
