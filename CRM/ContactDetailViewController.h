//
//  ContactDetailViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 22/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MyAddressBook.h"
#import "DropDownView.h"
#import "KTTextView.h"
#import "AddNewContactViewController.h"
#import "ListViewController.h"
#import "NS_Proposal_DD_TVCell.h"
@interface ContactDetailViewController : UIViewController<UITableViewDataSource , UITableViewDelegate , UITextFieldDelegate , MFMailComposeViewControllerDelegate , AddNewVCDelegate , UIActionSheetDelegate , NS_Proposal_DD_TVCellDelegate>
{
    IBOutlet UIScrollView *scrMainScrollView;
    IBOutlet UIView *next_step_View;
    IBOutlet UIView *history_View;
    IBOutlet UIView *next_step_tblHdr_View;
    IBOutlet UIView *history_tblHdr_View;
    IBOutlet UIView *history_Option_tblHdr_View;
    IBOutlet UIView *history_Option_List_View;
    IBOutlet UIView *History_Desc_RE_View;
    IBOutlet UIView *view_contact_list;
    IBOutlet UIView *Next_Step_option_View_Landscape;
    IBOutlet UIView *Next_Step_option_View_Portrate;
    IBOutlet UIView *TVH__NS_Proposal;
    IBOutlet UIView *TVH__NS_Task;
    IBOutlet UIView *TVH__NS_Reminder;
    IBOutlet UIView *TVH__NS_Appointment;
//    IBOutlet UIView *TVH__Contact_List;
    IBOutlet UIView *TVH_Timeline_HS;
    IBOutlet UIView *view_add_Proposal;
    IBOutlet UIView *view_add_task;
    IBOutlet UIView *view_add_appointment;
    IBOutlet UIView *view_add_reminder;
    IBOutlet UIView *view_call_user;
    IBOutlet UIView *view_email_user;
    IBOutlet UIView *view_date_picker;
//    IBOutlet UIView *view_configure_email;
    IBOutlet UIView *view_proposal_DD;
    
    IBOutlet UIView *view_history_landscape;
    IBOutlet UIView *view_history_portrate;
    IBOutlet UIView         *view_script_call;
    IBOutlet UIView         *view_note_call;
    IBOutlet UITextView     *txtvScriptCallUser;
    
    
    
    IBOutlet UIButton *btnPersonalDetails;
    IBOutlet UIButton *btnHistory;
    
    
    IBOutlet UIImageView *imgVwHistoryOptionbar;
    IBOutlet UIButton *btnHistoryCall;
    IBOutlet UIButton *btnHistoryEmail;
    IBOutlet UIButton *btnHistoryReminder;
    IBOutlet UIButton *btnHistoryEvent;
    IBOutlet UIButton *btnHistoryTimeLine;
    
    IBOutlet UIButton *btnHistoryCall_p;
    IBOutlet UIButton *btnHistoryEmail_p;
    IBOutlet UIButton *btnHistoryReminder_p;
    IBOutlet UIButton *btnHistoryEvent_p;
    IBOutlet UIButton *btnHistoryTimeLine_p;
    
    IBOutlet UIButton *btnCallUser;
    IBOutlet UIButton *btnProposal;
    IBOutlet UIButton *btnEmail;
    IBOutlet UIButton *btnTask;
    IBOutlet UIButton *btnReminder;
    IBOutlet UIButton *btnAppointment;
    
    IBOutlet UIButton *btnCallUser_P;
    IBOutlet UIButton *btnProposal_P;
    IBOutlet UIButton *btnEmail_P;
    IBOutlet UIButton *btnTask_P;
    IBOutlet UIButton *btnAppointment_P;
    IBOutlet UIButton *btnReminder_P;
    IBOutlet UIButton *btnCross;
    IBOutlet UIButton *btnViewScriptList;
    IBOutlet UIButton *btnScriptList;
    IBOutlet UIButton *btnSaveNote;
    
    UIButton *btnSelectedPopOver;
    
    
    IBOutlet UITextView *txtVwDesc;
    IBOutlet KTTextView *txtVwCallNote;
    
    IBOutlet UITableView *tblFollowUpdate;
    IBOutlet UITableView *tblNextStep;
    IBOutlet UITableView *tblHistory;
    IBOutlet UITableView *tblHistoryOption;
    IBOutlet UITableView *tblPersonalDetail;
    IBOutlet UITableView *tblScriptCallUser;
    IBOutlet UITableView *tblContactList;
    IBOutlet UITableView *tblProductList;
    
    IBOutlet UILabel *lblPersonNmae;
    IBOutlet UILabel *lblEmailId;
    IBOutlet UILabel *lblAppointment;
    IBOutlet UILabel *lblProposal;
    IBOutlet UILabel *lblReminder;
    IBOutlet UILabel *lbltask;
    IBOutlet UILabel *lblHistoryOptionTitle;
    IBOutlet UILabel *lblTitle;
    
    IBOutlet UIImageView *imgVwPerson;
    IBOutlet UIImageView *imgVwNoteFrame;
    IBOutlet UIImageView *imgVwScriptFrame;
    IBOutlet UIToolbar *toolBar;
    
    UITextField *currentTextField;
    UITextView *currentTextView;
    
    BOOL isEditing;
    BOOL isReminderSave;
    
    IBOutlet UIView *vwFirstLine;
    IBOutlet UITableView *tableEmailSelection;
    IBOutlet UIView *vwSelectedContacEmails;
    
    IBOutlet UITableView *tableEmailContact;
@private
	//Various drop Downs as per the Designs
	DropDownView*				dropDownTaskStatus;    
}
@property (nonatomic,retain)    DropDownView*	dropDownTaskStatus;
@property (nonatomic , retain)  NSString* strDropDownItem;
@property (nonatomic , retain) IBOutlet UIDatePicker* dateTimePicker;
@property (nonatomic , retain) MyAddressBook *aContactDetails;
@property (nonatomic , retain) NSString *NEXT_STEP_OPTION;
@property (retain, nonatomic) NSMutableArray * arrayFirstLine;

//Array for all emails
@property (retain, nonatomic) NSMutableArray * arrayEmails;


#pragma mark Array and Dictionary
@property (retain , nonatomic)  NSMutableDictionary *dictTemp;
@property (retain , nonatomic)  NSMutableArray      *arrAllKeys;
@property (retain , nonatomic)  NSMutableArray      *arrProposalList;
@property (retain , nonatomic)  NSMutableArray      *arrTaskList;
@property (retain , nonatomic)  NSMutableArray      *arrReminderList;
@property (retain , nonatomic)  NSMutableArray      *arrFollowUpdate;
@property (retain , nonatomic)  NSMutableArray      *arrScriptList;
@property (retain , nonatomic)  NSMutableArray      *arrAppointmentList;
@property (retain , nonatomic)  NSMutableArray      *arrProductList;
@property (retain , nonatomic)  NSMutableDictionary *dictTimeLineList;
@property (retain , nonatomic)  NSMutableArray      *arrHisOptionData;
@property (retain , nonatomic)  NSMutableArray      *arrContacts;

@property (nonatomic , assign)  int                 historySelectedOption;
@property (nonatomic , assign)  int                 editItemTag;
@property (nonatomic , assign)  int                 dateBtnTag;
@property (retain , nonatomic)  NSIndexPath         *selectedIndexPath;

@property (nonatomic , assign)  BOOL                 isTimelineTap;

@property (retain , nonatomic)  UIPopoverController *datePickerPopover;
@property (retain , nonatomic)  UIPopoverController *contactListPopover;
@property (retain , nonatomic)  UIPopoverController *productListPopover;
//For select first line
@property (retain, nonatomic) UIPopoverController * popoverSelectFirstLine;
@property (retain, nonatomic) UIPopoverController * popoverEmails;



- (IBAction)btnNextStepTapped:(UIButton*)sender;
- (IBAction)btnHistory_Option_Tapped:(UIButton*)sende;
- (IBAction)btnCancelDescViews:(UIButton*)sender;
- (IBAction)btnAddProposal_Tapped:(id)sender;
- (IBAction)btnShowPicker:(UIButton*)sender;
- (IBAction)btnDoneToolBar:(id)sender;
- (IBAction)saveButton_Tapped:(UIButton*)sender;
- (IBAction)btnAddTask_Tapped:(id)sender;
- (IBAction)btnAddAppointment_Tapped:(id)sender;
- (IBAction)btnViewAllTapped:(id)sender;
- (IBAction)btnShowList:(id)sender;
- (IBAction)btnDelete_Tapped:(UIButton*)sender;
- (IBAction)btnCrossOnScriptDetail:(id)sender;
- (IBAction)btnShowContactsPopover:(id)sender;
- (IBAction)btnEditTapped:(id)sender;
- (IBAction)btnDoneContacts:(id)sender;
-(IBAction)btnProposalDropDown:(UIButton*)sender;
-(void)navigateWithClassType:(NavigatType)navigatingClass;
- (IBAction)btnSendEmail:(id)sender;
@end
