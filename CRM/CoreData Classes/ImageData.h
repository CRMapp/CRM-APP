//
//  ImageData.h
//  CRM
//
//  Created by Narendra Verma on 24/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageData : NSManagedObject

@property (nonatomic, retain) NSData * image_Data;
@property (nonatomic, retain) NSString * image_Path;

@end
