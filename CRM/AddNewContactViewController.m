//
//  AddNewContactViewController.m
//  CRM
//
//  Created by Narendra Verma on 09/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//
#define kHeightSectionHeader 40
#define kHeightSectionFooter 60

// if we require only Back button in the center of the Footer set kBUTTONCANCEL to 0
#define kBUTTONCANCEL 1


#import "AddNewContactViewController.h"
#import "AddNewContectDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "CRMConfig.h"
//#import "CoreDataHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "GroupMemberList.h"
#import <MapKit/MapKit.h>
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "AllAddress.h"

// DataModel
#import "GroupList.h"
#import "SubGroupList.h"
#import "FunnelStageList.h"
#import "Industries.h"
#import "Global.h"
#import "AllEmail.h"
#import "AllPhone.h"
#import "AllUrl.h"

#import "UIImage+Additions.h"

//ImageData Narendra
#import "ImageData.h"
#import "GlobalDataPersistence.h"
#import "DHValidation.h"
#import "AddEditContactHelper.h"

@interface AddNewContactViewController (){
    NSMutableDictionary *allAddressBook;
    int numberOfSection;
}

@end

@implementation AddNewContactViewController
@synthesize popoverController;
@synthesize editMyAddObj;
@synthesize currentField;
@synthesize aDelegate;
@synthesize groupIndex;
@synthesize subGroupIndex;
@synthesize arrayIndustry;
@synthesize popoverindustry;

//
@synthesize dictM_MyaddressBook;

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
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertFunnelStageList];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertIndusrtiesInDatabase];
    self.managedObjectContext = ((AppDelegate*)CRM_AppDelegate).managedObjectContext;
    self.groupIndex = -999;
    self.subGroupIndex = -999;
    
    [[tblDetils layer]setBorderColor:[UIColor lightGrayColor].CGColor];
    [[tblDetils layer]setBorderWidth:1.0];
    
	tblDetils.tableFooterView = [self footerView];
	[btnPersonalDetails setSelected:YES];
	self.mArrDetilTitle = [NSMutableArray arrayWithArray:[self createArrayForTable]];
    
    
	GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
    [global setIsContactEditted:NO];
	if (self.editMyAddObj)
    {
        
		//Dict for editing
		global.dictMyAddressBook = [NSMutableDictionary dictionaryWithDictionary:[self createDictForEditing]];
        allAddressBook = [NSMutableDictionary dictionaryWithDictionary:[self createAllAddressBook]];
        
        [tblDetils reloadData];
    }
    else
    {
		//freash data
		global.dictMyAddressBook = [NSMutableDictionary dictionaryWithDictionary:0];
		
    }
	//    [self createHeaderView];
	
    [self addObserver_NotificationCenter];
    // Do any additional setup after loading the view from its nib.
}
- (void)createHeaderView
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(12, 71, 852, kHeightSectionHeader)] autorelease];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    
	UIImage * img = [UIImage imageNamed:@"call-user-tab-top-bg.png"];
	
	UIImageView * imgHeader = [[UIImageView alloc]initWithImage:img];
	[imgHeader setFrame:CGRectMake(0, 0, sectionView.frame.size.width, sectionView.frame.size.height)];
	[imgHeader setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	
	
	UILabel * lblEvent = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 20)];
	[lblEvent setCenter:CGPointMake(lblEvent.center.x, sectionView.center.y)];
	[lblEvent setText:@"Events"];
	[lblEvent setBackgroundColor:[UIColor clearColor]];
	[lblEvent setFont:[UIFont boldSystemFontOfSize:16]];
	[lblEvent setTextColor:[UIColor grayColor]];
	
	UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnDone addTarget:self action:@selector(btnTopDonePressed:) forControlEvents:UIControlEventTouchUpInside];
	[btnDone setTitle:@"Done" forState:UIControlStateNormal];
	[btnDone setFrame:CGRectMake(sectionView.frame.size.width - 70, sectionView.frame.origin.y, 60, 30)];
	[btnDone setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
	
	[btnDone setCenter:CGPointMake(btnDone.center.x, sectionView.center.y)];
	[btnDone setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
	
	[sectionView addSubview:imgHeader];
//	[sectionView addSubview:lblEvent];
	[sectionView addSubview:btnDone];
	
	[lblEvent release];
	[imgHeader release];
    
    [view_main addSubview:sectionView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)dealloc
{
	[dictM_MyaddressBook release];
    [vwIndustrySearch release];
    [tableIndustry release];
    [txtIndustrySearch release];
    [arrayIndustry release];
    [popoverindustry release];
    
    
	[_datePickerPopover release];
    _datePickerPopover = nil;
    
    [popoverController release];
    popoverController = nil;
    
	[_dropDownView release];
    _dropDownView = nil;
    
//    [_myAddObj release];
//    _myAddObj = nil;
    
	[_mArrDetilTitle release];
    
	[tblDetils release];
    tblDetils = nil;
	
    [btnPersonalDetails release];
	[btnCompInfo release];
	[btnProfileInfo release];
    
	[dateTimePicker release];
    dateTimePicker = nil;
    
	[view_date_picker release];
    view_date_picker = nil;
    
    [editMyAddObj release];
    editMyAddObj = nil;
    
    [view_main release];
    view_main = nil;
    
    [lblHeader release];
    
    [self removeObserver_NotificationCenter];

    [super dealloc];
}
- (void)viewDidUnload
{
//	_myAddObj = nil;
    _mArrDetilTitle = nil;
	[tblDetils release];
	tblDetils = nil;
    [super viewDidUnload];
}

#pragma mark - Add OR Remove Notification Observers
- (void)addObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLayout" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
	[[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}
-(void)setContentOffsetOfTableView
{
	@try {
        id view = [currentField superview];
		if(view != nil)
		{
            BOOL notContactCell = YES;
            do{
                if([view isKindOfClass:[AddNewContectDetailCell class]]){
                    notContactCell = NO;
                }else{
                    view = [view superview];
                    if(view == nil)
                        break;
                }
            }while (notContactCell);
            
			if (view != nil && !notContactCell){
				AddNewContectDetailCell *cell = (AddNewContectDetailCell *)view;
                [tblDetils scrollToRowAtIndexPath:cell.indexPathForCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
			}
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Exception desc : %@",exception.description);
	}
	@finally {
		
	}
    
	
	
	
}


#pragma mark - NSNotification methods
-(void)changeLayout:(NSNotification*)info
{
    if ([self.datePickerPopover isPopoverVisible])
    {
        [self.datePickerPopover dismissPopoverAnimated:YES];
    }
    
}
-(void)keyboardWasShown:(NSNotification*)notification
{
    
	NSLog(@"KeyBoard appear");
	
	// first of all reducce the higth of the table view
	
	NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	NSLog(@"Size of keyboard %@",NSStringFromCGSize(kbSize));
	
	CGRect rectTable = tblDetils.frame;
	
	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
	{
		rectTable.size.height = rectTable.size.height - kbSize.height;
	}else
	{
		rectTable.size.height = rectTable.size.height - kbSize.width;
	}
	
	[tblDetils setFrame:rectTable];
	
	
	//content offset
	[self setContentOffsetOfTableView];
	
}
-(void)keyboardWillBeHidden:(NSNotification*)notification
{
    
	NSLog(@"keyBoard hide");
    
	NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	NSLog(@"Size of keyboard %@",NSStringFromCGSize(kbSize));
	
	CGRect rectTable = tblDetils.frame;
	
	if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
	{
		rectTable.size.height = rectTable.size.height + kbSize.height;
	}else
	{
		rectTable.size.height = rectTable.size.height + kbSize.width;
	}
	
    //	[currentField setDelegate:nil];
    //	self.currentField = nil;
	
	[tblDetils setFrame:rectTable];

}
-(void)setTextfieldInFront
{
	NSLog(@"Table view subviews : %@",tblDetils.subviews);
    
    //	UIView* vwSub = nil;
	for (UIView * vwSub in tblDetils.subviews)
	{
		if ([vwSub isKindOfClass:[UIView class]])
		{
			for (UITextField * textFields in vwSub.subviews)
			{
				NSLog(@"TextFiled recived in sub : %@",textFields);
			}
		}
		
	}
}

#pragma mark

- (void) dictDetailValue{
    //==================Create a dictionary
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.dictDetailTitle =[NSMutableDictionary dictionary];
    //Email
    NSArray *emailsList = [[self.editMyAddObj relEmails] allObjects];
    for(AllEmail *emails in emailsList){
        [dict setValue:emails.emailURL forKey:emails.emailTitle];
    }
    [self.dictDetailTitle setObject:dict forKey:EMAIL_STRING];
    dict = nil;
    dict = [NSMutableDictionary dictionary];
    //Address
    NSArray *addList = [[self.editMyAddObj relAllAddress] allObjects];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    for (int i =0 ; i <[addList count]; i++){
        AllAddress *address = [addList objectAtIndex:i];
        [dict setObject:address.street forKey:STREET_STRING];
        [dict setObject:address.state  forKey:STATE_STRING];
        [dict setObject:address.city forKey:CITY_STRING];
        [dict setObject:address.zipCode forKey:ZIP_STRING];
        [dict setObject:address.countryCode forKey:COUNTRY_STRING];
        [tempDict setObject:dict forKey:address.addressType];
        dict =nil;
        dict = [NSMutableDictionary dictionary];
    }
    [self.dictDetailTitle setObject:tempDict forKey:ADDRESS_STRING];
    dict = nil;
    dict = [NSMutableDictionary dictionary];
    //Phone
    NSArray *phone = [[self.editMyAddObj relAllPhone] allObjects];
    for(AllPhone *aphone in phone){
        [dict setValue:aphone.phoneNumber forKey:aphone.phoneTitle];
    }
    [self.dictDetailTitle setObject:dict forKey:PHONE_STRING];
    dict = nil;
    dict = [NSMutableDictionary dictionary];
    //URL
    NSArray *URL = [[self.editMyAddObj relAllUrl] allObjects];
    for(AllUrl *aURL in URL){
        [dict setValue:aURL.urlAddress forKey:aURL.urlTitle];
    }
    [self.dictDetailTitle setObject:dict forKey:URL_STRING];
 
    //===================================================================================================
    
}

-(NSArray *)createArrayForTable
{
    if(self.dictDetailTitle == nil){
    [self dictDetailValue];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:
					  @"AddNewContact" ofType:@"plist"];
	// Build the array from the plist
	NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
	
	if (btnPersonalDetails.selected)
	{
        [lblHeader setText:@"Personal Information"];
        numberOfSection = [[dictionary objectForKey:@"AddNewContact"] count];
		return [dictionary objectForKey:@"AddNewContact"];
	}else if (btnCompInfo.selected)
	{
        [lblHeader setText:@"Company Information"];
        numberOfSection = [[dictionary objectForKey:@"CompInfo"] count];
		return [dictionary objectForKey:@"CompInfo"];
	}else if (btnProfileInfo.selected)
	{
        [lblHeader setText:@"Profile Information"];
        numberOfSection = [[dictionary objectForKey:@"ProfileInfo"] count];
		return [dictionary objectForKey:@"ProfileInfo"];
	}
	
	return nil;
}

- (NSInteger) numberOfRows:(NSString *) title{
    if([title isEqualToString:EMAIL_STRING]){
        int rows = 0;
        NSArray *emailslist = [[self.editMyAddObj relEmails] allObjects];
        for (AllEmail *emails in emailslist){
            rows++;
        }
        return rows;
    }
    if([title isEqualToString:ADDRESS_STRING]){
        int rows = 0;
        NSArray *addList = [[self.editMyAddObj relAllAddress] allObjects];
        for (int i =0 ; i <[addList count]; i++){
            rows++;
        }
        return rows;
    }
    if([title isEqualToString:PHONE_STRING]){
        int rows = 0;
        NSArray *phoneslist = [[self.editMyAddObj relAllPhone] allObjects];
        for (AllPhone *phones in phoneslist){
            rows++;
        }
        return rows;
    }
    if([title isEqualToString:URL_STRING]){
        int rows = 0;
        NSArray *urlslist = [[self.editMyAddObj relAllUrl] allObjects];
        for (AllUrl *aUrl in urlslist){
            rows++;
        }
        return rows;
    }
    return 1;
}
-(CGSize)getmaximumTextSizeOfDetailTitle
{
	CGSize maxSize = CGSizeMake(0, 0);
	for (int i = 0; i < [self.mArrDetilTitle count]; i++)
	{
		NSDictionary * dict = [self.mArrDetilTitle objectAtIndex:i];
		
		NSString * stringText = [dict objectForKey:kDETAILSTYPE];
		
		CGSize currectTextSize = [stringText sizeWithFont:[UIFont boldSystemFontOfSize:18]];
		NSLog(@"Currect : %@ max : %@",NSStringFromCGSize(currectTextSize),NSStringFromCGSize(maxSize));
		if (currectTextSize.width > maxSize.width)
		{
			maxSize = currectTextSize;
		}
	}
	
	return maxSize;
}
#pragma mark - UISearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self searchWithTextDidChange];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}
-(void)searchWithTextDidChange
{
	NSPredicate *predicate = nil;
	if ([txtIndustrySearch.text length])
	{
		predicate = [NSPredicate predicateWithFormat:@"ANY industryName CONTAINS[cd] %@",txtIndustrySearch.text];
	}
	
	NSArray *array = [CoreDataHelper searchObjectsForEntity:@"Industries" withPredicate:predicate andSortKey:@"industryName" andSortAscending:YES andContext:self.managedObjectContext];
	
	self.arrayIndustry = [NSMutableArray arrayWithArray:array];
	
	[tableIndustry reloadData];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
        return numberOfSection;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == tableIndustry)
	{
		return [self.arrayIndustry count];
	}
    //Dynamic Rows for multi value records.
    NSDictionary * tempDict = [self.mArrDetilTitle objectAtIndex:section];
    NSString *currentSection = [tempDict valueForKey:@"DetailName"];
    if([currentSection isEqualToString:EMAIL_STRING] || [currentSection isEqualToString:ADDRESS_STRING] || [currentSection isEqualToString:PHONE_STRING] || [currentSection isEqualToString:URL_STRING])
        return [self numberOfRows:currentSection];
    
	return 1;
    //return [self.mArrDetilTitle count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == tableIndustry)
	{
		static NSString *cellIdentifier = @"CellIdentifier";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		
		if (cell == nil)
		{
			cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
			
		}
		
        
		Industries * industryObj = [self.arrayIndustry objectAtIndex:indexPath.row];
		
		[cell.textLabel setText:[NSString stringWithFormat:@"%@",industryObj.industryName]];
		cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
		[cell.textLabel setTextColor:[UIColor darkGrayColor]];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
        
        if ([[global.dictMyAddressBook objectForKey:kAddNewContact_Industry] rangeOfString:industryObj.industryName options:NSCaseInsensitiveSearch].length)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
		return cell;
	}
    static NSString *cellIdentifier = @"AddNewContectDetailCell";
    
    AddNewContectDetailCell *cell = (AddNewContectDetailCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
		NSString *nibname = @"AddNewContectDetailCell";
		NSArray *arrItems = [[NSBundle mainBundle]loadNibNamed:nibname owner:nil options:nil ];
		for (id object in arrItems)
		{
			if([object isKindOfClass:[AddNewContectDetailCell class]])
			{
				cell = (AddNewContectDetailCell *)object;
				[cell setAdelegate:self];
				break;
			}
		}
    }
    [cell addObserver_NotificationCenter];
	cell.indexPathForCell = indexPath;
	// and other objects like radio(gender),dropdown buttons etc.
    
	NSDictionary * dict = [self.mArrDetilTitle objectAtIndex:indexPath.section];
	[cell setlabeldetailTitleWithDict:dict andWithSize:CGSizeMake(150, 20)];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    //set data in table view
	[cell getDataFromDict:self.dictDetailTitle andDict:dict];

	
	// dropDown First
	[cell.btnDropDown addTarget:self action:@selector(btndropDownTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnDropDown setTag:indexPath.section];
	
	
	// Button gender tapped (Female)
 	[cell.btnFemale addTarget:self action:@selector(btnMalefemaleTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnFemale setTag:indexPath.section];
	
	// Button gender tapped (Male)
	[cell.btnMale addTarget:self action:@selector(btnMalefemaleTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnMale setTag:indexPath.section];
	
	
	//button date
	[cell.btnDate addTarget:self action:@selector(btnDateTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnDate setTag:indexPath.section];
	
	//button Upload Image
	[cell.btnUpload addTarget:self action:@selector(btnImageUpload:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnUpload setTag:indexPath.section];
    
    // Drop down industry
	[cell.btnIndustryDropDown addTarget:self action:@selector(btnIndustryDropDownTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnIndustryDropDown setTag:indexPath.section];
	
  [tableView setEditing:YES animated:YES];
	return cell;
	
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // Detemine cell to be edited
    NSDictionary *tempDict = [self.mArrDetilTitle objectAtIndex:indexPath.section];
    if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:EMAIL_STRING] || [[tempDict valueForKey:kDETAILSTITLE] isEqualToString:ADDRESS_STRING] || [[tempDict valueForKey:kDETAILSTITLE] isEqualToString:URL_STRING] || [[tempDict valueForKey:kDETAILSTITLE] isEqualToString:PHONE_STRING]){
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}



//delete row with Edit tableview
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id roleToDelete = nil;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      //[tableView beginUpdates];
        
        // Delete the role object that was swiped
        NSDictionary *tempDict = [self.mArrDetilTitle objectAtIndex:indexPath.section];
        if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:EMAIL_STRING]){
            NSArray *emailsList = [[self.editMyAddObj relEmails] allObjects];
           roleToDelete = [emailsList objectAtIndex:indexPath.row];
            
        }
        else if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:URL_STRING]){
            NSArray *emailsList = [[self.editMyAddObj relAllUrl] allObjects];
            roleToDelete = [emailsList objectAtIndex:indexPath.row];
            
        }
        else if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:ADDRESS_STRING]){
            NSArray *emailsList = [[self.editMyAddObj relAllAddress] allObjects];
            roleToDelete = [emailsList objectAtIndex:indexPath.row];
            
        }
        else if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:PHONE_STRING]){
            NSArray *emailsList = [[self.editMyAddObj relAllPhone] allObjects];
            roleToDelete = [emailsList objectAtIndex:indexPath.row];
            
        }
        
        
        [self.managedObjectContext deleteObject:roleToDelete];
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        if(error == nil){
            [self.managedObjectContext refreshObject:[roleToDelete relMyAddressBook] mergeChanges:NO];
            
            
            if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:EMAIL_STRING]){
                [self.editMyAddObj relEmails];
            }
            else if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:URL_STRING]){
                [self.editMyAddObj relAllUrl];
            }
            else if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:ADDRESS_STRING]){
                [self.editMyAddObj relAllAddress];
            }
            else if([[tempDict valueForKey:kDETAILSTITLE] isEqualToString:PHONE_STRING]){
                [self.editMyAddObj relAllPhone];
            }
            // Delete the (now empty) row on the table
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self dictDetailValue];
            [tableView endUpdates];
        }else{
            NSLog(@"%@", [error description]);
        }
        //
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == tableIndustry)
	{
		return 44;
	}
	NSDictionary * dict = [self.mArrDetilTitle objectAtIndex:indexPath.section];
	
	NSString * text = [dict objectForKey:kDETAILSTYPE];
	
	if ([text rangeOfString:@"image" options:NSCaseInsensitiveSearch].length)
	{
		return 80;
	}

	else if([text rangeOfString:@"typetextview" options:NSCaseInsensitiveSearch].length)
	{
		NSString * key  = [dict valueForKey:kDETAILSTITLE];
		if ([key rangeOfString:@"note" options:NSCaseInsensitiveSearch].length)
		{
			return 250;
		}
		
		return 120;
	}
    else if ([text rangeOfString:@"address" options:NSCaseInsensitiveSearch].length){
        return 200;
    }
    
    return 44;
}

//UITableView Header in section

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kHeightSectionHeader)] autorelease];
    [sectionView setBackgroundColor:[UIColor clearColor]];

	UIImage * img = [UIImage imageNamed:@"call-user-tab-top-bg.png"];
	
	UIImageView * imgHeader = [[UIImageView alloc]initWithImage:img];
	[imgHeader setFrame:CGRectMake(0, 0, sectionView.frame.size.width, sectionView.frame.size.height)];
	[imgHeader setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	
	
	UILabel * lblEvent = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 20)];
	[lblEvent setCenter:CGPointMake(lblEvent.center.x, sectionView.center.y)];
	[lblEvent setText:@"Events"];
	[lblEvent setBackgroundColor:[UIColor clearColor]];
	[lblEvent setFont:[UIFont boldSystemFontOfSize:16]];
	[lblEvent setTextColor:[UIColor grayColor]];
	
	UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnDone addTarget:self action:@selector(btnTopDonePressed:) forControlEvents:UIControlEventTouchUpInside];
	[btnDone setTitle:@"Done" forState:UIControlStateNormal];
	[btnDone setFrame:CGRectMake(sectionView.frame.size.width - 70, 0, 60, 30)];
	[btnDone setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
	
	[btnDone setCenter:CGPointMake(btnDone.center.x, sectionView.center.y)];
	[btnDone setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	
	[sectionView addSubview:btnDone];
	
	
	[sectionView addSubview:imgHeader];
	[sectionView addSubview:lblEvent];
	[sectionView addSubview:btnDone];
	
	[lblEvent release];
	[imgHeader release];
    return sectionView;
}*/
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//
//	
//	return [self footerView];
//}
/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return kHeightSectionHeader;
}*/

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return kHeightSectionFooter;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == tableIndustry)
	{
		[self.popoverindustry dismissPopoverAnimated:YES];
		
		Industries * industry = [self.arrayIndustry objectAtIndex:indexPath.row];
		
		GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
		[global.dictMyAddressBook setValue:[NSString stringWithString:industry.industryName] forKey:kAddNewContact_Industry];
        
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            [global.dictMyAddressBook setValue:@"" forKey:kAddNewContact_Industry];
        }
        
		[tblDetils reloadData];
        
        
	}

    
}

-(void)btnFooterBackOrCancelTapped:(UIButton*)sender
{
	if (sender.tag == 22) //back
	{
		
		//For new conditions
		// we should as the user, if he really want to cancel or go back
		// as it will remove whole saved data.
	
		
        if (self.editMyAddObj)
        {
            [self.managedObjectContext refreshObject:self.editMyAddObj mergeChanges:NO];
        }
        else
        {
//            [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:self.myAddObj];
        }
        if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(refreshContactList)])
        {
            [self.aDelegate performSelector:@selector(refreshContactList) withObject:nil];
        }
        
		[self.navigationController popViewControllerAnimated:YES];
	}
    else if (sender.tag == 11) //cancel
    {
		
		//Cancel will empty all fileds from textfileds
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Do you want to roll back all changes!" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
		[alert setTag:11];
		[alert show];
		[alert release];
		
        if (self.editMyAddObj)
        {
            [self.managedObjectContext refreshObject:self.editMyAddObj mergeChanges:NO];
            if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(refreshContactList)])
            {
                [self.aDelegate performSelector:@selector(refreshContactList) withObject:nil];
            }
        }
        else 
        {
//            [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:self.myAddObj];
//            self.myAddObj = [NSEntityDescription insertNewObjectForEntityForName:@"MyAddressBook" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        }
        [tblDetils reloadData];
    }
}
-(UIView*)footerView
{
	UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblDetils.bounds.size.width, kHeightSectionFooter)] autorelease];
    [sectionView setBackgroundColor:[UIColor clearColor]];
	
	
	if (kBUTTONCANCEL)
	{
		UIButton * btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnCancel addTarget:self action:@selector(btnFooterBackOrCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
		[btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
		[btnCancel setFrame:CGRectMake(316, 0, 80, 34)];
		[btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
		
		[btnCancel setCenter:CGPointMake(sectionView.center.x - btnCancel.frame.size.width - 10, sectionView.center.y)];
		[btnCancel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
		
		[btnCancel setTag:11];
		
		[sectionView addSubview:btnCancel];
	}
	
	UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
	[btnBack addTarget:self action:@selector(btnFooterBackOrCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
	[btnBack setTitle:@"Back to the List" forState:UIControlStateNormal];
	[btnBack setFrame:CGRectMake(316, 0, 150, 34)];
	[btnBack setBackgroundImage:[[UIImage imageNamed:@"btn_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
	
	if (kBUTTONCANCEL)
	{
		[btnBack setCenter:CGPointMake(sectionView.center.x + 90, sectionView.center.y)];
	}else
	{
		[btnBack setCenter:sectionView.center];
	}
	
	[btnBack setTag:22];
	[btnBack setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	[sectionView addSubview:btnBack];
	return sectionView;
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1001)
    {
        [self removeDataFromDict];
        [self backToContactList];
    }
    else if (alertView.tag == 1002 && buttonIndex == 0)
    {
        [self checkAndPrepareNewRecord];
    }
	else if (alertView.tag == 11 && buttonIndex == 0)//Btn cancel tapped
	{
		[self cancelButtonProcedure];//Yes : roll back all changes
    }
}
#pragma mark - IBAction
- (void)backToContactList
{
    if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(refreshContactList)])
    {
        [self.aDelegate performSelector:@selector(refreshContactList) withObject:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
// Buttons on the header ()
-(NSString*)getRandomAlphanumericString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease]; //specify length here. even you can use full
}
- (IBAction)btnDoneToolBar:(id)sender
{
	GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
    [global setIsContactEditted:YES];
	NSString * strDate = [NSDateFormatter localizedStringFromDate:dateTimePicker.date
								   dateStyle:NSDateFormatterFullStyle
								   timeStyle:NSDateFormatterNoStyle];
	
	[global.dictMyAddressBook setValue:strDate forKey:kAddNewContact_DOB];
	
//	[self.myAddObj setBirthDay:dateTimePicker.date];
	[tblDetils reloadData];
    if ([self.datePickerPopover isPopoverVisible])
    {
        [self.datePickerPopover dismissPopoverAnimated:YES];
    }
}


- (IBAction)btnTopDonePressed:(id)sender
{
	//save data in database
    
    GlobalDataPersistence *global = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"firstName == %@ AND lastName == %@", [global.dictMyAddressBook valueForKey:k_TextFiled_FirstName],[global.dictMyAddressBook valueForKey:k_TextFiled_LastName]];
    
    NSArray *copyitemsearch = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:_myPredicate andSortKey:@"firstName" andSortAscending:YES andContext:self.managedObjectContext];
    
    if([copyitemsearch count] && !self.editMyAddObj)
    {
        MyAddressBook *searchPerson = (MyAddressBook*)[copyitemsearch lastObject];
        
        AllEmail *emails = [[[searchPerson relEmails] allObjects] lastObject];
        
        NSString *emailStr = nil;
        if (emails.emailURL)
        {
            emailStr = emails.emailURL;
        }
        
        NSString *message = nil;
        NSString *FN = (searchPerson.firstName.length)?searchPerson.firstName:@"";
        NSString *LN = (searchPerson.lastName.length)?searchPerson.lastName:@"";
        if (emailStr.length && emailStr)
        {
            
            message = [NSString stringWithFormat:@"A contact %@ %@ (%@) is already exist in your address book. Do you want to save anyway?",FN,LN,emailStr];
        }
        else
        {
            message = [NSString stringWithFormat:@"A contact %@ %@ is already exist in your address book. Do you want to save anyway?",FN,LN];
        }
        
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Notice!" message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
        [anAlertView setTag:1002];
        [anAlertView show];
        [anAlertView release];
    }
    else
    {
        [self checkAndPrepareNewRecord];
    }
	
//    NSString *recordId = [self getRandomAlphanumericString];
//    
//    if (!self.editMyAddObj)
//    {
//        if([self isContainsObject])
//        {
//            [self.myAddObj setRecordID:recordId];
//            
//            [self.myAddObj setCreationDate:[NSDate date]];
//            [self.myAddObj setModificationDate:[NSDate date]];
//            
//            AllAddress *allAddress = nil;
//            if ([self checkNetworkConnection])
//            {
//                allAddress = [[[self.myAddObj relAllAddress]allObjects] lastObject];
//                CLLocationCoordinate2D location = [self addressLocation:[self getAddressString:allAddress]];
//                [allAddress setLatitude:[NSString stringWithFormat:@"%f",location.latitude]];
//                [allAddress setLongitude:[NSString stringWithFormat:@"%f",location.longitude]];
//            }
//            NSString *username = nil;
//            if (self.myAddObj.firstName.length)
//            {
//                username = [NSString stringWithFormat:@"%@",(self.myAddObj.firstName)?self.myAddObj.firstName:@""];
//            }
//            if (username)
//            {
//                username = [username stringByAppendingString:(self.myAddObj.lastName)?self.myAddObj.lastName:@""];
//            }
//            else
//            {
//                username = [NSString stringWithFormat:@"%@",(self.myAddObj.lastName)?self.myAddObj.lastName:@"No Name"];
//            }
//            [allAddress setPersonName:username];
//            
//            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
//            if (self.groupIndex >= 0)
//            {
//                [self setgroupMember:recordId];
//            }
//            if (self.subGroupIndex >= 0)
//            {
//                [self setSubGroupIndex:recordId];
//            }
//            
//            
//            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Saved successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//            [anAlertView setTag:1001];
//            [anAlertView show];
//            [anAlertView release];
//        }
//        else
//        {
//            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Empty contact cannot be save." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//            [anAlertView show];
//            [anAlertView release];
//        }
//        
//    }
//    else
//    {
//        AllAddress *allAddress = nil;
//        if ([self checkNetworkConnection])
//        {
//            allAddress = [[[self.myAddObj relAllAddress]allObjects] lastObject];
//            CLLocationCoordinate2D location = [self addressLocation:[self getAddressString:allAddress]];
//            [allAddress setLatitude:[NSString stringWithFormat:@"%f",location.latitude]];
//            [allAddress setLongitude:[NSString stringWithFormat:@"%f",location.longitude]];
//        }
//        NSString *username = nil;
//        if (self.myAddObj.firstName.length)
//        {
//            username = [NSString stringWithFormat:@"%@",(self.myAddObj.firstName)?self.myAddObj.firstName:@""];
//        }
//        if (username)
//        {
//            username = [username stringByAppendingFormat:@" %@",(self.myAddObj.lastName)?self.myAddObj.lastName:@""];
//        }
//        else
//        {
//            username = [NSString stringWithFormat:@"%@",(self.myAddObj.lastName)?self.myAddObj.lastName:@"No Name"];
//        }
//        [allAddress setPersonName:username];
//        [self.myAddObj setModificationDate:[NSDate date]];
//        [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
//        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Updated successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//        [anAlertView setTag:1001];
//        [anAlertView show];
//        [anAlertView release];
//    }

    [Global SaveSyncLocationsFlag:NO];
    
	
}

- (void)checkAndPrepareNewRecord
{
    DHValidation *validate = [[DHValidation alloc]init];
    
    GlobalDataPersistence *global = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    NSString *email = [global.dictMyAddressBook valueForKey:k_TextFiled_Email];
    if ([validate validateEmail:email] || email.length == 0)
    {
        [self saveDatainDataBase];
    }
    else
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter valid email address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [anAlertView show];
        [anAlertView release];
    }
    [validate release];
}
- (BOOL)isContainsObject:(MyAddressBook*)aContact
{
    BOOL isEntryFound  = NO;
    NSDictionary *attributes = [CoreDataHelper getAttributesByName:@"MyAddressBook"];
//    NSLog(@"%@",attributes);
//    NSLog(@"%@",[attributes allKeys]);
    for (NSString *attr in [attributes allKeys])
    {
        NSLog(@"%@",[aContact valueForKey:attr]);
        NSString *str = [aContact valueForKey:attr];
        
        if (str && ![attr rangeOfString:@"image" options:NSCaseInsensitiveSearch].length
                && ![attr rangeOfString:KIND_STRING options:NSCaseInsensitiveSearch].length
                && ![attr rangeOfString:FUNNEL_STAGE_STRING options:NSCaseInsensitiveSearch].length
                && ![attr rangeOfString:@"isViewed" options:NSCaseInsensitiveSearch].length)
        {
            isEntryFound = YES;
            break;
        }
    }
    
    NSDictionary *relationships = [CoreDataHelper getRelationshipsByName:@"MyAddressBook"];
    
    for (NSRelationshipDescription *rel in relationships)
    {
        NSString *keyName = [NSString stringWithFormat:@"%@",rel];
        //get a set of all objects in the relationship
        NSMutableSet *sourceSet = [aContact mutableSetValueForKey:keyName];
        NSEnumerator *e = [sourceSet objectEnumerator];
        NSManagedObject *relatedObject;
        while ( relatedObject = [e nextObject])
        {
            isEntryFound = YES;
            break;
        }
        
    }
    if (!isEntryFound)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Empty contact cannot be save." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
        [anAlertView show];
        [anAlertView release];
    }
    
    return  isEntryFound;
}
- (BOOL)checkNetworkConnection
{
    Reachability *reachability	= [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        return NO;
    }
    return YES;
}
#pragma mark - Get Latitude and Longitude
-(CLLocationCoordinate2D) addressLocation:(NSString *)searchedLocation
{
	//    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];http://maps.googleapis.com/maps/api/geocode/json?address=durgapura%2C%20jaipur&sensor=true
    
    
	[SVProgressHUD show];
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSError *err;
    
	// get crash in case we get resuldata as nil
	// so we implemented below code
	CLLocationCoordinate2D location;
	double latitude = 0.0;
    double longitude = 0.0;
    
	if (resultData)
	{
		NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&err];
		
		NSMutableArray *resultArray = [jsonDict objectForKey:@"results"];
		
		
		
		if([resultArray count] > 0)
		{
			NSDictionary *latLongDict = [[[resultArray objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
			latitude = [[latLongDict objectForKey:@"lat"] floatValue];
			longitude = [[latLongDict objectForKey:@"lng"] floatValue];
			NSLog(@"json string is %@",latLongDict);
		}
		else
		{
			//Show error
		}
		
		
		location.latitude = latitude;
		location.longitude = longitude;
		[SVProgressHUD dismiss];
		return location;
		
	}
    else
    {
        location.latitude = latitude;
		location.longitude = longitude;
    }
	[SVProgressHUD dismiss];
    return location;
}
- (NSString*)getAddressString:(AllAddress*)allAddress
{
    NSString *address = @"";
    //    [allAddress.street stringByAppendingFormat:@" %@ %@ %@ %@",allAddress.city,allAddress.state,allAddress.countryCode,allAddress.zipCode];
    if(allAddress.street)
    {
        address = [address stringByAppendingFormat:@"%@",allAddress.street];
    }
    if(allAddress.city)
    {
        address = [address stringByAppendingFormat:@" %@",allAddress.city];
    }
    if(allAddress.state)
    {
        address = [address stringByAppendingFormat:@" %@",allAddress.state];
    }
    if(allAddress.countryCode)
    {
        address = [address stringByAppendingFormat:@" %@",allAddress.countryCode];
    }
    if(allAddress.zipCode)
    {
        address = [address stringByAppendingFormat:@" %@",allAddress.zipCode];
    }
    return address;
}
- (void)setgroupMember:(NSString*)recordId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",recordId];
    
    NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:self.managedObjectContext];
    NSLog(@"%@",previousEntry);
    
    if ([previousEntry count])
    {
        NSArray * arr = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:self.managedObjectContext];
        if([arr count])
        {
            GroupList *aGroup = [arr objectAtIndex:self.groupIndex];
            MyAddressBook *aPerson = [previousEntry lastObject];
            GroupMemberList *aGroupMember = (GroupMemberList *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupMemberList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            
            [aGroupMember setMemRecordID:aPerson.recordID];
            [aGroupMember setMemberName:[(aPerson.firstName)?aPerson.firstName:@"" stringByAppendingFormat:@" %@",(aPerson.lastName)?aPerson.lastName:@""]];
            [aGroupMember setMemberCompany:aPerson.organisation];
            [aGroupMember setMemberTitle:aPerson.jobTitle];
            
            [aGroupMember setRelGroupList:aGroup];
//            [aPerson setGroupName:aGroup.groupName];
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        }
    }
}
- (void)setSubgroupMember:(NSString*)recordId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recordID == %@",recordId];
    
    NSArray *previousEntry = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    NSLog(@"%@",previousEntry);
    
    if ([previousEntry count])
    {
        NSArray * arr = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        if([arr count])
        {
            SubGroupList *aSubGroup = [arr objectAtIndex:self.subGroupIndex];
            
            MyAddressBook *aPerson = [previousEntry lastObject];
            
            GroupMemberList *aGroupMember = (GroupMemberList *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupMemberList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            
            [aGroupMember setMemRecordID:aPerson.recordID];
            [aGroupMember setMemberName:[(aPerson.firstName)?aPerson.firstName:@"" stringByAppendingFormat:@" %@",(aPerson.lastName)?aPerson.lastName:@""]];
            [aGroupMember setMemberCompany:aPerson.organisation];
            [aGroupMember setMemberTitle:aPerson.jobTitle];
            
            [aGroupMember setRelSubGroup:aSubGroup];
            [aPerson setSubGroupName:aSubGroup.subGroupName];
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        }
    }
}
- (IBAction)btnOptionTapped:(UIButton*)sender
{
	
	[btnCompInfo setSelected:NO];
	[btnPersonalDetails setSelected:NO];
	[btnProfileInfo setSelected:NO];
	[sender setSelected:YES];
	
	self.mArrDetilTitle = [NSMutableArray arrayWithArray:[self createArrayForTable]];
	[tblDetils reloadData];
}




#pragma mark - Cell buttons
-(void)btnIndustryDropDownTapped:(UIButton*)sender
{
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	
	if (!self.popoverindustry) {
		
		UIViewController * controllerIndstry = [[UIViewController alloc]init];
		controllerIndstry.view = vwIndustrySearch;
		self.popoverindustry = [[[UIPopoverController alloc]initWithContentViewController:controllerIndstry] autorelease];
		[self.popoverindustry setPopoverContentSize:vwIndustrySearch.frame.size];
		[controllerIndstry release];
	}
	
	[self.arrayIndustry removeAllObjects];
	
	if (![self.arrayIndustry count])
	{
		[txtIndustrySearch setText:@""];
		
		AppDelegate * adelegate = CRM_AppDelegate;
		
		NSArray * array  = [CoreDataHelper searchObjectsForEntity:@"Industries" withPredicate:nil andSortKey:@"industryName" andSortAscending:YES andContext:adelegate.managedObjectContext];
		
		self.arrayIndustry = [NSMutableArray arrayWithArray:array];
	}
	
	[tableIndustry reloadData];
	
	[self.popoverindustry presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)btnImageUpload:(UIButton*)sender
{
    aSender = sender;
    UIActionSheet *actionSheet = nil;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
	actionSheet = [[UIActionSheet alloc] initWithTitle:@""
												  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
										 otherButtonTitles:@"Choose Existing Photo",@"Take Photo",nil];
		
		actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
		[actionSheet showInView:self.view];
	}
	else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@""delegate:self cancelButtonTitle:@"Cancel"
									destructiveButtonTitle:nil otherButtonTitles: @"Choose Existing Photo", nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
		[actionSheet showInView:self.view];
		
	}
}

-(void)btnDateTapped:(UIButton*)sender
{
//	[self.currentField resignFirstResponder];
	
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	
    if(self.datePickerPopover == nil)
    {
		
        UIViewController *datePickerVC = [[UIViewController alloc]init];
        
        datePickerVC.view = view_date_picker;
        
        [datePickerVC setContentSizeForViewInPopover:view_date_picker.frame.size];
        
        self.datePickerPopover = [[[UIPopoverController alloc]initWithContentViewController:datePickerVC] autorelease];
		
        
        [datePickerVC release];
    }
	[self.datePickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)btndropDownTapped:(UIButton*)sender
{
    [currentField resignFirstResponder];
	[self generateDropDown:sender];
	[self downloadDropDownData:sender];
}

-(void)btnMalefemaleTapped:(UIButton*)sender
{
	GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
    [global setIsContactEditted:YES];
	if ([sender.titleLabel.text rangeOfString:@"female" options:NSCaseInsensitiveSearch].length)
	{
//		self.myAddObj.gender = @"female";
		[global.dictMyAddressBook setValue:@"10" forKey:kAddNewContact_Gender];
		
	}
	else
	{
		[global.dictMyAddressBook setValue:@"11" forKey:kAddNewContact_Gender];
//		self.myAddObj.gender  = @"male";
	}
	[tblDetils reloadData];
}
#pragma mark ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	UIImagePickerController* imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
//	imagePickerController.navigationBar.barStyle = UIBarStyleDefault;
	imagePickerController.delegate = self;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_3_0
    imagePickerController.allowsImageEditing = YES;
#else
    imagePickerController.allowsEditing = YES;
#endif
	
	
	if(buttonIndex==0)
	{
		CGRect rect = [aSender convertRect:aSender.bounds toView:self.view];
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage,nil];
            
            imagePicker.allowsEditing = YES;
            if(self.popoverController == nil)
            {
            self.popoverController = [[[UIPopoverController alloc]
                                      initWithContentViewController:imagePicker] autorelease];
            }
            
            popoverController.delegate = self;
            
            [self.popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            
            [imagePicker release];
            newMedia = NO;
        }
        
        
	}
	if(buttonIndex==1)
	{
		if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            [self presentModalViewController:imagePicker
                                    animated:YES];
            [imagePicker release];
            newMedia = YES;
        }
        
	}
	
}
#pragma  mark - UIImagePickerControllerDelegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *UDID = [self stringWithNewUUID];
        //Save Image to Document Directory With This name <UUID>.png
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",UDID]];
        NSLog(@"%@",savedImagePath);
        
        image = [image imageByScalingProportionallyToSize:CGSizeMake(320, 337)];
        
		
		//Save nsdata and url of image in database
		//ImageData Narendra
		ImageData * data = [NSEntityDescription insertNewObjectForEntityForName:@"ImageData" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		
		NSData * imgData = UIImagePNGRepresentation(image);

		[data setImage_Data:imgData];
		[data setImage_Path:savedImagePath];
		
		if (![((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil])
		{
			NSLog(@"Data not saved in data base");
		}
		//----
		
        BOOL success =  [self saveImageDataToDocDir:imgData atPath:savedImagePath];
        if (success)
        {
			GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
			[global.dictMyAddressBook setValue:savedImagePath forKey:kAddNewContact_Image];
//            self.myAddObj.image = savedImagePath;
        }
        
        [tblDetils reloadData];
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)Imagesize
{
    CGSize thumbSize = CGSizeMake(340, 340);
    if(image.size.width <= 320 && image.size.height <=337)
    {
        return image;
    }
    else
    {
        UIGraphicsBeginImageContext(thumbSize);
        [image drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
        UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return destImage;
    }
    
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
    [global setIsContactEditted:YES];
    if (error)
    {
        [global setIsContactEditted:NO];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (NSString*)stringWithNewUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [newUUID autorelease];
}
- (BOOL)saveImageDataToDocDir:(NSData*)imgData atPath:(NSString*)path
{
    BOOL success =   [imgData writeToFile:path atomically:NO];
    
    return success;
}
#pragma mark - DropDown List methods
- (void)generateDropDown:(UIButton*)sender
{
    
	//Category Drop Down
	BOOL notContactCell = YES;
    id view = [sender superview];
    do{
        if([view isKindOfClass:[AddNewContectDetailCell class]]){
            notContactCell = NO;
        }else{
            view = [view superview];
            if(view == nil)
                break;
        }
    }while (notContactCell);
    AddNewContectDetailCell *cell = (AddNewContectDetailCell *)view;
	if (view != nil && !notContactCell)
	{
		
		if (self.dropDownView) {
			[_dropDownView removeFromSuperview];
            [_dropDownView release];
            _dropDownView = nil;
        }
        
		NSLog(@"%@",sender.superview);
		CGRect rect = [sender convertRect:sender.bounds toView:self.view];
		
        self.dropDownView = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
        [self.dropDownView setBackgroundColor:[UIColor clearColor]];
        
		if ([cell.lblDetailTitle.text rangeOfString:@"prefix" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDPrefix];
		}
		else if ([cell.lblDetailTitle.text rangeOfString:@"salutation" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDSalutation];
		}
		else if ([cell.lblDetailTitle.text rangeOfString:@"funnel stage" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDFunnelStage];
		}
		else if ([cell.lblDetailTitle.text rangeOfString:@"lead status" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDLeadStatus];
		}
		else if ([cell.lblDetailTitle.text rangeOfString:@"lead source" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDLeadSource];
		}
        else if([cell.lblDetailTitle.text rangeOfString:@"Add to group" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDGroup];
		}
        //subgroup
		
		else if([cell.lblDetailTitle.text rangeOfString:@"Add to subgroup" options:NSCaseInsensitiveSearch].length)
		{
			[self.dropDownView setDDType:DDSubGroup];
		}
		// add data in dropDown
		[self downloadDropDownData:sender];
		
		// if array has some count then only it should be added on view
		if ([self.dropDownView.myDataarray count])
		{
			[self.view addSubview:self.dropDownView];
		}
		
		// open dropDown with som delay because it won't work otherwise
		[self.dropDownView performSelector:@selector(openDropDown) withObject:nil afterDelay:0.1];
	}
    
}
- (void)downloadDropDownData:(UIButton*)sender
{
	NSDictionary * dict = [self.mArrDetilTitle objectAtIndex:sender.tag];
	NSString * title = [dict objectForKey:kDETAILSTITLE];
	NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
	
	
	if([title rangeOfString:@"prefix" options:NSCaseInsensitiveSearch].length)
    {
        [List addObjectsFromArray:[NSArray arrayWithObjects:@"Mr.",@"Ms.",@"Mrs.",nil]];
    }
	else if([title rangeOfString:@"Salutation" options:NSCaseInsensitiveSearch].length)
    {
        [List addObjectsFromArray:[NSArray arrayWithObjects:@"Dear",@"Hello",nil]];
    }
	else if ([title rangeOfString:@"Lead Source" options:NSCaseInsensitiveSearch].length)
	{
		NSArray * arr = @[@"Website",@"Email",@"Tradeshow",@"Referral",@"Direct Mail",@"Call Center",@"Social Media",@"PPC",@"Internal Sales",@"External Sales"];
		[List addObjectsFromArray:arr];

	}
	else if ([title rangeOfString:@"Lead Status" options:NSCaseInsensitiveSearch].length)
	{
		NSArray * arr = @[@"Prospect",@"Customer",@"Qualified"];
		[List addObjectsFromArray:arr];

	}
	else if ([title rangeOfString:@"Funnel stage" options:NSCaseInsensitiveSearch].length)
	{
        AppDelegate * adel = CRM_AppDelegate;
		NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:nil andSortKey:@"stageID" andSortAscending:YES andContext:[adel managedObjectContext]];
		
		NSMutableArray * arrayForDrop = [NSMutableArray arrayWithCapacity:0];
		
		for (FunnelStageList * funObj in arrayFunnel)
		{
			if ([funObj.stageID integerValue] != 13)
            {
                [arrayForDrop addObject:funObj.stageName];
            }
		}
		
		[List addObjectsFromArray:arrayForDrop];

		
	}
	else if([title rangeOfString:@"Add to Group" options:NSCaseInsensitiveSearch].length)// Group List
	{
		 NSArray * arr = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		for (int i = 0; i < [arr count]; i++)
		{
			GroupList * objGroup = [arr objectAtIndex:i];
			[List addObject:objGroup.groupName];
		}
		
	}
	else if([title rangeOfString:@"Add to Subgroup" options:NSCaseInsensitiveSearch].length)// Group List
	{
		NSArray * arr = [CoreDataHelper getObjectsForEntity:@"SubGroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		for (int i = 0; i < [arr count]; i++)
		{
			SubGroupList * objGroup = [arr objectAtIndex:i];
			[List addObject:objGroup.subGroupName];
		}
	}
	
	[self.dropDownView setDataArray:List];
	[List release];
	//else if ([title rangeOfString:@"Salutation" options:NSCaseInsensitiveSearch].length)
}

#pragma mark - DropDown delegate
-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
	[self.dropDownView removeFromSuperview];
	
	GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
    [global setIsContactEditted:YES];
    if(dropdown.strDropDownValue)
        switch (dropdown.DDType)
        {
            case DDPrefix:
            {
                if ([dropdown.strDropDownValue length])
                {
                    [global setIsContactEditted:YES];
                    [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                forKey:kAddNewContact_Prefix];
                }
            }
                break;
                
            case DDSalutation:
                {
                    if ([dropdown.strDropDownValue length])
                    {
                        [global setIsContactEditted:YES];
                        [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                    forKey:kAddNewContact_Salutation];
                    }
                }
                break;
            case DDFunnelStage:
            {
                if ([dropdown.strDropDownValue length])
                {
                    [global setIsContactEditted:YES];
                    [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                forKey:kAddNewContact_FunnelStage];
                }
            }
                break;
            case DDLeadStatus:
            {
                if ([dropdown.strDropDownValue length])
                {
                    [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                forKey:kAddNewContact_LeadStatus];
                    [global setIsContactEditted:YES];
                }
            }
                break;
            case DDLeadSource:
            {
                if ([dropdown.strDropDownValue length])
                {
                    [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                forKey:kAddNewContact_LeadSource];

                    [global setIsContactEditted:YES];
                }
            }
                break;
            case DDGroup:
            {
                if ([dropdown.strDropDownValue length])
                {
                    [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                forKey:kAddNewContact_AddGroup];
                    [global setIsContactEditted:YES];
                    self.groupIndex = index;
                }
            }
                break;
            case DDSubGroup:
            {
                if ([dropdown.strDropDownValue length])
                {
                    [global.dictMyAddressBook setValue:[NSString stringWithString:dropdown.strDropDownValue]
                                                forKey:kAddNewContact_AddSubGroup];
                    [global setIsContactEditted:YES];
                    self.subGroupIndex = index;
                }
            }
                break;
            default:
                break;
        }
	
	[tblDetils reloadData];
}
#pragma mark - New implementation
-(void)backButtonProcedure
{
	GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
	[self removeDataFromDict];
	global.dictMyAddressBook = nil;
	
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)cancelButtonProcedure
{
	// delete all data from global.dict
	[self removeDataFromDict];
	
	if (self.editMyAddObj)
	{
		// its for editing so need to have prior dict back
		GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
		[global.dictMyAddressBook addEntriesFromDictionary:[self createDictForEditing]];
	}
	[tblDetils reloadData];
}


-(NSDictionary *)createAllAddressBook
{
	NSMutableDictionary * dictEdit = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[dictEdit setValue:self.editMyAddObj.prefix		forKey:kAddNewContact_Prefix];
	[dictEdit setValue:self.editMyAddObj.salutation forKey:kAddNewContact_Salutation];
	[dictEdit setValue:self.editMyAddObj.firstName	forKey:k_TextFiled_FirstName];
	[dictEdit setValue:self.editMyAddObj.middleName forKey:k_TextFiled_MiddleName];
	[dictEdit setValue:self.editMyAddObj.lastName	forKey:k_TextFiled_LastName];
	[dictEdit setValue:self.editMyAddObj.suffix		forKey:k_TextFiled_Suffix];
	
	//Gender
	NSString * gender = self.editMyAddObj.gender;
	
	if ([gender length])
	{
		if ([gender rangeOfString:@"female" options:NSCaseInsensitiveSearch].length)
		{
			[dictEdit setValue:@"10" forKey:kAddNewContact_Gender];
		}else
		{
			[dictEdit setValue:@"11" forKey:kAddNewContact_Gender];
		}
	}
	//--
	[dictEdit setValue:self.editMyAddObj.image forKey:kAddNewContact_Image];					//Image
	
	//date of birth
	
	NSString * strDate = [NSDateFormatter localizedStringFromDate:self.editMyAddObj.birthDay
														dateStyle:NSDateFormatterFullStyle
														timeStyle:NSDateFormatterNoStyle];
	[dictEdit setValue:strDate forKey:kAddNewContact_DOB];
	//--
	
	//Email
	{
		[dictEdit setObject:[AddEditContactHelper setEmailsInDict:self.editMyAddObj] forKey:EMAIL_STRING];
	}
	
	//Address
	{
		
		AllAddress * address = [AddEditContactHelper getWorkAddress:self.editMyAddObj];
        
		if (address)
		{
			[dictEdit setValue:address.street forKey:k_TextFiled_Address];
			[dictEdit setValue:address.city forKey:k_TextFiled_City];
			[dictEdit setValue:address.state forKey:k_TextFiled_State];
			[dictEdit setValue:address.countryCode forKey:k_TextFiled_Country];
			[dictEdit setValue:address.zipCode forKey:k_TextFiled_ZipCode];
            [dictEdit setValue:address.addressType forKey:ADDRESS_TYPE_STRING];
		}
        
	}
	//--
	
	//Phone
	{
		[dictEdit setObject:[AddEditContactHelper setPhoneNumbers:self.editMyAddObj] forKey:PHONE_STRING];
	}
	//--
	
	
	/*Company info*/
	
	[dictEdit setValue:self.editMyAddObj.organisation			forKey:k_TextFiled_CompanyName];//CompanyName
	[dictEdit setValue:self.editMyAddObj.jobTitle				forKey:k_TextFiled_Title];//Title
	[dictEdit setValue:self.editMyAddObj.industry				forKey:kAddNewContact_Industry];//industry
	[dictEdit setValue:self.editMyAddObj.industryDescription	forKey:k_TextFiled_IndustryDes];//industry desc
	
	//Url
	{
        
        [dictEdit setObject:[AddEditContactHelper setURLInDict:self.editMyAddObj] forKey:URL_STRING];
        
	}
	//--
	
	/*Profile info*/
	[dictEdit setValue:self.editMyAddObj.groupName			forKey:kAddNewContact_AddGroup];			//group
	[dictEdit setValue:self.editMyAddObj.subGroupName		forKey:kAddNewContact_AddSubGroup];			//Subgroup
	
	//Funnal stage
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stageID == %@",self.editMyAddObj.funnelStageID];
	
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
	
	if ([array count])
	{
		FunnelStageList * funnalStage = [array lastObject];
		[dictEdit setValue:funnalStage.stageName forKey:kAddNewContact_FunnelStage];
	}
	
	//--
	
	[dictEdit setValue:self.editMyAddObj.leadStatus			forKey:kAddNewContact_LeadStatus];//Lead Status
	[dictEdit setValue:self.editMyAddObj.leadSource			forKey:kAddNewContact_LeadSource];//Lead source
	[dictEdit setValue:self.editMyAddObj.funnelDescription	forKey:k_TextFiled_FunnelDesc];//Funnel desc
	[dictEdit setValue:self.editMyAddObj.facebook			forKey:k_TextFiled_Facebook];//Facebook
	[dictEdit setValue:self.editMyAddObj.twitter			forKey:k_TextFiled_Twitter];//Twitter
	[dictEdit setValue:self.editMyAddObj.linkedin			forKey:k_TextFiled_Linkedin];//LinkedIn
	[dictEdit setValue:self.editMyAddObj.googlePlus			forKey:k_TextFiled_Google];//Google+
	[dictEdit setValue:self.editMyAddObj.scoring			forKey:k_TextFiled_Scoring];//Scoring
	[dictEdit setValue:self.editMyAddObj.note				forKey:k_TextFiled_Note];//Notes
    
	return dictEdit;
}

//---------------------Prakhar Editing Ends
-(NSDictionary *)createDictForEditing
{
	NSMutableDictionary * dictEdit = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[dictEdit setValue:self.editMyAddObj.prefix		forKey:kAddNewContact_Prefix];
	[dictEdit setValue:self.editMyAddObj.salutation forKey:kAddNewContact_Salutation];
	[dictEdit setValue:self.editMyAddObj.firstName	forKey:k_TextFiled_FirstName];
	[dictEdit setValue:self.editMyAddObj.middleName forKey:k_TextFiled_MiddleName];
	[dictEdit setValue:self.editMyAddObj.lastName	forKey:k_TextFiled_LastName];
	[dictEdit setValue:self.editMyAddObj.suffix		forKey:k_TextFiled_Suffix];
	
	//Gender
	NSString * gender = self.editMyAddObj.gender;
	
	if ([gender length])
	{
		if ([gender rangeOfString:@"female" options:NSCaseInsensitiveSearch].length)
		{
			[dictEdit setValue:@"10" forKey:kAddNewContact_Gender];
		}else
		{
			[dictEdit setValue:@"11" forKey:kAddNewContact_Gender];
		}
	}
	//--
	[dictEdit setValue:self.editMyAddObj.image forKey:kAddNewContact_Image];					//Image
	
	//date of birth
	
	NSString * strDate = [NSDateFormatter localizedStringFromDate:self.editMyAddObj.birthDay
														dateStyle:NSDateFormatterFullStyle
														timeStyle:NSDateFormatterNoStyle];
	[dictEdit setValue:strDate forKey:kAddNewContact_DOB];
	//--
	
	//Email
	{
		[dictEdit addEntriesFromDictionary:[AddEditContactHelper setEmailsInDict:self.editMyAddObj]];
	}
	
	//Address
	{
		
		AllAddress * address = [AddEditContactHelper getWorkAddress:self.editMyAddObj];
			
		if (address)
		{
			[dictEdit setValue:address.street forKey:k_TextFiled_Address];
			[dictEdit setValue:address.city forKey:k_TextFiled_City];
			[dictEdit setValue:address.state forKey:k_TextFiled_State];
			[dictEdit setValue:address.countryCode forKey:k_TextFiled_Country];
			[dictEdit setValue:address.zipCode forKey:k_TextFiled_ZipCode];
		}
			
	}
	//--
	
	//Phone
	{
		[dictEdit addEntriesFromDictionary:[AddEditContactHelper setPhoneNumbers:self.editMyAddObj]];
	}
	//--
	
	
	/*Company info*/
	
	[dictEdit setValue:self.editMyAddObj.organisation			forKey:k_TextFiled_CompanyName];//CompanyName
	[dictEdit setValue:self.editMyAddObj.jobTitle				forKey:k_TextFiled_Title];//Title
	[dictEdit setValue:self.editMyAddObj.industry				forKey:kAddNewContact_Industry];//industry
	[dictEdit setValue:self.editMyAddObj.industryDescription	forKey:k_TextFiled_IndustryDes];//industry desc
	
	//Url
	{
        
       [dictEdit addEntriesFromDictionary:[AddEditContactHelper setURLInDict:self.editMyAddObj]];
        
	}
	//--
	
	/*Profile info*/
	[dictEdit setValue:self.editMyAddObj.groupName			forKey:kAddNewContact_AddGroup];			//group
	[dictEdit setValue:self.editMyAddObj.subGroupName		forKey:kAddNewContact_AddSubGroup];			//Subgroup
	
	//Funnal stage
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stageID == %@",self.editMyAddObj.funnelStageID];
	
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
	
	if ([array count])
	{
		FunnelStageList * funnalStage = [array lastObject];
		[dictEdit setValue:funnalStage.stageName forKey:kAddNewContact_FunnelStage];
	}
	
	//--
	
	[dictEdit setValue:self.editMyAddObj.leadStatus			forKey:kAddNewContact_LeadStatus];//Lead Status
	[dictEdit setValue:self.editMyAddObj.leadSource			forKey:kAddNewContact_LeadSource];//Lead source
	[dictEdit setValue:self.editMyAddObj.funnelDescription	forKey:k_TextFiled_FunnelDesc];//Funnel desc
	[dictEdit setValue:self.editMyAddObj.facebook			forKey:k_TextFiled_Facebook];//Facebook
	[dictEdit setValue:self.editMyAddObj.twitter			forKey:k_TextFiled_Twitter];//Twitter
	[dictEdit setValue:self.editMyAddObj.linkedin			forKey:k_TextFiled_Linkedin];//LinkedIn
	[dictEdit setValue:self.editMyAddObj.googlePlus			forKey:k_TextFiled_Google];//Google+
	[dictEdit setValue:self.editMyAddObj.scoring			forKey:k_TextFiled_Scoring];//Scoring
	[dictEdit setValue:self.editMyAddObj.note				forKey:k_TextFiled_Note];//Notes

	return dictEdit;
}


-(void)saveDatainDataBase
{
	
	//save fresh data / saving new user in database
    GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
    /******** remove empty strings from data dictinalry****************/
    NSMutableDictionary *nonEmptyDict = [[NSMutableDictionary alloc] init];
    for (NSString *aKey in [global.dictMyAddressBook allKeys])
    {
        NSString *aValue = [global.dictMyAddressBook objectForKey:aKey];
        
        if ([aValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
        {
            [nonEmptyDict setObject:aValue forKey:aKey];
        }
    }
    //---
    [global setDictMyAddressBook:nonEmptyDict];
    [nonEmptyDict release];
	AppDelegate * appDelegate = CRM_AppDelegate;
	
	
	if ([[global.dictMyAddressBook allKeys] count])
	{
		MyAddressBook * addressBook = nil;
		
		if (self.editMyAddObj)
		{
			addressBook = self.editMyAddObj;
		}
		else
		{
			addressBook = [NSEntityDescription insertNewObjectForEntityForName:@"MyAddressBook" inManagedObjectContext:appDelegate.managedObjectContext];
			
			//as it is a new record so we need to insert new recordID
			
			[addressBook setRecordID:[self getRandomAlphanumericString]];
		}
		[addressBook setPrefix:[global.dictMyAddressBook valueForKey:kAddNewContact_Prefix]];						//Prefix
		[addressBook setSalutation:[global.dictMyAddressBook valueForKey:kAddNewContact_Salutation]];			//Salutation
		[addressBook setFirstName:[global.dictMyAddressBook valueForKey:k_TextFiled_FirstName]];				//First name
		[addressBook setMiddleName:[global.dictMyAddressBook valueForKey:k_TextFiled_MiddleName]];				//Middle name
		[addressBook setLastName:[global.dictMyAddressBook valueForKey:k_TextFiled_LastName]];					//Last name
		[addressBook setSuffix:[global.dictMyAddressBook valueForKey:k_TextFiled_Suffix]];					//Suffix
		
		//Gender
		NSString * gender = [global.dictMyAddressBook valueForKey:kAddNewContact_Gender];
		
		if ([gender length])
		{
			if ([gender isEqualToString:@"10"])
			{
				[addressBook setGender:@"female"];
			}else
			{
				[addressBook setGender:@"male"];
			}
		}
		
		//--
		
		[addressBook setImage:[global.dictMyAddressBook valueForKey:kAddNewContact_Image]];					//Image
		
		//date of birth
		NSString *dateString = [global.dictMyAddressBook valueForKey:kAddNewContact_DOB];
        
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateStyle:NSDateFormatterFullStyle];
        NSDate * dateFromString = [DateFormatter dateFromString:dateString];
        
		
		/*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"EEEE, MMMM dd, yyyy"];*/
		
	
		
		
		[addressBook setBirthDay:dateFromString];
		
//		[dateFormatter release];
        [DateFormatter release];
		//--
		
        
        
    
        /*
        
		//Email
		AllEmail * emails = nil;
		
		if (self.editMyAddObj && [[self.editMyAddObj.relEmails allObjects] count])
		{

			emails =  [AddEditContactHelper getWorkEmail:self.editMyAddObj];
		}
		else
		{
			emails = [NSEntityDescription insertNewObjectForEntityForName:@"AllEmail"
												   inManagedObjectContext:appDelegate.managedObjectContext];
		}
		
        
        
		[emails setEmailURL:[global.dictMyAddressBook valueForKey:k_TextFiled_Email]];
        
		[emails setRelMyAddressBook:addressBook];
		
		
		//--
		
		//Address
		{
			AllAddress * address = nil;
			
			//if editing object has any data and if addeditcontactHelper return nil..
			if (self.editMyAddObj && [AddEditContactHelper getWorkAddress:self.editMyAddObj])
			{
				address = [AddEditContactHelper getWorkAddress:self.editMyAddObj];
			}
			else
			{
				address = [NSEntityDescription insertNewObjectForEntityForName:@"AllAddress" inManagedObjectContext:appDelegate.managedObjectContext];
			}
			
			//Street
			
			NSString * FirstAdd = [global.dictMyAddressBook valueForKey:k_TextFiled_Address];
			NSString * SecondAdd = [global.dictMyAddressBook valueForKey:k_TextFiled_Address2];
			
			NSString * streetData = [NSString stringWithFormat:@"%@ %@",(FirstAdd)?(FirstAdd):@"",(SecondAdd)?(SecondAdd):@""];
			NSString *FN = ([global.dictMyAddressBook objectForKey:k_TextFiled_FirstName])?[global.dictMyAddressBook objectForKey:k_TextFiled_FirstName]:@"";
            NSString *LN = ([global.dictMyAddressBook objectForKey:k_TextFiled_LastName])?[global.dictMyAddressBook objectForKey:k_TextFiled_LastName]:@"";
            NSString *personName = [FN stringByAppendingFormat:@" %@",LN];
			[address setPersonName:personName];
			[address setStreet:([streetData stringByReplacingOccurrencesOfString:@" " withString:@""]).length?(streetData):nil];
			[address setCity:[global.dictMyAddressBook valueForKey:k_TextFiled_City]];					//city
			[address setState:[global.dictMyAddressBook valueForKey:k_TextFiled_State]];					//state
			[address setCountryCode:[global.dictMyAddressBook valueForKey:k_TextFiled_Country]];			//Country
			[address setZipCode:[global.dictMyAddressBook valueForKey:k_TextFiled_ZipCode]];			//Zip code
			
			
			if ([self checkNetworkConnection])
            {
               
                CLLocationCoordinate2D location = [self addressLocation:[self getAddressString:address]];
                [address setLatitude:[NSString stringWithFormat:@"%f",location.latitude]];
                [address setLongitude:[NSString stringWithFormat:@"%f",location.longitude]];
            }
			
			[address setRelMyAddressBook:addressBook];
			
			
			
		}
		//--
		
		//Phone
		{
			if (self.editMyAddObj)//we are edit mode
			{
                [AddEditContactHelper editPhoneNumber:self.editMyAddObj andMainDict:global.dictMyAddressBook andManageObjContext:appDelegate.managedObjectContext];
			}
			else
			{
                //As here we are making a new contact so we neeed not to worry abt any thing
                //just create new phone objects
                //insert single value(dict value) in single object
                
                //these loop is for 4 phone keys available
//                for (int i = 0 ; i < 4; i++)
//                {
                    //if we have any field available create a new object and insert related data into it
                    //and insert.

                AllPhone * phone = [NSEntityDescription insertNewObjectForEntityForName:@"AllPhone" inManagedObjectContext:appDelegate.managedObjectContext];
                
                [phone setPhoneNumber:
                 [global.dictMyAddressBook valueForKey:k_TextFiled_PhoneNum]];				//Phone number
                
                //Insert PhoneTitle ?
                
                [phone setRelMyAddressBook:addressBook];
                
                
                
                
//                }
//				phone = [NSEntityDescription insertNewObjectForEntityForName:@"AllPhone" inManagedObjectContext:appDelegate.managedObjectContext];
			}
			
//			[phone setPhone:[global.dictMyAddressBook valueForKey:k_TextFiled_PhoneNum]];				//Phone number
//			[phone setMobile:[global.dictMyAddressBook valueForKey:k_TextFiled_MobileNum]];				//Mobile number
//			[phone setHome:[global.dictMyAddressBook valueForKey:k_TextFiled_HomeNum]];					//Home number
//			[phone setWorkFax:[global.dictMyAddressBook valueForKey:k_TextFiled_FaxNum]];				//Fax number
//			
//			[phone setRelMyAddressBook:addressBook];
			
		}
		//--
		
		
		
		
		//url
		{
			AllUrl * url = nil;
			if (self.editMyAddObj && [[self.editMyAddObj.relAllUrl allObjects] count])
			{
					url = [[self.editMyAddObj.relAllUrl allObjects] objectAtIndex:0];
			}
			else
			{
				url = [NSEntityDescription insertNewObjectForEntityForName:@"AllUrl" inManagedObjectContext:appDelegate.managedObjectContext];
			}
			
			
			[url setWorkUrl:[global.dictMyAddressBook valueForKey:k_TextFiled_URL]];
			
			[url setRelMyAddressBook:addressBook];
		}
		*/
        
        //url
        // only edit existing contact
		{
			AllUrl * url = nil;
			if (self.editMyAddObj && [[self.editMyAddObj.relAllUrl allObjects] count])
			{
                NSDictionary *allURL = [self.dictDetailTitle objectForKey:URL_STRING];
                NSArray *allKeys = [allURL allKeys];
                NSArray *allValues = [allURL allValues];
                
                for(int i=0; i<[allKeys count]; i++)
                {
                    url = [[self.editMyAddObj.relAllUrl allObjects] objectAtIndex:i];
                    [url setUrlAddress:[allValues objectAtIndex:i]];
                    [url setUrlTitle:[allKeys objectAtIndex:i]];
                    
                    [url setRelMyAddressBook:addressBook];
                }
                
			}
			else
			{
				url = [NSEntityDescription insertNewObjectForEntityForName:@"AllUrl" inManagedObjectContext:appDelegate.managedObjectContext];
			}
		}
        
        /*
         
         if ([[dict objectForKey:kDETAILSTITLE] isEqualToString:ADDRESS_STRING]){
         NSDictionary *tempDict = [self.dictDetailTitle objectForKey:ADDRESS_STRING];
         NSArray *allAddressType = [tempDict allKeys];
         
         
         
         
         NSMutableArray *allcity = [NSMutableArray array];
         NSMutableArray *allcountry = [NSMutableArray array];
         NSMutableArray *allstate = [NSMutableArray array];
         NSMutableArray *allstreet = [NSMutableArray array];
         NSMutableArray *allzip = [NSMutableArray array];
         for(NSString *aKey in allAddressType){
         NSArray *currentAddress = [tempDict objectForKey:aKey];
         NSString *street = [currentAddress valueForKey:STREET_STRING];
         NSString *city = [currentAddress valueForKey:CITY_STRING];
         NSString *state = [currentAddress valueForKey:STATE_STRING];
         NSString *zip = [currentAddress valueForKey:ZIP_STRING];
         NSString *country = [currentAddress valueForKey:COUNTRY_STRING];
         [allcity addObject:city];
         [allcountry addObject:country];
         [allstate addObject:state];
         [allzip addObject:zip];
         [allstreet addObject:street];
         
         }
         
         
         [self.addressType setText:[allAddressType objectAtIndex:indexPathForCell.row]];
         [self.addressCity setText:[allcity objectAtIndex:indexPathForCell.row]];
         [self.addressCountry setText:[allcountry objectAtIndex:indexPathForCell.row]];
         [self.addressState setText:[allstate objectAtIndex:indexPathForCell.row]];
         [self.addressStreet setText:[allstreet objectAtIndex:indexPathForCell.row]];
         [self.addressZip setText:[allzip objectAtIndex:indexPathForCell.row]];
         
         }
         
         */
        //Address
        //only edit exixting contact
        {
            AllAddress *address = nil;
            if(self.editMyAddObj && [[self.editMyAddObj.relAllAddress allObjects] count]){
                NSDictionary *tempDict = [self.dictDetailTitle objectForKey:ADDRESS_STRING];
                NSArray *allAddressType = [tempDict allKeys];
                
                NSMutableArray *allcity = [NSMutableArray array];
                NSMutableArray *allcountry = [NSMutableArray array];
                NSMutableArray *allstate = [NSMutableArray array];
                NSMutableArray *allstreet = [NSMutableArray array];
                NSMutableArray *allzip = [NSMutableArray array];

                for(NSString *aKey in allAddressType){
                    NSArray *currentAddress = [tempDict objectForKey:aKey];
                    NSString *street = [currentAddress valueForKey:STREET_STRING];
                    NSString *city = [currentAddress valueForKey:CITY_STRING];
                    NSString *state = [currentAddress valueForKey:STATE_STRING];
                    NSString *zip = [currentAddress valueForKey:ZIP_STRING];
                    NSString *country = [currentAddress valueForKey:COUNTRY_STRING];
                    [allcity addObject:city];
                    [allcountry addObject:country];
                    [allstate addObject:state];
                    [allzip addObject:zip];
                    [allstreet addObject:street];
                    
                }
                
                for(int i=0; i<[allAddressType count]; i++)
                {
                    address = [[self.editMyAddObj.relAllAddress allObjects] objectAtIndex:i];
                    
                    [address setAddressType:[allAddressType objectAtIndex:i]];
                    [address setCity:[allcity objectAtIndex:i]];
                    [address setCountryCode:[allcountry objectAtIndex:i]];
                    [address setState:[allstate objectAtIndex:i]];
                    [address setStreet:[allstreet objectAtIndex:i]];
                    [address setZipCode:[allzip objectAtIndex:i]];
                    
                    [address setRelMyAddressBook:addressBook];
                }
                
            }
        }
        
        
        
        //phone
        //only edit existing contact
        {
			AllPhone * phone = nil;
			if (self.editMyAddObj && [[self.editMyAddObj.relAllPhone allObjects] count])
			{
                NSDictionary *allPhone = [self.dictDetailTitle objectForKey:PHONE_STRING];
                NSArray *allKeys = [allPhone allKeys];
                NSArray *allValues = [allPhone allValues];
                
                for(int i=0; i<[allKeys count]; i++)
                {
                    phone = [[self.editMyAddObj.relAllPhone allObjects] objectAtIndex:i];
                    [phone setPhoneNumber:[allValues objectAtIndex:i]];
                    [phone setPhoneTitle:[allKeys objectAtIndex:i]];
                    
                    [phone setRelMyAddressBook:addressBook];
                }
                
			}
			else
			{
				phone = [NSEntityDescription insertNewObjectForEntityForName:@"AllPhone" inManagedObjectContext:appDelegate.managedObjectContext];
			}
		}
        //Email
        //only edit exixting contact
        {
			AllEmail * email = nil;
			if (self.editMyAddObj && [[self.editMyAddObj.relEmails allObjects] count])
			{
                NSDictionary *allEmail = [self.dictDetailTitle objectForKey:EMAIL_STRING];
                NSArray *allKeys = [allEmail allKeys];
                NSArray *allValues = [allEmail allValues];
                
                for(int i=0; i<[allKeys count]; i++)
                {
                    email = [[self.editMyAddObj.relEmails allObjects] objectAtIndex:i];
                    [email setEmailURL:[allValues objectAtIndex:i]];
                    [email setEmailTitle:[allKeys objectAtIndex:i]];
                    
                    [email setRelMyAddressBook:addressBook];
                }
                
			}
			else
			{
				email = [NSEntityDescription insertNewObjectForEntityForName:@"AllEmail" inManagedObjectContext:appDelegate.managedObjectContext];
			}
		}
    
        
        
		[addressBook setOrganisation:[global.dictMyAddressBook valueForKey:k_TextFiled_CompanyName]];		//CompanyName
		[addressBook setJobTitle:[global.dictMyAddressBook valueForKey:k_TextFiled_Title]];					//Title
		[addressBook setIndustry:[global.dictMyAddressBook valueForKey:kAddNewContact_Industry]];			//industry
		[addressBook setIndustryDescription:[global.dictMyAddressBook valueForKey:k_TextFiled_IndustryDes]];//industry desc
        
        
		/*Profile info*/
		
		[addressBook setGroupName:[global.dictMyAddressBook valueForKey:kAddNewContact_AddGroup]];			//Group
		[addressBook setSubGroupName:[global.dictMyAddressBook valueForKey:kAddNewContact_AddSubGroup]];	//SubGroup
		
	/*	//Funnal stage
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stageName == %@",[global.dictMyAddressBook valueForKey:kAddNewContact_FunnelStage]];
		
		NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:appDelegate.managedObjectContext];
		
		if ([array count])
		{
			FunnelStageList * funnalStage = [array lastObject];
			[addressBook setFunnelStageID:funnalStage.stageID];
		}*/
		
		//--
		
		[addressBook setLeadStatus:[global.dictMyAddressBook valueForKey:kAddNewContact_LeadStatus]];		//Lead Status
		[addressBook setLeadSource:[global.dictMyAddressBook valueForKey:kAddNewContact_LeadSource]];		//Lead source
		[addressBook setFunnelDescription:[global.dictMyAddressBook valueForKey:k_TextFiled_FunnelDesc]];	//Funnel desc
		[addressBook setFacebook:[global.dictMyAddressBook valueForKey:k_TextFiled_Facebook]];				//Facebook
		[addressBook setTwitter:[global.dictMyAddressBook valueForKey:k_TextFiled_Twitter]];				//Twitter
		[addressBook setLinkedin:[global.dictMyAddressBook valueForKey:k_TextFiled_Linkedin]];				//LinkedIn
		[addressBook setGooglePlus:[global.dictMyAddressBook valueForKey:k_TextFiled_Google]];				//Google+
		[addressBook setScoring:[global.dictMyAddressBook valueForKey:k_TextFiled_Scoring]];				//Scoring
		[addressBook setNote:[global.dictMyAddressBook valueForKey:k_TextFiled_Note]];						//Notes
		
		if ([self isContainsObject:addressBook])
		{
            if ([appDelegate.managedObjectContext save:nil] && self.editMyAddObj == nil)
            {
                UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Saved successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                [anAlertView setTag:1001];
                [anAlertView show];
                [anAlertView release];
            }
            else if ([appDelegate.managedObjectContext save:nil] && self.editMyAddObj != nil && global.isContactEditted)
            {
                UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Updated successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                [anAlertView setTag:1001];
                [anAlertView show];
                [anAlertView release];
            }
            else
            {
                [self backToContactList];
            }
            
			
		}
	}
    else
    {
		UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Need to input information before selecting done" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
		
		[anAlertView show];
		[anAlertView release];
	}
}
//Method: Remove data on click cancel or click back
-(void)textFiledDidBeginEditingWithField:(UITextField*)textFiled
{
//  NOTICE : Do not release this text field.
//    UITextField *aTextF = [[UITextField alloc]init];
//    aTextF = textFiled;
    self.currentField = textFiled;
    [self setContentOffsetOfTableView];
}
-(void)removeDataFromDict
{
	GlobalDataPersistence * global = [GlobalDataPersistence sharedGlobalDataPersistence];
	[global.dictMyAddressBook removeAllObjects];
	
}


@end
