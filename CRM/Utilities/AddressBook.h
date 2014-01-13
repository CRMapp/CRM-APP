//
//  AddressBook.h
//  CRM
//
//  Created by Sheetal's iMac on 18/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
@interface AddressBook : NSObject
{
    
}
+ (NSMutableArray*)arrayOfAddressBook;
+ (NSMutableArray*)collectContacts;
+(NSDictionary*)getDetailOfContact:(ABRecordRef)ref;
+ (void)saveMyAddressBook:(NSDictionary*)aDict;
+ (NSMutableArray*)collectContactsWithoutSave;
+ (void)updateAppDatabaseFromiPad;
- (void)removeImageAtPAth:(NSString*)fullPath;
@end
