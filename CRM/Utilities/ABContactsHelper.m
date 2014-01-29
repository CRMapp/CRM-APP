//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ABContactsHelper.h"
#import "AllUrl.h"
#import "AllAddress.h"
#import "AllEmail.h"
#import "AllPhone.h"
#import "AllDate.h"
#import "AllRelatedName.h"
#define CFAutorelease(obj) ({CFTypeRef _obj = (obj); (_obj == NULL) ? NULL : [(id)CFMakeCollectable(_obj) autorelease]; })

@implementation ABContactsHelper
/*
 Note: You cannot CFRelease the addressbook after CFAutorelease(ABAddressBookCreate());
 */
+ (ABAddressBookRef) addressBook
{
	return CFAutorelease(ABAddressBookCreate());
}

+ (NSArray *) contacts
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *thePeople = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:thePeople.count];
	for (id person in thePeople)
		[array addObject:[ABContact contactWithRecord:(ABRecordRef)person]];
	[thePeople release];
	return array;
}

+ (int) contactsCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	return ABAddressBookGetPersonCount(addressBook);
}

+ (int) contactsWithImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

+ (int) contactsWithoutImageCount
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *peopleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
	int ncount = 0;
	for (id person in peopleArray) if (!ABPersonHasImageData(person)) ncount++;
	[peopleArray release];
	return ncount;
}

// Groups
+ (int) numberOfGroups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	int ncount = groups.count;
	[groups release];
	return ncount;
}

+ (NSArray *) groups
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	NSArray *groups = (NSArray *)ABAddressBookCopyArrayOfAllGroups(addressBook);
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:groups.count];
	for (id group in groups)
		[array addObject:[ABGroup groupWithRecord:(ABRecordRef)group]];
	[groups release];
	return array;
}

// Sorting
+ (BOOL) firstNameSorting
{
	return (ABPersonGetCompositeNameFormat() == kABPersonCompositeNameFormatFirstNameFirst);
}

#pragma mark Contact Management

// Thanks to Eridius for suggestions re: error
+ (BOOL) addContact: (ABContact *) aContact withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookAddRecord(addressBook, aContact.record, (CFErrorRef *) error)) return NO;
    
	NSLog(@"address Book record .record ID  %d",ABRecordGetRecordID(aContact.record));
    return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}

+ (BOOL) addGroup: (ABGroup *) aGroup withError: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
	if (!ABAddressBookAddRecord(addressBook, aGroup.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook, (CFErrorRef *) error);
}
+ (BOOL) removePersonFrom_iPadAddressBook: (MyAddressBook *) person
{
    if ([person.recordID length] >= 10)
    {
        return NO;
    }
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"recordID == %d",[person.recordID integerValue]];
	NSArray *array = [contacts filteredArrayUsingPredicate:pred];
    
    if ([array count])
    {
        NSError *error = nil;
        ABContact *ABPerson = (ABContact*)[array lastObject];
        return [ABPerson removeSelfFromAddressBook:&error];
    }
    return NO;
}
+ (NSArray *) contactsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	return [contacts filteredArrayUsingPredicate:pred];
}

+ (NSArray *) contactsMatchingName: (NSString *) fname andName: (NSString *) lname
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", fname, fname, fname, fname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	pred = [NSPredicate predicateWithFormat:@"firstname contains[cd] %@ OR lastname contains[cd] %@ OR nickname contains[cd] %@ OR middlename contains[cd] %@", lname, lname, lname, lname];
	contacts = [contacts filteredArrayUsingPredicate:pred];
	return contacts;
}
+ (NSArray *) contactsMatchingPhone: (NSString *) number
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"phonenumbers contains[cd] %@", number];
	return [contacts filteredArrayUsingPredicate:pred];
}
+ (NSArray *) contactsMatchingEmail: (NSString *) email
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"emailaddresses contains[cd] %@", email];
	return [contacts filteredArrayUsingPredicate:pred];
}
+ (BOOL) canUpdateContact: (MyAddressBook*) searchContact
{
	NSPredicate *pred;
	NSArray *contacts = [ABContactsHelper contacts];
	pred = [NSPredicate predicateWithFormat:@"recordID == %d", [searchContact.recordID integerValue]];
    contacts = [contacts filteredArrayUsingPredicate:pred];
    
    if(contacts.count == 0)
        return NO;
    
    ABContact *contact = [contacts lastObject];
    
    NSLog(@"%@ , %@ , %@",contact.firstname,contact.middlename,contact.lastname);

    NSError *error;
    
	return [self addContact:[ABContactsHelper getContactWithUpdateValues:contact withContact:searchContact] withError:&error];
}
+(ABContact*)getContactWithUpdateValues:(ABContact*)ABContact withContact:(MyAddressBook*)aContact
{
    
    [ABContact setImage:[UIImage imageWithContentsOfFile:aContact.image]];
    [ABContactsHelper getABAddressBookRecord:ABContact withContact:aContact];
    
    /**************** SINGLE VALUES *********************/
   /* [ABContact setFirstname:            aContact.firstName];
    [ABContact setMiddlename:           aContact.middleName];
    [ABContact setLastname:             aContact.lastName];
    [ABContact setPrefix:               aContact.prefix];
    [ABContact setSuffix:               aContact.suffix];
    [ABContact setJobtitle:             aContact.jobTitle];
    [ABContact setDepartment:           aContact.department];
    [ABContact setOrganization:         aContact.organisation];
    [ABContact setNote:                 aContact.note];
    [ABContact setBirthday:             aContact.birthDay];
//    ABContact.creationDate Automatically set addresssbook
//    modificationDate Automatically set addresssbook
    [ABContact setFirstnamephonetic:    aContact.firstNamePh];
    [ABContact setMiddlenamephonetic:   aContact.middleNamePh];
    [ABContact setLastnamephonetic:     aContact.lastNamePh];*/
    
    
    /**************** MULTI VALUES PHONES *********************/
    return ABContact;
}
+(ABRecordRef)getABAddressBookRecord:(ABContact*)ABContact withContact:(MyAddressBook*)aContact
{
    ABRecordRef person = ABContact.record;
    
    //Setting image property
//    [self setImage:[UIImage imageWithContentsOfFile:aContact.image] record:person];
    
    // Setting basic properties
    ABRecordSetValue(person, kABPersonFirstNameProperty,                aContact.firstName , nil);
    ABRecordSetValue(person, kABPersonMiddleNameProperty,               aContact.middleName , nil);
    ABRecordSetValue(person, kABPersonLastNameProperty,                 aContact.lastName , nil);
    
    ABRecordSetValue(person, kABPersonPrefixProperty,                   aContact.prefix , nil);
    ABRecordSetValue(person, kABPersonSuffixProperty,                   aContact.suffix , nil);
    
    ABRecordSetValue(person, kABPersonJobTitleProperty,                 aContact.jobTitle , nil);
    ABRecordSetValue(person, kABPersonDepartmentProperty,               aContact.department , nil);
    ABRecordSetValue(person, kABPersonOrganizationProperty,             aContact.organisation , nil);
    
    ABRecordSetValue(person, kABPersonNoteProperty,                     aContact.note , nil);
    
    ABRecordSetValue(person, kABPersonBirthdayProperty,                 aContact.birthDay , nil);
    ABRecordSetValue(person, kABPersonCreationDateProperty,             aContact.creationDate , nil);
    ABRecordSetValue(person, kABPersonModificationDateProperty,         [NSDate date] , nil);
    
    ABRecordSetValue(person, kABPersonFirstNamePhoneticProperty,        aContact.firstNamePh , nil);
    ABRecordSetValue(person, kABPersonMiddleNamePhoneticProperty,       aContact.middleNamePh , nil);
    ABRecordSetValue(person, kABPersonLastNamePhoneticProperty,         aContact.lastNamePh , nil);
    
    // Adding phone numbers
    {
        NSArray *phoneslist = [[aContact relAllPhone] allObjects];
        
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        for (AllPhone *phones in phoneslist)
        {
                ABMultiValueAddValueAndLabel(phoneNumberMultiValue, phones.phoneNumber, (CFStringRef)phones.phoneTitle, NULL);
                ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
            }
        CFRelease(phoneNumberMultiValue);
    }
    
    // Adding url
    {
        NSArray *urlslist = [[aContact relAllUrl] allObjects];
        ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllUrl *aUrl in urlslist)
        {
            ABMultiValueAddValueAndLabel(urlMultiValue, aUrl.urlAddress, (CFStringRef)aUrl.urlTitle, NULL);
            ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
        }
            CFRelease(urlMultiValue);
    }
    
    // Adding emails
    {
        NSArray *emailslist = [[aContact relEmails] allObjects];
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllEmail *emails in emailslist)
        {
            ABMultiValueAddValueAndLabel(emailMultiValue, emails.emailURL, (CFStringRef)emails.emailTitle, NULL);
            ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
        }
        CFRelease(emailMultiValue);
    }
    
    // Adding address
    {
        NSArray *addList = [[aContact relAllAddress] allObjects];
        
        ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        for (AllAddress *address in addList)
        {
            NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
            if(address.zipCode)
                [addressDictionary setObject:address.zipCode        forKey:(NSString *)kABPersonAddressZIPKey];
            if(address.street)
                [addressDictionary setObject:address.street         forKey:(NSString *)kABPersonAddressStreetKey];
            if(address.city)
                [addressDictionary setObject:address.city           forKey:(NSString *)kABPersonAddressCityKey];
//            if(address.addressType)
//                [addressDictionary setObject:address.addressType    forKey:(NSString *)kABPersonAddressProperty];
            if(address.state)
                [addressDictionary setObject:address.state          forKey:(NSString *)kABPersonAddressStateKey];
            if(address.countryCode)
                [addressDictionary setObject:address.countryCode    forKey:(NSString *)kABPersonAddressCountryKey];
            //    [addressDictionary setObject:address.countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
            ABMultiValueAddValueAndLabel(addressMultipleValue, addressDictionary, (CFStringRef)address.addressType, NULL);
            [addressDictionary release];
            
            ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
        }
        CFRelease(addressMultipleValue);
    }
    // Adding social profiles
    {
        
        ABMultiValueRef social = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        //adding social twitter
        ABMultiValueAddValueAndLabel(social, (CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                          (NSString *)kABPersonSocialProfileServiceTwitter, kABPersonSocialProfileServiceKey,
                                                          aContact.twitter, kABPersonSocialProfileUsernameKey,
                                                          nil]), kABPersonSocialProfileServiceTwitter, NULL);
        //adding social facebook
        ABMultiValueAddValueAndLabel(social, (CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                          (NSString *)kABPersonSocialProfileServiceFacebook, kABPersonSocialProfileServiceKey,
                                                          aContact.facebook, kABPersonSocialProfileUsernameKey,
                                                          nil]), kABPersonSocialProfileServiceFacebook, NULL);
        //adding social linkedin
        ABMultiValueAddValueAndLabel(social, (CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                          (NSString *)kABPersonSocialProfileServiceLinkedIn, kABPersonSocialProfileServiceKey,
                                                          aContact.linkedin, kABPersonSocialProfileUsernameKey,
                                                          nil]), kABPersonSocialProfileServiceLinkedIn, NULL);
        
        ABRecordSetValue(person, kABPersonSocialProfileProperty, social, NULL);
        CFRelease(social);
    }
    //Alldates
    {
        NSArray *dateList = [[aContact relAllDates] allObjects];
        ABMutableMultiValueRef datesMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllDate *aDate in dateList)
        {
            ABMultiValueAddValueAndLabel(datesMultiValue, aDate.dates, (CFStringRef)aDate.dateTitle, NULL);
            ABRecordSetValue(person, kABPersonDateProperty, datesMultiValue, nil);
        }
        
        CFRelease(datesMultiValue);
    }
    
    //All related names
    {
        NSArray *relatedList = [[aContact relAllRelatedNames] allObjects];
        ABMutableMultiValueRef relatedMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllRelatedName *arelated in relatedList)
        {
            if(arelated.relatedNames && arelated.nameTitle)
                ABMultiValueAddValueAndLabel(relatedMultiValue, [NSString stringWithString:arelated.relatedNames], (CFStringRef)[NSString stringWithString:arelated.nameTitle], NULL);
            ABRecordSetValue(person, kABPersonRelatedNamesProperty, relatedMultiValue, nil);
        }
        CFRelease(relatedMultiValue);
    }
    return person;
}
+ (NSArray *) groupsMatchingName: (NSString *) fname
{
	NSPredicate *pred;
	NSArray *groups = [ABContactsHelper groups];
	pred = [NSPredicate predicateWithFormat:@"name contains[cd] %@ ", fname];
	return [groups filteredArrayUsingPredicate:pred];
}
@end