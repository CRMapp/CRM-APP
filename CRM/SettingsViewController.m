//
//  SettingsViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 11/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewProductTVCell.h"
#import "GroupTVCell.h"
#import "ViewScriptTVCell.h"
#import "SyncTVCell.h"
#import "ProductList.h"
#import "ScriptList.h"
#import <Twitter/Twitter.h>
#import "AllUrl.h"
#import "CRMConfig.h"
#import "GlobalDataPersistence.h"
#import "Global.h"
#import "AddressBook.h"
#import "MyAddressBook.h"
#import "DHValidation.h"
#import "Reachability.h"
#import "SubGroupList.h"
#import "SubGroupTVCell.h"
#import "TouchView.h"
#import "GroupMemberList.h"
#import "AllAddress.h"
#import "AllEmail.h"
#import "AllPhone.h"
#import "AllDate.h"
#import "AllRelatedName.h"
#import "ContactViewTVCell.h"
#import "SVProgressHUD.h"
#import "ReminderList.h"
#import "FollowUpdate.h"
#import "FunnelStageList.h"
#import "EmailList.h"
#import "GroupMemberTVCell.h"
#import "PersonalDetailsTVCell.h"
#import "ABContactsHelper.h"
#import "AESEncryption.h"
#import "FBEncryptorAES.h"
#import "FirstLine.h"
#import "CheckMarkCell.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize dropDownCurrency;
@synthesize dropDownGroups;
@synthesize strDropDownCurrency;
@synthesize strDropDownGroup;
@synthesize arrProductList;
@synthesize arrScriptList;
@synthesize editItemTag;
@synthesize arrGroupList;
@synthesize arrSubGroupList;
@synthesize arrBackUpData;
@synthesize arrMapSelectedContact;
@synthesize isFromMapView;
@synthesize arrMemberList;
@synthesize dictTemp;
@synthesize arrAllKeys;
@synthesize selectedGroup;
@synthesize strDropDownItem;
@synthesize dropDownReminder;
@synthesize reminder_tag;
@synthesize email_type_tag;
@synthesize popoverSelectFirstLine;
@synthesize datePickerPopover;
@synthesize arrayFirstLine;
#pragma mark - View life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertIndusrtiesInDatabase];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertFunnelStageList];
    
    [[view_below_options layer] setCornerRadius:8.0];
    [[view_below_options layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[view_below_options layer] setBorderWidth:1.0];
    
    [self btnViewProductList:btnViewProduct];
    NSLog(@"%d",[Global GetPasswordCreated]);
    btnEnableDisable.selected = [Global GetPasswordCreated];
    if (btnEnableDisable.selected || [Global GetPasswordSaved])
    {
        txtfEmailId.text = [Global GetUserEmailFromDefaults];
        txtfPassword.text = [FBEncryptorAES decryptBase64String:[Global GetUserPassword] keyString:kEncryptionKey];
        txtfConfirmPassword.text = [FBEncryptorAES decryptBase64String:[Global GetUserPassword] keyString:kEncryptionKey];
    }

    if (self.isFromMapView)
    {
        [self btnGroup:btnGroup];
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Notice!\nCreate or Add to a Group" message:@"To import selected contacts you can create a new group or add them to an existing group by checking the group name box and clicking the \"done\" button next to the search field. " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];

    }
    
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
    [self addObserver_NotificationCenter];
    
        // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",arrMapSelectedContact);
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
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [popoverSelectFirstLine release];
    popoverSelectFirstLine = nil;
    [datePickerPopover release];
    datePickerPopover = nil;
    [view_options_landscape release];
    view_options_landscape = nil;
    
    [view_options_portrate release];
    view_options_portrate = nil;
    
    [view_create_password   release];
    [view_below_options     release];
    [view_product_list      release];
    [view_add_product       release];
    [view_grouplist         release];
    [view_script            release];
    [view_add_script        release];
    [view_sync              release];
    [view_add_group         release];
    [view_Subgroup_list     release];
    [view_add_Subgroup      release];
    [view_member_list       release];
    [view_Contact_Info      release];
    [view_add_reminder      release];
    [view_date_picker       release];
    [view_configure_email   release];
    [view_email_user        release];
    
    view_create_password    = nil;
    view_below_options      = nil;
    view_product_list       = nil;
    view_add_product        = nil;
    view_grouplist          = nil;
    view_script             = nil;
    view_add_script         = nil;
    view_sync               = nil;
    view_add_group          = nil;
    view_Subgroup_list      = nil;
    view_add_Subgroup       = nil;
    view_member_list        = nil;
    view_Contact_Info       = nil;
    view_add_reminder       = nil;
    view_date_picker        = nil;
    view_configure_email    = nil;
    view_email_user         = nil;
    
    
    [lblAddProduct1 release];
    [lblAddProduct2 release];
    [lblAddProduct3 release];
    [lblAddEditTitleGroup release];
    [lblAddEditTitleSubGroup release];
    [lblReminder release];
    
    [btnAddNewGrp release];
    [btnSetReminder release];
    [btnSendMail release];
    [btnGroup release];
    [btnEnableDisable release];
    [btnViewProduct release];
    [btnAddNewSbGrp release];
    [btnSbGrpSetReminder release];
    [btnSbGrpSendMail release];
    [btnAccounts release];
    
    [tblProductList release];
    [tblScriptList release];
    [tblGroupList release];
    [tblSubGroupList release];
    [tblContactist release];
    [tblContactInfo release];
    
    tblProductList = nil;
    tblScriptList = nil;
    tblGroupList = nil;
    tblSubGroupList = nil;
    tblContactist = nil;
    tblContactInfo = nil;
    
    [txtfEmailId release];
    [txtfPassword release];
    [txtfConfirmPassword release];
    [imgVDropDown  release];
    [txtfSearchGroupName release];
    
    [dropDownCurrency release];
    [dropDownGroups release];
    [strDropDownCurrency release];
    [strDropDownGroup release];
    [strDropDownItem release];
    
    [arrProductList release];
    [arrScriptList release];
    [arrGroupList release];
    [arrSubGroupList release];
    [arrBackUpData release];
    [arrMemberList release];
    [arrayFirstLine release];
    
    [dictTemp release];
    [arrAllKeys release];
    
    dictTemp = nil;
    arrAllKeys = nil;
    
    [arrMapSelectedContact release];
    
    arrProductList = nil;
    arrScriptList = nil;
    arrGroupList = nil;
    arrSubGroupList = nil;
    arrBackUpData = nil;
    arrMemberList = nil;
    arrMapSelectedContact = nil;
    arrayFirstLine = nil;
    
    [toolBar release];
    [dateTimePicker release];
    
    [self removeObserver_NotificationCenter];
    [vwFirstLine release];
    [tableEmailSelection release];
    [super dealloc];
}
#pragma mark - Change layouts as per orientation
-(void)changeLayout:(NSNotification*)info
{
    
    NSDictionary *themeInfo     =   [info userInfo];
    int orientation = [[themeInfo objectForKey:@"kOrientation"] intValue];
    [self updateUI:orientation];
    if (btnGroup.selected == YES)
    {
        [self updateGroupUI:orientation];
        [self updateSubGroupUI:orientation];
    }
    if(self.dropDownGroups)
    {
        [self.dropDownGroups closeTableView];
    }
    if(self.dropDownCurrency)
    {
        [self.dropDownCurrency closeTableView];
    }
    if(self.dropDownReminder)
    {
        [self.dropDownReminder closeTableView];
    }
    [tblContactInfo reloadData];
    
}
- (void)updateUI:(int)orientation
{
    if (orientation <= 2)
    {
        [view_options_portrate setHidden:NO];
        [view_options_landscape setHidden:YES];
    }
    else
    {
        [view_options_portrate setHidden:YES];
        [view_options_landscape setHidden:NO];
    }
    
}
- (void)updateGroupUI:(int)orientation
{
    if (orientation <= 2)
    {
        [btnAddNewGrp setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btnSetReminder setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [btnSendMail setImageEdgeInsets:UIEdgeInsetsMake(0, -21, 0, 0)];
    }
    else
    {
        [btnAddNewGrp setImageEdgeInsets:UIEdgeInsetsMake(0, -58, 0, 0)];
        [btnSetReminder setImageEdgeInsets:UIEdgeInsetsMake(0, -75, 0, 0)];
        [btnSendMail setImageEdgeInsets:UIEdgeInsetsMake(0, -88, 0, 0)];
    }
}
- (void)updateSubGroupUI:(int)orientation
{
    if (orientation <= 2)
    {
        [btnAddNewSbGrp setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [btnSbGrpSetReminder setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        [btnSbGrpSendMail setImageEdgeInsets:UIEdgeInsetsMake(0, -21, 0, 0)];
    }
    else
    {
        [btnAddNewSbGrp setImageEdgeInsets:UIEdgeInsetsMake(0, -58, 0, 0)];
        [btnSbGrpSetReminder setImageEdgeInsets:UIEdgeInsetsMake(0, -75, 0, 0)];
        [btnSbGrpSendMail setImageEdgeInsets:UIEdgeInsetsMake(0, -88, 0, 0)];
    }
}

#pragma mark - DropDown List methods
- (void)generateDropDown:(NSString*)aDropDown
{
    
	//Category Drop Down
	if([aDropDown isEqualToString:DROPDOWNCURRENCY])
    {
        if (dropDownCurrency) {
            [dropDownCurrency release];
            dropDownCurrency = nil;
        }
        
        self.dropDownCurrency = [[[DropDownView alloc] initWithFrame:CGRectMake(637, 3, 190, 35) target:self] autorelease];
        [self.dropDownCurrency setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [self.dropDownCurrency setBackgroundColor:[UIColor clearColor]];
        [self.dropDownCurrency.myLabel setText:@"Select Currency"];
        [view_add_product addSubview:self.dropDownCurrency];
    }
    else if([aDropDown isEqualToString:DROPDOWNGROUP])
    {
        if (dropDownGroups)
        {
            [dropDownGroups removeFromSuperview];
            [dropDownGroups release];
            dropDownGroups = nil;
        }
        
        self.dropDownGroups = [[[DropDownView alloc] initWithFrame:imgVDropDown.frame target:self] autorelease];
        [self.dropDownGroups setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self.dropDownGroups setBackgroundColor:[UIColor clearColor]];
        [self.dropDownGroups.myLabel setText:@"Select Group"];
        [view_add_Subgroup addSubview:self.dropDownGroups];
    }
    else if([aDropDown isEqualToString:DROPDOWNFOLLOWUPBY])
    {
        if (dropDownReminder)
        {
            [dropDownReminder release];
            dropDownReminder = nil;
        }
        self.dropDownReminder = [[[DropDownView alloc] initWithFrame:CGRectMake(130, 145, 260, 35) target:self] autorelease];
        [self.dropDownReminder setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
        [self.dropDownReminder setBackgroundColor:[UIColor clearColor]];
        [self.dropDownReminder.myLabel setText:@"Select Reminder Type"];
        [view_add_reminder addSubview:self.dropDownReminder];
    }
	
    
}
- (void)downloadDropDownData:(NSString*)aDropDown
{
    if([aDropDown isEqualToString:DROPDOWNCURRENCY])
    {
        NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
        //    for (int i = 0; i<[self.arrCategoryData count]; i++)
        //    {
        //        UserCategory* user = [self.arrCategoryData objectAtIndex:i];
        //        [List addObject:user.cat_name];
        //    }
        [List addObjectsFromArray:[NSArray arrayWithObjects:@"Currency1",@"Currency2",@"Currency3",@"Currency4",@"Currency5", @"Currency6",@"Currency7",@"Currency8",@"Currency9",@"Currency10",nil]];
        
        [self.dropDownCurrency setDataArray:List];
        [List release];
    }
    else if([aDropDown isEqualToString:DROPDOWNGROUP])
    {
        NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
        for (int i = 0; i<[self.arrGroupList count]; i++)
        {
            GroupList* group = [self.arrGroupList objectAtIndex:i];
            [List addObject:group.groupName];
        }
        [self.dropDownGroups setDataArray:List];
        [List release];
    }
    else if([aDropDown isEqualToString:DROPDOWNFOLLOWUPBY])
    {
        NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
        [List addObjectsFromArray:[NSArray arrayWithObjects:@"Email",@"Call",@"Proposal",@"Visit",nil]];
        [self.dropDownReminder setDataArray:List];
        [List release];
    }
}
#pragma mark DropDownView delegate method
-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
	if(self.dropDownCurrency == dropdown)
    {
        self.strDropDownCurrency = dropdown.strDropDownValue;
    }
    else if(self.dropDownGroups == dropdown)
    {
        self.strDropDownGroup = dropdown.strDropDownValue;
    }
    else if(self.dropDownReminder == dropdown)
    {
        self.strDropDownItem = dropdown.strDropDownValue;
    }
}
- (void)openDropDown:(DropDownView*)dropdown
{
    [currentTextField resignFirstResponder];
}
#pragma mark - IBAction methods
#pragma mark -

#pragma mark - top options method
- (IBAction)btnOptionTapped:(UIButton*)sender
{
    //Flurry
	[AppDelegate setFlurryEventWithSender:sender];
    [dropDownCurrency closeTableView];
    [dropDownGroups closeTableView];
    [dropDownReminder closeTableView];
    switch (sender.tag) {
        case 11:
            [self btnViewProductList:sender];
            break;
        case 12:
            [self btnGroup:sender];
            break;
        case 13:
            [self btnCreatePassword:sender];
            break;
        case 14:
            [self btnViewScript:sender];
            break;
        case 15:
            [self btnSync:sender];
            break;
            
        default:
            break;
    }
}
#pragma mark - Create password methods
-(void)btnCreatePassword:(UIButton*)sender
{
    [self removeSubviews];
    [self resetBtns:sender];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_create_password setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_create_password];
    }
    else
    {
        [view_create_password setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_create_password];
    }
    for (UIView *aview in view_create_password.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
    }
}
- (IBAction)btnSavePassword:(UIButton*)sender
{
    [AppDelegate setFlurryWithText:@"Button Save Create Password"];
    
    if ([self validateField])
    {
        [Global SaveUserEmailToDefaults:txtfEmailId.text];
//        [Global SaveUserPassword:[AESEncryption performEncryptionONString:txtfPassword.text withkey:kEncryptionKey]];
        [Global SaveUserPassword:[FBEncryptorAES encryptBase64String:txtfPassword.text keyString:kEncryptionKey separateLines:YES]];
        [Global SetPasswordSaved:YES];
        
        NSLog(@"%@",[Global GetUserPassword]);
        NSLog(@"%@",[FBEncryptorAES decryptBase64String:[Global GetUserPassword] keyString:kEncryptionKey]);
       
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password saved successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
    }
}
- (IBAction)btnEnableDisablePassword:(UIButton*)sender
{
    if (sender.selected) //disable password 
    {
        [self disablePassword];
        sender.selected = !sender.selected;
    }
    else  //enable password 
    {
        if ([self validateField])
        {
            [self enablePassword];
            sender.selected = !sender.selected;
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"App log in Password is now enabled. Please completely close the Clue application to use this feature." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [anAlertView show];
            [anAlertView release];
        }
        
    }
}
- (void)enablePassword
{
    [Global SaveUserEmailToDefaults:txtfEmailId.text];
    [Global SaveUserPassword:[FBEncryptorAES encryptBase64String:txtfPassword.text keyString:kEncryptionKey separateLines:YES                 ]];
    [Global SetPasswordCreated:YES];
}
- (void)disablePassword
{
    [Global SetPasswordCreated:NO];
}
- (BOOL)validateField
{
    DHValidation *emailValidation=[[DHValidation alloc] init];
    BOOL emailValid=[emailValidation validateEmail:txtfEmailId.text];
    [emailValidation release];
    if (txtfEmailId.text.length <=0)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
//        [txtfEmailId becomeFirstResponder];
        return NO;
    }
    else if(!emailValid)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
//        [txtfEmailId becomeFirstResponder];
        return NO;
    }
    if ([txtfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <=0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if ([txtfConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <=0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter confirm password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if (!([txtfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >= 6 && [txtfPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 16))
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password should have 6 to 16 characters in length" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if (![txtfPassword.text isEqualToString:txtfConfirmPassword.text])
    {
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Confirm password must be same." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        return NO;
        
    }
    return YES;
}
#pragma mark - Configure Account
- (IBAction)btnConfigureAccount:(id)sender
{
    //Flurry
	[AppDelegate setFlurryEventWithSender:(UIButton *)sender];
    
    [view_create_password removeFromSuperview];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [view_configure_email layer].cornerRadius = 8.0;
    [view_configure_email layer].borderWidth  = .5;
    [[view_configure_email layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    if (orientation <= 2)
    {
        [view_configure_email setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_configure_email];
    }
    else
    {
        [view_configure_email setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_configure_email];
    }
    for (UIView *aview in view_configure_email.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
            [txt setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        }
    }
}
- (NSString*)validateEmail:(NSString*)email
{
    NSString *retStr = nil;
    DHValidation *emailValidation=[[DHValidation alloc] init];
    BOOL emailValid=[emailValidation validateEmail:email];
    [emailValidation release];
    if (email.length <=0)
    {
        return @"Please enter your email";
    }
    else if(!emailValid)
    {
        return  @"Please enter a valid email.";
    }
    return retStr;
}
- (NSString*)validatePassword:(NSString*)pass
{
    NSString *retStr = nil;
    
    if ([pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <=0)
    {
        return @"Please enter your password";
    }
    //    else if (!([pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >= 6 && [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 16))
    //    {
    //        return @"Password should have 6 to 16 characters in length";
    //    }
    return  retStr;
    
}
- (void)saveAccountDetails
{
    NSString * message = nil;
    NSString *email = nil;
    NSString *pass = nil;
    NSString *host = nil;
    for (UIView *aview in view_configure_email.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            
            if (txt.tag == 1)
            {
                if ([self validateEmail:[[txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString]])
                {
                    message = [self validateEmail:[[txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString]];
                    break;
                }
                else
                {
                    email = [txt.text lowercaseString];
                }
                
            }
            if (txt.tag == 2)
            {
                if ([self validatePassword:[txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]])
                {
                    message = [self validatePassword:[[txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString]];
                    break;
                }
                else
                {
                    pass = txt.text;
                }
            }
            if (txt.tag == 3)
            {
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
                {
                    message = @"Please enter SMTP host";
                    break;
                }
                else
                {
                    host = [txt.text lowercaseString];
                }
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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:email                           forKey:@"fromEmail"];
        [userDefaults setObject:email                           forKey:@"toEmail"];
        [userDefaults setObject:host                            forKey:@"relayHost"];
        [userDefaults setObject:email                           forKey:@"login"];
        [userDefaults setObject:pass                            forKey:@"pass"];
        [userDefaults setObject:[NSNumber numberWithBool:YES]   forKey:@"requiresAuth"];
        [userDefaults setObject:[NSNumber numberWithBool:YES]   forKey:@"wantsSecure"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //test email
        NSMutableArray      *emailsArray = [NSMutableArray array];
        
        NSMutableDictionary *emailsDict  = [NSMutableDictionary dictionary];
        [emailsDict setObject:email  forKey:RECIPIENT_STRING];
        [emailsDict setObject:@"test mail" forKey:SUBJECT_STRING];
        [emailsDict setObject:@"" forKey:FIRST_LINE_STRING];
        [emailsDict setObject:@"" forKey:MESSAGE_BODY_STRING];
        [emailsArray addObject:emailsDict];
        SMTPSender *smtp = [SMTPSender sharedSMTPSender];
        [smtp setADelegate:self];
        [smtp setIsTesting:YES];
        [smtp sendEmailToUsers:emailsArray message:@"Authenticating"];
        
    }
}
#pragma mark - View product methods
-(void)btnViewProductList:(UIButton*)sender
{
    [self removeSubviews];
    [self resetBtns:sender];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_product_list setFrame:CGRectMake(0, 0, view_below_options.frame.size.width, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_product_list];
    }
    else
    {
        [view_product_list setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_product_list];
    }
    self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    [tblProductList reloadData];
    
}
- (IBAction)btnAddProduct:(id)sender
{
    //Flurry
	[AppDelegate setFlurryEventWithSender:sender];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_add_product setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_product];
    }
    else
    {
        [view_add_product setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_product];
    }
//    [self btnRadioAddProduct:btnEnterProduct];
    for (UIView *aview in view_add_product.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
    }
    
//    [self generateDropDown:DROPDOWNCURRENCY];
//    [self downloadDropDownData:DROPDOWNCURRENCY];
    
}
- (void)saveProduct
{
    NSString *message = nil;
    for (UIView *aview in view_add_product.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter product name.";
                //                if (txt.tag == 2)   message = @"Please enter product code.";
                if (txt.tag == 2)   message = @"Please enter product price.";
//                if (txt.tag == 3)   message = @"Please enter product description.";
//                if (txt.tag == 4)   message = @"Please enter product code.";
                break;
            }
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
//                message = @"Please enter product description.";
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
        ProductList *aProductList = (ProductList *)[NSEntityDescription insertNewObjectForEntityForName:@"ProductList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_product.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                
                if (txt.tag == 1)
                {
                    [aProductList setProductName:txt.text];
                }
                else if (txt.tag == 4)
                {
                    [aProductList setProductCode:txt.text];
                }
                else if (txt.tag == 2)
                {
                    [aProductList setPrice:[Global convertStringToNumberFormatter:txt.text withDollerSign:NO]];
                }
//                else if (txt.tag == 3)
//                {
//                    
//                }
                
            }
            else if([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                {
                    [aProductList setProductDesc:txt.text];
                }
            }
        }
        if (strDropDownCurrency != nil)
        {
            [aProductList setCurrency:self.strDropDownCurrency];
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblProductList reloadData];
        [self resetProductView];
        self.strDropDownCurrency = nil;
    }
}
- (void)editProduct:(UIButton*)sender
{
    isEditing = YES;
    self.editItemTag = sender.tag;
    ProductList *aProduct = [self.arrProductList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_product.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aProduct.productName;
            }
            else if (txt.tag == 4)
            {
                txt.text = aProduct.productCode;
            }
            else if (txt.tag == 2)
            {
                txt.text = [Global convertStringToNumberFormatter:aProduct.price withDollerSign:YES];
            }
//            else if (txt.tag == 3)
//            {
//                txt.text = aProduct.productDesc;
//            }
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                txt.text = aProduct.productDesc;
            }
        }
    }
    [self btnAddProduct:nil];
    
}
- (void)updateProduct
{
    ProductList *aProduct = [self.arrProductList objectAtIndex:self.editItemTag];
    NSString *message = nil;
    for (UIView *aview in view_add_product.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter product name.";
//                if (txt.tag == 4)   message = @"Please enter product code.";
                if (txt.tag == 2)   message = @"Please enter product price.";
//                if (txt.tag == 3)   message = @"Please enter product description.";
                break;
            }
            if (txt.tag == 1)
            {
                [aProduct setProductName:txt.text];
            }
            else if (txt.tag == 4)
            {
                [aProduct setProductCode:txt.text];
            }
            else if (txt.tag == 2)
            {
                [aProduct setPrice:[Global convertStringToNumberFormatter:txt.text withDollerSign:NO]];
            }
//            else if (txt.tag == 3)
//            {
//                
//            }
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
//            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aProduct setProductDesc:txt.text];
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
        if (strDropDownCurrency != nil)
        {
            [aProduct setCurrency:self.strDropDownCurrency];
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblProductList reloadData];
        [self resetProductView];
        self.strDropDownCurrency = nil;
        self.editItemTag = nil;
    }
}
- (void)deleteProduct:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete product?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1001];
    [anAlertView show];
    [anAlertView release];
}
- (void)resetProductView
{
    for (UIView *aview in view_add_product.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = @"";
            }
            else if (txt.tag == 2)
            {
                txt.text = @"";
            }
            else if (txt.tag == 3)
            {
                txt.text = @"";
            }
            else if (txt.tag == 4)
            {
                txt.text = @"";
            }
            
        }
        if ([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";
        }
    }
    [view_add_product removeFromSuperview];
}
- (IBAction)btnRadioAddProduct:(UIButton*)sender
{
//    [btnEnterProduct setSelected:NO];
//    [btnUploadCSV setSelected:NO];
    sender.selected = !sender.selected;
    if (sender.tag == 1)
    {
        [lblAddProduct1 setText:@"Enter Product"];
        [lblAddProduct2 setText:@"Product Code"];
        [lblAddProduct3 setText:@"Price"];
    }
    else
    {
        [lblAddProduct1 setText:@"Product Name"];
        [lblAddProduct2 setText:@"Price"];
        [lblAddProduct3 setText:@"Upload CSV File"];
    }
    
}
#pragma mark-
#pragma mark - view script methods
-(void)btnViewScript:(UIButton*)sender
{
    [self removeSubviews];
    [self resetBtns:sender];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_script setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_script];
    }
    else
    {
        [view_script setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_script];
    }
    self.arrScriptList = [CoreDataHelper getObjectsForEntity:@"ScriptList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    [tblScriptList reloadData];
}
- (IBAction)btnAddScript:(id)sender
{
    //Flurry
	[AppDelegate setFlurryEventWithSender:(UIButton*)sender];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_add_script setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_script];
    }
    else
    {
        [view_add_script setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_script];
    }
    for (UIView *aview in view_add_script.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
    }
}
- (void)saveScript
{

    NSString *message = nil;
    
    for (UIView *aview in view_add_script.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter script name.";
//                if (txt.tag == 2)   message = @"Please enter script decription.";
//                if (txt.tag == 3)   message = @"Please enter script.";
             
            }
        }
        if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 && txt.tag == 102)
            {
                message = @"Please enter script.";
            }
            else if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 && txt.tag == 101)
            {
                message = @"Please enter script decription.";
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
        ScriptList *aScriptList = (ScriptList *)[NSEntityDescription insertNewObjectForEntityForName:@"ScriptList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_script.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;

                if (txt.tag == 1)
                {
                    [aScriptList setScriptName:txt.text];
                }
//                else if (txt.tag == 2)
//                {
//                    [aScriptList setScript_Description:txt.text];
//                }
//                else if (txt.tag == 3)
//                {
//                    [aScriptList setScriptText:txt.text];
//                }
                
            }
            if([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if (txt.tag == 101)
                {
                    [aScriptList setScript_Description:txt.text];
                }
                else if (txt.tag == 102)
                {
                    [aScriptList setScriptText:txt.text];
                }
            }
            
        }
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        [aScriptList setScript_date:dateString];
        
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        self.arrScriptList = [CoreDataHelper getObjectsForEntity:@"ScriptList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblScriptList reloadData];
        [self resetScriptView];
    }
}
- (void)resetScriptView
{
    for (UIView *aview in view_add_script.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = @"";
            }
            else if (txt.tag == 2)
            {
                txt.text = @"";
            }
//            else if (txt.tag == 3)
//            {
//                txt.text = @"";
//            }
        }
        if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            txt.text = @"";
        }
    }
    [view_add_script removeFromSuperview];
}
- (void)editScript:(UIButton*)sender
{
    isEditing = YES;
    self.editItemTag = sender.tag;
    ScriptList *aScript= [self.arrScriptList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_script.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aScript.scriptName;
            }
            else if (txt.tag == 2)
            {
                txt.text = aScript.script_Description;
            }
//            else if (txt.tag == 3)
//            {
//                txt.text = aScript.scriptText;
//            }
            
        }
        if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if (txt.tag == 101)
            {
                txt.text = aScript.script_Description;
            }
            else if (txt.tag == 102)
            {
                txt.text = aScript.scriptText;
            }
            
        }
    }
    [self btnAddScript:nil];
}
- (void)updateScript
{
    ScriptList *aScript= [self.arrScriptList objectAtIndex:self.editItemTag];
    NSString *message = nil;
    
    for (UIView *aview in view_add_script.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter script name.";
                if (txt.tag == 2)   message = @"Please enter script decription.";
                if (txt.tag == 3)   message = @"Please enter script.";
                break;
            }
            if (txt.tag == 1)
            {
                [aScript setScriptName:txt.text];
            }
            else if (txt.tag == 2)
            {
                [aScript setScript_Description:txt.text];
            }
//            else if (txt.tag == 3)
//            {
//                [aScript setScriptText:txt.text];
//            }
        }
        if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if (txt.tag == 101)
            {
                [aScript setScript_Description:txt.text];
            }
            else if (txt.tag == 102)
            {
                [aScript setScriptText:txt.text];
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
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterNoStyle];
        [aScript setScript_date:dateString];
        
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        self.arrScriptList = [CoreDataHelper getObjectsForEntity:@"ScriptList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblScriptList reloadData];
        [self resetScriptView];
    }
}
- (void)deleteScript:(UIButton*)sender
{
    
    //Flurry
	[AppDelegate setFlurryWithText:@"Delete Script"];
    
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete script?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1004];
    [anAlertView show];
    [anAlertView release];
    
}
#pragma mark-

#pragma mark - Sync methods
-(void)btnSync:(UIButton*)sender
{
    [self removeSubviews];
    [self resetBtns:sender];
    /*if ([self.arrBackUpData count])
    {
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        GDP.arrMyAddressBookData  = [NSMutableArray arrayWithArray:self.arrBackUpData];
        self.arrBackUpData = nil;
        [txtfSearchContact setText:@""];
    }*/
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_sync setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_sync];
    }
    else
    {
        [view_sync setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_sync];
    }
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    if ([GDP.arrMyAddressBookData count] <= 0)
    {
        [AddressBook arrayOfAddressBook];
        ///Users/Vikash/Library/Application Support/iPhone Simulator/6.1/Applications/321714DD-8424-49BD-BEDF-527B161074BB/Documents/A46966E0-0421-41E4-9206-1E0F95D38AB9.png
        GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    }
     [tblContactist reloadData];

}
- (IBAction)btnSyncToAppDatabase:(id)sender //from ipad addressbook to app database
{
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Beta Sync" message:@"Clue will save your iPad contacts to the Clue app. NOTE: All selected contacts information on the Clue app contact will be REPLACED with the iPad contact information. Please back up your iPad contact data before you sync. Select OK if you want to REPLACE the Clue app contact data with the iPad contact data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Skip",nil];
    [anAlertView setTag:1052];
    [anAlertView show];
    [anAlertView release];
    
}

- (void)syncToAppDatabase{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    if ([GDP.arrMyAddressBookData count] == 0){
        [AddressBook arrayOfAddressBook];
        GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    }
    else{
        GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (MyAddressBook *aContact in GDP.arrMyAddressBookData){
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aContact];
        }
        if([((AppDelegate*)CRM_AppDelegate).managedObjectContext hasChanges]){
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        }
        [AddressBook updateAppDatabaseFromiPad];
    }
    GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    [tblContactist reloadData];
    [SVProgressHUD dismissWithSuccess:@"Done"];
}

- (void)syncToAddressBook{
    NSMutableArray *arrayOfAddressBook = [AddressBook collectContactsWithoutSave];
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    for (MyAddressBook *myAdd in GDP.arrMyAddressBookData){
        if(myAdd.isSelected){
            BOOL isUpdate = [ABContactsHelper canUpdateContact:myAdd];
            myAdd.isSelected = NO;
            if (isUpdate){
                continue;
            }
            BOOL isFound = NO;
            for (NSDictionary *aDict in arrayOfAddressBook){
                if ([[aDict objectForKey:RECORD_ID_STRING] integerValue] == [[myAdd recordID] integerValue]){
                    isFound = YES;
                    break;
                }
            }
            if (!isFound){
                [self saveContactToAddressBook:myAdd];
            }
        }
    }
    [tblContactist reloadData];
    [SVProgressHUD dismissWithSuccess:@"Done"];
}

- (IBAction)addContactToAddressBook
{
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Beta Sync" message:@"Clue will save your Clue app contacts to the iPad address book. NOTE: All selected contacts information on the iPad contacts will be REPLACED with the Clue app contact information. Please back up your iPad contact data before you sync. Select OK if you have backed up your iPad contact data and you want to REPLACE it with the Clue app contact data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Skip",nil];
    [anAlertView setTag:1051];
    [anAlertView show];
    [anAlertView release];
    
}
- (BOOL)saveContactToAddressBook:(MyAddressBook*)aContact
{
    // Creating new entry
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef person = ABPersonCreate();
    
    //Setting image property
    [self setImage:[UIImage imageWithContentsOfFile:aContact.image] record:person];
    
    // Setting basic properties
    ABRecordSetValue(person, kABPersonFirstNameProperty,                aContact.firstName , nil);
    ABRecordSetValue(person, kABPersonMiddleNameProperty,               aContact.middleName , nil);
    ABRecordSetValue(person, kABPersonLastNameProperty,                 aContact.lastName , nil);
    
    ABRecordSetValue(person, kABPersonPrefixProperty,                   aContact.prefix , nil);
    ABRecordSetValue(person, kABPersonSuffixProperty,                   aContact.suffix , nil);
    
    ABRecordSetValue(person, kABPersonJobTitleProperty,                 aContact.jobTitle , nil);
    ABRecordSetValue(person, kABPersonDepartmentProperty,               aContact.department , nil);
    ABRecordSetValue(person, kABPersonOrganizationProperty,             aContact.organisation , nil);
    
    ABRecordSetValue(person, kABPersonNoteProperty,                     aContact.note , nil);
    
    ABRecordSetValue(person, kABPersonBirthdayProperty,                 aContact.birthDay , nil);
    ABRecordSetValue(person, kABPersonCreationDateProperty,             aContact.creationDate , nil);
    ABRecordSetValue(person, kABPersonModificationDateProperty,         [NSDate date] , nil);
    
    ABRecordSetValue(person, kABPersonFirstNamePhoneticProperty,        aContact.firstNamePh , nil);
    ABRecordSetValue(person, kABPersonMiddleNamePhoneticProperty,       aContact.middleNamePh , nil);
    ABRecordSetValue(person, kABPersonLastNamePhoneticProperty,         aContact.lastNamePh , nil);
    
    // Adding phone numbers
    
    {
        NSArray *phoneslist = [[aContact relAllPhone] allObjects];
        
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        
        for (AllPhone *phones in phoneslist)
        {
           ABMultiValueAddValueAndLabel(phoneNumberMultiValue, phones.phoneNumber,        (CFStringRef)phones.phoneTitle, NULL);
            ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        }
        
        
        CFRelease(phoneNumberMultiValue);
    }


    
    // Adding url
    {
        NSArray *urlslist = [[aContact relAllUrl] allObjects];
        ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllUrl *aUrl in urlslist)
        {
            ABMultiValueAddValueAndLabel(urlMultiValue, aUrl.urlAddress, (CFStringRef)aUrl.urlTitle, NULL);
            ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
        }
        
        CFRelease(urlMultiValue);
    }
    
    // Adding emails
    {
        NSArray *emailslist = [[aContact relEmails] allObjects];
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllEmail *emails in emailslist)
        {
            ABMultiValueAddValueAndLabel(emailMultiValue, emails.emailURL,        (CFStringRef)emails.emailTitle, NULL);
            ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
        }
        
        CFRelease(emailMultiValue);
    }
    
    // Adding address
    {
        NSArray *addList = [[aContact relAllAddress] allObjects];
        
        ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        for (AllAddress *address in addList)
        {
            NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
            if(address.zipCode)
                [addressDictionary setObject:address.zipCode        forKey:(NSString *)kABPersonAddressZIPKey];
            if(address.street)
                [addressDictionary setObject:address.street         forKey:(NSString *)kABPersonAddressStreetKey];
            if(address.city)
                [addressDictionary setObject:address.city           forKey:(NSString *)kABPersonAddressCityKey];
            if(address.state)
                [addressDictionary setObject:address.state          forKey:(NSString *)kABPersonAddressStateKey];
            if(address.countryCode)
                [addressDictionary setObject:address.countryCode    forKey:(NSString *)kABPersonAddressCountryKey];
            //    [addressDictionary setObject:address.countryCode forKey:(NSString *)kABPersonAddressCountryCodeKey];
            ABMultiValueAddValueAndLabel(addressMultipleValue, addressDictionary, (CFStringRef)address.addressType, NULL);
            [addressDictionary release];
            
            ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
        }
        CFRelease(addressMultipleValue);
    }
    // Adding social profiles
    {
        
        ABMultiValueRef social = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        //adding social twitter
        ABMultiValueAddValueAndLabel(social, (CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (NSString *)kABPersonSocialProfileServiceTwitter, kABPersonSocialProfileServiceKey,
                                                                   aContact.twitter, kABPersonSocialProfileUsernameKey,
                                                                   nil]), kABPersonSocialProfileServiceTwitter, NULL);
        //adding social facebook
        ABMultiValueAddValueAndLabel(social, (CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                    (NSString *)kABPersonSocialProfileServiceFacebook, kABPersonSocialProfileServiceKey,
                                    aContact.facebook, kABPersonSocialProfileUsernameKey,
                                    nil]), kABPersonSocialProfileServiceFacebook, NULL);
        //adding social linkedin
        ABMultiValueAddValueAndLabel(social, (CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                          (NSString *)kABPersonSocialProfileServiceLinkedIn, kABPersonSocialProfileServiceKey,
                                                          aContact.linkedin, kABPersonSocialProfileUsernameKey,
                                                          nil]), kABPersonSocialProfileServiceLinkedIn, NULL);
        
        ABRecordSetValue(person, kABPersonSocialProfileProperty, social, NULL);
        CFRelease(social);
    }
    //Alldates
    {
        NSArray *dateList = [[aContact relAllDates] allObjects];
        ABMutableMultiValueRef datesMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllDate *aDate in dateList)
        {
            ABMultiValueAddValueAndLabel(datesMultiValue, aDate.dates, (CFStringRef)aDate.dateTitle, NULL);
            ABRecordSetValue(person, kABPersonDateProperty, datesMultiValue, nil);
        }
        
        CFRelease(datesMultiValue);
    }
    
    //All related names
    {
        NSArray *relatedList = [[aContact relAllRelatedNames] allObjects];
        ABMutableMultiValueRef relatedMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (AllRelatedName *arelated in relatedList)
        {
            if(arelated.relatedNames && arelated.nameTitle)
            ABMultiValueAddValueAndLabel(relatedMultiValue, [NSString stringWithString:arelated.relatedNames], (CFStringRef)[NSString stringWithString:arelated.nameTitle], NULL);
            ABRecordSetValue(person, kABPersonRelatedNamesProperty, relatedMultiValue, nil);
        }
        CFRelease(relatedMultiValue);
    }
    
    // Adding person to the address book
    ABAddressBookAddRecord(addressBook, person, nil);
    BOOL isSaved = ABAddressBookSave(addressBook, nil);
    CFRelease(addressBook);
    CFRelease(person);
    
    return isSaved;
}
- (void) setImage: (UIImage *) image record:(ABRecordRef)record
{
	CFErrorRef error;
	BOOL success;
	
	if (image == nil) // remove
	{
		if (!ABPersonHasImageData(record)) return; // no image to remove
		success = ABPersonRemoveImageData(record, &error);
		if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
		return;
	}
	
	NSData *data = UIImagePNGRepresentation(image);
	success = ABPersonSetImageData(record, (CFDataRef) data, &error);
	if (!success) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
}
- (void)btnCheckTapped:(UIButton*)sender
{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    MyAddressBook *aContact= [GDP.arrMyAddressBookData objectAtIndex:sender.tag];
    
    if(sender.selected)
    {
        sender.selected = !sender.selected;
        aContact.isSelected = sender.selected;
    }
    else
    {
        sender.selected = !sender.selected;
        aContact.isSelected = sender.selected;
    }
    
    [GDP.arrMyAddressBookData replaceObjectAtIndex:sender.tag withObject:aContact];
    
}
- (IBAction)btnSelectAllContacts:(UIButton*)sender
{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    
    for (MyAddressBook *aContact in GDP.arrMyAddressBookData)
    {
        aContact.isSelected = !sender.selected;
    }
    sender.selected = !sender.selected;
    [tblContactist reloadData];
}
#pragma mark view group methods
- (IBAction)btnAddNewGroup:(id)sender
{
    //Flurry
	[AppDelegate setFlurryEventWithSender:sender];
	
    [self removeSubviews];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_add_group setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_group];
    }
    else
    {
        [view_add_group setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_group];
    }
    for (UIView *aview in view_add_group.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
        }
    }
    lblAddEditTitleGroup.text = @"Add New Group";
    for (UIView *aview in view_add_group.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                [txt setDelegate:self];
            }
            break;
//            else if (txt.tag == 2)
//            {
//                [txt setDelegate:self];
//            }
        }
    }
    [view_grouplist removeFromSuperview];
    
}

-(void)btnGroup:(UIButton*)sender
{
    if(self.arrGroupList != nil)             {  [arrGroupList release];          arrGroupList = nil;           }
    if(self.arrSubGroupList != nil)          {  [arrSubGroupList release];      arrSubGroupList = nil;         }
    
    [self removeSubviews];
    [self resetBtns:sender];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_grouplist setFrame:CGRectMake(0, 0, view_below_options.frame.size.width, view_below_options.frame.size.height)];
        [view_grouplist setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [view_below_options addSubview:view_grouplist];
    }
    else
    {
        [view_grouplist setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_grouplist];
    }
    
    self.arrGroupList = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    [tblGroupList reloadData];
    
    [self updateGroupUI:orientation];
}
- (void)saveNewGroup
{
    NSString *message = nil;
    NSString *grpName = nil;
    for (UIView *aview in view_add_group.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter group name.";
//                if (txt.tag == 2)   message = @"Please enter group description.";
//                break;
            }
            if (txt.tag == 1)
            {
                grpName = txt.text;
            }
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                message = @"Please enter group description.";
            }
        }
        
    }
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"groupName contains[cd] %@",grpName];
    
    NSArray *groupArr = [CoreDataHelper searchObjectsForEntity:@"GroupList" withPredicate:myPredicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    if ([groupArr count])
    {
        message = @"Group name already exist.";
    }
    
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        GroupList *aGroupList = (GroupList *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        for (UIView *aview in view_add_group.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
    
                if (txt.tag == 1)
                {
                    [aGroupList setGroupName:txt.text];
                }
//                else if (txt.tag == 2)
//                {
//                    [aGroupList setGroupDesc:txt.text];
//                }
            }
            else if([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                {
                    [aGroupList setGroupDesc:txt.text];
                }
            }
            
        }
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrGroupList = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        
        [tblGroupList reloadData];
        
        [self btnGroup:btnGroup];
        [self resetNewGroupView];
    }
}
- (void)resetNewGroupView
{
    for (UIView *aview in view_add_group.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = @"";
            }
//            else if (txt.tag == 2)
//            {
//                txt.text = @"";
//            }
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                txt.text = @"";
            }
        }
    }
    [view_add_group removeFromSuperview];
    [self btnGroup:btnGroup];
}
- (void)updateGroup
{
    GroupList *aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
    NSString *message = nil;
    for (UIView *aview in view_add_group.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter group name.";
                if (txt.tag == 2)   message = @"Please enter group description.";
                break;
            }
            if (txt.tag == 1)
            {
                [aGroup setGroupName:txt.text];
            }
//            else if (txt.tag == 2)
//            {
//                [aGroup setGroupDesc:txt.text];
//            } 
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
            {
                [aGroup setGroupDesc:txt.text];
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
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        
        self.arrGroupList = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblGroupList reloadData];
        [self resetNewGroupView];
    }
}
- (void)deleteGroup:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete group?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1002];
    [anAlertView show];
    [anAlertView release];
    
}
- (void)editGroup:(UIButton*)sender
{
    isEditing = YES;
    self.editItemTag = sender.tag;
    GroupList *aGroup= [self.arrGroupList objectAtIndex:sender.tag];
    
    //Flurry
	NSDictionary * dict = [NSDictionary dictionaryWithObject:aGroup.groupName forKey:@"groupName"];
	[AppDelegate setFlurryWithText:@"Setting View edit Group" andParms:dict];
    
    for (UIView *aview in view_add_group.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aGroup.groupName;
            }
//            else if (txt.tag == 2)
//            {
//                
//            }
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                txt.text = aGroup.groupDesc;
            }
        }
    }
    [self btnAddNewGroup:nil];
    lblAddEditTitleGroup.text = @"Edit Group";
}
- (void)groupCheckTapped:(UIButton*)sender
{
    GroupList *aGroup= [self.arrGroupList objectAtIndex:sender.tag];
    
    if(sender.selected)
    {
        sender.selected = !sender.selected;
        aGroup.isGroupCheck = sender.selected;
    }
    else
    {
        sender.selected = !sender.selected;
        aGroup.isGroupCheck = sender.selected;
    }
    if (self.isFromMapView)
    {
        [btnGroupDone setHidden:NO];
    }
    [self.arrGroupList replaceObjectAtIndex:sender.tag withObject:aGroup];
 
    [tblGroupList reloadData];
}
- (BOOL)checkMemberAlreadyExistInGroupList:(NSArray*)memArr aMember:(MyAddressBook*)aMember
{
    for (GroupMemberList *amem in memArr)
    {
        if ([amem.memRecordID isEqualToString:aMember.recordID])
        {
            return YES;
            break;
        }
    }
    return NO;
}
- (void)resetGroupTable
{
    for (int i = 0; i < [self.arrGroupList count]; i++)
    {
        GroupList *aGroup= [self.arrGroupList objectAtIndex:i];
        aGroup.isGroupCheck = NO;
        [self.arrGroupList replaceObjectAtIndex:i withObject:aGroup];
    }
    [tblGroupList reloadData];
    [btnGroupDone setHidden:YES];
}
- (void)showMemberDetails:(id)sender
{
    //Flurry
	[AppDelegate setFlurryWithText:@"Setting Show Member Details"];
    
    UIButton *btn = (UIButton*)sender;
    
    GroupMemberList *aGroupMember= [self.arrMemberList objectAtIndex:btn.tag];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",aGroupMember.memRecordID];
    
    NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    NSLog(@"%@",previousEntry);
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_Contact_Info setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_Contact_Info];
    }
    else
    {
        [view_Contact_Info setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_Contact_Info];
    }
    [self loadContactDetail:[previousEntry lastObject]];
    [tblContactInfo reloadData];
}
- (void)deleteMemberFromGroup:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    self.editItemTag = btn.tag;
    
    //Flurry
	[AppDelegate setFlurryWithText:@"Delete member From Group"];
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete group member?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1022];
    [anAlertView show];
    [anAlertView release];
}
#pragma mark - Reminder methods
- (IBAction)btnAddReminder_Tapped:(id)sender
{
    //Flurry
    BOOL isGroupChk = NO;
    for (GroupList *group in self.arrGroupList)
    {
        if (group.isGroupCheck == YES)
        {
            isGroupChk = YES;
        }
    }
    if(isGroupChk)
    {
        [AppDelegate setFlurryEventWithSender:sender];
        
        [self.dropDownReminder removeFromSuperview];
        UIButton *btn = (UIButton*)sender;
        if (btn.superview == view_Subgroup_list)
        {
            [view_Subgroup_list removeFromSuperview];
        }
        if (btn.superview == view_grouplist)
        {
            [view_grouplist removeFromSuperview];
        }
        
        self.reminder_tag = btn.tag;
        
        //http://stackoverflow.com/questions/9232490/how-do-i-create-and-cancel-unique-uilocalnotification-from-a-custom-class
        [view_grouplist removeFromSuperview];
        self.strDropDownItem = nil;
        [lblReminder setText:@"Add New Reminder"];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
        [view_add_reminder layer].cornerRadius = 8.0;
        [view_add_reminder layer].borderWidth  = .5;
        [[view_add_reminder layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
        if (orientation <= 2)
        {
            [view_add_reminder setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
            [view_below_options addSubview:view_add_reminder];
        }
        else
        {
            [view_add_reminder setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
            [view_below_options addSubview:view_add_reminder];
        }
        for (UIView *aview in view_add_reminder.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                txt.text = @"";
                [txt setDelegate:self];
            }
        }
        [self generateDropDown:DROPDOWNFOLLOWUPBY];
        [self downloadDropDownData:DROPDOWNFOLLOWUPBY];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one group." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
	
}
- (void)saveGroup_Reminder
{
    self.reminder_tag = 101;
    NSString * message = nil;
    
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == 0)
            {
                if (txt.tag == 1)   message = @"Please enter reminder title.";
                if (txt.tag == 2)   message = @"Please enter reminder description.";
//                if (txt.tag == 4)   message = @"Please enter reminder location.";
                if (txt.tag == 5)   message = @"Please enter reminder date.";
                break;
            }
        }
        
    }
    if(self.strDropDownItem == nil || [self.strDropDownItem rangeOfString:@"Select Reminder Type" options:NSCaseInsensitiveSearch].length) message = @"Please select follow up by.";
    
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        BOOL isGroupChk = NO;
        int reminderCount = 0;
        for (GroupList *group in self.arrGroupList)
        {
            if (group.isGroupCheck == YES)
            {
                isGroupChk = YES;
                NSArray *members = [NSArray arrayWithArray:[[group relGroupMember] allObjects]];
                if ([members count])
                {
                    for (GroupMemberList *person in members)
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
                                if (txt.tag == 4)
                                {
                                    [aReminderList setRemLocation:txt.text];
                                }
                                if (txt.tag == 5)
                                {
                                    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                                    [DateFormatter setDateStyle:NSDateFormatterShortStyle];
                                    [aReminderList setRemDate:[DateFormatter dateFromString:txt.text]];
                                    [DateFormatter release];
                                }
                                
                            }
                            
                        }
                        [aReminderList setRemUniqueID:[self getRandomAlphanumericString]];
                        [aReminderList setRemFollowUpBy:self.strDropDownItem];
                        
                        [aReminderList setTimeStamp:[[NSDate date] timeIntervalSince1970]];
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",person.memRecordID];
                        
                        NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                        
                        MyAddressBook *myPerson = [previousEntry lastObject];
                        
                        [aReminderList setRelMyAddressBook:myPerson];
                        
                        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
                        reminderCount = reminderCount +1;
                        NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  dateTimePicker.date,FIRE_TIME_KEY,
                                                  aReminderList.remTitle,NOTIFICATION_TITLE_KEY,
                                                  aReminderList.remUniqueID,REMINDER_ID,
//                                                  aReminderList.remDesc,NOTIFICATION_MESSAGE_KEY,
                                                  [NSString stringWithFormat:@"You are about to add %d contacts to your %@ list",reminderCount,aReminderList.remFollowUpBy],NOTIFICATION_MESSAGE_KEY,
                                                  @"YES",IS_REMINDER_MULTIPLE,nil];
                        
                        [self scheduleReminder:itemDict];
                        
                        
                        
                        [self saveNS_FollowUpdate:myPerson];
                    }
                    
                }
                
            }
        }
        if(isGroupChk)
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Reminder set successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [anAlertView show];
            [anAlertView release];
            [self reset_Reminder];
            self.reminder_tag = -999;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one group." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
}
- (void)saveSubGroup_Reminder
{
    self.reminder_tag = 102;
    NSString * message = nil;
    
    for (UIView *aview in view_add_reminder.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == 0)
            {
                if (txt.tag == 1)   message = @"Please enter reminder title.";
                if (txt.tag == 2)   message = @"Please enter reminder description.";
                if (txt.tag == 4)   message = @"Please enter reminder location.";
                if (txt.tag == 5)   message = @"Please enter reminder date.";
                break;
            }
        }
        
    }
    if(self.strDropDownItem == nil) message = @"Please select follow up by.";
    
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        BOOL isSubGroupChk = NO;
        for (SubGroupList *subgroup in self.arrSubGroupList)
        {
            if (subgroup.isSubGroupCheck == YES)
            {
                NSArray *members = [NSArray arrayWithArray:[[subgroup relGroupMember] allObjects]];
                if ([members count])
                {
                    for (GroupMemberList *person in members)
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
                                if (txt.tag == 4)
                                {
                                    [aReminderList setRemLocation:txt.text];
                                }
                                if (txt.tag == 5)
                                {
                                    [aReminderList setRemDate:dateTimePicker.date];
                                }
                                
                            }
                            
                        }
                        [aReminderList setRemUniqueID:[self getRandomAlphanumericString]];
                        [aReminderList setRemFollowUpBy:self.strDropDownItem];
                        
                        
                        NSDate *date = [NSDate date];
                        NSTimeInterval ti = [date timeIntervalSince1970];
                        [aReminderList setTimeStamp:ti];
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",person.memRecordID];
                        
                        NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                        MyAddressBook *myPerson = [previousEntry lastObject];
                        [aReminderList setRelMyAddressBook:myPerson];
                        
                        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
                        
                        NSDictionary *itemDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  dateTimePicker.date,FIRE_TIME_KEY,
                                                  aReminderList.remTitle,NOTIFICATION_TITLE_KEY,
                                                  aReminderList.remUniqueID,REMINDER_ID,
                                                  aReminderList.remDesc,NOTIFICATION_MESSAGE_KEY,
                                                  @"YES",IS_REMINDER_MULTIPLE,nil];
                        
                        [self scheduleReminder:itemDict];
                        
                        
                        
                        [self saveNS_FollowUpdate:myPerson];
                    }
                    
                }
                
            }
        }
        
        if(isSubGroupChk)
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Reminder set successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [anAlertView show];
            [anAlertView release];
            [self reset_Reminder];
            self.reminder_tag = -999;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one sub-group." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
}
- (void)saveNS_FollowUpdate:(MyAddressBook*)aContactDetails  // FollowUpdate
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
    [aFollowUpdate setFollowDate:dateTimePicker.date];
    
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    [aFollowUpdate setTimeStamp:ti];
    [aFollowUpdate setRelMyAddressBook:aContactDetails];
    
    [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    
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
        
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_grouplist setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_grouplist];
    }
    else
    {
        [view_grouplist setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_grouplist];
    }
    [dropDownReminder removeFromSuperview];
    [view_add_reminder removeFromSuperview];
}
- (NSDate*)getDate
{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	// Get the current date
	NSDate *pickerDate = [dateTimePicker date];
	
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
                              [items valueForKey:IS_REMINDER_MULTIPLE],IS_REMINDER_MULTIPLE, 
                              title,NOTIFICATION_TITLE_KEY, nil];
    
    localNotif.userInfo = infoDict;
	
	// Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
}
- (IBAction)btnShowPicker:(UIButton*)sender
{
    [currentTextField resignFirstResponder];
    if(self.datePickerPopover == nil)
    {
        UIViewController *datePickerVC = [[UIViewController alloc]init];
        
        datePickerVC.view = view_date_picker;
        
        [datePickerVC setContentSizeForViewInPopover:view_date_picker.frame.size];
        
        self.datePickerPopover = [[[UIPopoverController alloc]initWithContentViewController:datePickerVC] autorelease];
        
        
        [datePickerVC release];
    }
    UIButton *btn = (UIButton*)sender;
    if(btn.superview == view_add_reminder)
    {
        [self.datePickerPopover presentPopoverFromRect:sender.frame inView:view_add_reminder permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}
- (IBAction)btnDoneToolBar:(id)sender
{
 
        for (UIView *aview in view_add_reminder.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if (txt.tag == 5)
                {
                    txt.text = [NSDateFormatter localizedStringFromDate:dateTimePicker.date
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
                    break;
                }
                
            }
        }
    [self.datePickerPopover dismissPopoverAnimated:YES];
}
-(NSString*)getRandomAlphanumericString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease]; //specify length here. even you can use full
}
#pragma mark - view subgroup list
- (void)subGroupsListTapped:(UIButton*)sender  // method to show sub-groups of a group
{
    GroupList *aGroup= [self.arrGroupList objectAtIndex:sender.tag];
    currentGroup = aGroup;
    
    //Flurry
	NSDictionary * dict = [NSDictionary dictionaryWithObject:aGroup.groupName forKey:@"groupName"];
	[AppDelegate setFlurryWithText:@"Setting View Button Show SubGroup" andParms:dict];
    
    
    self.arrSubGroupList = [NSMutableArray arrayWithArray:[[aGroup relSubGroup] allObjects]];
    
    if([self.arrSubGroupList count] == 0)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to create a sub group?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel",nil];
        [anAlertView setTag:10221];
        [anAlertView show];
        [anAlertView release];
    }
    else
    {
        [self AddSubGroupListView];
        [tblSubGroupList reloadData];
    }

}
 - (void)AddSubGroupListView
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [self updateSubGroupUI:orientation];
    if (orientation <= 2)
    {
        [view_Subgroup_list setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_Subgroup_list];
    }
    else
    {
        [view_Subgroup_list setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_Subgroup_list];
    }
}
- (IBAction)btnAddNewSubGroup:(id)sender
{
    //Flurry
	if (sender)
	{
		[AppDelegate setFlurryEventWithSender:sender];
	}
    [self removeSubviews];
    UIButton* btn = (UIButton*)sender;
    self.editItemTag = btn.tag;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_add_Subgroup setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_Subgroup];
    }
    else
    {
        [view_add_Subgroup setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_add_Subgroup];
    }
    for (UIView *aview in view_add_Subgroup.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            [txt setDelegate:self];
            txt.text = @"";
        }
    }
    lblAddEditTitleSubGroup.text = @"Add New SubGroup";
    self.strDropDownGroup = nil;
    [self generateDropDown:DROPDOWNGROUP];
    [self downloadDropDownData:DROPDOWNGROUP];
    for (int i = 0; i < [self.arrGroupList count]; i++)
    {
        GroupList *aGropp = [self.arrGroupList objectAtIndex:i];
        if ([currentGroup.groupName isEqualToString:aGropp.groupName])
        {
            [self.dropDownGroups setSelectedIndex:i];
            self.strDropDownGroup = aGropp.groupName;
            break;
        }
    }
}
- (void)saveNewSubGroup
{
    NSString *message = nil;
    NSString *subGrpNm = nil;
    for (UIView *aview in view_add_Subgroup.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter subgroup name.";
                if (txt.tag == 3)   message = @"Please enter subgroup description.";
                break;
            }
            if (txt.tag == 1)
            {
                subGrpNm = txt.text;
            }
        }
        
    }
    if(self.strDropDownGroup == nil)
        message = @"Please select one group.";

    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"subGroupName contains[cd] %@",(subGrpNm.length)?subGrpNm:@""];
    
    NSArray *groupArr = [CoreDataHelper searchObjectsForEntity:@"SubGroupList" withPredicate:myPredicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    if ([groupArr count])
    {
        message = @"Sub group name already exist.";
    }
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        SubGroupList *aSubGroup = (SubGroupList *)[NSEntityDescription insertNewObjectForEntityForName:@"SubGroupList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        for (UIView *aview in view_add_Subgroup.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;

                if (txt.tag == 1)
                {
                    [aSubGroup setSubGroupName:txt.text];
                }

                else if (txt.tag == 3)
                {
                    [aSubGroup setSubGroupDesc:txt.text];
                }
                
            }
            
        }
        GroupList *aGroup = nil;
        for (int i = 0; i < [self.arrGroupList count]; i++)
        {
            aGroup = [self.arrGroupList objectAtIndex:i];
            if ([self.strDropDownGroup isEqualToString:aGroup.groupName])
            {
                break;
            }
        }

        aSubGroup.relGroupList = aGroup;
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    //    self.arrSubGroupList = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
//        aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
        
        self.arrSubGroupList = [NSMutableArray arrayWithArray:[[currentGroup relSubGroup]allObjects]];
        [tblSubGroupList reloadData];
        
        [self resetSubGroupView];
        [self AddSubGroupListView];
        [self.dropDownGroups removeFromSuperview];
        self.editItemTag = nil;
    }
}
- (void)resetSubGroupView
{
    for (UIView *aview in view_add_Subgroup.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = @"";
            }
//            else if (txt.tag == 2)
//            {
//                txt.text = @"";
//            }
            else if (txt.tag == 3)
            {
                txt.text = @"";
            }
            
        }
    }
    [view_add_Subgroup removeFromSuperview];
}
- (void)editSubGroup:(UIButton*)sender
{
    
    //Flurry
    [self btnAddNewSubGroup:nil];
	[AppDelegate setFlurryWithText:@"Setting View Edit SubGroup"];
    
    isEditing = YES;
    self.editItemTag = sender.tag;
    SubGroupList *aSubGroup= [self.arrSubGroupList objectAtIndex:sender.tag];
    
    for (UIView *aview in view_add_Subgroup.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                txt.text = aSubGroup.subGroupName;
            }
//            else if (txt.tag == 2)
//            {
//                txt.text = aSubGroup.groupName;
//            }
            else if (txt.tag == 3)
            {
                txt.text = aSubGroup.subGroupDesc;
                
            }
        }
    }
    
    lblAddEditTitleSubGroup.text = @"Edit SubGroup";
    for (int i = 0; i < [self.arrGroupList count]; i++)
    {
        GroupList *aGropp = [self.arrGroupList objectAtIndex:i];
        if ([aSubGroup.relGroupList.groupName isEqualToString:aGropp.groupName])
        {
            [self.dropDownGroups setSelectedIndex:i];
            self.strDropDownGroup = aGropp.groupName;
            break;
        }        
    }
    
    
}
- (void)updateSubGroup
{
    SubGroupList *aSubGroup= [self.arrSubGroupList objectAtIndex:self.editItemTag];
    NSString *message = nil;
    for (UIView *aview in view_add_Subgroup.subviews)
    {
        if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
            {
                if (txt.tag == 1)   message = @"Please enter subgroup name.";
                if (txt.tag == 3)   message = @"Please enter subgroup description.";
                break;
            }
            if (txt.tag == 1)
            {
                [aSubGroup setSubGroupName:txt.text];
            }
//            else if (txt.tag == 2)
//            {
//                [aSubGroup setGroupName:txt.text];
//            }
            else if (txt.tag == 3)
            {
                [aSubGroup setSubGroupDesc:txt.text];
            }
        }
    }
    GroupList *aGroup = nil;
    for (int i = 0; i < [self.arrGroupList count]; i++)
    {
        aGroup = [self.arrGroupList objectAtIndex:i];
        if ([self.strDropDownGroup isEqualToString:aGroup.groupName])
        {
            break;
        }
    }
    aSubGroup.relGroupList = aGroup;
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
    //    [aSubGroup setGroupName:self.strDropDownGroup];
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    //    self.arrSubGroupList = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
//        GroupList *aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
        self.arrSubGroupList = [NSMutableArray arrayWithArray:[[currentGroup relSubGroup] allObjects]];
        [tblSubGroupList reloadData];
        [self resetSubGroupView];
        [self AddSubGroupListView];
    }
}
- (void)deleteSubGroup:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete sub group?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1021];
    [anAlertView show];
    [anAlertView release];
    
}
- (void)subGroupCheckTapped:(UIButton*)sender
{
    SubGroupList *aSubGroup= [self.arrSubGroupList objectAtIndex:sender.tag];
    
    if(sender.selected)
    {
        sender.selected = !sender.selected;
        aSubGroup.isSubGroupCheck = sender.selected;
    }
    else
    {
        sender.selected = !sender.selected;
        aSubGroup.isSubGroupCheck = sender.selected;
    }
    if (self.isFromMapView)
    {
        [btnSubGroupDone setHidden:NO];
    }
    [self.arrSubGroupList replaceObjectAtIndex:sender.tag withObject:aSubGroup];
    
    [tblSubGroupList reloadData];
}
- (BOOL)checkMemberAlreadyExistInSubGroupList:(NSArray*)memArr aMember:(MyAddressBook*)aMember
{
    for (GroupMemberList *amem in memArr)
    {
        if ([amem.memRecordID isEqualToString:aMember.recordID])
        {
            return YES;
            break;
        }
    }
    return NO;
}
#pragma mark - Email Methods
- (IBAction)btnSendEmailToGroupMember:(id)sender
{
    //Flurry
	[AppDelegate setFlurryEventWithSender:(UIButton*)sender];
    
    self.email_type_tag = 101;
    NSString * message = nil;
    NSString *toFields = nil;
    BOOL isGroupSelected = NO;
    if(![Global GetConfigureFlag])
    {
        message = @"Hello! to start using this function please set up your email details in settings.";
    }
    for (GroupList *aGroup in self.arrGroupList)
    {
        if (aGroup.isGroupCheck)
        {
            isGroupSelected = YES;
            if(toFields)
            {
                toFields = [toFields stringByAppendingFormat:@",%@",aGroup.groupName];
            }
            else
            {
                toFields = [NSString stringWithFormat:@"%@",aGroup.groupName];
            }
        }
    }
    if (!isGroupSelected)
    {
        if(message == nil)
        message = @"Please select atleast one group";
    }
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self removeSubviews];
        [view_email_user layer].cornerRadius = 8.0;
        [view_email_user layer].borderWidth  = .5;
        [[view_email_user layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
        if (orientation <= 2)
        {
            [view_email_user setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
            [view_below_options addSubview:view_email_user];
        }
        else
        {
            [view_email_user setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
            [view_below_options addSubview:view_email_user];
        }
        for (UIView *aview in view_email_user.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if(txt.tag == 1)
                {
                    txt.text = toFields;
                }
                else
                {
                    txt.text = @"";
                }
                    [txt setDelegate:self];
            }
            else if([aview isKindOfClass:[UITextView class]])
            {
                UITextView *txt = (UITextView*)aview;
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
                {
                    txt.text = @"";
                }
            }
            else if ([aview isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton*)aview;
                if ([btn.titleLabel.text rangeOfString:@"Select Personalization" options:NSCaseInsensitiveSearch].length)
                {
                    UIImage *btnImage = [[UIImage imageNamed:@"btn_bg.png"] stretchableImageWithLeftCapWidth:80 topCapHeight:0];
                    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
                }
                
            }

        }
        
        
    }
}
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
- (void)sendGroupEmail
{
    NSString * toSubject = @"";
    NSString * toMessage = @"";
    NSString * message = nil;
    //This loop is to check for empty fields by using subviews and show a alert message if any
    for (UIView *aview in view_email_user.subviews)
    {
        if(![Global GetConfigureFlag])
        {
            message = @"Hello! to start using this function please set up your email details in settings.";
            break;
        }
        else if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if (txt.tag == 1)
            {
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
                {
                    message = @"Recipients field cannot be empty.";
                    break;
                }
                
                
            }
            if (txt.tag == 4)
            {
                if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
                {
                    message = @"Subject cannot be empty.";
                    break;
                }
                else
                {
                    toSubject = txt.text;
                }
            }
            
        }
        else if([aview isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView*)aview;
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
    else //prepare for send email to group members
    {
        for (GroupList *aGroup in self.arrGroupList)  // for group member
        {
            if (aGroup.isGroupCheck)
            {
                aGroup.isGroupCheck = NO;
                
                NSString *toEmail = nil;
                
                NSMutableArray      *emailsArray = [NSMutableArray array];
                
                self.arrMemberList = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
                
                for (GroupMemberList *aGroupMember in self.arrMemberList)
                {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",aGroupMember.memRecordID];
                    
                    NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                    MyAddressBook *aContact = [previousEntry lastObject];
                    NSString *firstLine = [self createFirstLineOfEmail:aContact];
    //                if (aContact.isSelected)
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
                        }
                        if([[emailsDict allKeys] count] >= 4)
                        {
                            [emailsArray addObject:emailsDict];
                            [self saveEmailData:emailsDict withPerson:aContact];
                        }
                    }
                }
                
                NSLog(@"toEmail = %@",emailsArray);
                if([emailsArray count])
                {
                    SMTPSender *smtp = [SMTPSender sharedSMTPSender];
                    [smtp setIsTesting:NO];
                    [smtp sendEmailToUsers:emailsArray message:nil];
                }
            }
        }
        //to remove email view after send
        if(toMessage && toSubject)
        {
            [view_email_user removeFromSuperview];
            
            if(self.email_type_tag == 101)
            {
                [self btnGroup:btnGroup];
            }
            else if(self.email_type_tag == 102)
            {
                [self AddSubGroupListView];
            }
        }
    }
}
- (IBAction)btnSendEmailToSubGroupMember:(id)sender
{
    self.email_type_tag = 102;
    NSString * message = nil;
    NSString *toFields = nil;
    BOOL isSubGroupSelected = NO;
    if(![Global GetConfigureFlag])
    {
        message = @"Hello! to start using this function please set up your email details in settings.";
    }
    
    for (SubGroupList *aSubGroup in self.arrSubGroupList)
    {
        if (aSubGroup.isSubGroupCheck)
        {
            isSubGroupSelected = YES;
            if(toFields)
            {
                toFields = [toFields stringByAppendingFormat:@",%@",aSubGroup.subGroupName];
            }
            else
            {
                toFields = [NSString stringWithFormat:@"%@",aSubGroup.subGroupName];
            }
        }
    }
    if (!isSubGroupSelected)
    {
        message = @"Please select atleast one subgroup.";
    }
    if(message)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [view_email_user layer].cornerRadius = 8.0;
        [view_email_user layer].borderWidth  = .5;
        [[view_email_user layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
        if (orientation <= 2)
        {
            [view_email_user setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
            [view_below_options addSubview:view_email_user];
        }
        else
        {
            [view_email_user setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
            [view_below_options addSubview:view_email_user];
        }
        for (UIView *aview in view_email_user.subviews)
        {
            if ([aview isKindOfClass:[UITextField class]])
            {
                UITextField *txt = (UITextField*)aview;
                if(txt.tag == 1)
                {
                    txt.text = toFields;
                }
                else
                {
                    txt.text = @"";
                }
                    [txt setDelegate:self];
            }
        }

        
    }
}
- (void)sendSubGroupEmail
{
    NSString * toSubject = nil;
    NSString * toMessage = nil;
    NSString * message = nil;
    
    //This loop is to check for empty fields by using subviews and show a alert message if any
    for (UIView *aview in view_email_user.subviews)
    {
        if(![Global GetConfigureFlag])
        {
            message = @"Hello! to start using this function please set up your email details in settings.";
            break;
        }
        else if ([aview isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField*)aview;
            if ([txt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0 && txt.tag == 1)
            {
                message = @"Recipients field cannot be empty.";
                break;
                
            }
            else
            {
                toSubject = txt.text;
            }
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
    else //prepare for send email to group members
    {
        for (SubGroupList *aSubGroup in self.arrSubGroupList)  // for subgruop member
        {
        if (aSubGroup.isSubGroupCheck)
        {
            NSString *toEmail = nil;
            NSMutableArray      *emailsArray = [NSMutableArray array];
            
            self.arrMemberList = [NSArray arrayWithArray:[[aSubGroup relGroupMember] allObjects]];
            
            for (GroupMemberList *aGroupMember in self.arrMemberList)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",aGroupMember.memRecordID];
                
                NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                MyAddressBook *aContact = [previousEntry lastObject];
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
                    }
                    [emailsArray addObject:emailsDict];
                    
                    [self saveEmailData:emailsDict withPerson:aContact];
                }
            }
            
            NSLog(@"toEmail = %@",emailsArray);
            if([emailsArray count]) // send email after everything is fine
            {
                SMTPSender *smtp = [SMTPSender sharedSMTPSender];
                [smtp setIsTesting:NO];
                [smtp sendEmailToUsers:emailsArray message:nil];
            }
            
        }
        //to remove email view after send
        if(toMessage && toSubject)
        {
            [view_email_user removeFromSuperview];
            
            if(self.email_type_tag == 101)
            {
                [self btnGroup:btnGroup];
            }
            else if(self.email_type_tag == 102)
            {
                [self AddSubGroupListView];
            }
        }
    }
    }
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
    
    [aEmail setRelMyAddressBook:person];
    
    [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
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
	
	CGRect rect = [sender convertRect:sender.bounds toView:view_email_user];
    [self.popoverSelectFirstLine presentPopoverFromRect:rect inView:view_email_user permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
-(void)btnCheckBoxForFirstLineTapped:(UIButton*)sender
{
	FirstLine * line = [self.arrayFirstLine objectAtIndex:sender.tag];
	line.isSelected = !line.isSelected;
	[tableEmailSelection reloadData];
	
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
    if(firstLine.length)
        firstLine = [firstLine stringByAppendingString:@":"];
    
    return firstLine;
    
}
#pragma mark - SMTPSender Delegate
- (void)testingForConfigureMail:(NSNumber*)isSuccess error:(NSError *)error
{
    
    if ([isSuccess boolValue])
    {
        [Global SaveConfigureFlag:YES];
        [view_configure_email removeFromSuperview];
        [self btnCreatePassword:btnAccounts];
    }
    else
    {
        [Global SaveConfigureFlag:NO];
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Failed!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [anAlertView show];
        [anAlertView release];
    }
}
#pragma mark -
#pragma mark- membert list methods
- (void)btnShowMemberList:(id)sender
{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_member_list setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_member_list];
    }
    else
    {
        [view_member_list setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_member_list];
    }
}
#pragma mark- membert list methods 
- (void)btnShowContactDetails:(id)sender 
{
    
    //Flurry
	[AppDelegate setFlurryWithText:@"Setting View Show Contact details"];
    
    UIButton *btn = (UIButton*)sender;
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:btn.tag];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation <= 2)
    {
        [view_Contact_Info setFrame:CGRectMake(0, 0, 587, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_Contact_Info];
    }
    else
    {
        [view_Contact_Info setFrame:CGRectMake(0, 0, 844, view_below_options.frame.size.height)];
        [view_below_options addSubview:view_Contact_Info];
    }
    [self loadContactDetail:aContact];
    [tblContactInfo reloadData];
    
}
- (void)btnDeleteContactFromDatabase:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    self.editItemTag = btn.tag;
    
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1005];
    [anAlertView show];
    [anAlertView release];
    
}

- (void)loadContactDetail:(MyAddressBook*)aContactDetails
{
    NSLog(@"%@",aContactDetails);
    
    self.dictTemp =  [NSMutableDictionary dictionary];
    self.arrAllKeys = [NSMutableArray array];
    if(aContactDetails.gender)
    {
        [self.dictTemp setObject:aContactDetails.gender                forKey:GENDER_STRING];
        [arrAllKeys addObject:GENDER_STRING];
    }
    if(aContactDetails.prefix)
    {
        [self.dictTemp setObject:aContactDetails.prefix                 forKey:SALUTATION_STRING];
        [arrAllKeys addObject:SALUTATION_STRING];
    }
    
    if(aContactDetails.firstName)
    {
        [self.dictTemp setObject:aContactDetails.firstName                 forKey:FIRST_NAME_STRING];
        [arrAllKeys addObject:FIRST_NAME_STRING];
    }
    if(aContactDetails.firstNamePh)
    {
        [self.dictTemp setObject:aContactDetails.firstNamePh                forKey:PHONETIC_FIRST_STRING];
        [arrAllKeys addObject:PHONETIC_FIRST_STRING];
    }
    
    if(aContactDetails.middleName)
    {
        //        [lblPersonNmae setText:[lblPersonNmae.text stringByAppendingFormat:@" %@",aContactDetails.middleName]];
        [self.dictTemp setObject:aContactDetails.middleName            forKey:MIDDLE_NAME_STRING];
        [arrAllKeys addObject:MIDDLE_NAME_STRING];
    }
    if(aContactDetails.middleNamePh)
    {
        [self.dictTemp setObject:aContactDetails.middleNamePh                forKey:PHONETIC_MIDDLE_STRING];
        [arrAllKeys addObject:PHONETIC_MIDDLE_STRING];
    }
    
    if(aContactDetails.lastName)
    {
        [self.dictTemp setObject:aContactDetails.lastName              forKey:LAST_NAME_STRING];
        [arrAllKeys addObject:LAST_NAME_STRING];
    }
    if(aContactDetails.lastNamePh)
    {
        [self.dictTemp setObject:aContactDetails.lastNamePh                forKey:PHONETIC_LAST_STRING];
        [arrAllKeys addObject:PHONETIC_LAST_STRING];
    }
    //single values
    
    if(aContactDetails.suffix)
    {
        [self.dictTemp setObject:aContactDetails.suffix                 forKey:SUFFIX_STRING];
        [arrAllKeys addObject:SUFFIX_STRING];
    }
    if(aContactDetails.nickName)
    {
        [self.dictTemp setObject:aContactDetails.nickName                forKey:NICKNAME_STRING];
        [arrAllKeys addObject:NICKNAME_STRING];
    }
    if(aContactDetails.jobTitle)
    {
        [self.dictTemp setObject:aContactDetails.jobTitle              forKey:JOBTITLE_STRING];
        [arrAllKeys addObject:JOBTITLE_STRING];
    }
    if(aContactDetails.department)
    {
        [self.dictTemp setObject:aContactDetails.department              forKey:DEPARTMENT_STRING];
        [arrAllKeys addObject:DEPARTMENT_STRING];
    }
    if(aContactDetails.organisation)
    {
        [self.dictTemp setObject:aContactDetails.organisation          forKey:ORGANIZATION_STRING];
        [arrAllKeys addObject:ORGANIZATION_STRING];
    }
    /*
     NSArray *dateList = [[aContactDetails relAllDates] allObjects];
     
     for (AllDate *aDate in dateList)
     {
     [self.dictTemp setObject:[NSDateFormatter localizedStringFromDate:aDate.dates
     dateStyle:NSDateFormatterShortStyle
     timeStyle:NSDateFormatterNoStyle]      forKey:aDate.dateTitle];
     [arrAllKeys addObject:aDate.dateTitle];
     }
     */
    
    //phones fiels
    NSArray *phoneslist = [[aContactDetails relAllPhone] allObjects];
    for (AllPhone *phones in phoneslist)
    {
        [self.dictTemp setObject:phones.phoneNumber                                forKey:phones.phoneTitle];
        [arrAllKeys addObject:phones.phoneTitle];
    }
  
    //emails fields
    //int emailCount = 1;
    NSArray *emailslist = [[aContactDetails relEmails] allObjects];
    for (AllEmail *emails in emailslist)
    {
        [self.dictTemp setObject:emails.emailURL        forKey:emails.emailTitle];
        [arrAllKeys addObject:emails.emailTitle];
    }
    //urls fields
    NSArray *urlslist = [[aContactDetails relAllUrl] allObjects];
    for (AllUrl *aUrl in urlslist)
    {
        [self.dictTemp setObject:aUrl.urlAddress forKey:aUrl.urlTitle];
        [arrAllKeys addObject:aUrl.urlTitle];
    }
    //address fields
    NSString *lastAddressType = nil;
    NSArray *addList = [[aContactDetails relAllAddress] allObjects];
    NSString *fullAddress;
    for (int i =0 ; i <[addList count]; i++)
    {
        AllAddress *address = [addList objectAtIndex:i];
        //        NSString *city = (address.city)?address.city:@"";
        //        NSString *state = (address.state)?address.state:@"";
        //        NSString *street = (address.street)?address.street:@"";
        //
        //        NSString *strAddress = nil;
        NSString *keyStr = nil;
        /*if (city.length == 0 && state.length == 0 && street.length == 0)
         {
         
         }
         else
         {
         
         strAddress = [street stringByAppendingFormat:@" %@",city];
         
         if (state.length)
         {
         strAddress = [strAddress stringByAppendingFormat:@" (%@)",state];
         }
         strAddress = [strAddress stringByReplacingOccurrencesOfString:@"#" withString:@""];
         }
         //address fields
         if(strAddress)
         {
         
         if(!lastAddressType)
         {
         keyStr = [ADDRESS_STRING stringByAppendingFormat:@" %@",address.addressType];
         }
         else
         {
         if(![lastAddressType isEqualToString:address.addressType])
         keyStr = [ADDRESS_STRING stringByAppendingFormat:@" %@",address.addressType];
         else
         keyStr = [ADDRESS_STRING stringByAppendingFormat:@" %@%d",address.addressType,i];
         }
         [self.dictTemp setObject:strAddress                                 forKey:keyStr];
         [arrAllKeys addObject:keyStr];
         }
         */
        if(address.street)
        {
            if(!lastAddressType)
            {
                keyStr = [STREET_STRING stringByAppendingFormat:@" %d",i];
            }
            else
            {
                if(![lastAddressType isEqualToString:address.street])
                    keyStr = [STREET_STRING stringByAppendingFormat:@"  %d",i];
                else
                    keyStr = [STREET_STRING stringByAppendingFormat:@"  %d",i];
            }
            fullAddress = [NSString stringWithFormat:@" %@ \n",address.street];
//            [self.dictTemp setObject:address.street                            forKey:keyStr];
//            [arrAllKeys addObject:keyStr];
        }
        if(address.city)
        {
            if(!lastAddressType)
            {
                keyStr = [CITY_STRING stringByAppendingFormat:@" %d",i];
            }
            else
            {
                if(![lastAddressType isEqualToString:address.city])
                    keyStr = [CITY_STRING stringByAppendingFormat:@"  %d",i];
                else
                    keyStr = [CITY_STRING stringByAppendingFormat:@"  %d",i];
            }
             fullAddress = [NSString stringWithFormat:@"%@ %@ \n",fullAddress,address.city];
            //[self.dictTemp setObject:address.city                            forKey:keyStr];
            //[arrAllKeys addObject:keyStr];
        }
        if(address.state)
        {
            if(!lastAddressType)
            {
                keyStr = [STATE_STRING stringByAppendingFormat:@" %d",i];
            }
            else
            {
                if(![lastAddressType isEqualToString:address.state])
                    keyStr = [STATE_STRING stringByAppendingFormat:@"  %d",i];
                else
                    keyStr = [STATE_STRING stringByAppendingFormat:@"  %d",i];
            }
            fullAddress = [NSString stringWithFormat:@"%@ %@ \n",fullAddress,address.state];
            //[self.dictTemp setObject:address.state                            forKey:keyStr];
            //[arrAllKeys addObject:keyStr];
        }
        if(address.zipCode)
        {
            if(!lastAddressType)
            {
                keyStr = [ZIP_STRING stringByAppendingFormat:@" %d",i];
            }
            else
            {
                if(![lastAddressType isEqualToString:address.addressType])
                    keyStr = [ZIP_STRING stringByAppendingFormat:@"  %d",i];
                else
                    keyStr = [ZIP_STRING stringByAppendingFormat:@"  %d",i];
            }
            fullAddress = [NSString stringWithFormat:@"%@ %@ \n",fullAddress,address.zipCode];
            //[self.dictTemp setObject:address.zipCode                            forKey:keyStr];
            //[arrAllKeys addObject:keyStr];
        }
        if(address.countryCode)
        {
            if(!lastAddressType)
            {
                keyStr = [COUNTRY_STRING stringByAppendingFormat:@" %d",i];
            }
            else
            {
                if(![lastAddressType isEqualToString:address.addressType])
                    keyStr = [COUNTRY_STRING stringByAppendingFormat:@"  %d",i];
                else
                    keyStr = [COUNTRY_STRING stringByAppendingFormat:@"  %d",i];
            }
            fullAddress = [NSString stringWithFormat:@"%@ %@ \n",fullAddress,address.countryCode];
            //[self.dictTemp setObject:address.countryCode                        forKey:keyStr];
            //[arrAllKeys addObject:keyStr];
        }
        
        [self.dictTemp setObject:fullAddress                        forKey:address.addressType];
        [arrAllKeys addObject:address.addressType];

        
        lastAddressType = address.addressType;
    }
    
    if(aContactDetails.birthDay)
    {
        [self.dictTemp setObject:[NSDateFormatter localizedStringFromDate:aContactDetails.birthDay
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]      forKey:BIRTHDAY_STRING];
        [arrAllKeys addObject:BIRTHDAY_STRING];
        
    }
    
    //Alldates
    NSArray *dateList = [[aContactDetails relAllDates] allObjects];
    
    for (AllDate *aDate in dateList)
    {
        [self.dictTemp setObject:[NSDateFormatter localizedStringFromDate:aDate.dates
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterNoStyle]      forKey:aDate.dateTitle];
        [arrAllKeys addObject:aDate.dateTitle];
    }
    //All related names
    NSArray *relatedList = [[aContactDetails relAllRelatedNames] allObjects];
    
    for (AllRelatedName *arelated in relatedList)
    {
        [self.dictTemp setObject:arelated.relatedNames forKey:arelated.nameTitle];
        [arrAllKeys addObject:arelated.nameTitle];
    }
    
    /************* SOCIAL ******************************/
    if(aContactDetails.facebook)
    {
        [self.dictTemp setObject:aContactDetails.facebook         forKey:SOCIAL_FACEBOOK];
        [arrAllKeys addObject:SOCIAL_FACEBOOK];
    }
    if(aContactDetails.linkedin)
    {
        [self.dictTemp setObject:aContactDetails.linkedin         forKey:SOCIAL_LINKEDIN];
        [arrAllKeys addObject:SOCIAL_LINKEDIN];
    }
    if(aContactDetails.twitter)
    {
        [self.dictTemp setObject:aContactDetails.twitter         forKey:SOCIAL_TWITTER];
        [arrAllKeys addObject:SOCIAL_TWITTER];
    }
    if(aContactDetails.googlePlus)
    {
        [self.dictTemp setObject:aContactDetails.googlePlus         forKey:SOCIAL_GOOGLE_PLUS];
        [arrAllKeys addObject:SOCIAL_GOOGLE_PLUS];
    }
    /************* SOCIAL ******************************/
    ////////////////
    if(aContactDetails.industry)
    {
        [self.dictTemp setObject:aContactDetails.industry              forKey:INDUSTRY_STRING];
        [arrAllKeys addObject:INDUSTRY_STRING];
    }
    if(aContactDetails.industryDescription)
    {
        [self.dictTemp setObject:aContactDetails.industryDescription   forKey:INDUSTRY_DESCRIPTION_STRING];
        [arrAllKeys addObject:INDUSTRY_DESCRIPTION_STRING];
    }
    if (aContactDetails.isViewed == NO)
    {
        aContactDetails.isViewed = YES;
        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
    }
    
    if(aContactDetails.funnelStageID)
    {
        AppDelegate * adele = CRM_AppDelegate;
		
		NSPredicate * pridicate = [NSPredicate predicateWithFormat:@"stageID == %d",[aContactDetails.funnelStageID intValue]];
		
		NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:pridicate andSortKey:nil andSortAscending:NO andContext:[adele managedObjectContext]];
		
		if ([arrayFunnel count])
		{
			FunnelStageList * funnelObj = (FunnelStageList*)[arrayFunnel lastObject];
			
			[self.dictTemp setObject:funnelObj.stageName           forKey:FUNNEL_STAGE_STRING];
			[arrAllKeys addObject:FUNNEL_STAGE_STRING];
		}
        
    }
    if(aContactDetails.funnelDescription)
    {
        [self.dictTemp setObject:aContactDetails.funnelDescription     forKey:FUNNEL_DESCRIPTION_STRING];
        [arrAllKeys addObject:FUNNEL_DESCRIPTION_STRING];
    }
    if(aContactDetails.groupName)
    {
        [self.dictTemp setObject:aContactDetails.groupName             forKey:GROUP_STRING];
        [arrAllKeys addObject:GROUP_STRING];
    }
    if(aContactDetails.subGroupName)
    {
        [self.dictTemp setObject:aContactDetails.subGroupName          forKey:SUB_GROUP_STRING];
        [arrAllKeys addObject:SUB_GROUP_STRING];
    }
    if(aContactDetails.leadSource)
    {
        [self.dictTemp setObject:aContactDetails.leadSource            forKey:LEAD_SOURCE_STRING];
        [arrAllKeys addObject:LEAD_SOURCE_STRING];
    }
    if(aContactDetails.leadStatus)
    {
        [self.dictTemp setObject:aContactDetails.leadStatus            forKey:LEAD_STATUS_STRING];
        [arrAllKeys addObject:LEAD_STATUS_STRING];
    }
    
    if(aContactDetails.note)
    {
        [self.dictTemp setObject:aContactDetails.note                  forKey:NOTE_STRING];
        [arrAllKeys addObject:NOTE_STRING];
    }
    
    
    NSLog(@"%@",self.dictTemp);
}
#pragma mark - Store Data in the Database
- (IBAction)btnSaveTapped:(UIButton*)sender
{
    
    if (sender.superview == view_add_product)
    {
        if (isEditing)
        {
            [AppDelegate setFlurryWithText:@"Button Edit Product"];
            [self updateProduct];
            
        }
        else
        {
            [AppDelegate setFlurryWithText:@"Button Submit Add Product"];
            [self saveProduct];
            
        }
        [self.dropDownCurrency removeFromSuperview];
        
    }
    else if (sender.superview == view_add_script)
    {
        if (isEditing)
        {
            [AppDelegate setFlurryWithText:@"Button Edit Script"];
            [self updateScript];
            
        }
        else
        {
            [AppDelegate setFlurryWithText:@"Button Submit Add Script"];
            [self saveScript];
            
        }
    }
    else if (sender.superview == view_add_group)
    {
        if (isEditing)
        {
            [AppDelegate setFlurryWithText:@"Button Edit Group"];
            [self updateGroup];
            
        }
        else
        {
            [AppDelegate setFlurryWithText:@"Button Submit Add Group"];
            [self saveNewGroup];
            
        }
        
    }
    else if (sender.superview == view_add_Subgroup)
    {
        if (isEditing)
        {
            [AppDelegate setFlurryWithText:@"Button Edit Sub-Group"];
            [self updateSubGroup];
            
        }
        else
        {
            [AppDelegate setFlurryWithText:@"Button Submit Add Sub-Group"];
            [self saveNewSubGroup];
        }
    
        
    }
    else if (sender.superview == view_add_reminder)
    {
        if(self.reminder_tag == 101)
        {
            [AppDelegate setFlurryWithText:@"Button Submit Add Group Reminder"];
            [self saveGroup_Reminder];
        }
        else if(self.reminder_tag == 102)
        {
            [AppDelegate setFlurryWithText:@"Button Submit Add Sub group reminder"];
            [self saveSubGroup_Reminder];
        }
        
        
    }
    else if (sender.superview == view_email_user)
    {
        if(self.email_type_tag == 101)
        {
            if ([self checkNetworkConnection])
            {
                [AppDelegate setFlurryWithText:@"Button Send Group Email"];
                [self sendGroupEmail];
            }
        }
        else if(self.email_type_tag == 102)
        {
            if ([self checkNetworkConnection])
            {
                [AppDelegate setFlurryWithText:@"Button Send Sub-Group Email"];
                [self sendSubGroupEmail];
            }
            
        }
        
        
    }
    else if (sender.superview == view_configure_email)
    {
        [AppDelegate setFlurryWithText:@"Button Configure Email"];
        [self saveAccountDetails];
    }
    isEditing = NO;
    
}

- (void)resetBtns:(UIButton*)sender
{
    for (UIView *view in view_options_landscape.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            [btn setSelected:NO];
            if (btn.tag == sender.tag)
            {
                [btn setSelected:YES];
            }
        }
    }
    for (UIView *view in view_options_portrate.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            [btn setSelected:NO];
            if (btn.tag == sender.tag)
            {
                [btn setSelected:YES];
            }
        }
    }
    
}

- (IBAction)btnCancelAddProduct:(id)sender  //This method is used to cancel all views not only add product
{
    UIButton *btn = (UIButton*)sender;
    if(btn.superview == view_add_product)
    {
        [self resetProductView];
    }
    if(btn.superview == view_add_Subgroup)
    {
        [self AddSubGroupListView];
        [self.dropDownGroups removeFromSuperview];
        [self resetSubGroupView];
        
    }
    if(btn.superview == view_add_group)
    {
        [self resetNewGroupView];
    }
    if(btn.superview == view_add_reminder)
    {
        if(self.reminder_tag == 101)
        {
            [self btnGroup:btnGroup];
        }
        else if(self.reminder_tag == 102)
        {
            [self AddSubGroupListView];
        }
       
    }
    if(btn.superview == view_email_user)
    {
        [self AddSubGroupListView];
        if(self.email_type_tag == 101)
        {
            [self btnGroup:btnGroup];
        }
        else if(self.email_type_tag == 102)
        {
            [self AddSubGroupListView];
        }
        self.email_type_tag = -999;
    }
    if(btn.superview == view_configure_email)
    {
        [self btnCreatePassword:btnAccounts];
    }
    if(btn.superview == view_add_script)
    {
        [self resetScriptView];
    }
    [btn.superview removeFromSuperview];
}
- (void)removeSubviews
{
    for (UIView *aView in view_below_options.subviews) 
        [aView removeFromSuperview];
}
- (IBAction)btnDoneGroup:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if(btn.superview == view_grouplist)
    {
        for (GroupList *aGroup in self.arrGroupList)
        {
            NSArray *memArray = [[aGroup relGroupMember] allObjects];
            NSLog(@"%@",memArray);
            if (aGroup.isGroupCheck)
            {
                for (MyAddressBook *aPerson in self.arrMapSelectedContact)
                {
                   if(![self checkMemberAlreadyExistInGroupList:memArray aMember:aPerson])
                   {
                       GroupMemberList *aGroupMember = (GroupMemberList *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupMemberList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                    
                       [aGroupMember setMemRecordID:aPerson.recordID];
                       [aGroupMember setMemberName:[(aPerson.firstName)?aPerson.firstName:@"" stringByAppendingFormat:@" %@",(aPerson.lastName)?aPerson.lastName:@""]];
                       [aGroupMember setMemberCompany:(aPerson.organisation)?aPerson.organisation:@""];
                       [aGroupMember setMemberTitle:(aPerson.jobTitle)?aPerson.jobTitle:@""];

                       [aGroupMember setRelGroupList:aGroup];
//                       [aPerson setGroupName:aGroup.groupName];
                       [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                   }
                }
            }
        }
        [self resetGroupTable];
    }
    if(btn.superview == view_Subgroup_list)
    {
        for (SubGroupList *aSubGroup in self.arrSubGroupList)
        {
            NSArray *memArray = [[aSubGroup relGroupMember] allObjects];
            NSLog(@"%@",memArray);
            if (aSubGroup.isSubGroupCheck)
            {
                for (MyAddressBook *aPerson in self.arrMapSelectedContact)
                {
                    if(![self checkMemberAlreadyExistInSubGroupList:memArray aMember:aPerson])
                    {
                        GroupMemberList *aGroupMember = (GroupMemberList *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupMemberList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                        [aGroupMember setMemRecordID:aPerson.recordID];
                        [aGroupMember setMemberName:[(aPerson.firstName)?aPerson.firstName:@"" stringByAppendingFormat:@" %@",(aPerson.lastName)?aPerson.lastName:@""]];
                        [aGroupMember setMemberCompany:(aPerson.organisation)?aPerson.organisation:@""];
                        [aGroupMember setMemberTitle:(aPerson.jobTitle)?aPerson.jobTitle:@""];
                        
                        [aGroupMember setRelSubGroup:aSubGroup];
                        [aPerson setSubGroupName:aSubGroup.subGroupName];
                        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                    }

                }
            }
        }        
    }
}
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ((alertView.tag > 1000 && buttonIndex == 0)?alertView.tag:0) {
        case 1001:
            {
                ProductList *aProduct = [self.arrProductList objectAtIndex:self.editItemTag];
                NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"(proposalProducts CONTAINS[cd] %@)", aProduct.productName];
                NSArray *arrProposals = [CoreDataHelper searchObjectsForEntity:@"ProposalList" withPredicate:_myPredicate andSortKey:nil andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                
                if ([arrProposals count])
                {
                    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Notice!" message:@"This product is in use by some proposals so it cannot be deleted." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                    [anAlertView show];
                    [anAlertView release];
                }
                else
                {
                    [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aProduct];
                    
                    [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                    
                    self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                    [tblProductList reloadData];
                    
                    self.editItemTag = nil;
                }
            }
            break;
        case 1002:
            {
                //Flurry
                [AppDelegate setFlurryWithText:@"Setting View Delete Group"];
                
                GroupList *aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aGroup];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                
                self.arrGroupList = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                [tblGroupList reloadData];
                
                self.editItemTag = nil;
            }
            break;
        case 1021:
            {
                //Flurry
                [AppDelegate setFlurryWithText:@"Setting View delete Sub Group"];
                
                //        GroupList *aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
                
                SubGroupList *aSubGroup= [self.arrSubGroupList objectAtIndex:self.editItemTag];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aSubGroup];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                
                //        self.arrSubGroupList = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                self.arrSubGroupList = [NSMutableArray arrayWithArray:[[currentGroup relSubGroup] allObjects]];
                [tblSubGroupList reloadData];
                
                self.editItemTag = nil;
            }
            break;
        case 1022:
            {
                GroupMemberList *aGroupMember= [self.arrMemberList objectAtIndex:self.editItemTag];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aGroupMember];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                
                GroupList *aGroup = [self.arrGroupList objectAtIndex:self.selectedGroup];
                
                self.arrMemberList = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
                
                [tblMemberList reloadData];
            }
            break;
        case 10221:
            {
                //Flurry
                [AppDelegate setFlurryWithText:@"Setting View Sub Group list"];
                [self AddSubGroupListView];
                [tblSubGroupList reloadData];
            }
            break;
        case 1004:
            {
                ScriptList *aScript= [self.arrScriptList objectAtIndex:self.editItemTag];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aScript];
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                
                self.arrScriptList = [CoreDataHelper getObjectsForEntity:@"ScriptList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                
                [tblScriptList reloadData];
                
                self.editItemTag = nil;
            }
        case 1005:
            {
                //Flurry
                [AppDelegate setFlurryWithText:@"Setting view Delete Contact"];
                
                GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
                MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:self.editItemTag];
                
                [ABContactsHelper removePersonFrom_iPadAddressBook:aContact]; //delete from iPad address book
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aContact];//delete from app address book
                
                [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                
                GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                
                [tblContactist reloadData];
                
                self.editItemTag = nil;
            }
            break;
        case 1051:
            {
                //Flurry
                [AppDelegate setFlurryWithText:@"Save Contacts To Address Book"];
                BOOL isChecked = NO;
                GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
                for (MyAddressBook *myAdd in GDP.arrMyAddressBookData)
                {
                    if(myAdd.isSelected)
                    {
                        isChecked = YES;
                    }
                }
                if (!isChecked)
                {
                    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one contact that you want to update into the iPad address book." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                    [anAlertView show];
                    [anAlertView release];
                }
                else
                {
                    [SVProgressHUD showWithStatus:@"Syncing"];
                    [self performSelector:@selector(syncToAddressBook) withObject:nil afterDelay:0.1];
                }
            }
            break;
        case 1052:
            {
                //Flurry
                [AppDelegate setFlurryWithText:@"Save Contacts To App Data Base"];
                
                [SVProgressHUD showWithStatus:@"Syncing"];
                [self performSelector:@selector(syncToAppDatabase) withObject:nil afterDelay:0.1];
            }
            break;
        default:
            break;
    }
    /*if (alertView.tag == 1001 && buttonIndex == 0)
    {
        ProductList *aProduct = [self.arrProductList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aProduct];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrProductList = [CoreDataHelper getObjectsForEntity:@"ProductList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblProductList reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1002 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Setting View Delete Group"];
        
       GroupList *aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aGroup];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrGroupList = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblGroupList reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1021 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Setting View delete Sub Group"];
        
//        GroupList *aGroup= [self.arrGroupList objectAtIndex:self.editItemTag];
        
        SubGroupList *aSubGroup= [self.arrSubGroupList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aSubGroup];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
//        self.arrSubGroupList = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        self.arrSubGroupList = [NSMutableArray arrayWithArray:[[currentGroup relSubGroup] allObjects]];
        [tblSubGroupList reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1022 && buttonIndex == 0)
    {
        GroupMemberList *aGroupMember= [self.arrMemberList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aGroupMember];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        GroupList *aGroup = [self.arrGroupList objectAtIndex:self.selectedGroup];
        
        self.arrMemberList = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
        
        [tblMemberList reloadData];
    }
    else if (alertView.tag == 10221 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Setting View Sub Group list"];
        [self AddSubGroupListView];
        [tblSubGroupList reloadData];
    }
    else if (alertView.tag == 1004 && buttonIndex == 0)
    {
        ScriptList *aScript= [self.arrScriptList objectAtIndex:self.editItemTag];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aScript];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        self.arrScriptList = [CoreDataHelper getObjectsForEntity:@"ScriptList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        [tblScriptList reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1005 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Setting view Delete Contact"];
        
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:self.editItemTag];
        
        [ABContactsHelper removePersonFrom_iPadAddressBook:aContact]; //delete from iPad address book
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aContact];//delete from app address book
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        [tblContactist reloadData];
        
        self.editItemTag = nil;
    }
    else if (alertView.tag == 1051 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Save Contacts To Address Book"];
        BOOL isChecked = NO;
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        for (MyAddressBook *myAdd in GDP.arrMyAddressBookData)
        {
            if(myAdd.isSelected)
            {
                isChecked = YES;
            }
        }
        if (!isChecked)
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select atleast one contact that you want to update into the iPad address book." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [anAlertView show];
            [anAlertView release];
        }
        else
        {
            [SVProgressHUD showWithStatus:@"Syncing"];
            [self performSelector:@selector(syncToAddressBook) withObject:nil afterDelay:0.1];
        }
    }
    else if (alertView.tag == 1052 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Save Contacts To App Data Base"];
        
        [SVProgressHUD showWithStatus:@"Syncing"];
        [self performSelector:@selector(syncToAppDatabase) withObject:nil afterDelay:0.1];
    }*/
}
#pragma mark - Searching methods
- (NSArray*)getSearchResult:(NSString*)string withClass:(Class)aClass
{
    NSMutableArray* copyitemsearch = [[NSMutableArray alloc]initWithCapacity:0];
    if(aClass == [GroupList class])
    {
        for (GroupList *aGroup in self.arrGroupList)
        {
            // FriendRequest *obj = [self.arrofimages objectAtIndex:i];
            NSString* str = aGroup.groupName;
            NSRange titleResultsRange = [str rangeOfString:string options:NSCaseInsensitiveSearch];
            
            if(titleResultsRange.location != NSNotFound)
                
            {
                //if (titleResultsRange.location==0) //check for character at 1 index
                //{
                [copyitemsearch addObject:aGroup];
                //}
            }
        }
    }
    //
    if(aClass == [SubGroupList class])
    {
        for (SubGroupList *aSubGroup in self.arrSubGroupList)
        {
            // FriendRequest *obj = [self.arrofimages objectAtIndex:i];
            NSString* str = aSubGroup.subGroupName;
            NSRange titleResultsRange = [str rangeOfString:string options:NSCaseInsensitiveSearch];
            
            if(titleResultsRange.location != NSNotFound)
                
            {
                //if (titleResultsRange.location==0) //check for character at 1 index
                //{
                [copyitemsearch addObject:aSubGroup];
                //}
            }
        }
    }
    if(aClass == [MyAddressBook class])
    {
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        for (MyAddressBook *aContact in GDP.arrMyAddressBookData)
        {
            // FriendRequest *obj = [self.arrofimages objectAtIndex:i];
            NSString* str = [aContact.firstName stringByAppendingFormat:@" %@",aContact.lastName];
            
            NSRange titleResultsRange = [str rangeOfString:string options:NSCaseInsensitiveSearch];
            
            if(titleResultsRange.location != NSNotFound)
                
            {
                //if (titleResultsRange.location==0) //check for character at 1 index
                //{
                [copyitemsearch addObject:aContact];
                //}
            }
        }
    }
    NSArray *searchArr = [NSArray arrayWithArray:copyitemsearch];
        
    [copyitemsearch release];
    
    return searchArr;
}
- (void)searchGroupWithtextField:(UITextField*)textField
{
    NSPredicate *_myPredicate = nil;
    if (textField == txtfSearchGroupName)
    {

        if (textField.text.length > 0)
        {
            _myPredicate = [NSPredicate predicateWithFormat:@"(groupName CONTAINS[cd] %@)", [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
        }
        NSArray *copyitemsearch = [CoreDataHelper searchObjectsForEntity:@"GroupList" withPredicate:_myPredicate andSortKey:@"groupName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        self.arrGroupList = [NSMutableArray arrayWithArray:copyitemsearch];
        [tblGroupList reloadData];
        
    }
    else if (textField == txtfSearchSubGroup)
    {
        if (textField.text.length > 0)
        {
            _myPredicate = [NSPredicate predicateWithFormat:@"(subGroupName CONTAINS[cd] %@)", [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            
        }
        NSArray *copyitemsearch = [CoreDataHelper searchObjectsForEntity:@"SubGroupList" withPredicate:_myPredicate andSortKey:@"subGroupName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        self.arrSubGroupList = [NSMutableArray arrayWithArray:copyitemsearch];
        [tblSubGroupList reloadData];        
    }
    else if (textField == txtfSearchContact)
    {
        if (textField.text.length > 0)
        {
            NSString *_mySearchKey  = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            _myPredicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[cd] %@) OR (lastName CONTAINS[cd] %@) OR (middleName CONTAINS[cd] %@)", _mySearchKey, _mySearchKey, _mySearchKey];
        }
        
        
        NSArray *copyitemsearch = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:_myPredicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        {
            GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
            GDP.arrMyAddressBookData = [NSMutableArray arrayWithArray:copyitemsearch];
            [tblContactist reloadData];
        }
    }
    else if (textField.superview == view_member_list)
    {
        GroupList *aGroup = [self.arrGroupList objectAtIndex:self.selectedGroup];
        NSArray *arrMembers = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
        
        if (textField.text.length > 0)
        {
            NSMutableArray *temp = [NSMutableArray array];
            for (GroupMemberList *aMem in arrMembers)
            {
                NSRange titleResultsRange = [aMem.memberName rangeOfString:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] options:NSCaseInsensitiveSearch];
                
                if(titleResultsRange.location != NSNotFound)
                {
                    [temp addObject:aMem];
                }
            }
            self.arrMemberList = [NSMutableArray arrayWithArray:temp];
            [tblMemberList reloadData];
        }
        else
        {
            self.arrMemberList = [NSMutableArray arrayWithArray:arrMembers];
            [tblMemberList reloadData];
        }
        
        
    }
//    [self performSelector:@selector(resignSearchField:) withObject:textField afterDelay:1.0];
    
}
- (void)resignSearchField:(UITextField*)textField
{
    [textField resignFirstResponder];
}
- (BOOL)isProtraitOrientation
{
    UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    if (orientation <=2)
    {
        return YES;
    }
    return NO;
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    currentTextView = nil;
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    currentTextField = nil;
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == txtfSearchGroupName /*&& [self.arrBackUpData count]*/)
    {
        self.arrGroupList  = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblGroupList reloadData];
    }
    if (textField == txtfSearchSubGroup/* && [self.arrBackUpData count]*/)
    {
        self.arrSubGroupList  = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblSubGroupList reloadData];
    }
    if (textField == txtfSearchContact/* && [self.arrBackUpData count]*/)
    {
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        GDP.arrMyAddressBookData  = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblContactist reloadData];
    }
    if (textField.superview == view_member_list)
    {
        GroupList *aGroup = [self.arrGroupList objectAtIndex:self.selectedGroup];
        
        self.arrMemberList = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
        
        [tblMemberList reloadData];
    }
//    self.arrBackUpData = nil;
    
    [txtfSearchGroupName resignFirstResponder];
    [txtfSearchSubGroup resignFirstResponder];
    [txtfSearchContact resignFirstResponder];
//    [textField resignFirstResponder];
    [self performSelector:@selector(resignSearchField:) withObject:textField afterDelay:0.1];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0 && textField.superview == view_member_list)
    {
        GroupList *aGroup = [self.arrGroupList objectAtIndex:self.selectedGroup];
        
        self.arrMemberList = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
        
        [tblMemberList reloadData];
    }
    [textField resignFirstResponder];
   
    return YES;
}
#define CHARACTER_LIMIT 20
#define NUMBERS_ONLY @"1234567890."
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.superview == view_add_product && textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if (textField.tag == 4 || textField.tag == 2)
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
        }
        
    }
    else if (textField == txtfSearchGroupName || textField == txtfSearchSubGroup || textField == txtfSearchContact ||textField.superview == view_member_list)
    {
        [self performSelector:@selector(searchGroupWithtextField:) withObject:textField afterDelay:0.01];
    }
    return YES;
    
}
#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    currentTextField = nil;
    currentTextView = textView;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    return YES;
}
#pragma mark- UIkeyboard Methods
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (![self isProtraitOrientation])
    {
        NSDictionary *userInfo		=	[notification userInfo];
		NSValue* aValue				=	[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
		CGRect keyboardRect			=	[aValue CGRectValue];
        
		keyboardRect					=	[self.view convertRect:keyboardRect fromView:nil];
		
		CGFloat keyboardTop			=	keyboardRect.origin.y;
		
        CGRect rect;
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

    }
	
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (![self isProtraitOrientation])
    {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.33];
        [UIView setAnimationBeginsFromCurrentState:YES];
        NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        self.view.frame = CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
#pragma mark - Add OR Remove Notificatoin Observers
- (void)addObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLayout" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark - TouchView delegate
- (void)touchesDown:(NSSet *)touches
{
    [txtfSearchGroupName resignFirstResponder];
    UITouch *atouch = [[touches allObjects] lastObject];
    [atouch.view removeFromSuperview];
}
- (void)touchesUp:(NSSet *)touches
{
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
			
			GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
			MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:editItemTag];
			NSArray * address = [[aContact relAllAddress] allObjects];
			
			for (AllAddress * foundAdd in address)
			{
				if ([cell.lblValue.text rangeOfString:foundAdd.street options:NSCaseInsensitiveSearch].length  ||
                    [cell.lblValue.text rangeOfString:foundAdd.state options:NSCaseInsensitiveSearch].length   ||
                    [cell.lblValue.text rangeOfString:foundAdd.city options:NSCaseInsensitiveSearch].length    ||
                    [cell.lblValue.text rangeOfString:foundAdd.zipCode options:NSCaseInsensitiveSearch].length ||
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
			GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
			MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:editItemTag];
			
			NSArray * emails = [[aContact relEmails] allObjects];
			
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
	GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:editItemTag];
	if (buttonIndex == 0) // tweet open twitter
	{
		if ([TWTweetComposeViewController canSendTweet])
		{
			
			TWTweetComposeViewController *vc = [[[TWTweetComposeViewController alloc] init]autorelease];
			
			NSString * user = aContact.twitter;
			
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
		
		NSString * linkUrl = aContact.twitter;
		
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableEmailSelection)
	{
		return [self.arrayFirstLine count];
	}
    else if (tableView == tblProductList)
    {
        return [self.arrProductList count];
    }
    else if (tableView == tblScriptList)
    {
        return [self.arrScriptList count];
    }
    else if (tableView == tblContactist)
    {
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        return [GDP.arrMyAddressBookData count];
    }
    else if (tableView == tblGroupList)
    {
        return [self.arrGroupList count];
    }
    else if(tableView == tblSubGroupList)
    {
        return [self.arrSubGroupList count];
    }
    else if(tableView == tblMemberList)
    {
        return [self.arrMemberList count];
    }
    else if(tableView == tblContactInfo)
    {
        return [self.arrAllKeys count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == tableEmailSelection)
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
        FirstLine * lineObj = (FirstLine *)[self.arrayFirstLine objectAtIndex:indexPath.row];
        [cell.lblName setText:lineObj.itemName];
        [cell.btnCheckBox setSelected:lineObj.isSelected];
        [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxForFirstLineTapped:) forControlEvents:UIControlEventTouchUpInside];
		[cell.btnCheckBox setTag:indexPath.row];
		
		
		return cell;
	}
    if(tableView == tblProductList)
    {
        ProductList *aProduct = [self.arrProductList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"ViewProductTVCell";
        ViewProductTVCell* cell = nil;
        cell = (ViewProductTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ViewProductTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[ViewProductTVCell class]])
                {
                    
                    cell = (ViewProductTVCell*)currentObject;
                    
                }
            }
            cell.lblProductName.text    = (aProduct.productName)?aProduct.productName:@"";
            cell.lblDesc.text           = (aProduct.productDesc)?aProduct.productDesc:@"";
            
            [cell.btnEditProduct addTarget:self action:@selector(editProduct:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnEditProduct setTag:indexPath.row];
            
            [cell.btnDeleteProduct addTarget:self action:@selector(deleteProduct:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDeleteProduct setTag:indexPath.row];
        }
        return cell;
    }
    else if(tableView == tblGroupList)
    {
        GroupList *aGroup = [self.arrGroupList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"GroupTVCell";
        GroupTVCell* cell = nil;
        cell = (GroupTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GroupTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[GroupTVCell class]])
                {
                    
                    cell = (GroupTVCell*)currentObject;
                    
                }
            }
        }
        [cell.lblGroupName setText:(aGroup.groupName)?aGroup.groupName:@""];
        [cell.lblGroupDesc setText:(aGroup.groupDesc)?aGroup.groupDesc:@""];
        
        [cell.btnDelete addTarget:self action:@selector(deleteGroup:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete setTag:indexPath.row];
        
        [cell.btnEditGroup addTarget:self action:@selector(editGroup:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEditGroup setTag:indexPath.row];
        
        [cell.btnCheckBox setSelected:NO];
        if (aGroup.isGroupCheck)
        {
            [cell.btnCheckBox setSelected:YES];
        }
        
        [cell.btnCheckBox addTarget:self action:@selector(groupCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheckBox setTag:indexPath.row];
        
        [cell.btnSubGroup addTarget:self action:@selector(subGroupsListTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSubGroup setTag:indexPath.row];
        
        return cell;
    }
    else if(tableView == tblScriptList)
    {
        
        ScriptList *aScript= [self.arrScriptList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"ViewScriptTVCell";
        ViewScriptTVCell* cell = nil;
        cell = (ViewScriptTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ViewScriptTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[ViewScriptTVCell class]])
                {
                    
                    cell = (ViewScriptTVCell*)currentObject;
                    
                }
            }
        }
        cell.lblScriptName.text = (aScript.scriptName)?aScript.scriptName:@"";
        cell.lblScriptDesc.text = (aScript.script_Description)?aScript.script_Description:@"";
        cell.lblDate.text       = (aScript.script_date)?aScript.script_date:@"";
        
        [cell.btnEditScript addTarget:self action:@selector(editScript:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEditScript setTag:indexPath.row];
        
        [cell.btnDeleteScript addTarget:self action:@selector(deleteScript:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDeleteScript setTag:indexPath.row];
        return cell;
    }
    else if(tableView == tblContactist)
    {
        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        MyAddressBook *aContact = [GDP.arrMyAddressBookData objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"SyncTVCell";
        SyncTVCell* cell = nil;
        cell = (SyncTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SyncTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[SyncTVCell class]])
                {
                    
                    cell = (SyncTVCell*)currentObject;
                    
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.btnCheckBox setSelected:aContact.isSelected];
        
        cell.lblCompany.text  = (aContact.organisation)?aContact.organisation:@"";
        cell.lblTitle.text    = (aContact.jobTitle)?aContact.jobTitle:@"";
        cell.lblContactName.text = [(aContact.firstName)?aContact.firstName:@"" stringByAppendingFormat:@" %@",(aContact.lastName)?aContact.lastName:@""];
        
        [cell.btnViewContact addTarget:self action:@selector(btnShowContactDetails:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnViewContact setTag:indexPath.row];
        
        [cell.btnDeleteContact addTarget:self action:@selector(btnDeleteContactFromDatabase:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDeleteContact setTag:indexPath.row];
        
        [cell.btnCheckBox addTarget:self action:@selector(btnCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheckBox setTag:indexPath.row];
        
        return cell;
    }
    else if(tableView == tblSubGroupList)
    {
//        GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        SubGroupList *aSubGroup= [self.arrSubGroupList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"SubGroupTVCell";
        SubGroupTVCell* cell = nil;
        cell = (SubGroupTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubGroupTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[SubGroupTVCell class]])
                {
                    
                    cell = (SubGroupTVCell*)currentObject;
                    
                }
            }
        }
        cell.lblSubGroupName.text  = (aSubGroup.subGroupName)?aSubGroup.subGroupName:@"";
        cell.lblSubGrpDesc.text    = (aSubGroup.subGroupDesc)?aSubGroup.subGroupDesc:@"";
        
        [cell.btnDelete addTarget:self action:@selector(deleteSubGroup:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDelete setTag:indexPath.row];
        
        [cell.btnEdit addTarget:self action:@selector(editSubGroup:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEdit setTag:indexPath.row];
        
        [cell.btnCheckBox setSelected:NO];
        
        if (aSubGroup.isSubGroupCheck)
        {
            [cell.btnCheckBox setSelected:YES];
        }
        
        [cell.btnCheckBox addTarget:self action:@selector(subGroupCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheckBox setTag:indexPath.row];

        return cell;
    }
    else if(tableView == tblMemberList)
    {
        GroupMemberList *aGroupMember= [self.arrMemberList objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"GroupMemberTVCell";
        GroupMemberTVCell* cell = nil;
        cell = (GroupMemberTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GroupMemberTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[GroupMemberTVCell class]])
                {
                    
                    cell = (GroupMemberTVCell*)currentObject;
                    
                }
            }
        }        
        cell.lblContactName.text = (aGroupMember.memberName)?aGroupMember.memberName:@"";
        
        cell.lblCompany.text  = (aGroupMember.memberCompany)?aGroupMember.memberCompany:@"";
        cell.lblTitle.text    = (aGroupMember.memberTitle)?aGroupMember.memberTitle:@"";
        
        [cell.btnViewContact addTarget:self action:@selector(showMemberDetails:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnViewContact setTag:indexPath.row];
        
        [cell.btnDeleteContact addTarget:self action:@selector(deleteMemberFromGroup:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDeleteContact setTag:indexPath.row];
        
        return cell;
    }
    else if(tableView == tblContactInfo)
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateUITableViewCell:[self.arrAllKeys objectAtIndex:indexPath.row]
                          cellValue:[dictTemp objectForKey:[self.arrAllKeys objectAtIndex:indexPath.row]]];
        
        [cell.btnNavigateTo addTarget:self action:@selector(cellPersonalDetails_NavigateTo:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }

    return nil;

}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblContactInfo)
    {
		UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
        int orientation = interface;
        CGFloat width  = 680;
        if (orientation <=2)
        {
            width  = 395;
        }
        
        NSString *Text = nil;
        Text = [dictTemp objectForKey:[self.arrAllKeys objectAtIndex:indexPath.row]];
        
        float height = [Text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        NSLog(@"height =%f",height);
        if(height < 44)
            return 44;
        
        return height+10;
	}

    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    BOOL noMemberFound = NO;
    if(tableView == tblGroupList)
    {
        self.selectedGroup = indexPath.row;
        GroupList *aGroup = [self.arrGroupList objectAtIndex:indexPath.row];
        
        // Flurry
		NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithString:aGroup.groupName] forKey:@"groupName"];
		[AppDelegate setFlurryWithText:@"Setting View Table Group list" andParms:dict];
        
        self.arrMemberList = [NSArray arrayWithArray:[[aGroup relGroupMember] allObjects]];
        if([self.arrMemberList count])
        {
            [self btnShowMemberList:nil];
            [tblMemberList reloadData];
        }
        else
        {
            noMemberFound = YES;
        }
    }
    if(tableView == tblSubGroupList)
    {
        SubGroupList *aSubGroup = [self.arrSubGroupList objectAtIndex:indexPath.row];
        
        // Flurry
		NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithString:aSubGroup.subGroupName] forKey:@"subGroupName"];
		[AppDelegate setFlurryWithText:@"Setting View Table SubGroupName" andParms:dict];
        
        self.arrMemberList = [NSArray arrayWithArray:[[aSubGroup relGroupMember] allObjects]];
        if([self.arrMemberList count])
        {
            [self btnShowMemberList:nil];
            [tblMemberList reloadData];
        }
        else
        {
            noMemberFound = YES;
        }
    }
    if(noMemberFound)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No member found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)viewDidUnload {
    [vwFirstLine release];
    vwFirstLine = nil;
    [tableEmailSelection release];
    tableEmailSelection = nil;
    [super viewDidUnload];
}
@end
