//
//  FirstLine.m
//  CRM
//
//  Created by Narendra Verma on 21/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "FirstLine.h"

@implementation FirstLine

@synthesize isSelected;
@synthesize itemName;

-(void)dealloc
{
	[itemName release];
	itemName = nil;
	
	[super dealloc];
}

@end
