//
//  AddNewContectDetailCell.h
//  CRM
//
//  Created by Narendra Verma on 09/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#define kDETAILSTITLE @"DetailName"
#define kDETAILSTYPE  @"DetailsType"

//keys used for cell
#define kAddNewContact_Industry			@"Industry"
#define kAddNewContact_Salutation		@"Salutation"
#define kAddNewContact_Prefix			@"Prefix"

#define kAddNewContact_FunnelStage		@"Select Funnel Stage"
#define kAddNewContact_LeadStatus		@"Lead Status"
#define kAddNewContact_LeadSource		@"Lead Source"
#define kAddNewContact_AddGroup			@"Add To Group"
#define kAddNewContact_AddSubGroup		@"Add To Subgroup"
#define kAddNewContact_Gender			@"Gender"
#define kAddNewContact_DOB				@"Date of Birth"
#define kAddNewContact_Image			@"Image"



//TextFileds
#define k_TextFiled_Suffix				@"Suffix"
#define k_TextFiled_FirstName			@"First Name"
#define k_TextFiled_MiddleName			@"Middle Name"
#define k_TextFiled_LastName			@"Last Name"
#define k_TextFiled_Email				@"Email Address"
#define k_TextFiled_Address				@"Address"
#define k_TextFiled_Address2			@"Address2"
#define k_TextFiled_City				@"City"
#define k_TextFiled_State				@"State"
#define k_TextFiled_Country				@"Country"
#define k_TextFiled_ZipCode				@"Zip Code"
#define k_TextFiled_PhoneNum			@"Work Number"
#define k_TextFiled_MobileNum			@"Mobile Number"
#define k_TextFiled_HomeNum				@"Home Number"
#define k_TextFiled_FaxNum				@"Fax Number"


//Company info
#define k_TextFiled_CompanyName			@"Company Name"
#define k_TextFiled_Title				@"Title"
#define k_TextFiled_IndustryDes			@"Industry Description"
#define k_TextFiled_URL					@"URL"

//Profile info
#define k_TextFiled_FunnelDesc			@"Funnel Description"
#define k_TextFiled_Facebook			@"Facebook"
#define k_TextFiled_Twitter				@"Twitter"
#define k_TextFiled_Linkedin			@"Linkedin"
#define k_TextFiled_Google				@"Google+"
#define k_TextFiled_Scoring				@"Scoring"
#define k_TextFiled_Note				@"Notes"

#import <UIKit/UIKit.h>
#import "MyAddressBook.h"

@protocol AddNewContactdetailCellDelegate <NSObject>

-(void)textFiledDidBeginEditingWithField:(UITextField*)textFiled;

@end

@interface AddNewContectDetailCell : UITableViewCell<UITextViewDelegate , UITextFieldDelegate>
{
	IBOutlet UILabel *lblSaperator;
	CGPoint ptBeforeScrolling;
	IBOutlet UIView *vwRadio;
    IBOutlet UIView *addressEditView;
	IBOutlet UIImageView *imgPhoto;
    
}

//dict for my addressBook
@property (retain, nonatomic) MyAddressBook * editMyAddObj;
@property (retain, nonatomic) NSMutableDictionary * dictM_MyaddressBookCell;
@property (strong, nonatomic) NSMutableDictionary *dictDetailTitle;
@property (assign, nonatomic) id <AddNewContactdetailCellDelegate>  adelegate;

@property (strong, nonatomic) NSString *currentEditKey;

@property (retain,nonatomic) NSIndexPath * indexPathForCell;
@property (retain, nonatomic) IBOutlet UILabel *lblDetailTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblDictTitle;
@property (retain, nonatomic) IBOutlet UITextField *txtdetail;
@property (retain, nonatomic) IBOutlet UITextField *txtTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnUpload;
@property (retain, nonatomic) IBOutlet UIButton *btnDate;
@property (retain, nonatomic) IBOutlet UIButton *btnMale;
@property (retain, nonatomic) IBOutlet UIButton *btnFemale;
@property (retain, nonatomic) IBOutlet UITextView *txtView;
//For Address Edit
@property (retain, nonatomic) IBOutlet UITextField *addressType;
@property (retain, nonatomic) IBOutlet UITextField *addressStreet;
@property (retain, nonatomic) IBOutlet UITextField *addressCity;
@property (retain, nonatomic) IBOutlet UITextField *addressState;
@property (retain, nonatomic) IBOutlet UITextField *addressZip;
@property (retain, nonatomic) IBOutlet UITextField *addressCountry;
@property (retain, nonatomic) IBOutlet UILabel *lblAddAddress;
@property (retain, nonatomic) UIImageView * imgfirstDropDown;
@property (retain, nonatomic) UIImageView * imgSecondDropDown;
@property (retain, nonatomic) IBOutlet UIButton *btnViewHistory;
@property (retain, nonatomic) IBOutlet UIButton *btnAddLatPurchase;
@property (retain, nonatomic) IBOutlet UIButton *btnIndustryDropDown;

@property (retain, nonatomic) IBOutlet UITextField * txtSecondAddress;
@property (retain, nonatomic) IBOutlet UIButton *btnDropDown;

@property (retain, nonatomic) UITextField * txtFirstRseponder;

- (void)setlabeldetailTitleWithDict:(NSDictionary *)dictData andWithSize:(CGSize)size;
- (void)getDataFromDict:(NSMutableDictionary *)dictMultiValue andDict:(NSDictionary *)dict emailList:(NSMutableArray *)email urlList:(NSMutableArray *)url phoneList:(NSMutableArray *)phone addressList:(NSMutableArray *)address;
- (void)addObserver_NotificationCenter;

@end
