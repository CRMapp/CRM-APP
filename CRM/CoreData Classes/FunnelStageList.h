//
//  FunnelStageList.h
//  CRM
//
//  Created by Sheetal's iMac on 17/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FunnelStageList : NSManagedObject

@property (nonatomic, retain) NSString * stageName;
@property (nonatomic, retain) NSNumber * stageID;

@end
