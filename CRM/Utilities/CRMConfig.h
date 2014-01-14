//
//  SMConfig.h
//  Shop4Me
//
//  Created by Developer on 14/12/11.
//  Copyright (c) 2011 My Company All rights reserved.
//

#define CRM_AppDelegate (AppDelegate*)[UIApplication sharedApplication].delegate

//http://www.xprogress.com/post-56-best-example-of-how-to-add-entry-to-contacts-using-addressbookui-framework-on-iphone-sdk/

//  the above link is used to add record in address book


enum {
    HISTORY_CALL        = 11, 
    HISTORY_EMAIL       = 13, 
    HISTORY_REMINDER    = 14, 
    HISTORY_EVENT       = 12 
};

//
//typedef NSUInteger SVProgressHUDMaskType;


//Flurry
//Its a demo flurry key
#define KdemoFlurryKey 1
//#define kFlurryApplicationKey @"X8PFYC537J5T87K2YK38" 
#define kFlurryApplicationKey @"Y4GJKY87DKR2YVSYS538" //client key




#define NS_CALL         @"NSCALL"
#define NS_PROPOSAL     @"NSPROPOSAL"
#define NS_EMAIL        @"NSEMAIL"
#define NS_TASK         @"NSTASK"
#define NS_APPOINTMENT  @"NSAPPOINTMENT"
#define NS_REMINDER     @"NSREMINDER"
#define FOLLOW_UPDATE     @"FOLLOW_UPDATE"

#define DASHBOARD_STRING @"My Dashboard"
#define CONTACT_LIST_STRING @"Contact List"
#define CONTACT_STRING @"Contact Details"
#define MAP_STRING @"Map"
#define GRAPH_STRING @"Pipeline"
#define TOUR_STRING @"Tour"
#define GOAL_STRING @"Goal"
#define COMPANY_STRING @"Company"
#define SETTINGS_STRING @"Settings"


//address keys
#define CITY_STRING @"City"
#define COUNTRY_STRING @"Country"
#define STATE_STRING @"State" 
#define STREET_STRING @"Street" 
#define ZIP_STRING @"ZIP"
#define ADDRESS_TYPE_STRING @"Address Type" 

//phones keys
#define MOBILE_NUMBER_STRING @"Mobile"
#define PHONES_NUMBER_STRING @"Main"
#define HOME_NUMBER_STRING @"Home"
#define IPHONE_NUMBER_STRING @"iPhone"
#define HANDY_NUMBER_STRING @"Händy Custom Field"
#define FAX_NUMBER_STRING @"Fax Number"
#define WORK_NUMBER_STRING @"Work"

#define FIRST_NAME_STRING	@"First Name"
#define MIDDLE_NAME_STRING	@"Middle Name"
#define LAST_NAME_STRING	@"Last Name"

#define PREFIX_STRING	@"prefix"
#define SUFFIX_STRING	@"suffix"

#define NICKNAME_STRING         @"Nickname"
#define PHONETIC_FIRST_STRING   @"First name Phonetic"
#define PHONETIC_MIDDLE_STRING  @"Middle name Phonetic"
#define PHONETIC_LAST_STRING    @"Last name Phonetic"


#define SALUTATION_STRING	@"salutation"

#define GENDER_STRING	@"Gender"
#define INDUSTRY_DESCRIPTION_STRING	@"Industry Description"
#define INDUSTRY_STRING	@"industry"
#define FUNNEL_DESCRIPTION_STRING	@"Funnel Description"

#define FUNNEL_STAGE_STRING	@"Funnel Stage"
#define GROUP_STRING	@"Group Name"
#define SUB_GROUP_STRING	@"Sub Group Name"

#define LEAD_SOURCE_STRING	@"Lead Source"
#define LEAD_STATUS_STRING	@"Lead Status"


#define ORGANIZATION_STRING	@"Organization"
#define JOBTITLE_STRING		@"Job Title"
#define DEPARTMENT_STRING	@"Department"

#define NOTE_STRING	@"Note"

#define BIRTHDAY_STRING				@"Date of Birth"
#define CREATION_DATE_STRING		@"Creation Date"
#define MODIFICATION_DATE_STRING	@"Modification Date"

#define KIND_STRING	@"Kind"



#define HOME_URL_STRING         @"Home"
#define WORK_URL_STRING         @"Work"
#define OTHER_STRING            @"Other"

#define HOME_PAGE_URL_STRING	@"Home page"
#define HOME_PAGE_STRING         @"Home url"
#define WORK_PAGE_STRING         @"Work url"

#define EMAIL_STRING	@"Email"
#define ADDRESS_STRING	@"Address"
#define DATE_STRING		@"Date"
#define PHONE_STRING	@"Phone"
#define SMS_STRING		@"Instant Message"
#define URL_STRING		@"URL"
#define RELATED_STRING	@"Related Name"

#define IMAGE_STRING	@"Contact_Image"
#define RECORD_ID_STRING	@"record Id"

#define LATITUDE_STRING @"latitude"
#define LONGITUDE_STRING @"longitude"

#define FEEDBACK_SUBJECT_STRING @"Feedback From CRM APP"

#define DROPDOWNCURRENCY @"dropDownCurrency"
#define DROPDOWNGROUP @"dropDownGroups"
#define DROPDOWNTASK @"dropDownTask"
#define DROPDOWNPRODUCT @"dropDownProduct"
#define DROPDOWNFOLLOWUPBY @"dropDownFollowUpBy"
#define DROPDOWNFIRSTLINEITEM @"dropDownFirstLine"

#define GROUP_REMINDER @"groupReminder"
#define SUBGROUP_REMINDER @"subGroupReminder"


#define EMAIL_ID_STRING	@"userEmail"
#define PASSWORD_STRING	@"userPassword"
#define IS_REMEMBER_ME_STRING	@"isRememberMe"
#define IS_ACCOUNT_CONFIGURE	@"isConfigured"
#define IS_SYNC_LOCATION	@"isSyncLocation"
#define IS_APP_FIRST_LAUNCH	@"isAppFirstLaunched"
#define IS_SALE_PIPELINE	@"isSalePipeline"
#define IS_LOCK_STRING	@"isPasswordCreated"
#define IS_PASSWORD_SAVED	@"isPasswordSaved"


#define FIRE_TIME_KEY @"kReminderFireTime"

#define NOTIFICATION_MESSAGE_KEY @"kMessage"

#define IS_REMINDER_MULTIPLE @"kMultiReminder"

#define NOTIFICATION_TITLE_KEY @"kTitle"
#define REMINDER_ID @"ID"


#define RECIPIENT_STRING	@"toRecipient"
#define SUBJECT_STRING      @"toSubject"
#define FIRST_LINE_STRING	@"toFirstLine"
#define MESSAGE_BODY_STRING	@"toMessage"


//Social Networks Keys
#define SOCIAL_STRING             @"Social"
#define SOCIAL_FACEBOOK             @"facebook"
#define SOCIAL_TWITTER              @"twitter"
#define SOCIAL_LINKEDIN             @"linkedin"
#define SOCIAL_FLICKR               @"flickr"
#define SOCIAL_MYSPACE              @"myspace"
#define SOCIAL_GOOGLE_PLUS          @"google Plus"


#pragma mark - UserVoice Keys
#define UV_CONFIG_SITE  @"https://cluecrm.uservoice.com"
//#define UV_API_KEY      @"lJavPZgV1w7hcB1N1Phg"
//#define UV_SECRET_KEY   @"Ecv3doehkaD4Kixjwgouznc0oZJDp6MQ0ZJepJxa5k"
#define UV_API_KEY      @"CfvUjkqYvEtVAq7xbyxAQ"
#define UV_SECRET_KEY   @"daz4piHGnLdDgoZrdOsNbYeTk01GrSQpFwRP5ulkQ"

//GoogleCategory keys   
//#define kGooglecategory @"AIzaSyCsQtVKjFn709aoHsCjn88gQOT-u2T_xyY" //by datanexus
#define kGooglecategory @"AIzaSyDYO4NZN2mSlvqbucPaTlm_nSdA1NUWdFQ"
#define kMinRadius @"50000"
#define MinSpanLevel 0.3

#define kEncryptionKey @"a16byteslongkey!a16byteslongkey!"

