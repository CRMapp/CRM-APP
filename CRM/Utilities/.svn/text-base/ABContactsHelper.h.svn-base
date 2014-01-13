//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ABContact.h"
#import "ABGroup.h"
#import "MyAddressBook.h"
@interface ABContactsHelper : NSObject

// Address Book
+ (ABAddressBookRef) addressBook;

// Address Book Contacts and Groups
+ (NSArray *) contacts; // people
+ (NSArray *) groups; // groups

// Counting
+ (int) contactsCount;
+ (int) contactsWithImageCount;
+ (int) contactsWithoutImageCount;
+ (int) numberOfGroups;

// Sorting
+ (BOOL) firstNameSorting;

// Add contacts and groups
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error;
+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error;

// delete contacts and groups
+ (BOOL) removePersonFrom_iPadAddressBook: (MyAddressBook *) person;

// Find contacts
+ (NSArray *) contactsMatchingName: (NSString *) fname;
+ (NSArray *) contactsMatchingName: (NSString *) fname andName: (NSString *) lname;
+ (NSArray *) contactsMatchingPhone: (NSString *) number;
+ (NSArray *) contactsMatchingEmail: (NSString *) email;
+ (BOOL) canUpdateContact: (MyAddressBook*) searchContact;
// Find groups
+ (NSArray *) groupsMatchingName: (NSString *) fname;
@end

// For the simple utility of it. Feel free to comment out if desired
@interface NSString (cstring)
@property (readonly) char *UTF8String;
@end