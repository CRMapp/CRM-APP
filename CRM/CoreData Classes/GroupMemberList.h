//
//  GroupMemberList.h
//  CRM
//
//  Created by Sheetal's iMac on 14/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupList, SubGroupList;

@interface GroupMemberList : NSManagedObject

@property (nonatomic, retain) NSString * memberCompany;
@property (nonatomic, retain) NSString * memberName;
@property (nonatomic, retain) NSString * memberTitle;
@property (nonatomic, retain) NSString * memRecordID;
@property (nonatomic, retain) GroupList *relGroupList;
@property (nonatomic, retain) SubGroupList *relSubGroup;

@end
