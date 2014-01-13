//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

//#import "CoreDataHelper.h"
//#import "AppDelegate.h"
@implementation CoreDataHelper

#pragma mark -
#pragma mark Retrieve objects

// Fetch objects with a predicate
+(NSMutableArray *)searchObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate *)predicate andSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// If a sort key was passed then use it in the request
	if (sortKey != nil)
    {
        NSSortDescriptor *sortDescriptor = nil;
        if ([entityName isEqualToString:@"MyAddressBook"])
        {
            sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:sortKey
                                                ascending:sortAscending
                                                selector:@selector(localizedCaseInsensitiveCompare:)];
        }
        else
        {
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
        }
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
	}
    
	// Execute the fetch request
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy] autorelease];
	[request release];
    
	// If the returned array was nil then there was an error
	if (mutableFetchResults == nil)
		NSLog(@"Couldn't get objects for entity %@", entityName);
    
	// Return the results
	return mutableFetchResults;
}

// Fetch objects without a predicate
+(NSMutableArray *)getObjectsForEntity:(NSString*)entityName withSortKey:(NSString*)sortKey andSortAscending:(BOOL)sortAscending andContext:(NSManagedObjectContext *)managedObjectContext
{
    if ([entityName isEqualToString:@"MyAddressBook"] && sortKey == nil)
    {
        sortKey = @"firstName";
        sortAscending = YES;
    }
    if ([[NSArray arrayWithObjects:@"NotesList",@"EmailList",@"FollowUpdate",@"AppointmentList",@"ProposalList", nil] containsObject:entityName])
    {
        sortKey = @"timeStamp";
        sortAscending = NO;
    }
	return [self searchObjectsForEntity:entityName withPredicate:nil andSortKey:sortKey andSortAscending:sortAscending andContext:managedObjectContext];
}

#pragma mark -
#pragma mark Count objects

// Get a count for an entity with a predicate
+(NSUInteger)countForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	[request setIncludesPropertyValues:NO];
    
	// If a predicate was specified then use it in the request
	if (predicate != nil)
		[request setPredicate:predicate];
    
	// Execute the count request
	NSError *error = nil;
	NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
	[request release];
    
	// If the count returned NSNotFound there was an error
	if (count == NSNotFound)
		NSLog(@"Couldn't get count for entity %@", entityName);
    
	// Return the results
	return count;
}

// Get a count for an entity without a predicate
+(NSUInteger)countForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)managedObjectContext
{
	return [self countForEntity:entityName withPredicate:nil andContext:managedObjectContext];
}

#pragma mark -
#pragma mark Delete Objects

// Delete all objects for a given entity
+(BOOL)deleteAllObjectsForEntity:(NSString*)entityName andContext:(NSManagedObjectContext *)managedObjectContext
{
	// Create fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
    
	// Ignore property values for maximum performance
	[request setIncludesPropertyValues:NO];
    
	// Execute the count request
	NSError *error = nil;
	NSArray *fetchResults =[NSArray arrayWithArray:[managedObjectContext executeFetchRequest:request error:&error]];
	[request release];
    
	// Delete the objects returned if the results weren't nil
	if (fetchResults != nil)
    {
		for (NSManagedObject *manObj in fetchResults)
        {
			[managedObjectContext deleteObject:manObj];
		}
        if (![managedObjectContext save:&error])
        {
            NSLog(@"Error deleting %@ - error:%@",entityName,error);
        }
        
	} else {
		NSLog(@"Couldn't delete objects for entity %@", entityName);
		return NO;
	}
    
	return YES;	
}
#pragma mark Attributes and Relationships of Entity
+ (NSDictionary*)getAttributesByName:(NSString*)entityName
{
   return [[NSEntityDescription entityForName:entityName inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
}
+ (NSDictionary*)getRelationshipsByName:(NSString*)entityName
{
    return [[NSEntityDescription entityForName:entityName inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] relationshipsByName];
}
@end