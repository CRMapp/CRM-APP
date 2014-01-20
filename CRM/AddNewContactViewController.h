//
//  AddNewContactViewController.h
//  CRM
//
//  Created by Narendra Verma on 09/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressBook.h"
#import "DropDownView.h"
#import "AddNewContectDetailCell.h"
#import "GlobalDataPersistence.h"

@protocol AddNewVCDelegate <NSObject>

- (void)refreshContactList;

@end


@interface AddNewContactViewController : UIViewController<AddNewContactdetailCellDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
	CGSize maxSizeOfDetailTitle;
	IBOutlet UITableView *tblDetils;
	UIButton *aSender;
	IBOutlet UIDatePicker *dateTimePicker;
	IBOutlet UIView *view_date_picker;
    IBOutlet UIView *view_main;
    IBOutlet UILabel *lblHeader;
	IBOutlet UIButton *btnPersonalDetails;
	IBOutlet UIButton *btnCompInfo;
	IBOutlet UIButton *btnProfileInfo;
    BOOL newMedia;
    //Industry view
	IBOutlet UIView *vwIndustrySearch;
	IBOutlet UITableView *tableIndustry;
	IBOutlet UISearchBar *txtIndustrySearch;
	
	
}
//Dict for myaddressBook
@property (retain, nonatomic) NSMutableDictionary * dictM_MyaddressBook;
@property (retain, nonatomic) NSMutableDictionary *dictDetailTitle;
//array for Industry
@property (nonatomic, retain) NSMutableArray * arrayIndustry;
@property (retain , nonatomic) UIPopoverController *popoverindustry;
@property (nonatomic , assign) id <AddNewVCDelegate> aDelegate;
@property (retain , nonatomic) UIPopoverController *datePickerPopover;
@property (nonatomic, retain)  UIPopoverController *popoverController;
@property (nonatomic, retain)  UITextField *currentField;
@property (retain, nonatomic)  NSMutableArray * mArrDetilTitle;

//@property (retain, nonatomic) MyAddressBook * myAddObj;
@property (retain, nonatomic) MyAddressBook * editMyAddObj;

@property (assign, nonatomic) int groupIndex;
@property (assign, nonatomic) int subGroupIndex;

@property (retain, nonatomic) DropDownView * dropDownView;
- (IBAction)btnOptionTapped:(UIButton*)sender;
- (IBAction)btnDoneToolBar:(id)sender;
- (IBAction)btnTopDonePressed:(id)sender;
@end
