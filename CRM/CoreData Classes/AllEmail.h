//
//  AllEmail.h
//  CRM
//
//  Created by Madhup Singh Yadav on 13/01/14.
//  Copyright (c) 2014 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyAddressBook;

@interface AllEmail : NSManagedObject
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSString * emailURL;
@property (nonatomic, retain) NSString * emailTitle;
@property (nonatomic, retain) MyAddressBook *relMyAddressBook;
@end
