//
//  DisplayMap.m
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright 2010 Chakra Interactive Pvt Ltd. All rights reserved.
//

#import "DisplayMap.h"


@implementation DisplayMap

@synthesize coordinate,title,subtitle;

@synthesize aPerson;
@synthesize imgEgo;
@synthesize dictContactDetails;

-(void)dealloc
{
	[dictContactDetails release];
	dictContactDetails = nil;
	[imgEgo release];
	[title release];
    [subtitle release];
	[super dealloc];
}

@end
