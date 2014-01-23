//
//  SettingsViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 11/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import <MessageUI/MessageUI.h>
#import "SMTPSender.h"
#import "GroupList.h"

@interface SettingsViewController : UIViewController<UITextFieldDelegate , SMTPSenderDelegate,MFMailComposeViewControllerDelegate
, UIActionSheetDelegate>
{
    IBOutlet UIView     *view_options_portrate;
    IBOutlet UIView     *view_options_landscape;
    IBOutlet UIView     *view_create_password;
    IBOutlet UIView     *view_below_options;
    IBOutlet UIView     *view_product_list;
    IBOutlet UIView     *view_add_product;
    IBOutlet UIView     *view_grouplist;
    IBOutlet UIView     *view_script;
    IBOutlet UIView     *view_add_script;
    IBOutlet UIView     *view_sync;
    IBOutlet UIView     *view_add_group;
    IBOutlet UIView     *view_Subgroup_list;
    IBOutlet UIView     *view_add_Subgroup;
    IBOutlet UIView     *view_member_list;
    IBOutlet UIView     *view_Contact_Info;
    IBOutlet UIView     *view_add_reminder;
    IBOutlet UIView     *view_configure_email;
    IBOutlet UIView     *view_email_user;
    
    
    IBOutlet UILabel    *lblAddProduct1;
    IBOutlet UILabel    *lblAddProduct2;
    IBOutlet UILabel    *lblAddProduct3;
    IBOutlet UILabel    *lblAddEditTitleGroup;
    IBOutlet UILabel    *lblAddEditTitleSubGroup;
    IBOutlet UILabel    *lblReminder;
    
//    IBOutlet UIButton   *btnEnterProduct;
//    IBOutlet UIButton   *btnUploadCSV;
    IBOutlet UIButton   *btnAddNewGrp;
    IBOutlet UIButton   *btnSetReminder;
    IBOutlet UIButton   *btnSendMail;
    IBOutlet UIButton   *btnGroup;
    IBOutlet UIButton   *btnEnableDisable;
    IBOutlet UIButton   *btnViewProduct;
    IBOutlet UIButton   *btnAddNewSbGrp;
    IBOutlet UIButton   *btnSbGrpSetReminder;
    IBOutlet UIButton   *btnSbGrpSendMail;
    IBOutlet UIButton   *btnGroupDone;
    IBOutlet UIButton   *btnSubGroupDone;
    IBOutlet UIButton   *btnAccounts;
    
    IBOutlet UITableView *tblProductList;
    IBOutlet UITableView *tblScriptList;
    IBOutlet UITableView *tblGroupList;
    IBOutlet UITableView *tblSubGroupList;
    IBOutlet UITableView *tblContactist;
    IBOutlet UITableView *tblMemberList;
    IBOutlet UITableView *tblContactInfo;
    
    IBOutlet UITextField *txtfEmailId;
    IBOutlet UITextField *txtfPassword;
    IBOutlet UITextField *txtfConfirmPassword;
    
    IBOutlet UITextField *txtfSearchGroupName;
    IBOutlet UITextField *txtfSearchSubGroup;
    IBOutlet UITextField *txtfSearchContact;
    
    IBOutlet UIImageView *imgVDropDown;
    
    IBOutlet UIToolbar *toolBar;
    IBOutlet UIDatePicker* dateTimePicker;
    IBOutlet UIView *view_date_picker;
    IBOutlet UIView *vwFirstLine;
    IBOutlet UITableView *tableEmailSelection;
    
    UITextField *currentTextField;
    UITextView *currentTextView;
    
    BOOL isEditing;
    GroupList *currentGroup;

	DropDownView*				dropDownCurrency;
    DropDownView*               dropDownGroups;
    DropDownView*				dropDownReminder;
    
    

}

@property (nonatomic,retain)    DropDownView*	dropDownCurrency;
@property (nonatomic,retain)    DropDownView*	dropDownGroups;
@property (nonatomic,retain)    DropDownView*	dropDownReminder;
@property (nonatomic , retain)  NSString* strDropDownCurrency;
@property (nonatomic , retain)  NSString* strDropDownGroup;
@property (nonatomic , retain)  NSString* strDropDownItem;
@property (nonatomic , assign)  int reminder_tag;
@property (nonatomic , assign)  int email_type_tag;
@property (nonatomic , assign)  int editItemTag;
@property (nonatomic , assign)  int selectedGroup;
@property (nonatomic,retain)    NSArray*            arrProductList;
@property (nonatomic,retain)    NSArray*            arrScriptList;
@property (nonatomic,retain)    NSArray*            arrBackUpData;
@property (nonatomic,retain)    NSArray*            arrMemberList;
@property (retain, nonatomic) NSMutableArray  * arrayFirstLine;
@property (nonatomic,retain)    NSMutableArray*     arrMapSelectedContact;
@property (nonatomic,retain)    NSMutableArray*     arrGroupList;
@property (nonatomic,retain)    NSMutableArray*     arrSubGroupList;
@property (retain , nonatomic)  NSMutableDictionary *dictTemp;
@property (retain , nonatomic)  NSMutableArray      *arrAllKeys;
@property (retain , nonatomic)  UIPopoverController *datePickerPopover;
@property (retain, nonatomic) UIPopoverController * popoverSelectFirstLine;


@property (nonatomic , assign)  BOOL isFromMapView;


- (IBAction)btnOptionTapped:(UIButton*)sender;
- (IBAction)btnAddProduct:(id)sender;
- (IBAction)btnCancelAddProduct:(id)sender;
- (IBAction)btnRadioAddProduct:(id)sender;
- (IBAction)btnSaveTapped:(UIButton*)sender;
- (IBAction)btnEnableDisablePassword:(UIButton*)sender;
- (IBAction)btnSavePassword:(UIButton*)sender;
- (IBAction)btnAddNewGroup:(id)sender;
- (IBAction)btnAddNewSubGroup:(id)sender;
- (IBAction)btnDoneGroup:(id)sender;
- (IBAction)btnSyncToAppDatabase:(id)sender;
- (IBAction)addContactToAddressBook;
- (IBAction)btnShowPicker:(UIButton*)sender;
- (IBAction)btnAddReminder_Tapped:(id)sender;
- (IBAction)btnDoneToolBar:(id)sender;
- (IBAction)btnConfigureAccount:(id)sender;
- (IBAction)btnSendEmailToGroupMember:(id)sender;
- (IBAction)btnSendEmailToSubGroupMember:(id)sender;
- (IBAction)btnSelectFirstLineTapped:(UIButton *)sender;
- (IBAction)btnSelectAllContacts:(UIButton*)sender;

-(void)generateDropDown:(NSString*)aDropDown;

@end
