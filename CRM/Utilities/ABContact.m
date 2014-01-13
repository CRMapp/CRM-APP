//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ABContact.h"
#import "ABContactsHelper.h"
#import "Reachability.h"
#import "ImageData.h"
////#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#define CFAutorelease(obj) ({CFTypeRef _obj = (obj); (_obj == NULL) ? NULL : [(id)CFMakeCollectable(_obj) autorelease]; })



@implementation ABContact
@synthesize record;

- (id) initWithRecord: (ABRecordRef) aRecord
{
	if (self = [super init]) record = CFRetain(aRecord);
	return self;
}

+ (id) contactWithRecord: (ABRecordRef) person
{
	return [[[ABContact alloc] initWithRecord:person] autorelease];
}

+ (id) contactWithRecordID: (ABRecordID) recordID
{
	ABAddressBookRef addressBook = ABAddressBookCreate();
    __block BOOL accessGranted = NO;
    if ([[[UIDevice currentDevice]systemVersion] integerValue] >=6)
    {
        
        if (ABAddressBookRequestAccessWithCompletion != NULL)
        { // we're on iOS 6
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            dispatch_release(sema);
        }
    }
    else
    { // we're on iOS 5 or older
        accessGranted = YES;
    }
	ABRecordRef contactrec = ABAddressBookGetPersonWithRecordID(addressBook, recordID);
	ABContact *contact = [self contactWithRecord:contactrec];
	// CFRelease(contactrec);
    CFRelease(addressBook);
	return contact;
}

+ (id) contact
{
	ABRecordRef person = ABPersonCreate();
	id contact = [ABContact contactWithRecord:person];
	CFRelease(person);
	return contact;
}

- (void) dealloc
{
	if (record) CFRelease(record);
	[super dealloc];
}

#pragma mark utilities
+ (NSString *) localizedPropertyName: (ABPropertyID) aProperty
{
	return [(NSString *)ABPersonCopyLocalizedPropertyName(aProperty) autorelease];
}

+ (ABPropertyType) propertyType: (ABPropertyID) aProperty
{
	return ABPersonGetTypeOfProperty(aProperty);
}

+ (NSString *) propertyTypeString: (ABPropertyID) aProperty
{
	switch (ABPersonGetTypeOfProperty(aProperty))
	{
		case kABInvalidPropertyType: return @"Invalid Property";
		case kABStringPropertyType: return @"String";
		case kABIntegerPropertyType: return @"Integer";
		case kABRealPropertyType: return @"Float";
		case kABDateTimePropertyType: return DATE_STRING;
		case kABDictionaryPropertyType: return @"Dictionary";
		case kABMultiStringPropertyType: return @"Multi String";
		case kABMultiIntegerPropertyType: return @"Multi Integer";
		case kABMultiRealPropertyType: return @"Multi Float";
		case kABMultiDateTimePropertyType: return @"Multi Date";
		case kABMultiDictionaryPropertyType: return @"Multi Dictionary";
		default: return @"Invalid Property";
	}
}

+ (NSString *) propertyString: (ABPropertyID) aProperty
{
	/* switch (aProperty) // Sorry, this won't compile
	{
		case kABPersonFirstNameProperty: return FIRST_NAME_STRING;
		case kABPersonMiddleNameProperty: return MIDDLE_NAME_STRING;
		case kABPersonLastNameProperty: return LAST_NAME_STRING;
	 
		case kABPersonPrefixProperty: return PREFIX_STRING;
		case kABPersonSuffixProperty: return SUFFIX_STRING;
		case kABPersonNicknameProperty: return NICKNAME_STRING;
	
		case kABPersonFirstNamePhoneticProperty: return PHONETIC_FIRST_STRING;
		case kABPersonMiddleNamePhoneticProperty: return PHONETIC_MIDDLE_STRING;
		case kABPersonLastNamePhoneticProperty: return PHONETIC_LAST_STRING;
	 
		case kABPersonOrganizationProperty: return ORGANIZATION_STRING;
		case kABPersonJobTitleProperty: return JOBTITLE_STRING;
		case kABPersonDepartmentProperty: return DEPARTMENT_STRING;
	 
		case kABPersonNoteProperty: return NOTE_STRING;

		case kABPersonKindProperty: return KIND_STRING;
 
		case kABPersonBirthdayProperty: return BIRTHDAY_STRING;
		case kABPersonCreationDateProperty: return CREATION_DATE_STRING;
		case kABPersonModificationDateProperty: return MODIFICATION_DATE_STRING;

		case kABPersonEmailProperty: return EMAIL_STRING;
		case kABPersonAddressProperty: return ADDRESS_STRING;
		case kABPersonDateProperty: return DATE_STRING;
		case kABPersonPhoneProperty: return PHONE_STRING;
		case kABPersonInstantMessageProperty: return SMS_STRING;
		case kABPersonURLProperty: return URL_STRING;
		case kABPersonRelatedNamesProperty: return RELATED_STRING;			
	} */
	
	if (aProperty == kABPersonFirstNameProperty) return FIRST_NAME_STRING;
	if (aProperty == kABPersonMiddleNameProperty) return MIDDLE_NAME_STRING;
	if (aProperty == kABPersonLastNameProperty) return LAST_NAME_STRING;

//	if (aProperty == kABPersonPrefixProperty) return PREFIX_STRING;
//	if (aProperty == kABPersonSuffixProperty) return SUFFIX_STRING;
//	if (aProperty == kABPersonNicknameProperty) return NICKNAME_STRING;

//	if (aProperty == kABPersonFirstNamePhoneticProperty) return PHONETIC_FIRST_STRING;
//	if (aProperty == kABPersonMiddleNamePhoneticProperty) return PHONETIC_MIDDLE_STRING;
//	if (aProperty == kABPersonLastNamePhoneticProperty) return PHONETIC_LAST_STRING;

	if (aProperty == kABPersonOrganizationProperty) return ORGANIZATION_STRING;
	if (aProperty == kABPersonJobTitleProperty) return JOBTITLE_STRING;
	if (aProperty == kABPersonDepartmentProperty) return DEPARTMENT_STRING;
	
	if (aProperty == kABPersonNoteProperty) return NOTE_STRING;

	if (aProperty == kABPersonKindProperty) return KIND_STRING;

	if (aProperty == kABPersonBirthdayProperty) return BIRTHDAY_STRING;
	if (aProperty == kABPersonCreationDateProperty) return CREATION_DATE_STRING;
	if (aProperty == kABPersonModificationDateProperty) return MODIFICATION_DATE_STRING;

	if (aProperty == kABPersonEmailProperty) return EMAIL_STRING;
	if (aProperty == kABPersonAddressProperty) return ADDRESS_STRING;
	if (aProperty == kABPersonDateProperty) return DATE_STRING;
	if (aProperty == kABPersonPhoneProperty) return PHONE_STRING;
	if (aProperty == kABPersonInstantMessageProperty) return SMS_STRING;
	if (aProperty == kABPersonURLProperty) return URL_STRING;
	if (aProperty == kABPersonRelatedNamesProperty) return RELATED_STRING;

	return nil;
}

+ (BOOL) propertyIsMultivalue: (ABPropertyID) aProperty;
{
	if (aProperty == kABPersonFirstNameProperty) return NO;
	if (aProperty == kABPersonMiddleNameProperty) return NO;
	if (aProperty == kABPersonLastNameProperty) return NO;

	if (aProperty == kABPersonPrefixProperty) return NO;
	if (aProperty == kABPersonSuffixProperty) return NO;
	if (aProperty == kABPersonNicknameProperty) return NO;

	if (aProperty == kABPersonFirstNamePhoneticProperty) return NO;
	if (aProperty == kABPersonMiddleNamePhoneticProperty) return NO;
	if (aProperty == kABPersonLastNamePhoneticProperty) return NO;

	if (aProperty == kABPersonOrganizationProperty) return NO;
	if (aProperty == kABPersonJobTitleProperty) return NO;
	if (aProperty == kABPersonDepartmentProperty) return NO;

	if (aProperty == kABPersonNoteProperty) return NO;
	
	if (aProperty == kABPersonKindProperty) return NO;

	if (aProperty == kABPersonBirthdayProperty) return NO;
	if (aProperty == kABPersonCreationDateProperty) return NO;
	if (aProperty == kABPersonModificationDateProperty) return NO;
	
	return YES;
	/*
	if (aProperty == kABPersonEmailProperty) return YES;
	if (aProperty == kABPersonAddressProperty) return YES;
	if (aProperty == kABPersonDateProperty) return YES;
	if (aProperty == kABPersonPhoneProperty) return YES;
	if (aProperty == kABPersonInstantMessageProperty) return YES;
	if (aProperty == kABPersonURLProperty) return YES;
	if (aProperty == kABPersonRelatedNamesProperty) return YES;
	 */
}

+ (NSArray *) arrayForProperty: (ABPropertyID) anID inRecord: (ABRecordRef) record
{
	// Recover the property for a given record
	CFTypeRef theProperty = ABRecordCopyValue(record, anID);
	NSArray *items = (NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty);
	CFRelease(theProperty);
	return [items autorelease];
}

+ (id) objectForProperty: (ABPropertyID) anID inRecord: (ABRecordRef) record
{
	return [(id) ABRecordCopyValue(record, anID) autorelease];
}

+ (NSDictionary *) dictionaryWithValue: (id) value andLabel: (CFStringRef) label
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	if (value) [dict setObject:value forKey:@"value"];
	if (label) [dict setObject:(NSString *)label forKey:@"label"];
	return dict;
}

+ (NSDictionary *) addressWithStreet: (NSString *) street withCity: (NSString *) city
						   withState:(NSString *) state withZip: (NSString *) zip
						 withCountry: (NSString *) country withCode: (NSString *) code
{
	NSMutableDictionary *md = [NSMutableDictionary dictionary];
	if (street) [md setObject:street forKey:(NSString *) kABPersonAddressStreetKey];
	if (city) [md setObject:city forKey:(NSString *) kABPersonAddressCityKey];
	if (state) [md setObject:state forKey:(NSString *) kABPersonAddressStateKey];
	if (zip) [md setObject:zip forKey:(NSString *) kABPersonAddressZIPKey];
	if (country) [md setObject:country forKey:(NSString *) kABPersonAddressCountryKey];
	if (code) [md setObject:code forKey:(NSString *) kABPersonAddressCountryCodeKey];
	return md;
}

+ (NSDictionary *) smsWithService: (CFStringRef) service andUser: (NSString *) userName
{
	NSMutableDictionary *sms = [NSMutableDictionary dictionary];
	if (service) [sms setObject:(NSString *) service forKey:(NSString *) kABPersonInstantMessageServiceKey];
	if (userName) [sms setObject:userName forKey:(NSString *) kABPersonInstantMessageUsernameKey];
	return sms;
}

- (BOOL) removeSelfFromAddressBook: (NSError **) error
{
	ABAddressBookRef addressBook = CFAutorelease(ABAddressBookCreate());
    
	if (!ABAddressBookRemoveRecord(addressBook, self.record, (CFErrorRef *) error)) return NO;
	return ABAddressBookSave(addressBook,  (CFErrorRef *) error);
}

#pragma mark Record ID and Type
- (ABRecordID) recordID {return ABRecordGetRecordID(record);}
- (ABRecordType) recordType {return ABRecordGetRecordType(record);}
- (BOOL) isPerson {return self.recordType == kABPersonType;}

#pragma mark Getting Single Value Strings
- (NSString *) getRecordString:(ABPropertyID) anID
{
	return [(NSString *) ABRecordCopyValue(record, anID) autorelease];
}
- (NSString *) firstname {return [self getRecordString:kABPersonFirstNameProperty];}
- (NSString *) middlename {return [self getRecordString:kABPersonMiddleNameProperty];}
- (NSString *) lastname {return [self getRecordString:kABPersonLastNameProperty];}

- (NSString *) prefix {return [self getRecordString:kABPersonPrefixProperty];}
- (NSString *) suffix {return [self getRecordString:kABPersonSuffixProperty];}
- (NSString *) nickname {return [self getRecordString:kABPersonNicknameProperty];}

- (NSString *) firstnamephonetic {return [self getRecordString:kABPersonFirstNamePhoneticProperty];}
- (NSString *) middlenamephonetic {return [self getRecordString:kABPersonMiddleNamePhoneticProperty];}
- (NSString *) lastnamephonetic {return [self getRecordString:kABPersonLastNamePhoneticProperty];}

- (NSString *) organization {return [self getRecordString:kABPersonOrganizationProperty];}
- (NSString *) jobtitle {return [self getRecordString:kABPersonJobTitleProperty];}
- (NSString *) department {return [self getRecordString:kABPersonDepartmentProperty];}
- (NSString *) note {return [self getRecordString:kABPersonNoteProperty];}

#pragma mark Contact Name Utility
- (NSString *) contactName
{
	NSMutableString *string = [NSMutableString string];
	
	if (self.firstname || self.lastname)
	{
		if (self.prefix) [string appendFormat:@"%@ ", self.prefix];
		if (self.firstname) [string appendFormat:@"%@ ", self.firstname];
		if (self.nickname) [string appendFormat:@"\"%@\" ", self.nickname];
		if (self.lastname) [string appendFormat:@"%@", self.lastname];
		
		if (self.suffix && string.length)
			[string appendFormat:@", %@ ", self.suffix];
		else
			[string appendFormat:@" "];
	}
	
	if (self.organization) [string appendString:self.organization];
	return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) compositeName
{
	NSString *string = (NSString *)ABRecordCopyCompositeName(record);
	return [string autorelease];
}

#pragma mark NUMBER
- (NSNumber *) getRecordNumber: (ABPropertyID) anID
{
	return [(NSNumber *) ABRecordCopyValue(record, anID) autorelease];
}

- (NSNumber *) kind {return [self getRecordNumber:kABPersonKindProperty];}

#pragma mark Dates
- (NSDate *) getRecordDate:(ABPropertyID) anID
{
	return [(NSDate *) ABRecordCopyValue(record, anID) autorelease];
}

- (NSDate *) birthday {return [self getRecordDate:kABPersonBirthdayProperty];}
- (NSDate *) creationDate {return [self getRecordDate:kABPersonCreationDateProperty];}
- (NSDate *) modificationDate {return [self getRecordDate:kABPersonModificationDateProperty];}

#pragma mark Getting MultiValue Elements
- (NSArray *) arrayForProperty: (ABPropertyID) anID
{

	CFTypeRef theProperty = ABRecordCopyValue(record, anID);
	NSArray *items = (NSArray *)ABMultiValueCopyArrayOfAllValues(theProperty);
	CFRelease(theProperty);
	return [items autorelease];
}
-(NSString*)getLableName:(NSString*)aString
{
    NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"_$!<>"];
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [aString componentsSeparatedByCharactersInSet:chs];
    
    // Create string from the array components
    aString = [arrayOfComponents componentsJoinedByString:@""];
    
    NSLog(@"New string: %@", aString);
    return aString;
}
- (NSArray *) labelsForProperty: (ABPropertyID) anID
{
	ABMultiValueRef multiRef = ABRecordCopyValue(record, anID);
    CFAutorelease(multiRef);
	NSMutableArray *labels = [NSMutableArray array];
    if(ABMultiValueGetPropertyType(multiRef) == kABDictionaryPropertyType){
        CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(multiRef, 0);
        if(dict == nil)
            return nil;
        NSInteger size = CFDictionaryGetCount(dict);
        CFTypeRef *keysTypeRef = (CFTypeRef *) malloc( size * sizeof(CFTypeRef) );
        CFDictionaryGetKeysAndValues(dict, (const void **) keysTypeRef, NULL);
        const void **keys = (const void **) keysTypeRef;
        for (int i = 0; i < size; i++){
            NSString *label = keys[i];
            //		[labels addObject:[self getLableName:label]];  //This line is used remove special charactes
            if(label)
                [labels addObject:label];
        }
        free(keys);
        return labels;
    }else{
        NSInteger count = ABMultiValueGetCount(multiRef);
        for (int i = 0; i < count; i++){
            NSString *label = (NSString *)ABMultiValueCopyLabelAtIndex(multiRef, i);
            //		[labels addObject:[self getLableName:label]];  //This line is used remove special charactes
            if(label)
                [labels addObject:label];
            [label release];
        }
        return labels;
    }
	
}

- (NSArray *) emailArray {return [self arrayForProperty:kABPersonEmailProperty];}
- (NSArray *) emailLabels {return [self labelsForProperty:kABPersonEmailProperty];}
- (NSArray *) phoneArray {return [self arrayForProperty:kABPersonPhoneProperty];}
- (NSArray *) phoneLabels {return [self labelsForProperty:kABPersonPhoneProperty];}
- (NSArray *) relatedNameArray {return [self arrayForProperty:kABPersonRelatedNamesProperty];}
- (NSArray *) relatedNameLabels {return [self labelsForProperty:kABPersonRelatedNamesProperty];}
- (NSArray *) urlArray {return [self arrayForProperty:kABPersonURLProperty];}
- (NSArray *) urlLabels {return [self labelsForProperty:kABPersonURLProperty];}
- (NSArray *) dateArray {return [self arrayForProperty:kABPersonDateProperty];}
- (NSArray *) dateLabels {return [self labelsForProperty:kABPersonDateProperty];}
- (NSArray *) addressArray {return [self arrayForProperty:kABPersonAddressProperty];}
- (NSArray *) addressLabels {return [self labelsForProperty:kABPersonAddressProperty];}
- (NSArray *) smsArray {return [self arrayForProperty:kABPersonInstantMessageProperty];}
- (NSArray *) smsLabels {return [self labelsForProperty:kABPersonInstantMessageProperty];}

- (NSString *) phonenumbers {return [self.phoneArray componentsJoinedByString:@" "];}
- (NSString *) emailaddresses {return [self.emailArray componentsJoinedByString:@" "];}
- (NSString *) urls {return [self.urlArray componentsJoinedByString:@" "];}

- (NSArray *) dictionaryArrayForProperty: (ABPropertyID) aProperty
{
	NSArray *valueArray = [self arrayForProperty:aProperty];
	NSArray *labelArray = [self labelsForProperty:aProperty];
	
	int num = MIN(valueArray.count, labelArray.count);
	NSMutableArray *items = [NSMutableArray array];
	for (int i = 0; i < num; i++)
	{
		NSMutableDictionary *md = [NSMutableDictionary dictionary];
		if([valueArray objectAtIndex:i])
        {
            
            
            // Below code is used to get lat long of a address
            if(aProperty == 5) //for addresses
            {
             
                 ABMultiValueRef addresses = ABRecordCopyValue(record, kABPersonAddressProperty);
                 CFStringRef typeTmp = ABMultiValueCopyLabelAtIndex(addresses, i);
                 CFStringRef labeltype = ABAddressBookCopyLocalizedLabel(typeTmp);
    
                [md addEntriesFromDictionary:[valueArray objectAtIndex:i]];
                [md setObject:(NSString*) labeltype forKey:ADDRESS_TYPE_STRING];
                [md setObject:[NSNumber numberWithFloat:0.0] forKey:LATITUDE_STRING];
                [md setObject:[NSNumber numberWithFloat:0.0] forKey:LONGITUDE_STRING];
 
            }
            else if(aProperty == 3) //for phones (TO DO : Shifted in below with other statements of Email, dates, and all)
            {
                
                [md setObject:[valueArray objectAtIndex:i] forKey:[self getLableName:[labelArray objectAtIndex:i]]];
                
                
            }
            else if(aProperty == 22) //for urls
            {
                [md setObject:[valueArray objectAtIndex:i] forKey:[self getLableName:[labelArray objectAtIndex:i]]];
            }
            else if(aProperty == 4 || aProperty == 12 || aProperty == 23) //for emails , dates , related names
            {
                [md setObject:[valueArray objectAtIndex:i] forKey:[self getLableName:[labelArray objectAtIndex:i]]];
            }
            else //for others
            {
                [md setObject:[valueArray objectAtIndex:i] forKey:@"value"];
            }
            
        }
//		if([valueArray objectAtIndex:i])[md setObject:[labelArray objectAtIndex:i] forKey:@"label"];
        if([[md allKeys] count])
		[items addObject:md];
	}
	return items;
}

- (NSArray *) emailDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonEmailProperty];
}

- (NSArray *) phoneDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonPhoneProperty];
}

- (NSArray *) relatedNameDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonRelatedNamesProperty];
}

- (NSArray *) urlDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonURLProperty];
}

- (NSArray *) dateDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonDateProperty];
}

- (NSArray *) addressDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonAddressProperty];
}

- (NSArray *) smsDictionaries
{
	return [self dictionaryArrayForProperty:kABPersonInstantMessageProperty];
}

#pragma mark Setting Strings
- (BOOL) setString: (NSString *) aString forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFStringRef) aString, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (void) setFirstname: (NSString *) aString {[self setString: aString forProperty: kABPersonFirstNameProperty];}
- (void) setMiddlename: (NSString *) aString {[self setString: aString forProperty: kABPersonMiddleNameProperty];}
- (void) setLastname: (NSString *) aString {[self setString: aString forProperty: kABPersonLastNameProperty];}

- (void) setPrefix: (NSString *) aString {[self setString: aString forProperty: kABPersonPrefixProperty];}
- (void) setSuffix: (NSString *) aString {[self setString: aString forProperty: kABPersonSuffixProperty];}
- (void) setNickname: (NSString *) aString {[self setString: aString forProperty: kABPersonNicknameProperty];}

- (void) setFirstnamephonetic: (NSString *) aString {[self setString: aString forProperty: kABPersonFirstNamePhoneticProperty];}
- (void) setMiddlenamephonetic: (NSString *) aString {[self setString: aString forProperty: kABPersonMiddleNamePhoneticProperty];}
- (void) setLastnamephonetic: (NSString *) aString {[self setString: aString forProperty: kABPersonLastNamePhoneticProperty];}

- (void) setOrganization: (NSString *) aString {[self setString: aString forProperty: kABPersonOrganizationProperty];}
- (void) setJobtitle: (NSString *) aString {[self setString: aString forProperty: kABPersonJobTitleProperty];}
- (void) setDepartment: (NSString *) aString {[self setString: aString forProperty: kABPersonDepartmentProperty];}

- (void) setNote: (NSString *) aString {[self setString: aString forProperty: kABPersonNoteProperty];}

#pragma mark Setting Numbers
- (BOOL) setNumber: (NSNumber *) aNumber forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFNumberRef) aNumber, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

// const CFNumberRef kABPersonKindPerson;
// const CFNumberRef kABPersonKindOrganization;
- (void) setKind: (NSNumber *) aKind {[self setNumber:aKind forProperty: kABPersonKindProperty];}

#pragma mark Setting Dates

- (BOOL) setDate: (NSDate *) aDate forProperty:(ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, (CFDateRef) aDate, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (void) setBirthday: (NSDate *) aDate {[self setDate: aDate forProperty: kABPersonBirthdayProperty];}

#pragma mark Setting MultiValue

- (BOOL) setMulti: (ABMutableMultiValueRef) multi forProperty: (ABPropertyID) anID
{
	CFErrorRef error;
	BOOL success = ABRecordSetValue(record, anID, multi, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	return success;
}

- (ABMutableMultiValueRef) createMultiValueFromArray: (NSArray *) anArray withType: (ABPropertyType) aType
{
	ABMutableMultiValueRef multi = ABMultiValueCreateMutable(aType);
	for (NSDictionary *dict in anArray)
		ABMultiValueAddValueAndLabel(multi, (CFTypeRef) [dict objectForKey:@"value"], (CFTypeRef) [dict objectForKey:@"label"], NULL);
	
	return CFAutorelease(multi);
}

- (void) setEmailDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonEmailProperty];
	// CFRelease(multi);
}

- (void) setPhoneDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonPhoneMobileLabel, kABPersonPhoneIPhoneLabel, kABPersonPhoneMainLabel
	// kABPersonPhoneHomeFAXLabel, kABPersonPhoneWorkFAXLabel, kABPersonPhonePagerLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonPhoneProperty];
	// CFRelease(multi);
}

- (void) setUrlDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonHomePageLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonURLProperty];
	// CFRelease(multi);
}

// Not used/shown on iPhone
- (void) setRelatedNameDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonMotherLabel, kABPersonFatherLabel, kABPersonParentLabel, 
	// kABPersonSisterLabel, kABPersonBrotherLabel, kABPersonChildLabel, 
	// kABPersonFriendLabel, kABPersonSpouseLabel, kABPersonPartnerLabel, 
	// kABPersonManagerLabel, kABPersonAssistantLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiStringPropertyType];
	[self setMulti:multi forProperty:kABPersonRelatedNamesProperty];
	// CFRelease(multi);
}

- (void) setDateDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel
	// kABPersonAnniversaryLabel
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDateTimePropertyType];
	[self setMulti:multi forProperty:kABPersonDateProperty];
	// CFRelease(multi);
}

- (void) setAddressDictionaries: (NSArray *) dictionaries
{
	// kABPersonAddressStreetKey, kABPersonAddressCityKey, kABPersonAddressStateKey
	// kABPersonAddressZIPKey, kABPersonAddressCountryKey, kABPersonAddressCountryCodeKey
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDictionaryPropertyType];
	[self setMulti:multi forProperty:kABPersonAddressProperty];
	// CFRelease(multi);
}

- (void) setSmsDictionaries: (NSArray *) dictionaries
{
	// kABWorkLabel, kABHomeLabel, kABOtherLabel, 
	// kABPersonInstantMessageServiceKey, kABPersonInstantMessageUsernameKey
	// kABPersonInstantMessageServiceYahoo, kABPersonInstantMessageServiceJabber
	// kABPersonInstantMessageServiceMSN, kABPersonInstantMessageServiceICQ
	// kABPersonInstantMessageServiceAIM, 
	ABMutableMultiValueRef multi = [self createMultiValueFromArray:dictionaries withType:kABMultiDictionaryPropertyType];
	[self setMulti:multi forProperty:kABPersonInstantMessageProperty];
	// CFRelease(multi);
}

#pragma mark Images
- (UIImage *) image
{
	if (!ABPersonHasImageData(record)) return nil;
	CFDataRef imageData = ABPersonCopyImageDataWithFormat((record), kABPersonImageFormatThumbnail);
	UIImage *image = [UIImage imageWithData:(NSData *) imageData];
	CFRelease(imageData);
	return image;
}

- (void) setImage: (UIImage *) image
{
	CFErrorRef error;
	BOOL success;
	
	if (image == nil) // remove
	{
		if (!ABPersonHasImageData(record)) return; // no image to remove
		success = ABPersonRemoveImageData(record, &error);
		if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
		return;
	}
	
	NSData *data = UIImagePNGRepresentation(image);
	success = ABPersonSetImageData(record, (CFDataRef) data, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
}
#pragma mark - Social Links
- (NSDictionary*)getSocialLinksOfPerson
{
    NSDictionary *socialUNames = [self getUsernameFromRecord:record];
    if (socialUNames) {
        NSLog(@"%@", socialUNames);
    }
    return socialUNames;
}
- (NSDictionary*)getUsernameFromRecord:(ABRecordRef)ABrecord
{
   
    
    ABMultiValueRef socials = ABRecordCopyValue(ABrecord, kABPersonSocialProfileProperty);
    
    if (!socials) {
        return nil;
    }
    
    CFIndex socialsCount = ABMultiValueGetCount(socials);
    
    NSMutableDictionary *socialsDict = [NSMutableDictionary dictionary];
    
    for (int k=0 ; k<socialsCount ; k++)
    {
         NSString * socialUsername = nil;
        CFDictionaryRef socialValue = ABMultiValueCopyValueAtIndex(socials, k);
        if(CFStringCompare( CFDictionaryGetValue(socialValue, kABPersonSocialProfileServiceKey), kABPersonSocialProfileServiceTwitter, 0)==kCFCompareEqualTo)
        {
            socialUsername = (NSString*) CFDictionaryGetValue(socialValue, kABPersonSocialProfileUsernameKey);
            
            if(socialUsername)
            [socialsDict setObject:socialUsername forKey:SOCIAL_TWITTER];
            
        }
        else if(CFStringCompare( CFDictionaryGetValue(socialValue, kABPersonSocialProfileServiceKey), kABPersonSocialProfileServiceFacebook, 0)==kCFCompareEqualTo)
        {
            socialUsername = (NSString*) CFDictionaryGetValue(socialValue, kABPersonSocialProfileUsernameKey);
            
            if(socialUsername)
            [socialsDict setObject:socialUsername forKey:SOCIAL_FACEBOOK];
            
        }
        else if(CFStringCompare( CFDictionaryGetValue(socialValue, kABPersonSocialProfileServiceKey), kABPersonSocialProfileServiceLinkedIn, 0)==kCFCompareEqualTo)
        {
            socialUsername = (NSString*) CFDictionaryGetValue(socialValue, kABPersonSocialProfileUsernameKey);
            
            if(socialUsername)
            [socialsDict setObject:socialUsername forKey:SOCIAL_LINKEDIN];
            
        }
       /* else if(CFStringCompare( CFDictionaryGetValue(socialValue, kABPersonSocialProfileServiceKey), kABPersonSocialProfileServiceLinkedIn, 0)==kCFCompareEqualTo)
        {
            socialUsername = (NSString*) CFDictionaryGetValue(socialValue, kABPersonSocialProfileUsernameKey);
            [socialsDict setObject:socialUsername forKey:@"flickr"];
            
        }
        else if(CFStringCompare( CFDictionaryGetValue(socialValue, kABPersonSocialProfileServiceKey), kABPersonSocialProfileServiceLinkedIn, 0)==kCFCompareEqualTo)
        {
            socialUsername = (NSString*) CFDictionaryGetValue(socialValue, kABPersonSocialProfileUsernameKey);
            [socialsDict setObject:socialUsername forKey:@"myspace"];
            
        }*/
        CFRelease(socialValue);
    }
    CFRelease(socials);
    
    return [NSDictionary dictionaryWithDictionary:socialsDict];
}
#pragma mark Representations

// No Image
- (NSDictionary *) baseDictionaryRepresentation
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSString stringWithFormat:@"%d",[self recordID]] forKey:RECORD_ID_STRING];
	if (self.firstname) [dict setObject:self.firstname forKey:FIRST_NAME_STRING];
    
    if ([self.firstname isEqualToString:@"Albert-John"])
    {
        NSLog(@"%@",self.firstname);
    }
    
    
	if (self.middlename) [dict setObject:self.middlename forKey:MIDDLE_NAME_STRING];
	if (self.lastname) [dict setObject:self.lastname forKey:LAST_NAME_STRING];

	if (self.prefix)
        [dict setObject:self.prefix forKey:PREFIX_STRING];
	if (self.suffix)
        [dict setObject:self.suffix forKey:SUFFIX_STRING];
	if (self.nickname) [dict setObject:self.nickname forKey:NICKNAME_STRING];
	
	if (self.firstnamephonetic) [dict setObject:self.firstnamephonetic forKey:PHONETIC_FIRST_STRING];
	if (self.middlenamephonetic) [dict setObject:self.middlenamephonetic forKey:PHONETIC_MIDDLE_STRING];
	if (self.lastnamephonetic) [dict setObject:self.lastnamephonetic forKey:PHONETIC_LAST_STRING];
	
	if (self.organization) [dict setObject:self.organization forKey:ORGANIZATION_STRING];
	if (self.jobtitle) [dict setObject:self.jobtitle forKey:JOBTITLE_STRING];
	if (self.department) [dict setObject:self.department forKey:DEPARTMENT_STRING];
	
	if (self.note) [dict setObject:self.note forKey:NOTE_STRING];

	if (self.kind) [dict setObject:self.kind forKey:KIND_STRING];

	if (self.birthday) [dict setObject:self.birthday forKey:BIRTHDAY_STRING];
	if (self.creationDate) [dict setObject:self.creationDate forKey:CREATION_DATE_STRING];
	if (self.modificationDate) [dict setObject:self.modificationDate forKey:MODIFICATION_DATE_STRING];

    
	[dict setObject:self.emailDictionaries forKey:EMAIL_STRING];
	[dict setObject:self.addressDictionaries forKey:ADDRESS_STRING];
	[dict setObject:self.dateDictionaries forKey:DATE_STRING];
	[dict setObject:self.phoneDictionaries forKey:PHONE_STRING];
	[dict setObject:self.smsDictionaries forKey:SMS_STRING];
	[dict setObject:self.urlDictionaries forKey:URL_STRING];
	[dict setObject:self.relatedNameDictionaries forKey:RELATED_STRING];
	
	return dict;
}

// With image where available and record unique identifier
- (NSDictionary *) dictionaryRepresentation
{
	NSMutableDictionary *dict = [[[self baseDictionaryRepresentation] mutableCopy] autorelease];
    
    [dict addEntriesFromDictionary:[self getSocialLinksOfPerson]];
    
    
    //this code is used to get image of a contact
	 if (ABPersonHasImageData(record))
	 {
		CFDataRef imageData = ABPersonCopyImageDataWithFormat((record), kABPersonImageFormatThumbnail);
         
		
         
         NSString *UDID = [self stringWithNewUUID];
         //Save Image to Document Directory With This name <UUID>.png
         
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
         NSString *documentsDirectory = [paths objectAtIndex:0];
         NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",UDID]];
         NSLog(@"%@",savedImagePath);
         //Save nsdata and url of image in database
		 
		 //ImageData Narendra
//		 ImageData * data = [NSEntityDescription insertNewObjectForEntityForName:@"ImageData" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
//		 
//		 [data setImage_Data:(NSData*)imageData];
//		 [data setImage_Path:savedImagePath];
		 
		 if (![((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil])
		 {
			 NSLog(@"Data not saved in data base");
		 }
		 //----

         BOOL success =  [self saveImageDataToDocDir:(NSData*)imageData atPath:savedImagePath];
         if (success)
         {
             [dict setObject:savedImagePath forKey:IMAGE_STRING];
         }
		CFRelease(imageData);
	 }
	return dict;
}
- (NSString*)stringWithNewUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [newUUID autorelease];
}
- (BOOL)saveImageDataToDocDir:(NSData*)imgData atPath:(NSString*)path
{    
    BOOL success =   [imgData writeToFile:path atomically:NO];
    
    return success;
}
// No Image
- (NSData *) baseDataRepresentation
{
	NSString *errorString;
	NSDictionary *dict = [self baseDictionaryRepresentation];
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	if (!data) CFShow(errorString);
	return data; 
}


// With image where available
- (NSData *) dataRepresentation
{
	NSString *errorString;
	NSDictionary *dict = [self dictionaryRepresentation];
    if ([[dict objectForKey:FIRST_NAME_STRING] isEqualToString:@"Albert-John"])
    {
        NSLog(@"%@",self.firstname);
    }
	NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
	if (!data) CFShow(errorString);
	return data;
}

+ (id) contactWithDictionary: (NSDictionary *) dict
{
	ABContact *contact = [ABContact contact];
	if ([dict objectForKey:FIRST_NAME_STRING]) contact.firstname = [dict objectForKey:FIRST_NAME_STRING];
	if ([dict objectForKey:MIDDLE_NAME_STRING]) contact.middlename = [dict objectForKey:MIDDLE_NAME_STRING];
	if ([dict objectForKey:LAST_NAME_STRING]) contact.lastname = [dict objectForKey:LAST_NAME_STRING];
	
//	if ([dict objectForKey:PREFIX_STRING]) contact.prefix = [dict objectForKey:PREFIX_STRING];
//	if ([dict objectForKey:SUFFIX_STRING]) contact.suffix = [dict objectForKey:SUFFIX_STRING];
//	if ([dict objectForKey:NICKNAME_STRING]) contact.nickname = [dict objectForKey:NICKNAME_STRING];
	
//	if ([dict objectForKey:PHONETIC_FIRST_STRING]) contact.firstnamephonetic = [dict objectForKey:PHONETIC_FIRST_STRING];
//	if ([dict objectForKey:PHONETIC_MIDDLE_STRING]) contact.middlenamephonetic = [dict objectForKey:PHONETIC_MIDDLE_STRING];
//	if ([dict objectForKey:PHONETIC_LAST_STRING]) contact.lastnamephonetic = [dict objectForKey:PHONETIC_LAST_STRING];
	
	if ([dict objectForKey:ORGANIZATION_STRING]) contact.organization = [dict objectForKey:ORGANIZATION_STRING];
	if ([dict objectForKey:JOBTITLE_STRING]) contact.jobtitle = [dict objectForKey:JOBTITLE_STRING];
	if ([dict objectForKey:DEPARTMENT_STRING]) contact.department = [dict objectForKey:DEPARTMENT_STRING];
	
	if ([dict objectForKey:NOTE_STRING]) contact.note = [dict objectForKey:NOTE_STRING];
	
	if ([dict objectForKey:KIND_STRING]) contact.kind = [dict objectForKey:KIND_STRING];

	if ([dict objectForKey:EMAIL_STRING])   contact.emailDictionaries       = [dict objectForKey:EMAIL_STRING];
	if ([dict objectForKey:ADDRESS_STRING]) contact.addressDictionaries     = [dict objectForKey:ADDRESS_STRING];
	if ([dict objectForKey:DATE_STRING])    contact.dateDictionaries        = [dict objectForKey:DATE_STRING];
	if ([dict objectForKey:PHONE_STRING])   contact.phoneDictionaries       = [dict objectForKey:PHONE_STRING];
	if ([dict objectForKey:SMS_STRING])     contact.smsDictionaries         = [dict objectForKey:SMS_STRING];
	if ([dict objectForKey:URL_STRING])     contact.urlDictionaries         = [dict objectForKey:URL_STRING];
	if ([dict objectForKey:RELATED_STRING]) contact.relatedNameDictionaries = [dict objectForKey:RELATED_STRING];

	if ([dict objectForKey:IMAGE_STRING]) 
	{
		CFErrorRef error;
 		BOOL success = ABPersonSetImageData(contact.record, (CFDataRef) [dict objectForKey:IMAGE_STRING], &error);
		if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
	}

	return contact;
}

+ (id) contactWithData: (NSData *) data
{
	// Otherwise handle points
	CFStringRef errorString;
	CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListMutableContainers, &errorString);
	if (!plist) 
	{
		CFShow(errorString);
		return nil;
	}
	
	NSDictionary *dict = (NSDictionary *) plist;
	[dict autorelease];
	
	return [self contactWithDictionary:dict];
}
@end