//
//  ListViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 11/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	NavigatTypeCallUser = 1,
	NavigatTypeProposal,
	NavigatTypeEmail,
	NavigatTypeTask,
	NavigatTypeAppointment,
	NavigatTypeReminder
	
}NavigatType;

@interface ListViewController : UIViewController
{
    IBOutlet UITableView *aListTable;
    IBOutlet UILabel     *lblHeader;
}
@property (nonatomic , assign) int tagValue;
@property (nonatomic , assign) int deleteTag;
@property (nonatomic , retain) NSString *header;
@property (nonatomic , retain) NSArray *dataArray;
@property (nonatomic , retain) UINavigationController *aNavigation;
@end
