//
//  GroupList.h
//  CRM
//
//  Created by Sheetal's iMac on 14/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupMemberList, SubGroupList;

@interface GroupList : NSManagedObject

@property (nonatomic, retain) NSString * groupDesc;
@property (nonatomic, retain) NSString * groupName;


//Customize
@property (nonatomic , assign)  BOOL isGroupCheck;


@property (nonatomic, retain) NSSet *relGroupMember;
@property (nonatomic, retain) NSSet *relSubGroup;
@end

@interface GroupList (CoreDataGeneratedAccessors)

- (void)addRelGroupMemberObject:(GroupMemberList *)value;
- (void)removeRelGroupMemberObject:(GroupMemberList *)value;
- (void)addRelGroupMember:(NSSet *)values;
- (void)removeRelGroupMember:(NSSet *)values;

- (void)addRelSubGroupObject:(SubGroupList *)value;
- (void)removeRelSubGroupObject:(SubGroupList *)value;
- (void)addRelSubGroup:(NSSet *)values;
- (void)removeRelSubGroup:(NSSet *)values;

@end
