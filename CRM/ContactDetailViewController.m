                                  //
//  ContactDetailViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 22/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ContactDetailViewController.h"
#import <QuartzCore/QuartzCore.h>


#import "PersonalDetailsTVCell.h"
#import "NextStepTVCell.h"
#import "HistoryTVCell.h"
#import "HistoryCallTVCell.h"
#import "HistoryEmailTVCell.h"
#import "CRMConfig.h"
#import "AllAddress.h"
#import "AllEmail.h"
#import "AllPhone.h"
#import "AllUrl.h"
#import "ViewScriptTVCell.h"
#import "TouchView.h"
#import "ProposalList.h"
#import "Reachability.h"
#import "AllRelatedName.h"
#import "TaskList.h"
#import "AppointmentList.h"
#import "ReminderList.h"
#import "NS_ReminderTVCell.h"
#import "FollowUpdate.h"
#import "ScriptList.h"
#import "NotesList.h"
#import "EmailList.h"
#import "EditContact_EmailTVCell.h"
#import "SMTPSender.h"
#import "DHValidation.h"
#import "Global.h"
#import "FunnelStageList.h"
#import "AllDate.h"
#import "FirstLine.h"
#import "CheckMarkCell.h"
#import "AddNewContactViewController.h"
#import "ProposalTVCell.h"
#import "ProductList.h"
#import "TimeLineTVCell.h"
#import <Twitter/Twitter.h>
#import "ImageData.h"
@interface ContactDetailViewController ()


@end

@implementation ContactDetailViewController

@synthesize dictTemp;
@synthesize historySelectedOption;
@synthesize aContactDetails;
@synthesize arrAllKeys;
@synthesize NEXT_STEP_OPTION;
@synthesize dateTimePicker;
@synthesize arrProposalList;
@synthesize editItemTag;
@synthesize datePickerPopover;
@synthesize selectedIndexPath;
@synthesize arrTaskList;
@synthesize dropDownTaskStatus;
@synthesize strDropDownItem;
@synthesize arrAppointmentList;
@synthesize arrReminderList;
@synthesize arrFollowUpdate;
@synthesize arrScriptList;
@synthesize arrHisOptionData;
@synthesize contactListPopover;
@synthesize arrContacts;
@synthesize arrayFirstLine;
@synthesize arrayEmails;
@synthesize popoverSelectFirstLine;
@synthesize popoverEmails;
@synthesize dictTimeLineList;
@synthesize arrProductList;
@synthesize productListPopover;
@synthesize dateBtnTag;
@synthesize isTimelineTap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertFunnelStageList];

    [self resetAllEmails_isSelected];
	
	//Changes made
	NSArray * arrayName = [NSArray arrayWithObjects:SALUTATION_STRING,PREFIX_STRING,FIRST_NAME_STRING,MIDDLE_NAME_STRING,LAST_NAME_STRING,SUFFIX_STRING, nil];
	self.arrayFirstLine = [NSMutableArray arrayWithCapacity:0];
	
	for (NSString * name in arrayName)
	{
		FirstLine * lineObj = [[[FirstLine alloc]init] autorelease];
		
		[lineObj setIsSelected:YES];
		[lineObj setItemName:[name capitalizedString]];
		
		[self.arrayFirstLine addObject:lineObj];
	}

    
    
    BOOL file  =   [[NSFileManager defaultManager] fileExistsAtPath:self.aContactDetails.image];
    if (file)
    {
        imgVwPerson.image = [UIImage imageWithContentsOfFile:self.aContactDetails.image];
    }
    else
    {
		//ImageData Narendra
		//if file not found
		//and check if we have image url in database (image data)
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"image_Path == %@",self.aContactDetails.image];
		
		NSArray * array = [CoreDataHelper searchObjectsForEntity:@"ImageData" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		
		if ([array count])//we have image data in data base
		{
			ImageData * imgObj = [array lastObject];
			if (imgObj.image_Data)
			{
				[imgVwPerson setImage:[UIImage imageWithData:imgObj.image_Data]];
                
				//Now we save the image in the document dir
				//So that it can be accessed for there afetr words
				BOOL success =   [imgObj.image_Data writeToFile:self.aContactDetails.image atomically:NO];
				
				if (success)
				{
					NSLog(@"Image saved successFully");
				}
				
			}
			else
			{
                imgVwPerson.image = [UIImage imageNamed:@"ipad_user_img.png"];
			}
			
		}
		else// we dont have image data in database as well
		{
            imgVwPerson.image = [UIImage imageNamed:@"ipad_user_img.png"];
		}
    }
    [btnPersonalDetails setSelected:YES];
    
    [self updateTableLayouts];
    
    if(self.aContactDetails)
    {
        [self showPersonalDetails];
    }
    [self setMinimumPickerDate];
    // Notification sent when dismiss keyboard button is tapped.
	[self addObserver_NotificationCenter];
    [self setUserEmailLabel];
    [self fetchFollowUpdate];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [self updateUI:orientation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //deallo notification center
    [self removeObserver_NotificationCenter];
    
    //dealloc all property
    [aContactDetails release];

    [toolBar release];
    toolBar = nil;

    [dropDownTaskStatus release];
    dropDownTaskStatus = nil;
    
    [strDropDownItem release];
    strDropDownItem = nil;
    
    [selectedIndexPath release];
    selectedIndexPath = nil;
    
    //dealloc all texts
    [txtvScriptCallUser release];
    [txtVwDesc release];
    [txtvScriptCallUser release];
    [txtVwCallNote release];
    txtvScriptCallUser = nil;
    
    //dealloc popovers
    [datePickerPopover release];
    datePickerPopover = nil;
    [productListPopover release];
    productListPopover = nil;
    
    [contactListPopover release];
    contactListPopover = nil;
    [popoverEmails release];
    popoverEmails = nil;
	[popoverSelectFirstLine release];
    popoverSelectFirstLine = nil;
    
    
    //dealloc imageviews
    [imgVwNoteFrame release];
    [imgVwHistoryOptionbar release];
    imgVwHistoryOptionbar = nil;
    [imgVwScriptFrame release];
    
    //dealloc all lables
    [lblAppointment release];
    [lblProposal release];
    [lblReminder release];
    [lbltask release];
    [lblHistoryOptionTitle release];
    lblHistoryOptionTitle = nil;
    [lblPersonNmae release];
    [lblEmailId release];
    [lblTitle release];
    
    //dealloc all views
    [scrMainScrollView release];
    scrMainScrollView = nil;
    [view_script_call release];
    [view_note_call release];
    [History_Desc_RE_View release];
    [history_Option_tblHdr_View release];
    [history_Option_List_View release];
    [next_step_View release];
    [history_View release];
    [next_step_tblHdr_View release];
    [history_tblHdr_View release];
    [Next_Step_option_View_Landscape release];
    [Next_Step_option_View_Portrate release];
    [view_add_Proposal release];
    [TVH__NS_Proposal release];
    [TVH__NS_Task release];
    [vwFirstLine release];
    [view_add_task release];
    [TVH__NS_Appointment release];
    [view_call_user release];
    [view_email_user release];
    [view_contact_list release];
    view_script_call = nil;
    view_note_call = nil;
    
    [NEXT_STEP_OPTION release];
    NEXT_STEP_OPTION = nil;
    
    History_Desc_RE_View = nil;
    view_call_user = nil;
    view_email_user = nil;
    history_Option_tblHdr_View = nil;
    history_Option_List_View = nil;
    next_step_View = nil;
    history_View = nil;
    next_step_tblHdr_View = nil;
    history_tblHdr_View = nil;
    Next_Step_option_View_Landscape = nil;
    Next_Step_option_View_Portrate = nil;
    view_add_Proposal = nil;
    view_add_task = nil;
    view_contact_list = nil;
    TVH__NS_Appointment = nil;
    TVH__NS_Proposal = nil;
    TVH__NS_Task = nil;
    [dateTimePicker release];
    dateTimePicker = nil;
    [view_date_picker release];
    view_date_picker = nil;
    [vwSelectedContacEmails release];
    [view_history_portrate release];
    [view_history_landscape release];
    [view_proposal_DD release];
    
    //dealloc all buttons
    [btnPersonalDetails release];
    [btnHistory release];
    [btnCross release]; btnCross = nil;
    btnPersonalDetails = nil;
    btnHistory = nil;
    [btnHistoryCall release];
    [btnHistoryEmail release];
    [btnHistoryReminder release];
    [btnHistoryEvent release];
    
    [btnCallUser release];
    [btnProposal release];
    [btnEmail release];
    [btnReminder release];
    [btnTask release];
    [btnAppointment release];
    
    [btnCallUser_P release];
    [btnProposal_P release];
    [btnEmail_P release];
    [btnTask_P release];
    [btnAppointment_P release];
    [btnReminder_P release];
    [btnScriptList release];
    [btnSaveNote release];
    [btnHistoryCall_p release];
    [btnHistoryEmail_p release];
    [btnHistoryReminder_p release];
    [btnHistoryEvent_p release];
    [btnHistoryTimeLine_p release];
    [btnHistoryTimeLine release];
    
    //dealloc all table
    [tblHistoryOption release];     tblHistoryOption = nil;
    [tblFollowUpdate release];      tblFollowUpdate = nil;
    [tblNextStep release];          tblNextStep = nil;
    [tblHistory  release];          tblHistory = nil;
    [tblPersonalDetail release];    tblPersonalDetail = nil;
    [tblScriptCallUser release];    tblScriptCallUser = nil;
    [tableEmailSelection release];  tableEmailSelection = nil;
    [tableEmailContact release];    tableEmailContact = nil;
    [tblProductList release];       tblProductList = nil;
    
    //dealloc all arrays and dictionary
    [arrAllKeys release];           arrAllKeys = nil;
    
    [arrTaskList release];          arrTaskList = nil;
    
    [arrProposalList release];      arrProposalList = nil;
    
    [arrAppointmentList release];   arrAppointmentList = nil;
    
    [arrReminderList release];      arrReminderList = nil;
    
    [arrScriptList release];       arrScriptList = nil;
    
    [arrProductList release];       arrProductList = nil;
    
    [arrayFirstLine release];       arrayFirstLine = nil;
    
	[arrayEmails release];          arrayEmails = nil;
    
    [dictTemp release];
    dictTemp = nil;
    
    [TVH_Timeline_HS release];
    [super dealloc];
}
- (void)viewDidUnload {

    [btnHistoryCall release];
    btnHistoryCall = nil;
    [btnHistoryEmail release];
    btnHistoryEmail = nil;
    [btnHistoryReminder release];
    btnHistoryReminder = nil;
    [btnHistoryEvent release];
    btnHistoryEvent = nil;
    
    [btnCallUser_P release];
    btnCallUser_P = nil;
    [btnProposal_P release];
    btnProposal_P = nil;
    [btnEmail_P release];
    btnEmail_P = nil;
    [btnTask_P release];
    btnTask_P = nil;
    [btnAppointment_P release];
    btnAppointment_P = nil;
    [btnReminder_P release];
    btnReminder_P = nil;
    [lblPersonNmae release];
    lblPersonNmae = nil;
    [lblEmailId release];
    lblEmailId = nil;
    [vwFirstLine release];
    vwFirstLine = nil;
    [tableEmailSelection release];
    tableEmailSelection = nil;
    [vwSelectedContacEmails release];
    vwSelectedContacEmails = nil;
    [tableEmailContact release];
    tableEmailContact = nil;
    [view_history_portrate release];
    view_history_portrate = nil;
    [view_history_landscape release];
    view_history_landscape = nil;
    [btnHistoryCall_p release];
    btnHistoryCall_p = nil;
    [btnHistoryEmail_p release];
    btnHistoryEmail_p = nil;
    [btnHistoryReminder_p release];
    btnHistoryReminder_p = nil;
    [btnHistoryEvent_p release];
    btnHistoryEvent_p = nil;
    [btnHistoryTimeLine_p release];
    btnHistoryTimeLine_p = nil;
    [btnHistoryTimeLine release];
    btnHistoryTimeLine = nil;
    [imgVwScriptFrame release];
    imgVwScriptFrame = nil;
    [lblTitle release];
    lblTitle = nil;
    [view_proposal_DD release];
    view_proposal_DD = nil;
    [tblProductList release];
    tblProductList = nil;
    [TVH_Timeline_HS release];
    TVH_Timeline_HS = nil;
    [super viewDidUnload];
}
#pragma mark - NSNotification methods
-(void)changeLayout:(NSNotification*)info
{
    
    if([self.datePickerPopover isPopoverVisible])
    {
        [self.datePickerPopover dismissPopoverAnimated:NO];
    }
    else if([self.contactListPopover isPopoverVisible])
    {
        [self.contactListPopover dismissPopoverAnimated:NO];
    }
    
    if([self.popoverEmails isPopoverVisible])
    {
        [self.popoverEmails dismissPopoverAnimated:NO];
    }
	if([self.popoverSelectFirstLine isPopoverVisible])
    {
        [self.popoverSelectFirstLine dismissPopoverAnimated:NO];
    }
    

    NSDictionary *themeInfo     =   [info userInfo];
    int orintation = [[themeInfo objectForKey:@"kOrientation"] intValue];
    [self updateUI:orintation];
    
}
#pragma mark - Navigate as per Dashboard List
-(void)navigateWithClassType:(NavigatType)navigatingClass
{
	
	[self btnNextStepTapped:nil];
	
	UIButton * btn = nil;
	[btn setSelected:NO];
	
	switch (navigatingClass)
	{
		case NavigatTypeCallUser:
			btn = btnCallUser;
			
			break;
		case NavigatTypeProposal:
			btn = btnProposal;
			
			break;
			
		case NavigatTypeEmail:
			btn = btnEmail;
			break;
			
		case NavigatTypeAppointment:
			
			btn = btnAppointment;
			break;
            
		case NavigatTypeReminder:
			
			btn = btnReminder;
			break;
		case NavigatTypeTask:
			
			btn = btnTask;
			break;
            
	}
	
	[btn setSelected:YES];
	[self btnNextStep_Option_Tapped:btn];
}
#pragma mark - Method to show personal info
- (void)showPhone{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *phoneslist = [[self.aContactDetails relAllPhone] allObjects];
    for (AllPhone *phones in phoneslist){
    [dict setObject:phones.phoneNumber forKey:phones.phoneTitle];
    //[arrAllKeys addObject:phones.phoneTitle];
    }
    [self.dictTemp setObject:dict forKey:PHONE_STRING];
}
-(void)showEmail{
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    NSArray *emailslist = [[self.aContactDetails relEmails] allObjects];
    for (AllEmail *emails in emailslist){
        [dict setObject:emails.emailURL forKey:emails.emailTitle];
        //[arrAllKeys addObject:emails.emailTitle];
    }
    [self.dictTemp setObject:dict forKey:EMAIL_STRING];
}
-(void)showURL{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *urlslist = [[self.aContactDetails relAllUrl] allObjects];
    for (AllUrl *aUrl in urlslist){
        [dict setObject:aUrl.urlAddress forKey:aUrl.urlTitle];
        //[arrAllKeys addObject:aUrl.urlTitle];
    }
    [self.dictTemp setObject:dict forKey:URL_STRING];
}
-(void)showAddress{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *lastAddressType = nil;
    NSString *addressTitle =nil;
    NSString *addressStreet =nil;
    NSString *addressCity =nil;
    NSString *addressState =nil;
    NSString *addressZip =nil;
    NSString *addressCountry =nil;
    
        NSArray *addList = [[self.aContactDetails relAllAddress] allObjects];
        for (int i =0 ; i <[addList count]; i++){
            AllAddress *address = [addList objectAtIndex:i];
            NSString *keyStr = nil;
            if(address.addressType){
                if(!lastAddressType){
                    keyStr = [ADDRESS_TYPE_STRING stringByAppendingFormat:@" %d",i];
                }
                else{
                    if(![lastAddressType isEqualToString:address.street])
                        keyStr = [ADDRESS_TYPE_STRING stringByAppendingFormat:@"  %d",i];
                    else
                        keyStr = [ADDRESS_TYPE_STRING stringByAppendingFormat:@"  %d",i];
                }
                
               addressTitle = address.addressType;
                
            }
            
            if(address.street){
                if(!lastAddressType){
                    keyStr = [STREET_STRING stringByAppendingFormat:@" %d",i];
                }
                else{
                    if(![lastAddressType isEqualToString:address.street])
                        keyStr = [STREET_STRING stringByAppendingFormat:@"  %d",i];
                    else
                        keyStr = [STREET_STRING stringByAppendingFormat:@"  %d",i];
                }
                
               addressStreet = address.street;
            }
            if(address.city){
                if(!lastAddressType){
                    keyStr = [CITY_STRING stringByAppendingFormat:@" %d",i];
                }
                else{
                    if(![lastAddressType isEqualToString:address.city])
                        keyStr = [CITY_STRING stringByAppendingFormat:@"  %d",i];
                    else
                        keyStr = [CITY_STRING stringByAppendingFormat:@"  %d",i];
                }
  
              addressCity = address.city;
                
            }
            
            if(address.state){
                if(!lastAddressType){
                    keyStr = [STATE_STRING stringByAppendingFormat:@" %d",i];
                }
                else{
                    if(![lastAddressType isEqualToString:address.state])
                        keyStr = [STATE_STRING stringByAppendingFormat:@"  %d",i];
                    else
                        keyStr = [STATE_STRING stringByAppendingFormat:@"  %d",i];
                }
                
              addressState = address.state;
                
            }
            
            if(address.zipCode){
                if(!lastAddressType){
                    keyStr = [ZIP_STRING stringByAppendingFormat:@" %d",i];
                }
                else{
                    if(![lastAddressType isEqualToString:address.addressType])
                        keyStr = [ZIP_STRING stringByAppendingFormat:@"  %d",i];
                    else
                        keyStr = [ZIP_STRING stringByAppendingFormat:@"  %d",i];
                }
                
                addressZip = address.zipCode;
            
            }
            if(address.countryCode){
                if(!lastAddressType){
                    keyStr = [COUNTRY_STRING stringByAppendingFormat:@" %d",i];
                }
                else{
                    if(![lastAddressType isEqualToString:address.addressType])
                        keyStr = [COUNTRY_STRING stringByAppendingFormat:@"  %d",i];
                    else
                        keyStr = [COUNTRY_STRING stringByAppendingFormat:@"  %d",i];
                }
                
              addressCountry = address.countryCode;
                
            }
            lastAddressType = address.addressType;
            NSString *fullAddress = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@",addressStreet,addressCity,addressState,addressZip,addressCountry];
            [dict setObject:fullAddress forKey:addressTitle];
        }
    
    
    [self.dictTemp setObject:dict forKey:ADDRESS_STRING];
}

-(void)showBirthdayDate{
    if(self.aContactDetails.birthDay){
        [self.dictTemp setObject:[NSDateFormatter localizedStringFromDate:self.aContactDetails.birthDay
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]      forKey:BIRTHDAY_STRING];
        //[arrAllKeys addObject:BIRTHDAY_STRING];
    }
 }
-(void)showDate{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *dateList = [[self.aContactDetails relAllDates] allObjects];
    for (AllDate *aDate in dateList){
        [dict setObject:[NSDateFormatter localizedStringFromDate:aDate.dates
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]      forKey:aDate.dateTitle];
        //[arrAllKeys addObject:aDate.dateTitle];
    }
    [self.dictTemp setObject:dict forKey:DATE_STRING];
}
-(void)showRelatedName{
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    NSArray *relatedList = [[self.aContactDetails relAllRelatedNames] allObjects];
        for (AllRelatedName *arelated in relatedList){
            [dict setObject:arelated.relatedNames forKey:arelated.nameTitle];
            //[arrAllKeys addObject:arelated.nameTitle];
        }
    [self.dictTemp setObject:dict forKey:RELATED_STRING];
}
-(void)showIndustrialInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(self.aContactDetails.industry){
        [dict setObject:self.aContactDetails.industry forKey:INDUSTRY_STRING];
        //[arrAllKeys addObject:INDUSTRY_STRING];
    }
    if(self.aContactDetails.industryDescription){
        [dict setObject:self.aContactDetails.industryDescription forKey:INDUSTRY_DESCRIPTION_STRING];
        //[arrAllKeys addObject:INDUSTRY_DESCRIPTION_STRING];
    }
    if (self.aContactDetails.isViewed == NO){
        self.aContactDetails.isViewed = YES;
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    }
    
    if(self.aContactDetails.funnelStageID){
        AppDelegate * adele = CRM_AppDelegate;
		NSPredicate * pridicate = [NSPredicate predicateWithFormat:@"stageID == %d",[self.aContactDetails.funnelStageID intValue]];
		NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:pridicate andSortKey:nil andSortAscending:NO andContext:[adele managedObjectContext]];
		if ([arrayFunnel count]){
			FunnelStageList * funnelObj = (FunnelStageList*)[arrayFunnel lastObject];
			[dict setObject:funnelObj.stageName           forKey:FUNNEL_STAGE_STRING];
			//[arrAllKeys addObject:FUNNEL_STAGE_STRING];
		}
    }
    if(self.aContactDetails.funnelDescription){
        [dict setObject:self.aContactDetails.funnelDescription forKey:FUNNEL_DESCRIPTION_STRING];
        //[arrAllKeys addObject:FUNNEL_DESCRIPTION_STRING];
    }
    if(self.aContactDetails.groupName){
        [dict setObject:self.aContactDetails.groupName forKey:GROUP_STRING];
        //[arrAllKeys addObject:GROUP_STRING];
    }
    if(self.aContactDetails.subGroupName){
        [dict setObject:self.aContactDetails.subGroupName forKey:SUB_GROUP_STRING];
        //[arrAllKeys addObject:SUB_GROUP_STRING];
    }
    if(self.aContactDetails.leadSource){
        [dict setObject:self.aContactDetails.leadSource forKey:LEAD_SOURCE_STRING];
        //[arrAllKeys addObject:LEAD_SOURCE_STRING];
    }
    if(self.aContactDetails.leadStatus){
        [dict setObject:self.aContactDetails.leadStatus forKey:LEAD_STATUS_STRING];
        //[arrAllKeys addObject:LEAD_STATUS_STRING];
    }
    [self.dictTemp setObject:dict forKey:INDUSTRIAL_STRING];
}
-(void)showNote{
       if(self.aContactDetails.note){
        [self.dictTemp setObject:self.aContactDetails.note forKey:NOTE_STRING];
        //[arrAllKeys addObject:NOTE_STRING];
    }
}
-(void)showSocial{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(self.aContactDetails.facebook){
        [dict setObject:self.aContactDetails.facebook forKey:SOCIAL_FACEBOOK];
        //[arrAllKeys addObject:SOCIAL_FACEBOOK];
    }
    if(self.aContactDetails.linkedin){
           [dict setObject:self.aContactDetails.linkedin forKey:SOCIAL_LINKEDIN];
           //[arrAllKeys addObject:SOCIAL_LINKEDIN];
       }
       if(self.aContactDetails.twitter){
           [dict setObject:[ NSString stringWithFormat:@"@%@",self.aContactDetails.twitter] forKey:SOCIAL_TWITTER];
           //[arrAllKeys addObject:SOCIAL_TWITTER];
       }
        if(self.aContactDetails.googlePlus){
            [dict setObject:self.aContactDetails.googlePlus forKey:SOCIAL_GOOGLE_PLUS];
            //[arrAllKeys addObject:SOCIAL_GOOGLE_PLUS];
       }
    [self.dictTemp setObject:dict forKey:SOCIAL_STRING];
}
-(void)showProfileInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(self.aContactDetails.salutation){
        [dict setObject:self.aContactDetails.salutation forKey:SALUTATION_STRING];
        //[arrAllKeys addObject:SALUTATION_STRING];
    }
    if(self.aContactDetails.firstName){
        [lblPersonNmae setText:self.aContactDetails.firstName];
        [dict setObject:self.aContactDetails.firstName forKey:FIRST_NAME_STRING];
        //[arrAllKeys addObject:FIRST_NAME_STRING];
    }
    if(self.aContactDetails.firstNamePh){
        [dict setObject:self.aContactDetails.firstNamePh forKey:PHONETIC_FIRST_STRING];
        //[arrAllKeys addObject:PHONETIC_FIRST_STRING];
    }
    if(self.aContactDetails.middleName){
        [dict setObject:self.aContactDetails.middleName forKey:MIDDLE_NAME_STRING];
        //[arrAllKeys addObject:MIDDLE_NAME_STRING];
    }
    if(self.aContactDetails.middleNamePh){
        [dict setObject:self.aContactDetails.middleNamePh forKey:PHONETIC_MIDDLE_STRING];
        //[arrAllKeys addObject:PHONETIC_MIDDLE_STRING];
    }
    if(self.aContactDetails.lastName){
        [lblPersonNmae setText:[lblPersonNmae.text stringByAppendingFormat:@" %@",self.aContactDetails.lastName]];
        [dict setObject:self.aContactDetails.lastName forKey:LAST_NAME_STRING];
        //[arrAllKeys addObject:LAST_NAME_STRING];
    }
    if(self.aContactDetails.lastNamePh){
        [dict setObject:self.aContactDetails.lastNamePh forKey:PHONETIC_LAST_STRING];
        //[arrAllKeys addObject:PHONETIC_LAST_STRING];
    }
    if(self.aContactDetails.gender){
        [dict setObject:self.aContactDetails.gender forKey:GENDER_STRING];
        //[arrAllKeys addObject:GENDER_STRING];
    }
    if(self.aContactDetails.jobTitle){
        [lblTitle setText:self.aContactDetails.jobTitle];
        [dict setObject:self.aContactDetails.jobTitle forKey:JOBTITLE_STRING];
        //[arrAllKeys addObject:JOBTITLE_STRING];
    }
    if(self.aContactDetails.department){
        [dict setObject:self.aContactDetails.department forKey:DEPARTMENT_STRING];
        //[arrAllKeys addObject:DEPARTMENT_STRING];
    }
    if(self.aContactDetails.organisation){
        [dict setObject:self.aContactDetails.organisation forKey:ORGANIZATION_STRING];
        //[arrAllKeys addObject:ORGANIZATION_STRING];
    }
    if(self.aContactDetails.prefix){
        [dict setObject:self.aContactDetails.prefix forKey:PREFIX_STRING];
        //[arrAllKeys addObject:PREFIX_STRING];
    }
    if(self.aContactDetails.suffix){
        [dict setObject:self.aContactDetails.suffix forKey:SUFFIX_STRING];
        //[arrAllKeys addObject:SUFFIX_STRING];
    }
    if(self.aContactDetails.nickName){
        [dict setObject:self.aContactDetails.nickName forKey:NICKNAME_STRING];
        //[arrAllKeys addObject:NICKNAME_STRING];
    }
    [self.dictTemp setObject:dict forKey:PERSONAL_STRING];
}
- (void)showPersonalDetails{
    self.dictTemp =  [NSMutableDictionary dictionary];
    self.arrAllKeys = [NSMutableArray array];
    NSLog(@"%@",self.aContactDetails);
    [self showProfileInfo];
    [self showPhone];
    [self showEmail];
    [self showURL];
    [self showAddress];
    [self showBirthdayDate];
    [self showDate];
    [self showRelatedName];
    [self showIndustrialInfo];
    [self showNote];
    [self showSocial];
    NSLog(@"%@",self.dictTemp);
}
#pragma mark - fetch follow updates
- (void)fetchFollowUpdate
{
    self.arrFollowUpdate = [NSMutableArray arrayWithArray:[[self.aContactDetails relFollowUpdate] allObjects]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.arrFollowUpdate sortedArrayUsingDescriptors:sortDescriptors];
    
    self.arrFollowUpdate = [NSMutableArray arrayWithArray:sortedArray];
    [tblFollowUpdate reloadData];
    [sortDescriptor release];
}
#pragma mark - SET USER EMAIL
- (void)setUserEmailLabel
{
    /*As per client requirement in place on email ID we need to put company name in this lable*/
   /* NSArray *arrEmails = [[self.aContactDetails relEmails] allObjects];
    
    for (AllEmail *emails in arrEmails)
    {
        if(emails.workURL)
        {
            lblEmailId.text = emails.workURL;
            break;
        }
        else if(emails.homeURL)
        {
            lblEmailId.text = emails.homeURL;
            break;
        }
        
    }*/
    lblEmailId.text = self.aContactDetails.organisation;
    [lblTitle setText:self.aContactDetails.jobTitle];
}
#pragma mark - SET DATE PICKER MINIMUM DATE
- (void)setMinimumPickerDate
{
    [self.dateTimePicker setMinimumDate:[NSDate date]];
}
#pragma mark - Add OR Remove Notificatoin Observers
- (void)addObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter]   addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
    
    [[NSNotificationCenter defaultCenter]   addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]   addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter]   removeObserver:self name:@"changeLayout" object:nil];
    [[NSNotificationCenter defaultCenter]   removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter]   removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - UPDATE INTERFACE METHODS
- (void)updateTableLayouts
{
    [[tblPersonalDetail layer]setCornerRadius:8.0];
    
    [[tblFollowUpdate layer]setCornerRadius:8.0];
    [[tblFollowUpdate layer]setBorderWidth:1.0];
    [[tblFollowUpdate layer]setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    
    [[tblNextStep layer]setCornerRadius:8.0];
    [[tblNextStep layer]setBorderWidth:1.0];
    [[tblNextStep layer]setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

-(void)updateUI:(int)orientation
{
    if (self.dropDownTaskStatus)
    {
        [dropDownTaskStatus closeTableView];
    }

    [self updateHistoryView:orientation];
    [self updateNextStepView:orientation];
    [self updateNextStepProposal:orientation];
    [self updateNextStepTask:orientation];
    [self updateNextStepReminder:orientation];
    [self updateNextStepAppointment:orientation];
    [self updateNextStepEmail:orientation];
    
    [tblPersonalDetail reloadData];
}

- (void)updateHistoryView:(int)orientation
{
    if (orientation <=2)
    {
        [view_history_landscape setHidden:YES];
        [view_history_portrate setHidden:NO];
//        [imgVwHistoryOptionbar setFrame:CGRectMake(0, 0, 596, 65)];
//        [btnHistoryCall setFrame:CGRectMake(24, 8, 132, 49)];
//        [btnHistoryEmail setFrame:CGRectMake(164, 8, 132, 49)];
//        [btnHistoryReminder setFrame:CGRectMake(304, 8, 132, 49)];
//        [btnHistoryEvent setFrame:CGRectMake(444, 8, 132, 49)];
    }
    else
    {
        [view_history_landscape setHidden:NO];
        [view_history_portrate setHidden:YES];
       /* [imgVwHistoryOptionbar setFrame:CGRectMake(0, 0, 852, 65)];
        [btnHistoryCall setFrame:CGRectMake(150, 8, 132, 49)];
        [btnHistoryEmail setFrame:CGRectMake(290, 8, 132, 49)];
        [btnHistoryReminder setFrame:CGRectMake(430, 8, 132, 49)];
        [btnHistoryEvent setFrame:CGRectMake(570, 8, 132, 49)];*/
    }
}
- (void)updateNextStepView:(int)orientation
{
    if (orientation <=2)
    {
        [Next_Step_option_View_Portrate setHidden:NO];
        [Next_Step_option_View_Landscape setHidden:YES];
    }
    else
    {
        [Next_Step_option_View_Portrate setHidden:YES];
        [Next_Step_option_View_Landscape setHidden:NO];
    }
}
- (void)updateNextStepProposal:(int)orientation
{
    if (orientation <= 2)
    {
        [view_add_Proposal setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [view_add_Proposal setFrame:CGRectMake(0, 76, 852, 432)];
    }
}
- (void)updateNextStepEmail:(int)orientation
{
    if (orientation <= 2)
    {
        [view_email_user setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [view_email_user setFrame:CGRectMake(0, 76, 852, 432)];
    }
}
- (void)updateNextStepTask:(int)orientation
{
    if (orientation <= 2)
    {
        [view_add_task setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [view_add_task setFrame:CGRectMake(0, 76, 852, 432)];
    }
}
- (void)updateNextStepReminder:(int)orientation
{
    if (orientation <= 2)
    {
        [view_add_reminder setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [view_add_reminder setFrame:CGRectMake(0, 76, 852, 432)];
    }
}
- (void)updateNextStepAppointment:(int)orientation
{
    if (orientation <= 2)
    {
        [view_add_appointment setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [view_add_appointment setFrame:CGRectMake(0, 76, 852, 432)];
    }
}

#pragma mark -
#pragma mark - Scrollview layout methods

- (BOOL)isProtraitOrientation
{
    UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    if (orientation <=2)
    {
        [self updateHistoryView:orientation];
        return YES;
    }
    return NO;
}

-(float)CompareHightForText:(NSString *)Text WithText2:(NSString *)Text2 Width:(CGFloat)width
{
    CGFloat aHieght = 44;
    
	if (Text && Text2)
    {
        
        CGSize sizeOfRow1 = [Text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height1 = sizeOfRow1.height;
        
        CGSize sizeOfRow2 = [Text2 sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height2 = sizeOfRow2.height;
        
        if (height1 < height2)
        {
            aHieght = height2;
        }
        else
        {
            aHieght = height1;
        }
        
        
    }
    if (aHieght <44)
    {
        return 44.0;
    }
    return aHieght;
}
#pragma mark - IBAction methods
- (IBAction)btnPersonalDetailTapped:(UIButton*)sender
{
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    [history_View removeFromSuperview];
 
    if (btnHistory.isSelected)
    {
        [btnHistory setSelected:NO];
    }
    if (btnPersonalDetails.selected == NO)
    {
        sender.selected = !sender.selected;
        [next_step_View removeFromSuperview];
    }
}
- (IBAction)btnNextStepTapped:(UIButton*)sender
{
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    [self btnViewAllTapped:nil];
    self.NEXT_STEP_OPTION = FOLLOW_UPDATE;
//    btnPersonalDetails.selected = !btnPersonalDetails.selected;
    [btnHistory setSelected:NO];
    [btnPersonalDetails setSelected:NO];
    [next_step_View setFrame:CGRectMake(0, 158, 852, 511)];
    [next_step_View setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if ([self isProtraitOrientation])
    {
        [next_step_View setFrame:CGRectMake(0, 158, 599, 766)];
    }
    UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    [self updateNextStepView:orientation];
    
    [scrMainScrollView addSubview:next_step_View];
    
    self.NEXT_STEP_OPTION = FOLLOW_UPDATE;
//    self.arrFollowUpdate = [NSArray arrayWithArray:[[self.aContactDetails relFollowUpdate] allObjects]];
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
//                                                                   ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *sortedArray = [self.arrFollowUpdate sortedArrayUsingDescriptors:sortDescriptors];
//
//    self.arrFollowUpdate = [NSMutableArray arrayWithArray:sortedArray];
//    [tblNextStep reloadData];
//    [sortDescriptor release];
    
}
- (IBAction)btnViewAllTapped:(id)sender
{
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    [self resetNextStepOptions];
    self.NEXT_STEP_OPTION = FOLLOW_UPDATE;
    self.arrFollowUpdate = [NSMutableArray arrayWithArray:[[self.aContactDetails relFollowUpdate] allObjects]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [self.arrFollowUpdate sortedArrayUsingDescriptors:sortDescriptors];
    
    self.arrFollowUpdate = [NSMutableArray arrayWithArray:sortedArray];
    [tblNextStep reloadData];
    [sortDescriptor release];
}

- (IBAction)btnNextStep_Option_Tapped:(UIButton*)sender
{
    if (btnCallUser.selected)
    {
        [view_call_user removeFromSuperview];
    }
    if (sender.tag != 3)
    {
        for (UIView *aview in view_email_user.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
//                if(txt.tag == 1)
//                {txt.text = @"";}
                [txt setDelegate:self];
            }
            else if([aview isKindOfClass:[UITextView class]])
            {
//                UITextView *txt = (UITextView*)aview;
//                txt.text = @"";
            }
            else if([aview isKindOfClass:[UILabel class]])
            {
                UILabel *txt = (UILabel*)aview;
                if(txt.tag == 1)
                {
//                    txt.text = @"";
                }
            }
        }
    }
    [self resetNextStepOptions];
    [self setSelectesNextStepOption:sender.tag];
}

- (void)resetNextStepOptions
{
    [self removeInformationViews];
    
    [btnCallUser setSelected:NO];
    [btnProposal setSelected:NO];
    [btnEmail setSelected:NO];
    [btnTask setSelected:NO];
    [btnReminder setSelected:NO];
    [btnAppointment setSelected:NO];
    
    [btnCallUser_P setSelected:NO];
    [btnProposal_P setSelected:NO];
    [btnEmail_P setSelected:NO];
    [btnTask_P setSelected:NO];
    [btnAppointment_P setSelected:NO];
    [btnReminder_P setSelected:NO];
}
- (void)removeInformationViews
{
    [view_add_appointment   removeFromSuperview];
    [view_add_Proposal      removeFromSuperview];
    [view_add_reminder      removeFromSuperview];
    [view_add_task          removeFromSuperview];
    [view_call_user         removeFromSuperview];
    [view_email_user        removeFromSuperview];
    
}
- (void)setSelectesNextStepOption:(int)option
{
    if(self.arrTaskList != nil)             {  [arrTaskList release];          arrTaskList = nil;           }
    if(self.arrProposalList != nil)         {  [arrProposalList release];      arrProposalList = nil;       }
    if(self.arrAppointmentList != nil)      {  [arrAppointmentList release];   arrAppointmentList = nil;    }
    if(self.arrReminderList != nil)         {  [arrReminderList release];      arrReminderList = nil;       }
    if(self.arrScriptList != nil)           {  [arrScriptList release];      arrScriptList = nil;           }
    if(self.arrProductList != nil)          {  [arrProductList release];      arrProductList = nil;         }
    
    if(self.datePickerPopover != nil)       {  [datePickerPopover release];          datePickerPopover = nil;           }
    if(self.contactListPopover != nil)      {  [contactListPopover release];         contactListPopover = nil;           }
    if(self.productListPopover != nil)      {  [productListPopover release];         productListPopover = nil;           }
    if(self.popoverSelectFirstLine != nil)  {  [popoverSelectFirstLine release];     popoverSelectFirstLine = nil;           }
    if(self.popoverEmails != nil)           {  [popoverEmails release];              popoverEmails = nil;           }
    
    switch (option)
    {
        case 1:
            //Flurry
			[AppDelegate setFlurryWithText:@"Contact Details CallUser"];

            [btnCallUser setSelected:YES];
            [btnCallUser_P setSelected:YES];
            [self btnCallUserTapped:nil];
            break;
        case 2:
            //Flurry
			[AppDelegate setFlurryWithText:@"Contact Details Proposal"];
            //Flurry

            [btnProposal setSelected:YES];
            [btnProposal_P setSelected:YES];
            
            self.NEXT_STEP_OPTION = NS_PROPOSAL;
            self.arrProposalList = [NSMutableArray arrayWithArray:[[self.aContactDetails relProposal] allObjects]];
            [tblNextStep reloadData];
            [view_add_Proposal removeFromSuperview];
            [self reset_proposal];
            break;
        case 3:
            //Flurry
            [AppDelegate setFlurryWithText:@"Contact Details Email"];
 
            [btnEmail setSelected:YES];
            [btnEmail_P setSelected:YES];
            [self btnAddEmail_Tapped:nil];
            break;
        case 4:
            //Flurry
			[AppDelegate setFlurryWithText:@"Contact Details Task"];

            [btnTask setSelected:YES];
            [btnTask_P setSelected:YES];
            
            self.NEXT_STEP_OPTION = NS_TASK;
            self.arrTaskList = [NSMutableArray arrayWithArray:[[self.aContactDetails relTask] allObjects]];
            [tblNextStep reloadData];
//            [view_add_Proposal removeFromSuperview];
            break;
        case 5:
            //Flurry
			[AppDelegate setFlurryWithText:@"Contact Details Appointment"];

            [btnAppointment setSelected:YES];
            [btnAppointment_P setSelected:YES];
            self.NEXT_STEP_OPTION = NS_APPOINTMENT;
            self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
            [tblNextStep reloadData];
            break;
        case 6:
            //Flurry
			[AppDelegate setFlurryWithText:@"Contact Details Reminder"];
            
            [btnReminder setSelected:YES];
            [btnReminder_P setSelected:YES];
            self.NEXT_STEP_OPTION = NS_REMINDER;
            self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
            [tblNextStep reloadData];
            break;
        default:
            break;
    }

}
#pragma mark - History View methods
- (IBAction)btnHistory_Option_Tapped:(UIButton*)sender
{
    
    //    for my information in future
    //    btnHistoryCall                =  11 tag value
    //    btnHistoryEmail               =  13 tag value
    //    btnHistoryReminder            =  14 tag value
    //    btnHistoryAppointment         =  12 tag value
    
    if(sender.selected == NO)
    {
        [tblHistory setHidden:YES];
        [history_Option_List_View setHidden:NO];
        [self resetHistoryOptions];
        self.historySelectedOption = sender.tag;
        [self setSelectesHistoryOption:sender.tag];
    }
}
- (void)resetHistoryOptions
{
    [btnHistoryCall     setSelected:NO];
    [btnHistoryEmail    setSelected:NO];
    [btnHistoryReminder setSelected:NO];
    [btnHistoryEvent    setSelected:NO];
    [btnHistoryTimeLine setSelected:NO];
    
    [btnHistoryCall_p       setSelected:NO];
    [btnHistoryEmail_p      setSelected:NO];
    [btnHistoryReminder_p   setSelected:NO];
    [btnHistoryEvent_p      setSelected:NO];
    [btnHistoryTimeLine_p   setSelected:NO];
}
- (void)setSelectesHistoryOption:(int)option
{
    isTimelineTap = NO;
    [History_Desc_RE_View removeFromSuperview];
    
    if(self.arrAppointmentList != nil)      {  [arrAppointmentList release];    arrAppointmentList = nil;    }
    if(self.arrReminderList != nil)         {  [arrReminderList release];       arrReminderList = nil;       }
    if(self.arrHisOptionData != nil)        {  [arrHisOptionData release];      arrHisOptionData = nil;      }
    if(self.dictTimeLineList != nil)         {  [dictTimeLineList release];       dictTimeLineList = nil;       }
    
       switch (option) {
        case 11:
                [btnHistoryCall setSelected:YES];
                [btnHistoryCall_p setSelected:YES];
                [lblHistoryOptionTitle setText:@"Call History"];
                self.arrHisOptionData = [NSMutableArray arrayWithArray:[[self.aContactDetails relNotes] allObjects]];
                break;
        case 12:
                [btnHistoryEvent setSelected:YES];
                [btnHistoryEvent_p setSelected:YES];
                [lblHistoryOptionTitle setText:@"Appointment History"];
                self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
            
                break;
        case 13:
                [btnHistoryEmail setSelected:YES];
                [btnHistoryEmail_p setSelected:YES];
                [lblHistoryOptionTitle setText:@"Email History"];
                self.arrHisOptionData = [NSMutableArray arrayWithArray:[[self.aContactDetails relEmailList] allObjects]];
                break;
        case 14:
                [btnHistoryReminder setSelected:YES];
                [btnHistoryReminder_p setSelected:YES];
                [lblHistoryOptionTitle setText:@"Reminder History"];
                self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
                break;
        case 15:
               isTimelineTap = YES;
               [btnHistoryTimeLine setSelected:YES];
               [btnHistoryTimeLine_p setSelected:YES];
               [lblHistoryOptionTitle setText:@"Time Line List"];
               
               NSArray *arrayValues = [NSArray arrayWithObjects:[[self.aContactDetails relNotes]        allObjects],
                                                                [[self.aContactDetails relAppointment]  allObjects],
                                                                [[self.aContactDetails relEmailList]    allObjects],
                                                                [[self.aContactDetails relReminder]     allObjects],
                                                                nil];
               
               NSArray *arrayKeys = [NSArray arrayWithObjects:@"0",@"1", @"2",@"3",nil];
               
               self.dictTimeLineList = [NSMutableDictionary dictionaryWithObjects:arrayValues forKeys:arrayKeys];
               break;
        default:
            break;
    }
    
    //flurry
	NSString * string = [NSString stringWithFormat:@"Contact View History %@",lblHistoryOptionTitle.text];
	[AppDelegate setFlurryWithText:string];
    
    [tblHistoryOption reloadData];
    [self btnHistoryOptions_List];
    
}
- (void)btnHistoryOptions_List
{
    UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    [history_Option_List_View removeFromSuperview];
    if (orientation <=2)
    {
        
        [history_Option_List_View setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height+10, 599, 690)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.33];
        [history_Option_List_View setFrame:CGRectMake(0, 76, 599, 690)];
        [UIView commitAnimations];
    }
    else
    {
        
        [history_Option_List_View setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height+10, 852, 432)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.33];
        [history_Option_List_View setFrame:CGRectMake(0, 76, 852, 432)];
        [UIView commitAnimations];
    }
    [history_Option_List_View setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [history_View addSubview:history_Option_List_View];
}
- (IBAction)btnHistoryTapped:(UIButton*)sender
{
    [[tblHistory layer]setCornerRadius:8.0];
    [[tblHistory layer]setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[tblHistory layer]setBorderWidth:1.0];
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    if (btnPersonalDetails.isSelected)
    {
        [btnPersonalDetails setSelected:NO];
    }
    if(btnHistory.selected == NO)
    {
        sender.selected = !sender.selected;
    }
    else
    {
        [self resetHistoryOptions];
        [history_Option_List_View setHidden:YES];
        [tblHistory        setHidden:NO];
    }
    self.arrProposalList = [NSMutableArray arrayWithArray:[[self.aContactDetails relProposal] allObjects]];
    [tblHistory reloadData];
    [history_View setFrame:CGRectMake(0, 158, 852, 515)];
    [history_View setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if ([self isProtraitOrientation])
    {
        [history_View setFrame:CGRectMake(0, 158, 599, 755)];
    }
    [scrMainScrollView addSubview:history_View];
}
#pragma mark - Call USer Methods
- (void)btnCallUserTapped:(id)sender
{
    [txtVwCallNote setPlaceholderText:@"Enter Note Description"];
    [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    
    self.arrScriptList = [CoreDataHelper getObjectsForEntity:@"ScriptList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    [tblScriptCallUser reloadData];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_call_user setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [view_call_user setFrame:CGRectMake(0, 76, 852, 432)];
    }
    UIImage *image = [UIImage imageNamed:@"call_user_box.png"];
    image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:60];
    imgVwNoteFrame.image = image;
    imgVwScriptFrame.image = image;
    [next_step_View addSubview:view_call_user];
}
- (IBAction)btnShowList:(id)sender
{
    [btnScriptList setHidden:YES];
    [btnViewScriptList setHidden:YES]; //
    [view_script_call setHidden:NO];
    [view_note_call setFrame:CGRectMake(view_script_call.frame.size.width+12, 0, view_script_call.frame.size.width, view_script_call.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"call_user_box.png"];
    image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:60];
    [imgVwNoteFrame setImage:image];
    [tblScriptCallUser setHidden:NO];
    [txtvScriptCallUser setHidden:YES];
}
- (IBAction)btnCrossOnScriptDetail:(id)sender
{
    [btnViewScriptList setHidden:NO];
    [view_script_call setHidden:YES];
    [view_note_call setFrame:CGRectMake(0, 0, view_call_user.frame.size.width, view_call_user.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"big_box.png"];
    image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:60];
    [imgVwNoteFrame setImage:image];
}

#pragma mark - Notes methods
- (IBAction)btnDoneAddNoteTapped:(id)sender
{
    if ([txtVwCallNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
    {
        NotesList *aNote = (NotesList *)[NSEntityDescription insertNewObjectForEntityForName:@"NotesList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        NSDate *date = [NSDate date];
        NSTimeInterval ti = [date timeIntervalSince1970];
        [aNote setNoteDesc:[txtVwCallNote.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [aNote setNoteDate:date];
        [aNote setTimeStamp:ti];
        [aNote setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [self.aContactDetails setLastActivityDate:[NSDate date]];
        [aNote setRelMyAddressBook:self.aContactDetails];
        
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Note saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        [txtVwCallNote setText:@""];
        [btnSaveNote setHidden:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your note" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}
#pragma mark -
#pragma mark - Proposal methods
- (IBAction)btnAddProposal_Tapped:(id)sender
{
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [view_add_Proposal layer].cornerRadius = 8.0;
    [view_add_Proposal layer].borderWidth  = .5;
    [[view_add_Proposal layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (orientation <= 2)
    {
        [view_add_Proposal setFrame:CGRectMake(0, 76, 596, 690)];
        [next_step_View addSubview:view_add_Proposal];
    }
    else
    {
        [view_add_Proposal setFrame:CGRectMake(0, 76, 852, 432)];
        [next_step_View addSubview:view_add_Proposal];
    }
    [lblProposal setText:@"Add New Proposal"];
    
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
        
    }

    self.strDropDownItem = nil;
    [self generateDropDown:DROPDOWNPRODUCT];
    [self downloadDropDownData:DROPDOWNPRODUCT];
}
-(void)btnCheckProduct:(UIButton*)sender
{
    ProductList *aProduct = [self.arrProductList objectAtIndex:sender.tag];
    
    if ([aProduct.quantity integerValue] == 0)
    {
        [aProduct setQuantity:[NSNumber numberWithInt:1]];
    }
    sender.selected = !sender.selected;
    
    [aProduct setIsSelected:sender.selected];
    [tblProductList reloadData];
    
    float total = 0;
    for (ProductList *aProduct in self.arrProductList)
    {
        if (aProduct.isSelected)
        {
            NSLog(@"%f",[[Global convertPriceBackToNumbersWithPriceText:aProduct.price] floatValue]);
            NSLog(@"%d",[aProduct.quantity integerValue]);
            total = total + [[Global convertPriceBackToNumbersWithPriceText:aProduct.price] floatValue] * [aProduct.quantity integerValue];
        }
    }
    
    
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            
            if (txt.tag == 2)
            {
                if(total > 0)
                {
                    txt.text = [Global convertStringToNumberFormatter:[NSString stringWithFormat:@"%f",total] withDollerSign:YES];
                }
                else
                {
                    txt.text = @"";
                }
                
                break;
            }
            
        }
    }
}
-(IBAction)btnProposalDropDown:(UIButton*)sender
{
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
               [txt resignFirstResponder];
        }
        else if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            [txt resignFirstResponder];
        }
    }
    
    self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    if (isEditing)
    {
        ProposalList *aProposal= [self.arrProposalList objectAtIndex:self.editItemTag];
        if(aProposal.proposalProducts)
        {
            NSArray *products = [aProposal.proposalProducts componentsSeparatedByString:@","];
            NSArray *quantities = [aProposal.productQuantities componentsSeparatedByString:@","];
            for (int i =0; i < [self.arrProductList count]; i++)
            {
                ProductList *aProduct = [self.arrProductList objectAtIndex:i];
                if ([products containsObject:aProduct.productName])
                {
                    
                    [aProduct setIsSelected:YES];
                    [aProduct setQuantity:[NSNumber numberWithInt:[[quantities objectAtIndex:[products indexOfObject:aProduct.productName]] integerValue]]];
                    
                }
                else
                {
                    [aProduct setIsSelected:NO];
                }
            }
        }
    }
    
    //show popover
    if(self.productListPopover == nil)
    {
        UIViewController *vcSelectLine = [[UIViewController alloc]init];
        
        vcSelectLine.view = view_proposal_DD;
        
        [vcSelectLine setContentSizeForViewInPopover:view_proposal_DD.frame.size];
        
        self.productListPopover = [[[UIPopoverController alloc]initWithContentViewController:vcSelectLine] autorelease];
        
        
        [vcSelectLine release];
    }
    [tblProductList reloadData];
    
    CGRect rect = [sender convertRect:sender.bounds toView:view_add_Proposal];
    
    [self.productListPopover presentPopoverFromRect:rect inView:view_add_Proposal permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)btnShowPicker:(UIButton*)sender
{
    for (UIView *view in sender.superview.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)view;
            if ([txt isFirstResponder])
            {
                [txt resignFirstResponder];
                break;
            }
        }
    }
    [self.dateTimePicker setDatePickerMode:UIDatePickerModeDate];
    if(sender.superview == view_add_reminder)
        [self.dateTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
    
    self.dateBtnTag = sender.tag;
    if(self.datePickerPopover == nil)
    {
        UIViewController *datePickerVC = [[UIViewController alloc]init];
        
        datePickerVC.view = view_date_picker;
        
        [datePickerVC setContentSizeForViewInPopover:view_date_picker.frame.size];
        
        self.datePickerPopover = [[[UIPopoverController alloc]initWithContentViewController:datePickerVC] autorelease];
        
        [datePickerVC release];
    }
    UIButton *btn = (UIButton*)sender;
    if(btn.superview == view_add_Proposal)
    {
        [self.datePickerPopover presentPopoverFromRect:sender.frame inView:view_add_Proposal permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(btn.superview == view_add_appointment)
    {
        [self.datePickerPopover presentPopoverFromRect:sender.frame inView:view_add_appointment permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(btn.superview == view_add_reminder)
    {
        [self.datePickerPopover presentPopoverFromRect:sender.frame inView:view_add_reminder permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else if(btn.superview == view_add_task)
    {
        [self.datePickerPopover presentPopoverFromRect:sender.frame inView:view_add_task permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}
- (IBAction)btnDoneToolBar:(id)sender
{
    if ([self.NEXT_STEP_OPTION isEqualToString:NS_PROPOSAL])
    {
        for (UIView *aview in view_add_Proposal.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 3 && self.dateBtnTag == 101)
                {
                    txt.text = [NSDateFormatter localizedStringFromDate:self.dateTimePicker.date
                                                                                 dateStyle:NSDateFormatterShortStyle
                                                                                 timeStyle:NSDateFormatterNoStyle];
                    self.editItemTag = nil;
                    break;
                }
                else if (txt.tag == 4 && self.dateBtnTag == 102)
                {
                    txt.text = [NSDateFormatter localizedStringFromDate:self.dateTimePicker.date
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
                    self.editItemTag = nil;
                    break;
                }
                
            }
        }
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:NS_APPOINTMENT])
    {
        
        for (UIView *aview in view_add_appointment.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 2)
                {
                    txt.text = [NSDateFormatter localizedStringFromDate:self.dateTimePicker.date
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
                    break;
                }
                
            }
        }
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:NS_REMINDER])
    {
        
        for (UIView *aview in view_add_reminder.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 5)
                {
                    txt.text = [NSDateFormatter localizedStringFromDate:self.dateTimePicker.date
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
                    break;
                }
                
            }
        }
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:NS_TASK])
    {
        
        for (UIView *aview in view_add_task.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 3)
                {
                    txt.text = [NSDateFormatter localizedStringFromDate:self.dateTimePicker.date
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
                    break;
                }
                
            }
        }
    }
    [self.datePickerPopover dismissPopoverAnimated:YES];
    
}
- (void)saveNS_proposal
{
    NSString *message = nil;
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter proposal number.";
                if (txt.tag == 2)   message = @"Please enter proposal price.";
                if (txt.tag == 3)   message = @"Please enter proposal date.";
                if (txt.tag == 4)   message = @"Please enter target close date.";
                break;
            }
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
//                message = @"Please enter proposal note.";
                break;
            }
            
        }
        
    }
    if(self.strDropDownItem == nil || [self.strDropDownItem rangeOfString:@"Pipeline Stage" options:NSCaseInsensitiveSearch].length)
    {
        if(message == nil) message = @"Please select pipeline stage.";
    }
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        ProposalList *aProposalList = (ProposalList *)[NSEntityDescription insertNewObjectForEntityForName:@"ProposalList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_Proposal.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 1)
                {
                    [aProposalList setProposalNumber:txt.text];
                    
                }
                else if (txt.tag == 2)
                {
                    [aProposalList setProposalPrice:[Global convertPriceBackToNumbersWithPriceText:txt.text]];
                    
                }
                else if (txt.tag == 3)
                {
                    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                    [DateFormatter setDateStyle:NSDateFormatterShortStyle];
                    [aProposalList setProposalDate:[DateFormatter dateFromString:txt.text]];
                    [DateFormatter release];
                    
                }
                else if (txt.tag == 4)
                {
                    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                    [DateFormatter setDateStyle:NSDateFormatterShortStyle];
                    [aProposalList setProposalTargetDate:[DateFormatter dateFromString:txt.text]];
                    [DateFormatter release];
                    
                }
            }
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                {
                    [aProposalList setNote:txt.text];
                }
                
            }
             
        }
        [self.aContactDetails setLastActivityDate:[NSDate date]];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stageName == %@",self.strDropDownItem];
		
		NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		
		if ([array count])
		{
			FunnelStageList * funnalStage = [array lastObject];
			            
            if (self.aContactDetails.funnelStageID.length && self.aContactDetails.funnelStageID)
            {
                if ([self.aContactDetails.funnelStageID rangeOfString:funnalStage.stageName options:NSCaseInsensitiveSearch].length == 0) //stage not found
                {
                    self.aContactDetails.funnelStageID = [self.aContactDetails.funnelStageID stringByAppendingFormat:@",%@",funnalStage.stageName];
                }
                
            }
            else
            {
                self.aContactDetails.funnelStageID = [NSString stringWithFormat:@"%@",funnalStage.stageName];
            }
            
            [aProposalList setFunnelStage:funnalStage.stageName];
		}
        
        NSString *productList = nil;
        NSString *productQuantities = nil;
        for (ProductList *aProduct in self.arrProductList)
        {
            if (aProduct.isSelected)
            {
                aProduct.isSelected = !aProduct.isSelected;
                
                if (productList)
                {
                    productList = [productList stringByAppendingFormat:@",%@",aProduct.productName];
                    productQuantities = [productQuantities stringByAppendingFormat:@",%d",[aProduct.quantity integerValue]];
                }
                else
                {
                    productList = aProduct.productName;
                    productQuantities = [aProduct.quantity stringValue];
                }
            }
        }
        
        if(productList)
        [aProposalList setProposalProducts:productList];
        [aProposalList setProductQuantities:productQuantities];
        [aProposalList setTimeStamp:[[NSDate date] timeIntervalSince1970]];
        [aProposalList setRelMyAddressBook:self.aContactDetails];
        [aProposalList setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrProposalList = [NSMutableArray arrayWithArray:[[self.aContactDetails relProposal] allObjects]];
        [tblNextStep reloadData];
        [self reset_proposal];
    }
}
- (void)editProposal:(UIButton*)sender
{
    [AppDelegate setFlurryWithText:@"Contact View edit Proposal"];
    
    isEditing = YES;
    self.editItemTag = sender.tag;
    ProposalList *aProposal= [self.arrProposalList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aProposal.proposalNumber;
            }
            else if (txt.tag == 2)
            {
                txt.text = [Global convertStringToNumberFormatter:aProposal.proposalPrice withDollerSign:YES];
            }
            else if (txt.tag == 3)
            {
                txt.text = [NSDateFormatter localizedStringFromDate:aProposal.proposalDate
                                            dateStyle:NSDateFormatterShortStyle
                                            timeStyle:NSDateFormatterNoStyle];;
            }
            else if (txt.tag == 4)
            {
                txt.text = [NSDateFormatter localizedStringFromDate:aProposal.proposalTargetDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];;
            }
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = aProposal.note;
        }
    }
    [self btnAddProposal_Tapped:nil];
    NSArray *tempArr = [CoreDataHelper getObjectsForEntity:@"FunnelStageList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    for (int i =0 ; i < [tempArr count] ; i++)
    {
        FunnelStageList *funnel = [tempArr objectAtIndex:i];
        if ([aProposal.funnelStage isEqualToString:funnel.stageName])
        {
            self.strDropDownItem = funnel.stageName;
            
            NSArray *tempArr = @[@"Suspect",@"Prospect",@"Opportunity",@"Customer Won",@"Customer Lost",@"Customer Cancel"];
            
            for (int i =0; i < [tempArr count] ; i++)
            {
                if ([self.strDropDownItem isEqualToString:[tempArr objectAtIndex:i]])
                {
                    [self.dropDownTaskStatus setSelectedIndex:i];
                    break;
                }
            }
            break;
        }
    }
    
    [lblProposal setText:@"Edit Proposal"];
    

}
- (void)reset_proposal
{
    NSArray *products = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    for (ProductList *aProduct in products)
    {
        [aProduct setIsSelected:NO];
        [aProduct setQuantity:[NSNumber numberWithInt:1]];
    }
    [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            txt.text = @"";
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";            
        }
        
    }
    [self.dropDownTaskStatus removeFromSuperview];
    [view_add_Proposal removeFromSuperview];
}
- (void)updatePropoal
{
    //Flurry
	[AppDelegate setFlurryWithText:@"Contact View Update proposal"];
    
    ProposalList *aProposalList= [self.arrProposalList objectAtIndex:self.editItemTag];
    NSString *message = nil;
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length ==0)
            {
                if (txt.tag == 1)   message = @"Please enter proposal number.";
                if (txt.tag == 2)   message = @"Please enter proposal price.";
                if (txt.tag == 3)   message = @"Please enter proposal date.";
                if (txt.tag == 4)   message = @"Please enter target close date.";
                break;
            }
            if (txt.tag == 1)
            {
                [aProposalList setProposalNumber:txt.text];
            }
            else if (txt.tag == 2)
            {
                
                [aProposalList setProposalPrice:[[Global convertStringToNumberFormatter:txt.text withDollerSign:NO] stringByReplacingOccurrencesOfString:@"," withString:@""]];
            }
            else if (txt.tag == 3)
            {
                NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                [DateFormatter setDateStyle:NSDateFormatterShortStyle];
                [aProposalList setProposalDate:[DateFormatter dateFromString:txt.text]];
                [DateFormatter release];
                
            }
            else if (txt.tag == 4)
            {
                NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                [DateFormatter setDateStyle:NSDateFormatterShortStyle];
                [aProposalList setProposalTargetDate:[DateFormatter dateFromString:txt.text]];
                [DateFormatter release];
                
            }
        }
        
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aProposalList setNote:txt.text];
            }
            else
            {
//                message = @"Please enter proposal note.";
            }
            
        }
    }
    if([self.arrProductList count] == 0)
        self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stageName == %@",self.strDropDownItem];
    
    NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    if ([array count])
    {
        FunnelStageList * funnalStage = [array lastObject];
        
        NSLog(@"%@",[self.aContactDetails.relProposal allObjects]);
        NSLog(@"%@",[NSPredicate predicateWithFormat:@"funnelStage contains[cd] %@",aProposalList.funnelStage]);
        NSArray *checkForLastStage = [[self.aContactDetails.relProposal allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"funnelStage == %@",aProposalList.funnelStage]];
        
        if ([checkForLastStage count] == 1 || [checkForLastStage count] == 0)//check for not more than one proposal with same stage of a user
        {
            //replace
            self.aContactDetails.funnelStageID = [self.aContactDetails.funnelStageID stringByReplacingOccurrencesOfString:aProposalList.funnelStage withString:funnalStage.stageName];
        }
        else
        {
            //update by adding new stage
            self.aContactDetails.funnelStageID = [self.aContactDetails.funnelStageID stringByAppendingFormat:@",%@",funnalStage.stageName];
        }
        [aProposalList setFunnelStage:funnalStage.stageName];
        
    }
    NSString *productList = nil;
    NSString *productQuantities = nil;
    for (ProductList *aProduct in self.arrProductList)
    {
        if (aProduct.isSelected)
        {
            aProduct.isSelected = !aProduct.isSelected;                                                                      
            
            if (productList)
            {
                productList = [productList stringByAppendingFormat:@",%@",aProduct.productName];
                productQuantities = [productQuantities stringByAppendingFormat:@",%d",[aProduct.quantity integerValue]];
            }
            else
            {
                productList = aProduct.productName;
                productQuantities = [aProduct.quantity stringValue];
            }
        }
    }
    if(productList)
        [aProposalList setProposalProducts:productList];
    if(productQuantities)
        [aProposalList setProductQuantities:productQuantities];
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:101];
        [alert show];
        [alert release];
    }
    else
    {
        [aProposalList setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrProposalList = [NSMutableArray arrayWithArray:[[self.aContactDetails relProposal] allObjects]];
        [tblNextStep reloadData];
        
        [self reset_proposal];
    }
    
}
- (void)deleteProposal:(UIButton*)sender
{
    
    
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete proposal?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1002];
    [anAlertView show];
    [anAlertView release];
    
}
#pragma mark - task methods
- (IBAction)btnAddTask_Tapped:(id)sender
{
    if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    [self.dropDownTaskStatus removeFromSuperview];
    self.strDropDownItem = nil;
    [lbltask setText:@"Add New task"];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [view_add_task layer].cornerRadius = 8.0;
    [view_add_task layer].borderWidth  = .5;
    [[view_add_task layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (orientation <= 2)
    {
        [view_add_task setFrame:CGRectMake(0, 76, 596, 690)];
        [next_step_View addSubview:view_add_task];
    }
    else
    {
        [view_add_task setFrame:CGRectMake(0, 76, 852, 432)];
        [next_step_View addSubview:view_add_task];
    }
    for (UIView *aview in view_add_task.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
        
    }
    [self generateDropDown:DROPDOWNTASK];
    [self downloadDropDownData:DROPDOWNTASK];
}
- (void)saveNS_Task
{
    NSString *message = nil;
    for (UIView *aview in view_add_task.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter task name.";
                if (txt.tag == 2)   message = @"Please enter task description.";
                if (txt.tag == 3)   message = @"Please enter task due date.";
                break;
            }
        }
        
    }
    if(self.strDropDownItem == nil || [self.strDropDownItem rangeOfString:@"Select Status" options:NSCaseInsensitiveSearch].length)
    {
        if(message == nil) message = @"Please select task status.";
    }
    
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        TaskList *aTaskList = (TaskList *)[NSEntityDescription insertNewObjectForEntityForName:@"TaskList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_task.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 1)
                {
                    [aTaskList setTaskName:txt.text];
                }
                else if (txt.tag == 2)
                {
                    [aTaskList setTaskDesc:txt.text];
                }
                else if (txt.tag == 3)
                {
                    [aTaskList setDueDate:self.dateTimePicker.date];
                }
                
            }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aTaskList setNote:txt.text];
            }
            
        }
        
        }
        [self.aContactDetails setLastActivityDate:[NSDate date]];
        [aTaskList setTaskStatus:self.strDropDownItem];
        [aTaskList setRelMyAddressBook:self.aContactDetails];
        [aTaskList setTimeStamp:[[NSDate date] timeIntervalSince1970]];
        [aTaskList setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        //Create iCal task
        [((AppDelegate*)CRM_AppDelegate) saveEventForTask:aTaskList];
        
        self.arrTaskList = [NSMutableArray arrayWithArray:[[self.aContactDetails relTask] allObjects]];
        [tblNextStep reloadData];
        [self reset_Task];
    }
}
- (void)reset_Task
{
    for (UIView *aview in view_add_task.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            txt.text = @"";
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";
        }
    }
    [view_add_task removeFromSuperview];
    [self.dropDownTaskStatus removeFromSuperview];
}
- (void)edittask:(UIButton*)sender
{
    [self btnAddTask_Tapped:nil];
    
    isEditing = YES;
    self.editItemTag = sender.tag;
    TaskList *aTask= [self.arrTaskList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_task.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aTask.taskName;
            }
            else if (txt.tag == 2)
            {
                txt.text = aTask.taskDesc;
            }
            else if (txt.tag == 3)
            {
                txt.text = [NSDateFormatter localizedStringFromDate:aTask.dueDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
                self.dateTimePicker.date = aTask.dueDate;
            }
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = aTask.note;
        }
    }
    NSArray *tempArr = [NSArray arrayWithObjects:@"Open",@"Running",@"Closed",nil];
    for (int i = 0; i < [tempArr count]; i++)
    {
        
        if ([aTask.taskStatus isEqualToString:[tempArr objectAtIndex:i]])
        {
            self.strDropDownItem = aTask.taskStatus;
            [self.dropDownTaskStatus setSelectedIndex:i];
            break;
        }
    }
    
    [lbltask setText:@"Edit Task"];
}
- (void)updateTask
{
    TaskList *aTask= [self.arrTaskList objectAtIndex:self.editItemTag];
    NSString *message = nil;
    
    for (UIView *aview in view_add_task.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter task name.";
                if (txt.tag == 2)   message = @"Please enter task description.";
                if (txt.tag == 3)   message = @"Please enter task due date.";
                break;
            }
            if (txt.tag == 1)
            {
                [aTask setTaskName:txt.text];
            }
            else if (txt.tag == 2)
            {
                [aTask setTaskDesc:txt.text];
            }
            else if (txt.tag == 3)
            {
                [aTask setDueDate:self.dateTimePicker.date];
            }
            
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aTask setNote:txt.text];
            }
            else
            {
                //                message = @"Please enter proposal note.";
            }
            
        }
        
    }
    if(self.strDropDownItem == nil) message = @"Please select task status.";
    [aTask setTaskStatus:self.strDropDownItem];
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:101];
        [alert show];
        [alert release];
    }
    else
    {
        [aTask setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrTaskList = [NSMutableArray arrayWithArray:[[self.aContactDetails relTask] allObjects]];
        [tblNextStep reloadData];
        
        [self reset_Task];
    }
}
- (void)deleteTask:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete task?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1004];
    [anAlertView show];
    [anAlertView release];
    
}
#pragma mark -
#pragma mark - Appointment methods
- (IBAction)btnAddAppointment_Tapped:(id)sender
{
    
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    
    [lblAppointment setText:@"Add New Appointment"];
    [self.dateTimePicker setDate:[NSDate date]];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [view_add_appointment layer].cornerRadius = 8.0;
    [view_add_appointment layer].borderWidth  = .5;
    [[view_add_appointment layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (orientation <= 2)
    {
        [view_add_appointment setFrame:CGRectMake(0, 76, 596, 690)];
        [next_step_View addSubview:view_add_appointment];
    }
    else
    {
        [view_add_appointment setFrame:CGRectMake(0, 76, 852, 432)];
        [next_step_View addSubview:view_add_appointment];
    }
    for (UIView *aview in view_add_appointment.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
            break;
        }
        
    }
}
- (void)saveNS_Appointment
{
    NSString * message = nil;
    for (UIView *aview in view_add_appointment.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter appointment title.";
                if (txt.tag == 2)   message = @"Please enter appointment date.";
//                if (txt.tag == 3)   message = @"Please enter appointment description.";
                break;
            }
        }
        /*if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                message = @"Please enter appointment note.";
//                break;
            }
            
        }*/
    }

    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        AppointmentList *aAppointmentList = (AppointmentList *)[NSEntityDescription insertNewObjectForEntityForName:@"AppointmentList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_appointment.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 1)
                {
                    [aAppointmentList setTitle:txt.text];
                }
                if (txt.tag == 3)
                {
                    [aAppointmentList setDesc:txt.text];
                }
                
            }
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                {
                    [aAppointmentList setNote:txt.text];
                }
                
            }
            
        }
        [self.aContactDetails setLastActivityDate:[NSDate date]];
        [aAppointmentList setDate:self.dateTimePicker.date];
        [aAppointmentList setTimeStamp:[[NSDate date] timeIntervalSince1970]];
        [aAppointmentList setRelMyAddressBook:self.aContactDetails];
        [aAppointmentList setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        
        //Create iCal task
        [((AppDelegate*)CRM_AppDelegate) saveEventForTask:aAppointmentList];
        
        self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
        [tblNextStep reloadData];
        [self reset_Appointment];
            
    }
    
}
- (void)reset_Appointment
{
    for (UIView *aview in view_add_appointment.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            txt.text = @"";
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";
        }
        
    }
    [view_add_appointment removeFromSuperview];
}
- (void)editAppointment:(UIButton*)sender
{
    [self btnAddAppointment_Tapped:nil];
    isEditing = YES;
    self.editItemTag = sender.tag;
    AppointmentList *aAppointment= [self.arrAppointmentList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_appointment.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aAppointment.title;
            }
            
            if (txt.tag == 2)
            {
                self.dateTimePicker.date = aAppointment.date;
                txt.text = [NSDateFormatter localizedStringFromDate:aAppointment.date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
                
            }
            if (txt.tag == 3)
            {
                txt.text = aAppointment.desc;
            }
            
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = aAppointment.note;
        }
    }
    [lblAppointment setText:@"Edit Appointment"];

}
- (void)updateAppointment
{
    AppointmentList *aAppointment= [self.arrAppointmentList objectAtIndex:self.editItemTag];
    NSString * message = nil;
    
    for (UIView *aview in view_add_appointment.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter appointment title.";
                if (txt.tag == 2)   message = @"Please enter appointment date.";
//                if (txt.tag == 3)   message = @"Please enter appointment description.";
                break;
            }
            
            if (txt.tag == 1)
            {
                [aAppointment setTitle:txt.text];
            }
            if (txt.tag == 2)
            {
                [aAppointment setDate:self.dateTimePicker.date];
                
            }
            if (txt.tag == 3)
            {
                [aAppointment setDesc:txt.text];
            }
                        
        }
        else if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aAppointment setNote:txt.text];
            }
            
        }
        
    }
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:101];
        [alert show];
        [alert release];
    }
    else
    {
        [aAppointment setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
        [tblNextStep reloadData];
        
        [self reset_Appointment];
    }
}
- (void)deleteAppointment:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete appointment?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1005];
    [anAlertView show];
    [anAlertView release];
    
}
#pragma mark -

#pragma mark - Reminder methods
- (IBAction)btnAddReminder_Tapped:(id)sender
{
    //flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    //http://stackoverflow.com/questions/9232490/how-do-i-create-and-cancel-unique-uilocalnotification-from-a-custom-class

    [self.dropDownTaskStatus removeFromSuperview];
    self.strDropDownItem = nil;
    [lblReminder setText:@"Add New Reminder"];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [view_add_reminder layer].cornerRadius = 8.0;
    [view_add_reminder layer].borderWidth  = .5;
    [[view_add_reminder layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (orientation <= 2)
    {
        [view_add_reminder setFrame:CGRectMake(0, 76, 596, 690)];
        [next_step_View addSubview:view_add_reminder];
    }
    else
    {
        [view_add_reminder setFrame:CGRectMake(0, 76, 852, 432)];
        [next_step_View addSubview:view_add_reminder];
    }
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
    }
    [self generateDropDown:DROPDOWNFOLLOWUPBY];
    [self downloadDropDownData:DROPDOWNFOLLOWUPBY];
}
- (void)saveNS_Reminder
{
    NSString * message = nil;
    
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter reminder title.";
//                if (txt.tag == 2)   message = @"Please enter reminder description.";
//                if (txt.tag == 4)   message = @"Please enter reminder location.";
                if (txt.tag == 5)   message = @"Please enter reminder date.";
                break;
            }
        }
        
    }
    if(self.strDropDownItem == nil || [self.strDropDownItem rangeOfString:@"Select Reminder Type" options:NSCaseInsensitiveSearch].length) if(message == nil) message = @"Please select follow up by.";
    
    if(message)
    {
        isReminderSave = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        ReminderList *aReminderList = (ReminderList *)[NSEntityDescription insertNewObjectForEntityForName:@"ReminderList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_reminder.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 1)
                {
                    [aReminderList setRemTitle:txt.text];
                }
                if (txt.tag == 2)
                {
                    [aReminderList setRemDesc:txt.text];
                }
                if (txt.tag == 4 && txt.text.length)
                {
                    [aReminderList setRemLocation:txt.text];
                }
                if (txt.tag == 5)
                {
                    [aReminderList setRemDate:self.dateTimePicker.date];
                }
                
            }
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                {
                    [aReminderList setNote:txt.text];
                }
                
            }
            
        }
        [self.aContactDetails setLastActivityDate:[NSDate date]];
        [aReminderList setRemUniqueID:[self getRandomAlphanumericString]];
        [aReminderList setRemFollowUpBy:self.strDropDownItem];
        
        
        NSDate *date = [NSDate date];
        NSTimeInterval ti = [date timeIntervalSince1970];
        [aReminderList setTimeStamp:ti];
        [aReminderList setRelMyAddressBook:self.aContactDetails];
        [aReminderList setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];

        NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                          self.dateTimePicker.date,FIRE_TIME_KEY,
                                                                          aReminderList.remTitle,NOTIFICATION_TITLE_KEY,
                                                                          aReminderList.remUniqueID,REMINDER_ID,
                                                                          aReminderList.remDesc,NOTIFICATION_MESSAGE_KEY, nil];

        [self scheduleReminder:itemDict];
        
        //Create iCal task
        [((AppDelegate*)CRM_AppDelegate) saveEventForTask:aReminderList];
        

        self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
    //                                                                   ascending:NO];
    //    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    NSArray *sortedArray = [self.arrReminderList sortedArrayUsingDescriptors:sortDescriptors];
    //    
    //    self.arrReminderList = [NSMutableArray arrayWithArray:sortedArray];
        [tblNextStep reloadData];
        [self saveNS_FollowUpdate:aReminderList];
        [self reset_Reminder];
    }
        
}
- (void)saveNS_FollowUpdate:(ReminderList*)aReminder  // FollowUpdate
{
    FollowUpdate *aFollowUpdate = (FollowUpdate *)[NSEntityDescription insertNewObjectForEntityForName:@"FollowUpdate" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                [aFollowUpdate setFollowTitle:txt.text];
            }
            if (txt.tag == 2)
            {
                [aFollowUpdate setFollowDesc:txt.text];
            }
            
        }
        
    }
    [aFollowUpdate setFollowType:self.strDropDownItem];
    [aFollowUpdate setFollowDate:self.dateTimePicker.date];
    
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    [aFollowUpdate setTimeStamp:ti];
    [aFollowUpdate setRelMyAddressBook:self.aContactDetails];
    [aFollowUpdate setRelReminderList:aReminder];
    [aFollowUpdate setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
    [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    
    [self fetchFollowUpdate];
    
}
- (void)reset_Reminder
{
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            txt.text = @"";
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";
        }
    }
    [dropDownTaskStatus removeFromSuperview];
    [view_add_reminder removeFromSuperview];
}
- (NSDate*)getDate
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	// Get the current date
	NSDate *pickerDate = [self.dateTimePicker date];
	
	// Break the date up into components
	NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit )
												   fromDate:pickerDate];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit )
												   fromDate:pickerDate];
	
	// Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
	// Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
	[dateComps setSecond:00];
    
    NSDate *fireDate = [calendar dateFromComponents:dateComps];
    [dateComps release];
    return fireDate;
}
- (void)scheduleReminder:(NSDictionary*)items
{   
    NSDate *fireDate = [self getDate];
   
	
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
	
	// Notification details
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [items valueForKey:NOTIFICATION_MESSAGE_KEY]];
	// Set the action button
    localNotif.alertAction = @"View";
	
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
	
	// Specify custom data for the notification
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%@", nil), [items valueForKey:NOTIFICATION_TITLE_KEY]];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              fireDate,FIRE_TIME_KEY,
                              [items valueForKey:REMINDER_ID],REMINDER_ID,
                              [items valueForKey:NOTIFICATION_MESSAGE_KEY],NOTIFICATION_MESSAGE_KEY,
                              title,NOTIFICATION_TITLE_KEY, nil];
    
    localNotif.userInfo = infoDict;
	
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
	

//    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Reminder set successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//    [anAlertView show];
//    [anAlertView release];
}
-(void)cancelReminder:(ReminderList*)aReminder
{
    
    NSArray *arrNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in arrNotifications)
    {
        NSDictionary *userInfo = notification.userInfo;
        
        NSLog(@"%@",userInfo);
        
        if ([aReminder.remUniqueID isEqualToString:[userInfo objectForKey:REMINDER_ID]])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}
- (void)editReminder:(UIButton*)sender
{
    [self btnAddReminder_Tapped:nil];
    [lblReminder setText:@"Edit Reminder"];
    isEditing = YES;
    self.editItemTag = sender.tag;
    ReminderList *aReminder= [self.arrReminderList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aReminder.remTitle;
            }
            if (txt.tag == 2)
            {
                txt.text = aReminder.remDesc;
            }
            if (txt.tag == 4 && aReminder.remLocation.length)
            {
                txt.text = aReminder.remLocation;
            }
            if (txt.tag == 5)
            {
                txt.text = [NSDateFormatter localizedStringFromDate:aReminder.remDate
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
            }
            
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = aReminder.note;
        }
    }
    [self.dateTimePicker setDate:aReminder.remDate];
    
    self.strDropDownItem = aReminder.remFollowUpBy;
    
    NSArray *tempArr = [NSArray arrayWithObjects:@"Send Email",@"Call",@"Arrange an appointment",@"Other",nil];
    for (int i = 0; i < [tempArr count]; i++)
    {
        
        if ([aReminder.remFollowUpBy isEqualToString:[tempArr objectAtIndex:i]])
        {
            [self.dropDownTaskStatus setSelectedIndex:i];
            break;
        }
    }

}
- (void)updateReminder
{
    ReminderList *aReminder = [self.arrReminderList objectAtIndex:self.editItemTag];
    
    [self cancelReminder:aReminder];
    NSString * message = nil;
   
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter reminder title.";
//                if (txt.tag == 2)   message = @"Please enter reminder description.";
//                if (txt.tag == 4)   message = @"Please enter reminder location.";
                if (txt.tag == 5)   message = @"Please enter reminder date.";
                break;
            }
            if (txt.tag == 1)
            {
                [aReminder setRemTitle:txt.text];
            }
            if (txt.tag == 2)
            {
                [aReminder setRemDesc:txt.text];
            }
            if (txt.tag == 4 && txt.text.length)
            {
                [aReminder setRemLocation:txt.text];
            }
            
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aReminder setNote:txt.text];
            }
            else
            {
                //                message = @"Please enter proposal note.";
            }
            
        }
        
    }
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    [aReminder setTimeStamp:ti];
    if(self.strDropDownItem == nil) message = @"Please select follow up by.";
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:101];
        [alert show];
        [alert release];
    }
    else
    {
        [aReminder setRemFollowUpBy:self.strDropDownItem];
        [aReminder setRemDate:self.dateTimePicker.date];
        [aReminder setCanShowInDashBoard:[NSNumber numberWithBool:YES]];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.dateTimePicker.date,FIRE_TIME_KEY,
                                  aReminder.remTitle,NOTIFICATION_TITLE_KEY,
                                  aReminder.remUniqueID,REMINDER_ID,
                                  aReminder.remDesc,NOTIFICATION_MESSAGE_KEY, nil];
        
        [self scheduleReminder:itemDict];
        
        self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
    //    NSArray *temp = [NSArray arrayWithArray:self.arrReminderList];
        
    //    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
    //                                                                   ascending:NO];
    //    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //    NSArray *sortedArray = [self.arrReminderList sortedArrayUsingDescriptors:sortDescriptors];
    //    
    //    self.arrReminderList = [NSMutableArray arrayWithArray:sortedArray];
    //    
    //    [sortDescriptor release];
        
        [tblNextStep reloadData];
        
        [self reset_Reminder];
    }
}
- (void)deleteReminder:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete reminder?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1006];
    [anAlertView show];
    [anAlertView release];
    
}
-(NSString*)getRandomAlphanumericString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease]; //specify length here. even you can use full
}
#pragma mark - Email methods
- (IBAction)btnShowContactsPopover:(id)sender
{
    for (UIView *aview in view_email_user.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt isFirstResponder])
            {
                [txt resignFirstResponder];
                break;
            }
            
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt isFirstResponder])
            {
                [txt resignFirstResponder];
                break;
            }
            
        }
        
    }
    
    self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    NSMutableArray *arraytemp = [NSMutableArray array];
    
    for (MyAddressBook *myadd in self.arrContacts)
    {
        NSArray *arrEmails = [[myadd relEmails] allObjects];
        BOOL isContainsEmail = NO;
        
        for (AllEmail *aEmail in arrEmails)
        {            
            if(aEmail.emailURL)
            {
                isContainsEmail = YES;
                break;
            }
        }
        if (isContainsEmail)
        {
            [arraytemp addObject:myadd];
        }
    }
    
        
    self.arrContacts = arraytemp;
    for (UIView *aview in view_contact_list.subviews)
    {
        if ([aview isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)aview;
            if ([btn.titleLabel.text rangeOfString:@"Select Personalization" options:NSCaseInsensitiveSearch].length)
            {
                UIImage *btnImage = [[UIImage imageNamed:@"btn_bg.png"] stretchableImageWithLeftCapWidth:80 topCapHeight:0];
                [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
                break;
            }
            
        }
    }
    UIButton *btn = (UIButton*)sender;
    btnSelectedPopOver = btn;
    if(self.contactListPopover == nil)
    {
        UIViewController *datePickerVC = [[UIViewController alloc]init];
        
        datePickerVC.view = view_contact_list;
        
        [datePickerVC setContentSizeForViewInPopover:CGSizeMake(700, ((AppDelegate*)CRM_AppDelegate).navigation.visibleViewController.view.frame.size.height-100)];
        
        self.contactListPopover = [[[UIPopoverController alloc]initWithContentViewController:datePickerVC] autorelease];
        
        
        [datePickerVC release];
    }
    [self.contactListPopover presentPopoverFromRect:btn.frame inView:view_email_user permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)btnAddEmail_Tapped:(id)sender
{
    
    //http://stackoverflow.com/questions/9232490/how-do-i-create-and-cancel-unique-uilocalnotification-from-a-custom-class
    
    self.strDropDownItem = nil;
    [lblReminder setText:@"Add New Reminder"];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [view_email_user layer].cornerRadius = 8.0;
    [view_email_user layer].borderWidth  = .5;
    [[view_email_user layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (orientation <= 2)
    {
        [view_email_user setFrame:CGRectMake(0, 76, 596, 690)];
        [next_step_View addSubview:view_email_user];
    }
    else
    {
        [view_email_user setFrame:CGRectMake(0, 76, 852, 432)];
        [next_step_View addSubview:view_email_user];
    }
    for (UIView *aview in view_email_user.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
//            if(txt.tag == 1) //txt.text = lblEmailId.text;
//            txt.text = @"";
            [txt setDelegate:self];
        }
        else if ([aview isKindOfClass:[UILabel class]])
        {
//            UILabel *txt = (UILabel*)aview;
//            if(txt.tag == 1) 
//            txt.text = @"";
//            [txt setDelegate:self];
        }
    }
    for (MyAddressBook* aContact in self.arrContacts)
    {
        if (aContact.isSelected)
        {
            [aContact setIsSelected:NO];
        }
    }
    [tblContactList reloadData];

}
- (void)saveEmailData:(NSDictionary*)info withPerson:(MyAddressBook*)person
{
    EmailList *aEmail = (EmailList *)[NSEntityDescription insertNewObjectForEntityForName:@"EmailList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    
    [aEmail setEmailId:[info objectForKey:RECIPIENT_STRING]];
    [aEmail setDesc:[info objectForKey:MESSAGE_BODY_STRING]];
    [aEmail setDate:date];
    [aEmail setTimeStamp:ti];
    [aEmail setEmailTitle:[info objectForKey:SUBJECT_STRING]];
    
    [self.aContactDetails setLastActivityDate:[NSDate date]];
    [aEmail setRelMyAddressBook:self.aContactDetails];
    
    [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
}
-(void)btnSelectContact:(UIButton*)sender
{
	
	MyAddressBook *aContact= [self.arrContacts objectAtIndex:sender.tag];
	
	//open in case check mark is unchecked
	//And as its unchecked, there is no mail selected in the addressBook
	if (!sender.selected)
	{
		//get email data for selected user
		self.arrayEmails = [NSMutableArray arrayWithArray:[aContact.relEmails allObjects]];
		
		//show popover
		if(self.popoverEmails == nil)
		{
			UIViewController *vcSelectLine = [[UIViewController alloc]init];
			
			vcSelectLine.view = vwSelectedContacEmails;
			
			[vcSelectLine setContentSizeForViewInPopover:vwSelectedContacEmails.frame.size];
			
			self.popoverEmails = [[[UIPopoverController alloc]initWithContentViewController:vcSelectLine] autorelease];
			
			
			[vcSelectLine release];
		}
		[tableEmailContact reloadData];
		
		CGRect rect = [sender convertRect:sender.bounds toView:view_contact_list];
		
		[self.popoverEmails presentPopoverFromRect:rect inView:view_contact_list permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
	}
	else
	{
		//We deselect the mail check mark in ViewDetails
		// Need to deselect all emails in database as well
		
		NSArray * array = [[aContact relEmails] allObjects];
		
		for (AllEmail * email in array)
		{
			[email setIsSelected:[NSNumber numberWithBool:NO]];
			
			if(![((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil])
			{
				NSLog(@"Not saved data");
			}
		}
		
		// need to deselect myAddressBook is selected as well
		[aContact setIsSelected:NO];
		
		[tblContactList reloadData];
		
	}
}

- (IBAction)btnSendEmail:(id)sender
{
    //Flurry
	if (sender)
	{
		UIButton * btn = (UIButton*)sender;
		NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
		[AppDelegate setFlurryWithText:string];
	}
    if ([self checkNetworkConnection])
    {
        NSString * message = nil;
        NSString * toSubject = nil;
        NSString * toMessage = nil;
        
        for (UIView *aview in view_email_user.subviews)
        {
            if(![Global GetConfigureFlag])
            {
                message = @"Hello! to start using this function please set up your email details in settings.";
                break;
            }
            else if([aview isKindOfClass:[UILabel class]])
            {
                UILabel *txt = (UILabel*)aview;
                if([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 && txt.tag == 1)
                {
                    message = @"Please add at least one recipient";
                }
            }
            else if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if(txt.isFirstResponder) [txt resignFirstResponder];
                //            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 && txt.tag == 1)
                //            {
                //                message = @"Please add at least one recipient";
                //                break;
                //
                //            }
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 && txt.tag == 4)
                {
                    message = @"Subject cannot be empty.";
                    break;
                    
                }
                else
                {
                    toSubject = txt.text;
                }
                
            }
            else if([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if(txt.isFirstResponder) [txt resignFirstResponder];
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
                {
                    message = @"message cannot be empty.";
                    break;
                }
                else
                {
                    toMessage = txt.text;
                }
                
            }
        }
        if(message)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
        {
            //TODO: Nikhil start from here
            NSString *toEmail = nil;
            
            NSMutableArray      *emailsArray = [NSMutableArray array];
            
            for (int i =0 ; i < [self.arrContacts count]; i++)
            {
                MyAddressBook* aContact = [self.arrContacts objectAtIndex:i];
                NSString *firstLine = [self createFirstLineOfEmail:aContact];
                if (aContact.isSelected)
                {
                    
                    NSMutableDictionary *emailsDict  = [NSMutableDictionary dictionary];
                    AllEmail *emails = [[[aContact relEmails] allObjects] lastObject];
                    NSString *strEmail = nil;
                    
                    if(emails.emailURL)
                    {
                        strEmail = emails.emailURL;
                    }
                    if (strEmail)
                    {
                        NSLog(@"Name = %@ , Email = %@",aContact.firstName,strEmail);
                        if (toEmail.length)
                        {
                            toEmail = [toEmail stringByAppendingFormat:@",%@",strEmail];
                        }
                        else
                        {
                            toEmail = [NSString stringWithFormat:@"%@",strEmail];
                        }
                        [emailsDict setObject:strEmail  forKey:RECIPIENT_STRING];
                        [emailsDict setObject:toSubject forKey:SUBJECT_STRING];
                        [emailsDict setObject:firstLine forKey:FIRST_LINE_STRING];
                        [emailsDict setObject:toMessage forKey:MESSAGE_BODY_STRING];
                        [self saveEmailData:emailsDict withPerson:aContact];
                    }
                    [emailsArray addObject:emailsDict];
                }
            }
            
            NSLog(@"toEmail = %@",emailsArray);
            SMTPSender *smtp = [SMTPSender sharedSMTPSender];
            [smtp setIsTesting:NO];
            [smtp sendEmailToUsers:emailsArray message:nil];
            
            //reset email view
            for (UIView *aview in view_email_user.subviews)
            {
                if ([aview isKindOfClass:[UITextField class]])
                {
                    UITextField *txt = (UITextField*)aview;
                    txt.text = @"";
                    [txt setDelegate:self];
                }
                else if ([aview isKindOfClass:[UILabel class]])
                {
                    UILabel *txt = (UILabel*)aview;
                    if(txt.tag == 1)
                        txt.text = @"";
                }
                if ([aview isKindOfClass:[UITextView class]])
                {
                    UITextView *txt = (UITextView*)aview;
                    txt.text = @"";
                    //                [txt setDelegate:self];
                }
            }
            [self resetAllEmails_isSelected];
        }
    }
    
}
- (NSString*)createFirstLineOfEmail:(MyAddressBook*)person
{
    NSString *firstLine = @"";
     
    BOOL isSalutation   = NO;
    BOOL isSuffix       = NO;
    BOOL isPrefix       = NO;
    BOOL isFirstName    = NO;
    BOOL isLastName     = NO;
    BOOL isMidName      = NO;
    
    for (FirstLine * FLObj in self.arrayFirstLine)
    {
        if ([FLObj.itemName isEqualToString:[SALUTATION_STRING capitalizedString]] && FLObj.isSelected)
        {
            isSalutation    = YES;
        }
        else if ([FLObj.itemName isEqualToString:[PREFIX_STRING capitalizedString]] && FLObj.isSelected)
        {
            isPrefix        = YES;
        }
        else if ([FLObj.itemName isEqualToString:[FIRST_NAME_STRING capitalizedString]] && FLObj.isSelected)
        {
            isFirstName    = YES;
        }
        else if ([FLObj.itemName isEqualToString:[MIDDLE_NAME_STRING capitalizedString]] && FLObj.isSelected)
        {
            isMidName      = YES;
        }
        else if ([FLObj.itemName isEqualToString:[LAST_NAME_STRING capitalizedString]] && FLObj.isSelected)
        {
            isLastName     = YES;
        }
        else if ([FLObj.itemName isEqualToString:[SUFFIX_STRING capitalizedString]] && FLObj.isSelected)
        {
            isSuffix        = YES;
        }
        
    }
    
    if (person.salutation && isSalutation)
    {
        if(firstLine)
            firstLine = [firstLine stringByAppendingFormat:@" %@",person.salutation];
        else
            firstLine = [firstLine stringByAppendingFormat:@"%@",person.salutation];
    }
    if (person.prefix && isPrefix)
    {
        if(firstLine)
            firstLine = [firstLine stringByAppendingFormat:@" %@",person.prefix];
        else
            firstLine = [firstLine stringByAppendingFormat:@"%@",person.prefix];
    }
    if (person.firstName && isFirstName)
    {
        if(firstLine)
            firstLine = [firstLine stringByAppendingFormat:@" %@",person.firstName];
        else
            firstLine = [firstLine stringByAppendingFormat:@"%@",person.firstName];
    }
    if (person.middleName && isMidName)
    {
        if(firstLine)
            firstLine = [firstLine stringByAppendingFormat:@" %@",person.middleName];
        else
            firstLine = [firstLine stringByAppendingFormat:@"%@",person.middleName];
    }
    if (person.lastName && isLastName)
    {
        if(firstLine)
            firstLine = [firstLine stringByAppendingFormat:@" %@",person.lastName];
        else
            firstLine = [firstLine stringByAppendingFormat:@"%@",person.lastName];
    }
    if (person.suffix && isSuffix)
    {
        if(firstLine)
            firstLine = [firstLine stringByAppendingFormat:@" %@",person.suffix];
        else
            firstLine = [firstLine stringByAppendingFormat:@"%@",person.suffix];
    }
    if(firstLine.length > 0)
        firstLine = [firstLine stringByAppendingString:@":"];
    
    return firstLine;

}
- (IBAction)btnDoneContacts:(id)sender
{
    NSString *toEmail = nil;
    for (int i =0 ; i < [self.arrContacts count]; i++)
    {
        MyAddressBook* aContact = [self.arrContacts objectAtIndex:i];
        if (aContact.isSelected)
        {
            
            for (AllEmail *emails in [aContact relEmails])
			{
				
				if ([emails.isSelected boolValue])
				{
					NSString *strEmail = nil;
					
					if(emails.emailURL)
					{
						strEmail = emails.emailURL;
					}
					if (strEmail)
					{
						NSLog(@"Name = %@ , Email = %@",aContact.firstName,strEmail);
						if (toEmail.length)
						{
							toEmail = [toEmail stringByAppendingFormat:@",%@",[strEmail lowercaseString]];
						}
						else
						{
							toEmail = [NSString stringWithFormat:@"%@",[strEmail lowercaseString]];
						}
						
					}
				}
			}
        }
    }
    NSLog(@"toEmail = %@",toEmail);
//    if(toEmail)
    {
        for (UIView *aview in view_email_user.subviews)
        {
            if ([aview isKindOfClass:[UILabel class]])
            {
                UILabel *txt = (UILabel*)aview;
                if (txt.tag == 1)
                {
                    if (toEmail)
                    {
                        txt.text = toEmail;
                    }
                    else
                    {
                        txt.text = @"";
                    }
                    
                    break;
                    
                }
            }
        }
    }
    
    [self.contactListPopover dismissPopoverAnimated:YES];
}
#pragma mark -
#pragma mark - DropDown List methods
- (void)generateDropDown:(NSString*)aDropDown
{

    if (dropDownTaskStatus)
    {
        [dropDownTaskStatus removeFromSuperview];
        [dropDownTaskStatus release];
        dropDownTaskStatus = nil;
    }
    if([aDropDown isEqualToString:DROPDOWNPRODUCT])
    {
        self.dropDownTaskStatus = [[[DropDownView alloc] initWithFrame:CGRectMake(153, 193, 274, 35) target:self] autorelease];
        //        [self.dropDownTaskStatus setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self.dropDownTaskStatus setBackgroundColor:[UIColor clearColor]];
        [self.dropDownTaskStatus.myLabel setText:@"Pipeline Stage"];
        [view_add_Proposal addSubview:self.dropDownTaskStatus];
    }
    if([aDropDown isEqualToString:DROPDOWNTASK])
    {
        self.dropDownTaskStatus = [[[DropDownView alloc] initWithFrame:CGRectMake(121, 145, 274, 35) target:self] autorelease];
//        [self.dropDownTaskStatus setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self.dropDownTaskStatus setBackgroundColor:[UIColor clearColor]];
        [self.dropDownTaskStatus.myLabel setText:@"Select Status"];
        [view_add_task addSubview:self.dropDownTaskStatus];
    }
    else if([aDropDown isEqualToString:DROPDOWNFOLLOWUPBY])
    {
        self.dropDownTaskStatus = [[[DropDownView alloc] initWithFrame:CGRectMake(130, 145, 260, 35) target:self] autorelease];
//        [self.dropDownTaskStatus setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        [self.dropDownTaskStatus setBackgroundColor:[UIColor clearColor]];
        [self.dropDownTaskStatus.myLabel setText:@"Select Reminder Type"];
        [view_add_reminder addSubview:self.dropDownTaskStatus];
    }
}
- (void)downloadDropDownData:(NSString*)aDropDown
{
    
        NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
        //    for (int i = 0; i<[self.arrCategoryData count]; i++)
        //    {
        //        UserCategory* user = [self.arrCategoryData objectAtIndex:i];
        //        [List addObject:user.cat_name];
        //    }self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    if([aDropDown isEqualToString:DROPDOWNPRODUCT])
    {
        
        [List addObjectsFromArray:@[@"Suspect",@"Prospect",@"Opportunity",@"Customer Won",@"Customer Lost",@"Customer Cancel"]];
    }
    else if([aDropDown isEqualToString:DROPDOWNTASK])
    {
        [List addObjectsFromArray:[NSArray arrayWithObjects:@"Open",@"Running",@"Closed",nil]];
    }
    else if([aDropDown isEqualToString:DROPDOWNFOLLOWUPBY])
    {
        [List addObjectsFromArray:[NSArray arrayWithObjects:@"Send Email",@"Call",@"Arrange an appointment",@"Other",nil]];
    }
        
        
        [self.dropDownTaskStatus setDataArray:List];
        [List release];
}
- (void)openDropDown:(DropDownView*)dropdown
{
    [currentTextField resignFirstResponder];
    [currentTextView resignFirstResponder];
}
#pragma mark DropDownView delegate method
-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
    self.strDropDownItem = dropdown.strDropDownValue;
}
#pragma mark - Cancel views methods
- (IBAction)btnCancelDescViews:(UIButton*)sender
{
    if (sender.superview == view_add_Proposal)
    {
        [self reset_proposal];
    }
    else if (sender.superview == view_add_appointment)
    {
        [self reset_Appointment];
    }
    else if (sender.superview == view_add_task)
    {
        [self reset_Task];
    }
    else if (sender.superview == view_add_reminder)
    {
        [self reset_Reminder];
    }
    [sender.superview removeFromSuperview];
    isEditing = NO;
}
#pragma  mark - network availability
- (BOOL)checkNetworkConnection
{
    Reachability *reachability	= [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}
#pragma mark - Save data into Database
- (IBAction)saveButton_Tapped:(UIButton*)sender                    
{
	NSString * string = nil;
	
    if (sender.superview == view_add_Proposal)
    {
        if(isEditing)
        {
            [self updatePropoal];
			string = @"Contact View Edit Proposal";
        }
        else
        {
			string = @"Contact View Save Proposal";
            [self saveNS_proposal];
            
        }
        
    }
    else if (sender.superview == view_add_task)
    {
        if(isEditing)
        {
			string = @"Contact View Edit Task";
            [self updateTask];
        }
        else
        {
			string = @"Contact View Save Task";
            [self saveNS_Task];
            
        }
        
        
    }
    else if (sender.superview == view_add_appointment)
    {
		
		
        if(isEditing)
        {
			string = @"Contact View Edit Appointment";
            [self updateAppointment];
        }
        else
        {
			string = @"Contact View Save Appointment";
            [self saveNS_Appointment];
            
        }
        
        
        
        
    }
    //    else if (sender.superview == view_add_reminder)
    //    {
    //        if(isEditing)
    //        {
    //			string = @"Contact View Edit Reminder";
    //            [self updateReminder];
    //        }
    //        else
    //        {
    //			string = @"Contact View Save Reminder";
    //            [self saveNS_Reminder];
    //
    //        }
    //
    //
    //    }
    else if (sender.superview == view_add_reminder)
    {
        if(isEditing)
        {
			string = @"Contact View Save Reminder";
            [self updateReminder];
        }
        else
        {
			string = @"Contact View Save Reminder";
            [self saveNS_Reminder];
            
        }
        if(isReminderSave)
        [self reset_Reminder];
        
    }
    else if (sender.superview == History_Desc_RE_View)
    {
        [self updateHistory_RE_View];
    }
	
	//Flurry
	[AppDelegate setFlurryWithText:string];
    //    else if (sender.superview == view_email_user)
    //    {
    //        [self showMailComposerSheet];
    //    }
    //    else if (sender.superview == view_configure_email)
    //    {
    //        [self saveAccountDetails];
    //    }
    
    isEditing = NO;
}

#pragma mark - Edit method
- (IBAction)btnEditTapped:(id)sender
{
    AddNewContactViewController * addNewVC = [[AddNewContactViewController alloc]initWithNibName:@"AddNewContactViewController" bundle:nil];
    [addNewVC setADelegate:self];
    [addNewVC setEditMyAddObj:self.aContactDetails];
	[self.navigationController pushViewController:addNewVC animated:YES];
	[addNewVC release];
}
#pragma mark - AddNewContactViewController Delegate
- (void)refreshContactList
{
    [self showPersonalDetails];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1002 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Contact view Delete Proposal"];
        ProposalList *aProposal = [self.arrProposalList objectAtIndex:self.editItemTag];
        
        NSArray *checkForLastStage = [[self.aContactDetails.relProposal allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"funnelStage == %@",aProposal.funnelStage]];
        
        if ([checkForLastStage count] == 1)
        {
            self.aContactDetails.funnelStageID = [self.aContactDetails.funnelStageID stringByReplacingOccurrencesOfString:aProposal.funnelStage withString:@""];
            self.aContactDetails.funnelStageID = [self.aContactDetails.funnelStageID stringByReplacingOccurrencesOfString:@",," withString:@","];
        }
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aProposal];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrProposalList = [NSMutableArray arrayWithArray:[[self.aContactDetails relProposal] allObjects]];
        [tblNextStep reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1004 && buttonIndex == 0)
    {
        TaskList *aTask = [self.arrTaskList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aTask];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrTaskList = [NSMutableArray arrayWithArray:[[self.aContactDetails relTask] allObjects]];
        [tblNextStep reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1005 && buttonIndex == 0)
    {
        AppointmentList *aAppointment = [self.arrAppointmentList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aAppointment];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
        [tblNextStep reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1006 && buttonIndex == 0)
    {
        ReminderList *aReminder = [self.arrReminderList objectAtIndex:self.editItemTag];
        
        [self cancelReminder:aReminder];
            
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aReminder];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
        [tblNextStep reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 101)
    {
        isEditing = YES;
    }
}
#pragma mark - TouchView delegate
- (void)touchesDown:(NSSet *)touches
{
//    [self.dateTimePicker setHidden:YES];
//    [toolBar setHidden:YES];
//    UITouch *atouch = [[touches allObjects] lastObject];
//    [atouch.view removeFromSuperview];
}
#pragma mark - Searching methods
- (void)searchContactWithtextField:(UITextField*)textField
{
    
//    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
    {
        NSString *_mySearchKey = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[cd] %@) OR (lastName CONTAINS[cd] %@) OR (middleName CONTAINS[cd] %@)", _mySearchKey, _mySearchKey, _mySearchKey];
        
        if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            _myPredicate = nil;
        }
        
        self.arrContacts = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:_myPredicate andSortKey:@"recordID" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        NSMutableArray *arraytemp = [NSMutableArray array];
        
        for (MyAddressBook *myadd in self.arrContacts)
        {
            NSArray *arrEmails = [[myadd relEmails] allObjects];
            BOOL isContainsEmail = NO;
            
            for (AllEmail *aEmail in arrEmails)
            {
                if(aEmail.emailURL)
                {
                    isContainsEmail = YES;
                    break;
                }
            }
            if (isContainsEmail)
            {
                [arraytemp addObject:myadd];
            }
        }
        
        
        self.arrContacts = arraytemp;
//        if ([copyitemsearch count] >0)
        {
//            self.arrContacts = [NSMutableArray arrayWithArray:copyitemsearch];
            [tblContactList reloadData];
        }
        
    }
//    [textField resignFirstResponder];
}
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (![self isProtraitOrientation]/* && textField.superview != TVH__Contact_List*/)
    {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.44];
        [UIView setAnimationBeginsFromCurrentState:YES];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        self.view.frame = CGRectMake(self.view.frame.origin.x,-290, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    currentTextField = textField;
    currentTextView = nil;
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    NSMutableArray *arraytemp = [NSMutableArray array];
    
    for (MyAddressBook *myadd in self.arrContacts)
    {
        NSArray *arrEmails = [[myadd relEmails] allObjects];
        BOOL isContainsEmail = NO;
        
        for (AllEmail *aEmail in arrEmails)
        {
            if(aEmail.emailURL)
            {
                isContainsEmail = YES;
                break;
            }
        }
        if (isContainsEmail)
        {
            [arraytemp addObject:myadd];
        }
    }
    
    
    self.arrContacts = arraytemp;
    
    [tblContactList reloadData];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    currentTextField = nil;
    return YES;
}
#define CHARACTER_LIMIT 20
#define NUMBERS_ONLY @"1234567890."

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField.superview == view_add_Proposal && textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if (textField.tag == 1 || textField.tag == 2)
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
        }
        
    }
    else if (textField.superview == view_contact_list)
    {
        [self performSelector:@selector(searchContactWithtextField:) withObject:textField afterDelay:0.01];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];

    return YES;
}
#pragma mark- UIkeyboard Methods
- (void)keyboardWillShow:(NSNotification *)notification
{    
    if (![self isProtraitOrientation] /*&& currentTextField.superview != TVH__Contact_List*/)
    {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationBeginsFromCurrentState:YES];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        self.view.frame = CGRectMake(self.view.frame.origin.x,-290, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if ([self.contactListPopover isPopoverVisible])
    {
        [self.contactListPopover presentPopoverFromRect:btnSelectedPopOver.frame inView:view_email_user permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
	/*if (![self isProtraitOrientation])
    {
        NSDictionary *userInfo		=	[notification userInfo];
		NSValue* aValue				=	[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
		CGRect keyboardRect			=	[aValue CGRectValue];
        
		keyboardRect					=	[self.view convertRect:keyboardRect fromView:nil];
		
		CGFloat keyboardTop			=	keyboardRect.origin.y;
		
        CGRect rect = CGRectMake(0, 0, 0, 0);
		if (currentTextView)
		{
			rect = [currentTextView convertRect:currentTextView.bounds toView:self.view];
		}
		else if(currentTextField)
		{
			rect = [currentTextField convertRect:currentTextField.bounds toView:self.view];
		}
		if (rect.origin.y + rect.size.height > keyboardTop)
		{
			float YOffsetOfDoneView		=	keyboardTop - rect.size.height;
			
			[UIView animateWithDuration:0.25 animations:^{
				self.view.frame = CGRectMake(self.view.frame.origin.x,-YOffsetOfDoneView, self.view.frame.size.width, self.view.frame.size.height);
			}];
        }
        
    }*/
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (![self isProtraitOrientation])
    {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationBeginsFromCurrentState:YES];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        self.view.frame = CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if ([self.contactListPopover isPopoverVisible])
    {
        [self.contactListPopover presentPopoverFromRect:btnSelectedPopOver.frame inView:view_email_user permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    if (![self isProtraitOrientation])
//    {
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDuration:0.44];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
//        self.view.frame = CGRectMake(self.view.frame.origin.x,-290, self.view.frame.size.width, self.view.frame.size.height);
//        [UIView commitAnimations];
//    }
    currentTextField = nil;
    currentTextView = textView;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (![self isProtraitOrientation])
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.44];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == txtVwCallNote)
    {
        [btnSaveNote setHidden:YES];
        int alenght = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
        int textlenght = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
        if((alenght  && alenght != 1) || textlenght)
        [btnSaveNote setHidden:NO];
    }
    return YES;
}
#pragma - mark  link to phone email address methods
/*
 Methord : Used to when user tap on the email/address/phone number/twitter/Social etc.
 
 for example if we tap on the email require to open email popover
 address, require to navigate to address in map application
 
 */
-(void)cellPersonalDetails_NavigateTo:(UIButton*)sender
{
	
	PersonalDetailsTVCell * cell = (PersonalDetailsTVCell*)[sender superview] ;
	UIApplication * aApplication =	[UIApplication sharedApplication];
	
	switch (sender.tag)
	{
		case 1://Twitter
        {
            
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:@"Tweet",@"View Tweets",
                                          nil];
            
            CGRect rect = [sender convertRect:sender.bounds toView:self.view];
            [actionSheet showFromRect:rect inView:self.view animated:YES];
            [actionSheet release];
        }
			break;
            
		case 2://address
        {
            
            //Get matching address
            
            NSArray * address = [[self.aContactDetails relAllAddress] allObjects];
            
            for (AllAddress * foundAdd in address)
            {
                if ([cell.lblValue.text rangeOfString:foundAdd.street options:NSCaseInsensitiveSearch].length ||
                    [cell.lblValue.text rangeOfString:foundAdd.state options:NSCaseInsensitiveSearch].length  ||
                    [cell.lblValue.text rangeOfString:foundAdd.city options:NSCaseInsensitiveSearch].length   ||
                    [cell.lblValue.text rangeOfString:foundAdd.zipCode options:NSCaseInsensitiveSearch].length||
                    [cell.lblValue.text rangeOfString:foundAdd.countryCode options:NSCaseInsensitiveSearch].length)
                {
                    
                    NSString * addressField = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",foundAdd.street,foundAdd.city,foundAdd.state,foundAdd.countryCode,foundAdd.zipCode];
                    addressField = [addressField stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSURL * addUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?q=%@",addressField]];
                    
                    if ([aApplication canOpenURL:addUrl])
                    {
                        [aApplication openURL:addUrl];
                    }
                    
                    break;
                }
            }
            
            
        }
			break;
		case 3://Facebook - linkedin - google+
		{
			
			NSString * link = [[self getProperUrlForLink:cell.lblValue.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			NSURL * addUrl = nil;
			
			if ([cell.lblTitle.text rangeOfString:@"Facebook" options:NSCaseInsensitiveSearch].length)
			{
				
				addUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@",link]];
                
			}
			else if ([cell.lblTitle.text rangeOfString:@"linkedin" options:NSCaseInsensitiveSearch].length)
			{
				addUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.linkedin.com/%@",link]];
			}
			else if ([cell.lblTitle.text rangeOfString:@"google" options:NSCaseInsensitiveSearch].length)
			{
				addUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://plus.google.com/%@",link]];
			}
            
			
			if ([aApplication canOpenURL:addUrl])
			{
				[aApplication openURL:addUrl];
			}
		}
			
			break;
			
		case 4://Emails
        {
            //Getting all emails
            NSArray * emails = [[self.aContactDetails relEmails] allObjects];
            
            for (AllEmail * foundEmail in emails)
            {
                if ([cell.lblValue.text rangeOfString:(foundEmail.emailURL)?(foundEmail.emailURL):@"" options:NSCaseInsensitiveSearch].length)
                {
                    
                    //Open the mfMail composer sheet
                    
                    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
                    
                    mailViewController.mailComposeDelegate = self;
                    
                    [mailViewController setToRecipients:[NSArray arrayWithObject:[cell.lblValue.text lowercaseString]]];
                    [mailViewController setMessageBody:@"" isHTML:NO];
                    mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                    
                    [self presentViewController:mailViewController animated:YES completion:^{}];
                    
                    break;
                }
            }
        }
			break;
			
		case 5://urls
        {
            NSString * linkUrl = cell.lblValue.text;
            
            if (![linkUrl rangeOfString:@"http"].length)
            {
                linkUrl = [NSString stringWithFormat:@"http://%@",linkUrl];
            }
            
            NSURL * url = [NSURL URLWithString:linkUrl];
            if ([aApplication canOpenURL:url])
            {
                [aApplication openURL:url];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Cannot open url." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
        }
			break;
		case 6://Phone
		{
			
			NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",cell.lblValue.text]];
			if ([aApplication canOpenURL:url])
			{
				[aApplication openURL:url];
			}
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Call feature not supported on this iPad model." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
		}
			break;
		default:
			break;
	}
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[controller dismissViewControllerAnimated:YES completion:^{}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (buttonIndex == 0) // tweet open twitter
	{
		if ([TWTweetComposeViewController canSendTweet])
		{
			
			TWTweetComposeViewController *vc = [[[TWTweetComposeViewController alloc] init] autorelease];
			
			NSString * user = self.aContactDetails.twitter;
			
			if (![user rangeOfString:@"@"].length)
			{
				user = [NSString stringWithFormat:@"@%@ ",user];
			}
			
			[vc setInitialText:user];
			[self presentViewController:vc animated:YES completion:nil];
		}
		else
		{
			
			NSString *message = @"Cannot complete tweet at the moment. This is because it cannot reach Twitter or you don't have a Twitter account associated with this device.";
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	else if(buttonIndex == 1) // view tweet
	{
		
		NSString * linkUrl = self.aContactDetails.twitter;
		
		if ([linkUrl rangeOfString:@"@"].length)
		{
			linkUrl = [linkUrl stringByReplacingOccurrencesOfString:@"@" withString:@""];
		}
		
		NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.twitter.com/%@",linkUrl]];
		
		if ([[UIApplication sharedApplication] canOpenURL:url])
		{
			[[UIApplication sharedApplication] openURL:url];
		}
        
	}
}
-(NSString *)getProperUrlForLink:(NSString *)link
{
	
	//we just remove the pleced http:,www,<site>.com from the url.
	//So that can be put afterwords
	NSRange range = [link rangeOfString:@"com/"];
	
	if (range.length)
	{
		link = [link substringFromIndex:(range.location + range.length)];
	}
    
	return link;
}
#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1001)
    {
        if(self.historySelectedOption == 15) return [self.dictTimeLineList count];
    }
    if(tableView.tag == 22){
        NSArray *allkeys = [self.dictTemp allKeys];
        return [allkeys count];
    }
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSString*)listType
{
    if ([self.NEXT_STEP_OPTION isEqualToString:NS_PROPOSAL])
    {
        return [self.arrProposalList count];
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:NS_TASK])
    {
        return [self.arrTaskList count];
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:NS_APPOINTMENT])
    {
        return [self.arrAppointmentList count];
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:NS_REMINDER])
    {
        return [self.arrReminderList count];
    }
    else if ([self.NEXT_STEP_OPTION isEqualToString:FOLLOW_UPDATE])
    {
        return [self.arrFollowUpdate count];
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[dictTemp count]);
    
    if (tableView == tableEmailSelection)
	{
		return [self.arrayFirstLine count];
	}
	else if (tableView == tableEmailContact)
	{
		return [self.arrayEmails count];
	}
    else if (tableView == tblProductList)
	{
		return [self.arrProductList count];
	}
    
    else if (tableView.tag == 22){
        NSInteger i;
        NSArray *dictKeys = [self.dictTemp allKeys];
        id aKey = [dictKeys objectAtIndex:section];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[self.dictTemp objectForKey:aKey] forKey:aKey];
        NSArray *arr=[dict valueForKey:aKey];
        @try{
            i = [arr count];
        }
        @catch(NSException * e){
            return 1;
        }
        i = [arr count];
            return i;
    }
    else if (tableView == tblScriptCallUser)
    {
        return  [arrScriptList count];
    }
    else if (tableView.tag == 11)
    {
        return  [arrFollowUpdate count];
    }
    else if (tableView.tag == 33)
    {
       return [self numberOfRowsInSection:self.NEXT_STEP_OPTION];
    }
    else if (tableView.tag == 44)
    {
        return [self.arrProposalList count];
    }
    else if (tableView.tag == 1001)
    {
        if(self.historySelectedOption == 14) return [self.arrReminderList count];
        if(self.historySelectedOption == 12) return [self.arrAppointmentList count];
        if(self.historySelectedOption == 13) return [self.arrHisOptionData count];
        if(self.historySelectedOption == 11) return [self.arrHisOptionData count];
        if(self.historySelectedOption == 15)
        {
            return [[self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",section]] count];
        }
        return 10;
    }
    else if (tableView == tblContactList)
    {
        return [self.arrContacts count];
    }
    return 0;
}

//Header in Section for Conatct view
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionHead = nil;
    NSArray *allkeys = [self.dictTemp allKeys];
    sectionHead = [allkeys objectAtIndex:section];
    return sectionHead;
}


- (UITableViewCell *)createTVCellFor:(UITableView *)tableView AtIndexPath:(NSIndexPath *)indexPath listType:(NSString*)listType
{
    if ([listType isEqualToString:NS_PROPOSAL])
    {
        ProposalList *aProposal = [self.arrProposalList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"ProposalTVCell";
        ProposalTVCell* cell = nil;
        cell = (ProposalTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProposalTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[ProposalTVCell class]])
                {
                    
                    cell = (ProposalTVCell*)currentObject;
                    
                }
            }
        }
        NSString *date = [NSDateFormatter localizedStringFromDate:aProposal.proposalDate
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle];
        
        cell.lblName.text = (aProposal.proposalNumber)?aProposal.proposalNumber:@"";
		
		
        cell.lblDesc.text = (aProposal.proposalPrice)?[Global convertStringToNumberFormatter:aProposal.proposalPrice
																			  withDollerSign:YES]:@"$0";
        cell.lblDate.text       = (date.length)?date:@"";

        [cell.btnEdit addTarget:self action:@selector(editProposal:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit setTag:indexPath.row];
        
        [cell.btnDelete addTarget:self action:@selector(deleteProposal:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete setTag:indexPath.row];
        return cell;
    }
    
    else if ([listType isEqualToString:NS_TASK])
    {
        TaskList *aTask= [self.arrTaskList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"ProposalTVCell";
        ProposalTVCell* cell = nil;
        cell = (ProposalTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProposalTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[ProposalTVCell class]])
                {
                    
                    cell = (ProposalTVCell*)currentObject;
                    
                }
            }
        }
        cell.lblName.text = (aTask.taskName)?aTask.taskName:@"";
        cell.lblDesc.text = (aTask.taskDesc)?[NSString stringWithFormat:@"%@",aTask.taskDesc]:@"";
        cell.lblDate.text       = (aTask.taskStatus)?aTask.taskStatus:@"";
        
        [cell.btnEdit addTarget:self action:@selector(edittask:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit setTag:indexPath.row];

        [cell.btnDelete addTarget:self action:@selector(deleteTask:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete setTag:indexPath.row];
        return cell;
    }
    else if ([listType isEqualToString:NS_APPOINTMENT])
    {
        AppointmentList *aAppointment= [self.arrAppointmentList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"ProposalTVCell";
        ProposalTVCell* cell = nil;
        cell = (ProposalTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProposalTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[ProposalTVCell class]])
                {
                    
                    cell = (ProposalTVCell*)currentObject;
                    
                }
            }
        }
        NSString *date = [NSDateFormatter localizedStringFromDate:aAppointment.date
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle];
        NSArray *component =  [date componentsSeparatedByString:@","];
        NSLog(@"%@",component);
        cell.lblName.text = (aAppointment.title)?aAppointment.title:@"";
        
        if([component count] >0)
        cell.lblDesc.text = [component objectAtIndex:0];
        
        if([component count] >= 2)
        cell.lblDate.text       = [component objectAtIndex:1];

        [cell.btnEdit addTarget:self action:@selector(editAppointment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit setTag:indexPath.row];

        [cell.btnDelete addTarget:self action:@selector(deleteAppointment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete setTag:indexPath.row];
        return cell;
    }
    else if ([listType isEqualToString:NS_REMINDER])
    {
        ReminderList *aReminder= [self.arrReminderList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"NS_ReminderTVCell";
        NS_ReminderTVCell* cell = nil;
        cell = (NS_ReminderTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NS_ReminderTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[NS_ReminderTVCell class]])
                {
                    
                    cell = (NS_ReminderTVCell*)currentObject;
                    
                }
            }
        }
        cell.lblRemTitle.text = (aReminder.remTitle)?aReminder.remTitle:@"";
        NSString *date = [NSDateFormatter localizedStringFromDate:aReminder.remDate
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle];
        cell.lblRemDate.text       = date;
        cell.lblRemDesc.text = aReminder.remDesc;
        cell.lblRemLocation.text = aReminder.remLocation;
        
        [cell.btnEdit addTarget:self action:@selector(editReminder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit setTag:indexPath.row];

        [cell.btnDelete addTarget:self action:@selector(deleteReminder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete setTag:indexPath.row];
        return cell;
    }
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Table for first line selection
	if (tableView == tableEmailSelection  || tableView == tableEmailContact)
	{
		
		CheckMarkCell * cell = (CheckMarkCell*)[tableView dequeueReusableCellWithIdentifier:@"CheckMarkCell"];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CheckMarkCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[CheckMarkCell class]])
                {
                    
                    cell = (CheckMarkCell*)currentObject;
                    
                }
            }
        }
        
		//this for first line only
		if (tableView == tableEmailSelection)
		{
			FirstLine * lineObj = (FirstLine *)[self.arrayFirstLine objectAtIndex:indexPath.row];
			[cell.lblName setText:lineObj.itemName];
			[cell.btnCheckBox setSelected:lineObj.isSelected];
			[cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxForFirstLineTapped:) forControlEvents:UIControlEventTouchUpInside];
			
		}
		else// this is to show the email list
		{
			AllEmail * email = (AllEmail*)[self.arrayEmails objectAtIndex:indexPath.row];
			NSString * emailurl = nil;
			if (email.emailURL)
			{
				emailurl = [email.emailURL lowercaseString];
			}
			[cell.lblName setText:emailurl];
			
			[cell.btnCheckBox setSelected:[email.isSelected boolValue]];
			
			[cell.btnCheckBox addTarget:self action:@selector(btnCheckForEmailSelectedTapped:) forControlEvents:UIControlEventTouchUpInside];
			
		}
		[cell.btnCheckBox setTag:indexPath.row];
		
		
		return cell;
	}
	//--
    if (tableView.tag == 11) // table for follow updates details
    {
        FollowUpdate *aFollow = [self.arrFollowUpdate objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"NextStepTVCell";
        NextStepTVCell* cell = nil;
        cell = (NextStepTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NextStepTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[NextStepTVCell class]])
                {
                    
                    cell = (NextStepTVCell*)currentObject;
                    
                }
            }
        }
        [cell updateUITableViewCellForFollowUpdate:aFollow];
        return cell;
    }
    else if (tableView == tblProductList) // table for product list in add proposal view
    {
       ProductList  *aProduct = [self.arrProductList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"NS_Proposal_DD_TVCell";
        NS_Proposal_DD_TVCell* cell = nil;
        cell = (NS_Proposal_DD_TVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NS_Proposal_DD_TVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {  
                if([currentObject isKindOfClass:[NS_Proposal_DD_TVCell class]])
                {
                    
                    cell = (NS_Proposal_DD_TVCell*)currentObject;
                    [cell setAdelegate:self];
                    
                }
            }
        }
        [cell updateUITableViewCellForProduct:aProduct];
        [cell.btnCheckBox addTarget:self action:@selector(btnCheckProduct:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheckBox setTag:indexPath.row];
        [cell.btnCheckBox setSelected:aProduct.isSelected];
        
        [cell.txtfQuantity setHidden:YES];
        
        if(aProduct.isSelected)
        {
            [cell.txtfQuantity setHidden:NO];
            
            if([aProduct.quantity integerValue])
                [cell.txtfQuantity setText:[aProduct.quantity stringValue]];
        }
        
        [cell.txtfQuantity setTag:indexPath.row];
        return cell;
    }
    else if (tableView.tag == 22) // table for personal details
    {
        static NSString *CellIdentifier = @"PersonalDetailsTVCell";
        PersonalDetailsTVCell* cell = nil;
        cell = (PersonalDetailsTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PersonalDetailsTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[PersonalDetailsTVCell class]])
                {
                    
                    cell = (PersonalDetailsTVCell*)currentObject;
                    
                }
            }
        }
        NSArray *allKeys = [self.dictTemp allKeys];
        NSString *currentKey = [allKeys objectAtIndex:indexPath.section];
        NSDictionary *currentValue = [self.dictTemp objectForKey:currentKey];
       
        
        
        if([currentKey isEqualToString:NOTE_STRING] || [currentKey isEqualToString:BIRTHDAY_STRING]){
            
            
            [cell updateUITableViewCell:currentKey
                              cellValue:[self.dictTemp objectForKey:currentKey]];
            [cell.btnNavigateTo addTarget:self action:@selector(cellPersonalDetails_NavigateTo:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else{
            NSArray *allCurrentKeys = [currentValue allKeys];
            NSArray *allCurrentValues = [currentValue allValues];
            NSString *multiCellKey = [allCurrentKeys objectAtIndex:indexPath.row];
            NSString *multiCellValue = [allCurrentValues objectAtIndex:indexPath.row];

    
            
            [cell updateUITableViewCell:multiCellKey
                              cellValue:multiCellValue];
            [cell.btnNavigateTo addTarget:self action:@selector(cellPersonalDetails_NavigateTo:) forControlEvents:UIControlEventTouchUpInside];
            }
        
        /*
        [cell updateUITableViewCell:[self.arrAllKeys objectAtIndex:indexPath.row]
                          cellValue:[dictTemp objectForKey:[self.arrAllKeys objectAtIndex:indexPath.row]]];
        [cell.btnNavigateTo addTarget:self action:@selector(cellPersonalDetails_NavigateTo:) forControlEvents:UIControlEventTouchUpInside];
         */
        
        return cell;
    }
    else if (tableView == tblScriptCallUser)
    {
        static NSString *CellIdentifier = @"ScriptListCell";
        ScriptList *aScript = [self.arrScriptList objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]  autorelease];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = aScript.scriptName;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];        
        
        return cell;
    }
    else if (tableView.tag == 33) // table for Next Step
    {
        if ([self.NEXT_STEP_OPTION isEqualToString:NS_PROPOSAL])
        {
           return [self createTVCellFor:tableView AtIndexPath:indexPath listType:NS_PROPOSAL];
        }
        else if ([self.NEXT_STEP_OPTION isEqualToString:NS_TASK])
        {
            return [self createTVCellFor:tableView AtIndexPath:indexPath listType:NS_TASK];
        }
        else if ([self.NEXT_STEP_OPTION isEqualToString:NS_APPOINTMENT])
        {
            return [self createTVCellFor:tableView AtIndexPath:indexPath listType:NS_APPOINTMENT];
        }
        else if ([self.NEXT_STEP_OPTION isEqualToString:NS_APPOINTMENT])
        {
            return [self createTVCellFor:tableView AtIndexPath:indexPath listType:NS_APPOINTMENT];
        }
        else if ([self.NEXT_STEP_OPTION isEqualToString:NS_REMINDER])
        {
            return [self createTVCellFor:tableView AtIndexPath:indexPath listType:NS_REMINDER];
        }
        else if ([self.NEXT_STEP_OPTION isEqualToString:FOLLOW_UPDATE])
        {
            static NSString *CellIdentifier = @"NextStepTVCell";
            NextStepTVCell* cell = nil;
            cell = (NextStepTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NextStepTVCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    
                    if([currentObject isKindOfClass:[NextStepTVCell class]])
                    {
                        
                        cell = (NextStepTVCell*)currentObject;
                        
                    }
                }
            }
            if(indexPath.row % 2 == 0)
            {
                [cell.bgView setBackgroundColor:[UIColor whiteColor]];
            }
            
            FollowUpdate *aFollow = [self.arrFollowUpdate objectAtIndex:indexPath.row];
            [cell updateUITableViewCellForNextStep:aFollow];
            
            return cell;
        }
    }
    else if (tableView.tag == 44) // table for history 
    {
        ProposalList *aProposal = [self.arrProposalList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"HistoryTVCell";
        HistoryTVCell* cell = nil;
        cell = (HistoryTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        
//        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HistoryTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[HistoryTVCell class]])
                {
                    
                    cell = (HistoryTVCell*)currentObject;
                    
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row % 2 == 0)
        {
            [cell.bgView setBackgroundColor:[UIColor whiteColor]];
        }
        NSString *date = [NSDateFormatter localizedStringFromDate:aProposal.proposalDate
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle];
        cell.lblProposalNumber.text = (aProposal.proposalNumber)?aProposal.proposalNumber:@"";
		
		
        cell.lblAmount.text         = (aProposal.proposalPrice)?[Global convertStringToNumberFormatter:aProposal.proposalPrice
                                                                                        withDollerSign:YES]:@"$0";
        cell.lblDate.text           = (date.length && date)?date:@"";
        return cell;

        
    }
    else if (tableView.tag == 1001) // table for history call tab
    {
        if(self.historySelectedOption != 15)
        {
            static NSString *CellIdentifier = @"HistoryCallTVCell";
            HistoryCallTVCell* cell = nil;
            cell = (HistoryCallTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HistoryCallTVCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    
                    if([currentObject isKindOfClass:[HistoryCallTVCell class]])
                    {
                        
                        cell = (HistoryCallTVCell*)currentObject;
                        
                    }
                }
            }
            {
                
                if(self.historySelectedOption == HISTORY_EVENT )
                {
                    AppointmentList *aAppointment = [self.arrAppointmentList objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryEventOption:aAppointment];
                }
                else if (self.historySelectedOption == HISTORY_EMAIL)
                {
                    EmailList *aEmail = [self.arrHisOptionData objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryEmailOption:aEmail];
                }
                else if(self.historySelectedOption == HISTORY_REMINDER)
                {
                    ReminderList *aReminder = [self.arrReminderList objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryReminderOption:aReminder];
                }
                if (self.historySelectedOption == HISTORY_CALL)
                {
                    NotesList *aNote = [self.arrHisOptionData objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryCallOption:aNote];
                }
                //        if(indexPath.row % 2 == 0)
                //        {
                //            [cell.bgView setBackgroundColor:[UIColor whiteColor]];
                //        }
                return cell;
            }
        }
        else
        {
            static NSString *CellIdentifier = @"TimeLineTVCell";
            TimeLineTVCell* cell = nil;
            cell = (TimeLineTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TimeLineTVCell" owner:nil options:nil];
                
                for(id currentObject in topLevelObjects)
                {
                    
                    if([currentObject isKindOfClass:[TimeLineTVCell class]])
                    {
                        
                        cell = (TimeLineTVCell*)currentObject;
                        
                    }
                }
            }
            {
                static NSArray *dataArray  = nil;
                if (indexPath.section == 0)
                {
                    dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
                    NotesList *aNote = [dataArray objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryCallOption:aNote];
                }
                else if(indexPath.section == 1)
                {
                    dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
                    AppointmentList *aAppointment = [dataArray objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryEventOption:aAppointment];
                }
                else if (indexPath.section == 2)
                {
                    dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
                    EmailList *aEmail = [dataArray objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryEmailOption:aEmail];
                }
                else if(indexPath.section == 3)
                {
                    dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
                    ReminderList *aReminder = [dataArray objectAtIndex:indexPath.row];
                    [cell updateUITableViewForHistoryReminderOption:aReminder];
                }
                                
                return cell;
            }
        }
        
    }
    else if (tableView == tblContactList)
    {
        MyAddressBook *person = [self.arrContacts objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"EditContact_EmailTVCell";
        EditContact_EmailTVCell* cell = nil;
        cell = (EditContact_EmailTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EditContact_EmailTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[EditContact_EmailTVCell class]])
                {
                    
                    cell = (EditContact_EmailTVCell*)currentObject;
                    
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell updateTableViewCell:person];
        
        [cell.btnCheck addTarget:self action:@selector(btnSelectContact:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheck setTag:indexPath.row];
        
        return cell;
    }
    return nil;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 22)
    {
        NSString *stringTemp;
        UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
        int orientation = interface;
        CGFloat width  = 680;
        if (orientation <=2)
        {
            width  = 395;
        }
        // for dynamic cell height
        NSArray *allKeys = [self.dictTemp allKeys];
        NSString *currentKey = [allKeys objectAtIndex:indexPath.section];
        NSDictionary *currentValue = [self.dictTemp objectForKey:currentKey];
        if([currentKey isEqualToString:NOTE_STRING] || [currentKey isEqualToString:BIRTHDAY_STRING]){
            stringTemp = [self.dictTemp objectForKey:currentKey]; //for Dynamic height of cell
        }
        else{
            NSArray *allCurrentValues = [currentValue allValues];
            NSString *multiCellValue = [allCurrentValues objectAtIndex:indexPath.row];
            stringTemp = multiCellValue;
            }
        NSString *Text = nil;
        Text = stringTemp;
        
        float height = [Text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        
//        NSLog(@"height =%f",height);
        if(height < 44)
            return 44;
        
        return height+10;
    }
    else if (tableView.tag == 11)
    {
        return 44;
    }
    else if (tableView.tag == 33)
    {
        return 44;
    }
    else if (tableView.tag == 1001)
    {
        return 44;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 33)
    {
        return next_step_tblHdr_View.frame.size.height;
    }
    else if (tableView.tag == 44)
    {
        return history_tblHdr_View.frame.size.height;
    }
    else if (tableView.tag == 1001)
    {
        if (section == 0)
        return history_Option_tblHdr_View.frame.size.height;
    }
//    else if (tableView == tblContactList)
//    {
//        return TVH__Contact_List.frame.size.height;
//    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 33)
    {
        if ([self.NEXT_STEP_OPTION isEqualToString:NS_PROPOSAL])
        {
            return TVH__NS_Proposal;
        }
        if ([self.NEXT_STEP_OPTION isEqualToString:NS_TASK])
        {
            return TVH__NS_Task;
        }
        if ([self.NEXT_STEP_OPTION isEqualToString:NS_APPOINTMENT])
        {
            return TVH__NS_Appointment;
        }
        if ([self.NEXT_STEP_OPTION isEqualToString:NS_REMINDER])
        {
            return TVH__NS_Reminder;
        }
        if ([self.NEXT_STEP_OPTION isEqualToString:FOLLOW_UPDATE])
        {
            return next_step_tblHdr_View;
        }
        
        
    }
    else if (tableView.tag == 44)
    {
        return history_tblHdr_View;
    }
    else if (tableView.tag == 1001)
    {
        if (section == 0)
        {
            if (isTimelineTap)
            {
                return TVH_Timeline_HS;
            }
            return history_Option_tblHdr_View;
        }
        
    }
//    else if (tableView == tblContactList)
//    {
//        return TVH__Contact_List;
//    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = nil;
    if (tableView.tag == 1001) // table for history call tab
    {
        if(self.historySelectedOption != 15)
        {
            self.editItemTag = indexPath.row;
            [self addHistory_RE_View];
            [self setHistory_RE_View];
        }
        else
        {
            self.selectedIndexPath = indexPath;
            [self addHistory_RE_View];
            [self setHistory_RE_View];
        }
    }
    else if (tableView == tblScriptCallUser)
    {
        [btnScriptList setHidden:NO];
        ScriptList *aScript = [self.arrScriptList objectAtIndex:indexPath.row];
        [tblScriptCallUser setHidden:YES];
        [txtvScriptCallUser setHidden:NO];
        [txtvScriptCallUser setText:aScript.scriptText];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - NS_Proposal_DD_TVCell Delegate
- (void)sendQuantity:(UITextField *)textFiled
{
    ProductList *aProduct = [self.arrProductList objectAtIndex:textFiled.tag];
    
    if (textFiled.text.length)
    {
        [aProduct setQuantity:[NSNumber numberWithInt:[textFiled.text integerValue]]];
    }
    else
    {
        [aProduct setQuantity:[NSNumber numberWithInt:1]];
    }
        
//    [tblProductList reloadData];
    
        
    float total = 0;
    for (ProductList *aProduct in self.arrProductList)
    {
        if (aProduct.isSelected)
        {
            total = total + [[Global convertPriceBackToNumbersWithPriceText:aProduct.price] floatValue] * [aProduct.quantity floatValue];
        }
        else
        {
            [aProduct setQuantity:nil];
        }
    }
    
    
    for (UIView *aview in view_add_Proposal.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            
            if (txt.tag == 2)
            {
                if(total > 0)
                {
                    txt.text = [Global convertStringToNumberFormatter:[NSString stringWithFormat:@"%f",total] withDollerSign:YES];
                }
                else
                {
                    txt.text = @"";
                }
                
                break;
            }
            
        }
    }
    NSLog(@"sendQuantity = %@",textFiled.text);
}
#pragma mark - History Email And reminder methods
- (void)addHistory_RE_View
{
    [History_Desc_RE_View layer].cornerRadius = 8.0;
    [History_Desc_RE_View layer].borderWidth  = .5;
    [[History_Desc_RE_View layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if ([self isProtraitOrientation])
    {
        [History_Desc_RE_View setFrame:CGRectMake(0, 76, 596, 690)];
    }
    else
    {
        [History_Desc_RE_View setFrame:CGRectMake(0, 76, 852, 432)];
    }
    [History_Desc_RE_View setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [history_View addSubview:History_Desc_RE_View];
}
- (void)fillValueTitle:(NSString*)title date:(NSString*)dateStr description:(NSString*)desc
{
    for (UIView *aview in History_Desc_RE_View.subviews)
    {
        if ([aview isKindOfClass:[UILabel class]])
        {
            UILabel *txt = (UILabel*)aview;
            if(txt.tag == 1)
            {
                txt.text = dateStr;
                [txt setUserInteractionEnabled:NO];
            }
            else if (txt.tag == 2)
            {
                txt.text = title;
            }
            else
            {
            }
        }
        else if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = desc;
        }
        
    }
}
- (void)setHistory_RE_View
{
    if(self.historySelectedOption == 12)
    {
        AppointmentList *aAppointment= [self.arrAppointmentList objectAtIndex:self.editItemTag];
        [self fillValueTitle:@"Edit Appointment"
                        date:[NSDateFormatter localizedStringFromDate:aAppointment.date
                                                                                    dateStyle:NSDateFormatterShortStyle
                                                                                     timeStyle:NSDateFormatterNoStyle]
                 description:aAppointment.desc];
    }
    else if(self.historySelectedOption == 14)
    {
        ReminderList *aReminder= [self.arrReminderList objectAtIndex:self.editItemTag];
        [self fillValueTitle:@"Edit Reminder"
                        date:[NSDateFormatter localizedStringFromDate:aReminder.remDate
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterNoStyle]
                 description:aReminder.remDesc];
    }
    else if(self.historySelectedOption == 11)
    {
        NotesList *aNote= [self.arrHisOptionData objectAtIndex:self.editItemTag];
        [self fillValueTitle:@"Edit Call details"
                        date:[NSDateFormatter localizedStringFromDate:aNote.noteDate
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterNoStyle]
                 description:aNote.noteDesc];
    }
    else if(self.historySelectedOption == 13)
    {
        EmailList *aEmail= [self.arrHisOptionData objectAtIndex:self.editItemTag];
        [self fillValueTitle:@"Edit Email details"
                        date:[NSDateFormatter localizedStringFromDate:aEmail.date
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterNoStyle]
                 description:aEmail.desc];
    }
    else if(self.historySelectedOption == 15)
    {
        static NSArray *dataArray  = nil;
        if (self.selectedIndexPath.section == 0)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            NotesList *aNote = [dataArray objectAtIndex:self.selectedIndexPath.row];
            [self fillValueTitle:@"Edit Call details"
                            date:[NSDateFormatter localizedStringFromDate:aNote.noteDate
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]
                     description:aNote.noteDesc];
        }
        else if(self.selectedIndexPath.section == 1)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            AppointmentList *aAppointment = [dataArray objectAtIndex:self.selectedIndexPath.row];
            [self fillValueTitle:@"Edit Appointment"
                            date:[NSDateFormatter localizedStringFromDate:aAppointment.date
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]
                     description:aAppointment.desc];
        }
        else if (self.selectedIndexPath.section == 2)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            EmailList *aEmail = [dataArray objectAtIndex:self.selectedIndexPath.row];
            [self fillValueTitle:@"Edit Email details"
                            date:[NSDateFormatter localizedStringFromDate:aEmail.date
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]
                     description:aEmail.desc];
        }
        else if(self.selectedIndexPath.section == 3)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            ReminderList *aReminder = [dataArray objectAtIndex:self.selectedIndexPath.row];
            [self fillValueTitle:@"Edit Reminder"
                            date:[NSDateFormatter localizedStringFromDate:aReminder.remDate
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]
                     description:aReminder.remDesc];
        }
    }
}
- (void)updateHistory_RE_View
{
    if(self.historySelectedOption == 12)
    {
        AppointmentList *aAppointment= [self.arrAppointmentList objectAtIndex:self.editItemTag];
        for (UIView *aview in History_Desc_RE_View.subviews)
        {
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                aAppointment.desc = txt.text;
            }
            
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
        
        [tblHistoryOption reloadData];
    }
    else if(self.historySelectedOption == 14)
    {
        ReminderList *aReminder= [self.arrReminderList objectAtIndex:self.editItemTag];
        for (UIView *aview in History_Desc_RE_View.subviews)
        {
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                aReminder.remDesc = txt.text;
            }
            
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
        [tblHistoryOption reloadData];
    }
    else if(self.historySelectedOption == 11)
    {
        NotesList *aNote= [self.arrHisOptionData objectAtIndex:self.editItemTag];
        for (UIView *aview in History_Desc_RE_View.subviews)
        {
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                aNote.noteDesc = txt.text;
            }
            
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrHisOptionData = [NSMutableArray arrayWithArray:[[self.aContactDetails relNotes] allObjects]];
        [tblHistoryOption reloadData];
    }
    else if(self.historySelectedOption == 13)
    {
        EmailList *aEmail= [self.arrHisOptionData objectAtIndex:self.editItemTag];
        for (UIView *aview in History_Desc_RE_View.subviews)
        {
            if ([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                aEmail.desc = txt.text;
            }
            
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrHisOptionData = [NSMutableArray arrayWithArray:[[self.aContactDetails relEmailList] allObjects]];
        [tblHistoryOption reloadData];
    }
    else if(self.historySelectedOption == 15)
    {
        static NSArray *dataArray  = nil;
        if (self.selectedIndexPath.section == 0)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            NotesList *aNote = [dataArray objectAtIndex:self.selectedIndexPath.row];
            for (UIView *aview in History_Desc_RE_View.subviews)
            {
                if ([aview isKindOfClass:[UITextView class]])
                {
                    UITextView *txt = (UITextView*)aview;
                    aNote.noteDesc = txt.text;
                }
                
            }
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
            
            [tblHistoryOption reloadData];
        }
        else if(self.selectedIndexPath.section == 1)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            AppointmentList *aAppointment = [dataArray objectAtIndex:self.selectedIndexPath.row];
            for (UIView *aview in History_Desc_RE_View.subviews)
            {
                if ([aview isKindOfClass:[UITextView class]])
                {
                    UITextView *txt = (UITextView*)aview;
                    aAppointment.desc = txt.text;
                }
                
            }
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
            
            
            [tblHistoryOption reloadData];
        }
        else if (self.selectedIndexPath.section == 2)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            EmailList *aEmail = [dataArray objectAtIndex:self.selectedIndexPath.row];
            for (UIView *aview in History_Desc_RE_View.subviews)
            {
                if ([aview isKindOfClass:[UITextView class]])
                {
                    UITextView *txt = (UITextView*)aview;
                    aEmail.desc = txt.text;
                }
                
            }
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
            
            [tblHistoryOption reloadData];
        }
        else if(self.selectedIndexPath.section == 3)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            ReminderList *aReminder = [dataArray objectAtIndex:self.selectedIndexPath.row];
            for (UIView *aview in History_Desc_RE_View.subviews)
            {
                if ([aview isKindOfClass:[UITextView class]])
                {
                    UITextView *txt = (UITextView*)aview;
                    aReminder.remDesc = txt.text;
                }
                
            }
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
            
            [tblHistoryOption reloadData];
        }
    }
    
    [self resetHistory_RE_View];
}
- (void)resetHistory_RE_View
{
    [History_Desc_RE_View removeFromSuperview];
    for (UIView *aview in History_Desc_RE_View.subviews)
    {
        if ([aview isKindOfClass:[UILabel class]])
        {
            UILabel *txt = (UILabel*)aview;
            if(txt.tag != 0)
            txt.text = @"";
            [txt setUserInteractionEnabled:NO];
        }
        else if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";
        }
        
    }
}
- (IBAction)btnDelete_Tapped:(UIButton*)sender
{
    if (self.historySelectedOption == 11) //call
    {
        NotesList *aNote = [self.arrHisOptionData objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aNote];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrHisOptionData = [NSMutableArray arrayWithArray:[[self.aContactDetails relNotes] allObjects]];
        
    }
    else if (self.historySelectedOption == 12) //appoint
    {
        AppointmentList *aAppointment = [self.arrAppointmentList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aAppointment];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrAppointmentList = [NSMutableArray arrayWithArray:[[self.aContactDetails relAppointment] allObjects]];
    }
    else if (self.historySelectedOption == 13) //email
    {
        EmailList *aEmail = [self.arrHisOptionData objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aEmail];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrHisOptionData = [NSMutableArray arrayWithArray:[[self.aContactDetails relEmailList] allObjects]];
    }
    else if (self.historySelectedOption == 14) //reminder
    {
        ReminderList *aReminder = [self.arrAppointmentList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aReminder];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrReminderList = [NSMutableArray arrayWithArray:[[self.aContactDetails relReminder] allObjects]];
        
    }
    else if(self.historySelectedOption == 15)
    {
        static NSArray *dataArray  = nil;
        if (self.selectedIndexPath.section == 0)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            NotesList *aNote = [dataArray objectAtIndex:self.selectedIndexPath.row];
            
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aNote];
            
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
            
        }
        else if(self.selectedIndexPath.section == 1)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            AppointmentList *aAppointment = [dataArray objectAtIndex:self.selectedIndexPath.row];
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aAppointment];
            
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
            
        }
        else if (self.selectedIndexPath.section == 2)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            EmailList *aEmail = [dataArray objectAtIndex:self.selectedIndexPath.row];
           [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aEmail];
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
            
        }
        else if(self.selectedIndexPath.section == 3)
        {
            dataArray = [self.dictTimeLineList objectForKey:[NSString stringWithFormat:@"%d",self.selectedIndexPath.section]];
            ReminderList *aReminder = [dataArray objectAtIndex:self.selectedIndexPath.row];
             [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aReminder];
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
            
        }
    }
    NSArray *arrayValues = [NSArray arrayWithObjects:[[self.aContactDetails relNotes]        allObjects],
                            [[self.aContactDetails relAppointment]  allObjects],
                            [[self.aContactDetails relEmailList]    allObjects],
                            [[self.aContactDetails relReminder]     allObjects],
                            nil];
    
    NSArray *arrayKeys = [NSArray arrayWithObjects:@"0",@"1", @"2",@"3",nil];
    
    self.dictTimeLineList = [NSMutableDictionary dictionaryWithObjects:arrayValues forKeys:arrayKeys];
    [tblHistoryOption reloadData];
    [History_Desc_RE_View removeFromSuperview];
    
}
#pragma mark - First line code
- (IBAction)btnSelectFirstLineTapped:(UIButton *)sender
{
	
	if(self.popoverSelectFirstLine == nil)
    {
        UIViewController *vcSelectLine = [[UIViewController alloc]init];
        
        vcSelectLine.view = vwFirstLine;
        
        [vcSelectLine setContentSizeForViewInPopover:vwFirstLine.frame.size];
        
        self.popoverSelectFirstLine = [[[UIPopoverController alloc]initWithContentViewController:vcSelectLine] autorelease];
        
        
        [vcSelectLine release];
    }
	
	[vwFirstLine setFrame:CGRectMake(0, 0, 200, 100)];
	[tableEmailSelection reloadData];
	
	CGRect rect = [sender convertRect:sender.bounds toView:view_contact_list];
    [self.popoverSelectFirstLine presentPopoverFromRect:rect inView:view_contact_list permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
-(void)btnCheckBoxForFirstLineTapped:(UIButton*)sender
{
	FirstLine * line = [self.arrayFirstLine objectAtIndex:sender.tag];
	line.isSelected = !line.isSelected;
	
	[tableEmailSelection reloadData];
	
}
-(void)btnCheckForEmailSelectedTapped:(UIButton*)sender
{
	AppDelegate * aDelegate = CRM_AppDelegate;
	
	AllEmail * email = (AllEmail*)[self.arrayEmails objectAtIndex:sender.tag];
	//Set email selected
	if (![email.isSelected boolValue]  || !email.isSelected)
	{
		[email setIsSelected:[NSNumber numberWithBool:YES]];
	}
	else
		//Set email unselected
	{
		[email setIsSelected:[NSNumber numberWithBool:NO]];
	}
	
	//Set my addressBook object selected
	MyAddressBook * addressBook = email.relMyAddressBook;
	
	BOOL foundSelected = NO;
	
	for (AllEmail * email in addressBook.relEmails)
	{
		if ([email.isSelected boolValue])
		{
			//That means there is an email selected
			foundSelected = YES;
			break;
		}
	}
	
	if (foundSelected)
	{
		// if we found any selected email
		// set isSelected for myAdressBook as well
		[addressBook setIsSelected:YES];
	}else
	{
		[addressBook setIsSelected:NO];
	}
	
	if (![aDelegate.managedObjectContext save:nil]) {
		NSLog(@"Unable to save");
	}
	
	[tblContactList reloadData];
	[tableEmailContact reloadData];
}
-(void)resetAllEmails_isSelected
{
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelected == %d",1];
	
	
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"AllEmail" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
	
	for (AllEmail * emails in array)
	{
        [emails.relMyAddressBook setIsSelected:NO];
		[emails setIsSelected:[NSNumber numberWithBool:NO]];
		
		if (![((AppDelegate *)CRM_AppDelegate).managedObjectContext save:nil])
		{
			NSLog(@"Data unable to reset");
		}
	}
}
@end
