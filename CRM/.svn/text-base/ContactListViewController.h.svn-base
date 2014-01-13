//
//  ContactListViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 26/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook.h"
#import "DropDownView.h"
#import "AddNewContactViewController.h"

@protocol ContactListVCDelegate <NSObject>
- (void)changeNavigationTitle;
@end

@interface ContactListViewController : UIViewController <AddNewVCDelegate>
{
    IBOutlet UITableView *tblContactList;
    IBOutlet UIImageView *imgVSearchBg;
    IBOutlet UIImageView *imgVDropDownBg;
    IBOutlet UIButton *btnAddNew;
//    IBOutlet UIButton *btnDeleteAll;
    IBOutlet UITextField *txtfSearch;
    
@private
	//Various drop Downs as per the Designs
	DropDownView*				dropDownGroup;

}
@property (nonatomic,retain) DropDownView*	dropDownGroup;
@property (nonatomic , retain) NSString* strDropDownGroupName;
@property (nonatomic , retain) NSMutableArray *arrContacts;
@property (nonatomic , retain) NSArray *arrGroupList;
@property (nonatomic , assign) int editItemTag;


@property (nonatomic , assign) id<ContactListVCDelegate> aDelegate;


-(void)generateDropDown;
-(IBAction)btnAddNewContact:(id)sender;
@end
