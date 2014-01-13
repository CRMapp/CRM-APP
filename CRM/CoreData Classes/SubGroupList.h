//
//  SubGroupList.h
//  CRM
//
//  Created by Sheetal's iMac on 14/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupList, GroupMemberList;

@interface SubGroupList : NSManagedObject

@property (nonatomic, retain) NSString * subGroupName;
@property (nonatomic, retain) NSString * subGroupDesc;
@property (nonatomic, assign) BOOL  isSubGroupCheck;;
@property (nonatomic, retain) NSSet *relGroupMember;
@property (nonatomic, retain) GroupList *relGroupList;
@end

@interface SubGroupList (CoreDataGeneratedAccessors)

- (void)addRelGroupMemberObject:(GroupMemberList *)value;
- (void)removeRelGroupMemberObject:(GroupMemberList *)value;
- (void)addRelGroupMember:(NSSet *)values;
- (void)removeRelGroupMember:(NSSet *)values;

@end
