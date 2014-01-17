//
//  AddEditContactHelper.h
//  CRM
//
//  Created by Narendra Verma on 12/06/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyAddressBook;
@class	AllEmail;
@class AllAddress;
@interface AddEditContactHelper : NSObject

+(NSDictionary *)setPhoneNumbers:(MyAddressBook*)addObj;

+(NSDictionary *)setEmailsInDict:(MyAddressBook*)addObj;

+(NSDictionary *)setURLInDict:(MyAddressBook*)addObj;

+(AllEmail *)getWorkEmail:(MyAddressBook *)addressBook;

+(AllAddress*)getWorkAddress:(MyAddressBook *)addObj;


+(void)editPhoneNumber:(MyAddressBook*)address andMainDict:(NSDictionary *)dict andManageObjContext:(NSManagedObjectContext * )manageObj;
@end
