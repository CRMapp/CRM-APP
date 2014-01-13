//
//  GlobalGameSettings.m
//  FingerOlympic
//
//  Created by RahulSharma on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalDataPersistence.h"

@implementation GlobalDataPersistence

@synthesize arrMyAddressBookData;
@synthesize dictMyAddressBook;
@synthesize isContactEditted;
static GlobalDataPersistence *sharedGlobalDataPersistence=nil;

+ (GlobalDataPersistence *)sharedGlobalDataPersistence
{
    if(sharedGlobalDataPersistence == nil)
    {
		sharedGlobalDataPersistence = [[super allocWithZone:NULL] init];
	}
	
	return sharedGlobalDataPersistence;
}
@end
