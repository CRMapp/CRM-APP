//
//  AddEditContactHelper.m
//  CRM
//
//  Created by Narendra Verma on 12/06/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "AddEditContactHelper.h"

#import "AddNewContectDetailCell.h"
//Classes

#import "AllPhone.h"
#import "AllEmail.h"
#import "AllAddress.h"
#import "AllUrl.h"

#import "MyAddressBook.h"

#import "AddNewContectDetailCell.h"
@implementation AddEditContactHelper

/*
 Method : setPhoneNumber:
 @prams addObj object from which we require to get data
 
 return a dict with phone numbers
 */
+(NSDictionary *)setPhoneNumbers:(MyAddressBook*)addObj
{
	NSMutableDictionary * dictEdit = [NSMutableDictionary dictionaryWithCapacity:0];
	
	for (AllPhone * aPhone in [[addObj relAllPhone] allObjects])
	{
		[dictEdit setValue:aPhone.phoneNumber forKey:aPhone.phoneTitle];
	}
	
	return dictEdit;
}

+(NSDictionary *)setURLInDict:(MyAddressBook *)addObj
{
	NSMutableDictionary * dictEdit = [NSMutableDictionary dictionaryWithCapacity:0];
	
	for (AllUrl * aURL in [[addObj relAllUrl] allObjects])
	{
		[dictEdit setValue:aURL.urlAddress forKey:aURL.urlTitle];
	}
	
	return dictEdit;
}

/*
 Method : setEmailsInDict:
 @prams addObj object from which we require to get data
 
 return a dict with work Email, if we don't have work email then any of the email exist
 */

+(NSDictionary *)setEmailsInDict:(MyAddressBook*)addObj
{
	NSMutableDictionary * dictEdit = [NSMutableDictionary dictionaryWithCapacity:0];
	
	for (AllEmail * emails in [[addObj relEmails] allObjects])
	{
		[dictEdit setValue:emails.emailURL forKey:emails.emailTitle];
	}
	
	return dictEdit;
    
}

+(AllAddress*)getWorkAddress:(MyAddressBook *)addObj
{
	//our main focus is on the work address only
	for (AllAddress * allAdd in [[addObj relAllAddress] allObjects])
	{
		if ([allAdd.addressType rangeOfString:@"work" options:NSCaseInsensitiveSearch].length)
		{
			return allAdd;
			
		}
	}
	
	//if we haven't got any work address then any address
	for (AllAddress * allAdd in [[addObj relAllAddress] allObjects])
	{
		return allAdd;
	}
	
	return nil;
}

+(AllEmail *)getWorkEmail:(MyAddressBook *)addressBook
{
	for (AllEmail * emails in [[addressBook relEmails] allObjects])
	{
		if ([[emails.emailTitle lowercaseString] isEqualToString:@"work"])
		{
			return emails;
		}
	}
	
	//else we send the zeroth object
	return [[addressBook.relEmails allObjects] objectAtIndex:0];
}

/*now the requirement for the editing mode
 
 first we need to check for the key in the phone array
 if that object exist
 
 that means we need to edit it 
 
 else
 
 we need to create a new phone object
 */


//[phone setPhone:[global.dictMyAddressBook valueForKey:k_TextFiled_PhoneNum]];				//Phone number
//			[phone setMobile:[global.dictMyAddressBook valueForKey:k_TextFiled_MobileNum]];				//Mobile number
//			[phone setHome:[global.dictMyAddressBook valueForKey:k_TextFiled_HomeNum]];					//Home number
//			[phone setWorkFax:[global.dictMyAddressBook valueForKey:k_TextFiled_FaxNum]];

+(void)editPhoneNumber:(MyAddressBook*)address andMainDict:(NSDictionary *)dict andManageObjContext:(NSManagedObjectContext * )manageObj
{
    NSArray * arrAllPhone = [address.relAllPhone allObjects];
    BOOL isPhoneFound;
    for(AllPhone *phone in arrAllPhone)
    {
        isPhoneFound = NO;
        if([phone.phoneNumber length])
            {
                phone.phoneNumber = [dict valueForKey:phone.phoneTitle];
                isPhoneFound = YES;
                break;
            }
        if(!isPhoneFound)
            {
                AllPhone * newPhone = [NSEntityDescription insertNewObjectForEntityForName:@"AllPhone" inManagedObjectContext:manageObj];
                newPhone.phoneNumber = [dict valueForKey:phone.phoneTitle];
                [newPhone setRelMyAddressBook:address];
            }
    }
}
@end
