//
//  DisplayMap.h
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright 2010 Chakra Interactive Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "MyAddressBook.h"
#import "EGOImageView.h"
@interface DisplayMap : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
    MyAddressBook *aPerson;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) MyAddressBook *aPerson;
@property (nonatomic,retain) EGOImageView * imgEgo;
@property (nonatomic, retain) NSMutableDictionary * dictContactDetails;

@end
