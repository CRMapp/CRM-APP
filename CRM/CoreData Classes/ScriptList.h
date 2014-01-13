//
//  ScriptList.h
//  CRM
//
//  Created by Sheetal's iMac on 12/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScriptList : NSManagedObject

@property (nonatomic, retain) NSString * scriptName;
@property (nonatomic, retain) NSString * script_Description;
@property (nonatomic, retain) NSString * scriptText;
@property (nonatomic, retain) NSString * script_date;
@end
