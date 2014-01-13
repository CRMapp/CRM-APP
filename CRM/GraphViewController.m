//
//  GraphViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 04/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#define KEYTOTAL @"total"

#define kHeightSectionHeader 40

#import "GraphViewController.h"
#import "FunnelTVCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Industries.h"
//#import "AppDelegate.h"
//#import "CoreDataHelper.h"
#import "FunnelStageList.h"
#import "MyAddressBook.h"
#import "DateUtility.h"
#import "TouchView.h"

#import <MapKit/MapKit.h>

#import "AllAddress.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "ContactDetailViewController.h"
@interface GraphViewController ()
{
	// to refresh the selected button
	int lastSelected;
}

@end

@implementation GraphViewController

@synthesize dropDownViewInGraph;
@synthesize popoverView;
@synthesize mArrayFunnelItems;
@synthesize editItemTag;
@synthesize lastIndexpath;
@synthesize arrayIndustry;
@synthesize popoverIndustry;
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
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] insertIndusrtiesInDatabase];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertFunnelStageList];
    
	for (UIView * viewForBorder in self.view.subviews)
	{
		if (viewForBorder.tag == 100) {
			[viewForBorder.layer setBorderColor:[UIColor lightGrayColor].CGColor];
			[viewForBorder.layer setBorderWidth:1.0];
		}
	}
	lastSelected = 15;
	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    isFilterSearch = NO;
    isNewSearch = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
	int oriantation = 0;
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
	{
		oriantation = 3;
	}
	if(btnFunnelFilter.selected == NO)
    {
        [vwFilterView removeFromSuperview];
        [self removeTouchView];
		[self resetAllFilterTextField];
    }
    
	[self setSelectedOptionButtonWithTag:lastSelected];
	[self setUIAccordingToOriantation:oriantation];
	
	[self generateGraph];
	[super viewWillAppear:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
//    int oriantation = 0;
	
    UIInterfaceOrientation oriantation = [[UIApplication sharedApplication]statusBarOrientation];
//	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
//	{
//		oriantation = 3;
//	}
	if(btnFunnelFilter.selected == NO)
    {
        [vwFilterView removeFromSuperview];
        [self removeTouchView];
		[self resetAllFilterTextField];
    }
    
	[self setSelectedOptionButtonWithTag:lastSelected];
	[self setUIAccordingToOriantation:oriantation];
}
-(void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLayout" object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
	[[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
	
	[super viewWillDisappear:NO];
}
-(void)dealloc
{

    [txtIndustrySearch release];
    [tableIndustry release];
    [vwIndustrySearch release];
    [arrayIndustry release];
    [popoverIndustry release];
    
	[dropDownViewInGraph release];
	dropDownViewInGraph = nil;
	[popoverView release];
	popoverView = nil;
	[mArrayFunnelItems release];
	[vwLandscape release];
	[vwPortrate release];
	[tableDetails release];
    [vwGraph release];
	[lblNoData release];
	
    [vwFilterView release];
	[switchProposal release];
	[btnFunnelFilter release];
	[txtRestrictDistance release];
	[txtFromLocation release];
    [lblLastContactedDays release];
    [view_header release];
	[super dealloc];
}

#pragma mark - Change layouts as per orientation
-(void)changeLayout:(NSNotification*)info
{
    NSDictionary *themeInfo     =   [info userInfo];
    int orientation = [[themeInfo objectForKey:@"kOrientation"] intValue];
	[self setUIAccordingToOriantation:orientation];
	
	//hide vwFilter
    if (vwFilterView.superview)
    {
        [self HideAnimmation];
    }
	
}
-(void)setUIAccordingToOriantation:(int)oriantation
{
	if (self.popoverView)
	{
		[self.popoverView dismissPopoverAnimated:YES];
	}
	
	if (oriantation <= 2)
	{
		//Portrate
		[vwLandscape setHidden:YES];
		[vwPortrate setHidden:NO];
	}
	else 
	{
		//Landscape
		[vwLandscape setHidden:NO];
		[vwPortrate setHidden:YES];
	}
	
	[self performSelector:@selector(generateGraph) withObject:nil afterDelay:0.3];
}
- (void)viewDidUnload {
	
	
	[vwLandscape release];
	vwLandscape = nil;
	[vwPortrate release];
	vwPortrate = nil;
	[tableDetails release];
	tableDetails = nil;
    [vwGraph release];
    vwGraph = nil;
	[lblNoData release];
	lblNoData = nil;
    [vwFilterView release];
    vwFilterView = nil;
	[switchProposal release];
	switchProposal = nil;

	[btnFunnelFilter release];
	btnFunnelFilter = nil;
	[txtRestrictDistance release];
	txtRestrictDistance = nil;
	[txtFromLocation release];
	txtFromLocation = nil;
    [lblLastContactedDays release];
    lblLastContactedDays = nil;
    [view_header release];
    view_header = nil;
	[super viewDidUnload];
}
-(void)setDataInTableViewWithFunnelStageID:(int)stageID andPredicate:(NSPredicate*)nextPredicate
{
	lastSelected = stageID;
	[self.mArrayFunnelItems removeAllObjects];
	AppDelegate * aDelegate = CRM_AppDelegate;
    
	NSArray * arrayMy = nil;
	
	
//	if (stageID != 13)
	if (1)
    {
		//ignore this
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stageID == %d",stageID];
		
		NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        if ([array count] <= 1)
        {
            FunnelStageList * funnalStage = [array lastObject];
            predicate = [NSPredicate predicateWithFormat:@"funnelStageID contains[cd] %@",funnalStage.stageName];
        }
        else if([array count] >= 2)
        {
            FunnelStageList * funnalStage = [array objectAtIndex:0];
            
            FunnelStageList * funnalStage1 = [array objectAtIndex:1];
            
            predicate = [NSPredicate predicateWithFormat:@"funnelStageID contains[cd] %@ OR funnelStageID contains[cd] %@",funnalStage.stageName,funnalStage1.stageName];
        }
            
        	
		if (nextPredicate)
		{
			[btnFunnelFilter setSelected:YES];
			predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,nextPredicate, nil]];
		}
		
        arrayMy = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
	}
	else
	{
		
		
		NSArray * arrayMyAdd = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:nextPredicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
		
		NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:0];
		
		for (MyAddressBook * addressBookObj in arrayMyAdd)
		{
			NSArray * arrayProposal = [[addressBookObj relProposal] allObjects];
			
			for (ProposalList * proposalObj in arrayProposal)
			{
				[arrayM addObject:addressBookObj];
			}
		}
		
		arrayMy = [NSArray arrayWithArray:arrayM];
	}
	
	NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
	
	
	
	/*if (switchProposal.on)
	{
		
		// is switch is remain on that means that filter is applicable
		// So set funnel filter selected
		[btnFunnelFilter setSelected:YES];
		
		for (MyAddressBook * addressBookObj in arrayMy)
		{
			NSArray * arrayProposal = [[addressBookObj relProposal] allObjects];
			
			for (ProposalList * proposalObj in arrayProposal)
			{
				[mArray addObject:addressBookObj];
			}
		}
	}
	else */if ([txtFromLocation.text length] && [txtRestrictDistance.text length])
	{
		if([self checkNetworkConnection])
        {
            CLLocationCoordinate2D restrictLocation = [self addressLocation:txtFromLocation.text];
            
            for (MyAddressBook * myAdd in arrayMy)
            {
                for (AllAddress * address in [myAdd.relAllAddress allObjects])
                {
                    CLLocationCoordinate2D location ;
                    location.latitude = [address.latitude doubleValue];
                    location.longitude= [address.longitude doubleValue];
                    
                    CLLocation  * fromocation = [[[CLLocation alloc]initWithLatitude:restrictLocation.latitude longitude:restrictLocation.longitude] autorelease];
                    
                    CLLocation  * addBookuserLocation = [[[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude] autorelease];
                    
//                    CLLocationDistance Km = [addBookuserLocation distanceFromLocation:fromocation]/1000;
                    CLLocationDistance miles = [addBookuserLocation distanceFromLocation:fromocation]/1609.34;
                    
                    NSLog(@"Distance : %f",miles);
                    if (miles <= [txtRestrictDistance.text doubleValue])
                    {
                        NSLog(@"Distance got : %f",miles);
                        [mArray addObject:myAdd];
                        break;
                    }
                }
            }
        }
		
		
	}
	else
	{
		[mArray addObjectsFromArray:arrayMy];
	}
    
    if (isFilterSearch)
    {
        if ([txtFromLocation.text length] || [txtRestrictDistance.text length])
        {
            [btnFunnelFilter setSelected:YES];
            [self checkCustomerInOtherOptions:nextPredicate withArray:mArray];
        }
        else
        {
            [self checkCustomerInOtherOptions:nextPredicate withArray:nil];
        }
    }
	self.mArrayFunnelItems = [NSMutableArray arrayWithArray:mArray];
	
	[tableDetails reloadData];
}
#pragma mark - Check For Set Highlight Top Options
- (void)checkCustomerInOtherOptions:(NSPredicate*)nextPredicate withArray:(NSArray*)mArray//:(NSArray*)allContacts
{
//    NSArray* allContacts = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:nil andSortKey:nil andSortAscending:YES andContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]];
    
    NSPredicate *myPredicate = nil;
    
    NSString *message = nil;
    for (int i = 11; i <= 15; i++)
    {
//        if (lastSelected != i)
        {
            NSArray *searchArr = nil;
            
            myPredicate = [NSPredicate predicateWithFormat:@"stageID == %d",i];

            //----
			NSArray * array = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:myPredicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
//			FunnelStageList * funnalStage = [array lastObject];
            
            if ([array count] == 1)
            {
                FunnelStageList * funnalStage = [array lastObject];
                myPredicate = [NSPredicate predicateWithFormat:@"funnelStageID contains[cd] %@",funnalStage.stageName];
            }
            else if([array count] == 2)
            {
                FunnelStageList * funnalStage = [array objectAtIndex:0];
                
                FunnelStageList * funnalStage1 = [array objectAtIndex:1];
                
                myPredicate = [NSPredicate predicateWithFormat:@"funnelStageID contains[cd] %@ OR funnelStageID contains[cd] %@",funnalStage.stageName,funnalStage1.stageName];
            }
			if (nextPredicate)
            {
                myPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:myPredicate,nextPredicate, nil]];
            }
//			myPredicate = [NSPredicate predicateWithFormat:@"funnelStageID contains[cd] %@",funnalStage.stageName];
			//----

            
//            searchArr = [allContacts filteredArrayUsingPredicate:myPredicate];
            searchArr = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:myPredicate andSortKey:nil andSortAscending:YES andContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]];
            
            NSMutableArray *tempArr = [NSMutableArray array];
            if (mArray)
            {
                for (MyAddressBook *myAdd in mArray)
                {
                    if ([searchArr containsObject:myAdd])
                    {
                        [tempArr addObject:myAdd];
                    }
                }
                searchArr = tempArr;
            }
            
            if ([searchArr count])
            {
//                myPredicate = [NSPredicate predicateWithFormat:@"stageID == %d",i];
//                NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:myPredicate andSortKey:nil andSortAscending:YES andContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]];
//				
//				FunnelStageList *aFunnel = [arrayFunnel lastObject];
                
				if(message == nil)
                {
                    message = @"Contact Found. Please check other Pipeline Stage buttons.";
                }
                [self setHighLightedOptionForStage:i withHighLightColor:[UIImage imageNamed:@"white-btn-highlt.png"]];
            }
            
        }
    }
    if (isNewSearch)
    {
        if(message)
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Success" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            //        [anAlertView setTag:1001];
            [anAlertView show];
            [anAlertView release];
        }
        else
        {
            for (int i = 11; i <= 15; i++)
            {
                [self setHighLightedOptionForStage:0 withHighLightColor:[UIImage imageNamed:@"white-btn.png"]];
            }
            message = @"No contact found with this criteria";
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            //        [anAlertView setTag:1001];
            [anAlertView show];
            [anAlertView release];
        }
        isNewSearch = NO;
    }
    
}
- (void)setHighLightedOptionForStage:(int)tag withHighLightColor:(UIImage*)image
{
    for (UIButton * btn in vwPortrate.subviews)
    {
        if ([btn isMemberOfClass:[UIButton class]])
        {
            if (btn.tag == tag)
            {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }
            else if (tag == 0)
            {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }
        }
        
    }
    
    for (UIButton * btn in vwLandscape.subviews)
    {
        if ([btn isMemberOfClass:[UIButton class]])
        {
            if (btn.tag == tag)
            {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }
            else if (tag == 0)
            {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
            }
        }
    }
}
-(void)resetAllFilterTextField
{
    
	for (id subViews in vwFilterView.subviews)
	{
		if ([subViews isKindOfClass:[UITextField class]])
		{
			UITextField * txtFilter = (UITextField*)subViews;
			[txtFilter setText:@""];
		}
		else if ([subViews isKindOfClass:[UIButton class]])
		{
			UIButton * btn = (UIButton*)subViews;
			[btn setSelected:NO];
		}
	}
	
	[switchProposal setOn:NO];
	
	// Set button as unselected
	[btnFunnelFilter setSelected:NO];
    
    isFilterSearch = NO;
    [self setHighLightedOptionForStage:0 withHighLightColor:[UIImage imageNamed:@"white-btn.png"]];
}

#pragma mark - VwFilter
- (void)removeTouchView
{
    for (UIView * vwremove in self.view.subviews)
	{
		if ([vwremove isKindOfClass:[TouchView class]])
		{
			[vwremove removeFromSuperview];
			break;
		}
	}
}
-(void)HideAnimmation
{
	[self removeTouchView];

	[UIView animateWithDuration:0.33 animations:^{
		
		[vwFilterView setAlpha:0.0];
				
	}
	completion:^ (BOOL finished){
//		 if (finished)
         {
			 [vwFilterView removeFromSuperview];
			 [vwFilterView setAlpha:1.0];

		 }
	 }];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1001 && buttonIndex == 0)
    {
        MyAddressBook *aContact = [self.mArrayFunnelItems objectAtIndex:self.editItemTag];
        
        aContact.funnelStageID = 0;
        
//        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aContact];
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
        
        int oriantation = 0;
        
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        {
            oriantation = 3;
        }
        
        
        [self setSelectedOptionButtonWithTag:lastSelected];
        [self setUIAccordingToOriantation:oriantation];
        
        [self generateGraph];
        
//        [self.mArrayFunnelItems removeObjectAtIndex:self.editItemTag];
        
        [tableDetails reloadData];
        
        if (btnFunnelFilter.selected)
        {
            isNewSearch = NO;
            [self setHighLightedOptionForStage:0 withHighLightColor:[UIImage imageNamed:@"white-btn.png"]];
            [self performSelector:@selector(checkCustomerInOtherOptions) withObject:nil afterDelay:0.01];
        }
        
    }
    
}

#pragma mark - Cell methods

- (void)deleteContact:(UIButton*)sender
{
    self.editItemTag = sender.tag;
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1001];
    [anAlertView show];
    [anAlertView release];
}
- (void)editContact:(UIButton*)sender
{
    MyAddressBook *myobj = [self.mArrayFunnelItems objectAtIndex:sender.tag];
    AddNewContactViewController * addNewVC = [[AddNewContactViewController alloc]initWithNibName:@"AddNewContactViewController" bundle:nil];
//    [addNewVC setADelegate:self];
    [addNewVC setEditMyAddObj:myobj];
	[self.navigationController pushViewController:addNewVC animated:YES];
	[addNewVC release];
}
- (void)btnCheckTapped:(UIButton*)sender
{
    
    if (self.lastIndexpath)
    {
        MyAddressBook *myAddLAst = [self.mArrayFunnelItems objectAtIndex:self.lastIndexpath.row];
        [myAddLAst setIsSelected:NO];
    }
    
    MyAddressBook *aContact= [self.mArrayFunnelItems objectAtIndex:sender.tag];
    
    
    
    NSDate *alastDate   = aContact.lastActivityDate;
    NSDate *today       = [NSDate date];
    
    if (alastDate == nil)
    {
        alastDate = aContact.creationDate;
    }
    int days = [[NSDate calculateDataAndTimeDeffrence:alastDate endDate:today] integerValue];
    
    NSLog(@"%d",days);
    
    if(sender.selected)
    {
        sender.selected = !sender.selected;
        aContact.isSelected = sender.selected;
        [lblLastContactedDays setText:@"-:-"];
    }
    else
    {
        if(days == 0)
            [lblLastContactedDays setText:@"Today"];
        if(days > 0)
            [lblLastContactedDays setText:[NSString stringWithFormat:@"%d",days]];
        sender.selected = !sender.selected;
        aContact.isSelected = sender.selected;
    }
    
    [self.mArrayFunnelItems replaceObjectAtIndex:sender.tag withObject:aContact];
    [tableDetails reloadData];
    
    self.lastIndexpath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
}
#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	//	self.currentField = nil;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == tableIndustry)
	{
		return [self.arrayIndustry count];
	}
	return [self.mArrayFunnelItems count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
		return cell;
	}

    MyAddressBook * myBook = [self.mArrayFunnelItems objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"FunnelTVCell";
    
    FunnelTVCell *cell = (FunnelTVCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil)
	{
		NSString *nibname = @"FunnelTVCell";
		NSArray *arrItems = [[NSBundle mainBundle]loadNibNamed:nibname owner:nil options:nil ];
		for (id object in arrItems)
		{
			if([object isKindOfClass:[FunnelTVCell class]])
			{
				cell = (FunnelTVCell *)object;
				break;
			}
		}
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [cell.btnChackMark setSelected:myBook.isSelected];
    
    [cell.btnDelete addTarget:self action:@selector(deleteContact:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDelete setTag:indexPath.row];
    
    [cell.btnEdittapped addTarget:self action:@selector(editContact:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEdittapped setTag:indexPath.row];
    
    [cell.btnChackMark addTarget:self action:@selector(btnCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnChackMark setTag:indexPath.row];
    
	
	[cell setDataInCell:myBook];

	
	
	return cell;
	
}
/* - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 
 }
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    if (tableView == tableIndustry)
    {
        [self.popoverIndustry dismissPopoverAnimated:YES];
        for (UITextField * textField in vwFilterView.subviews)
        {
            if ([textField isKindOfClass:[UITextField class]]) {
                if (textField.tag == 104)
                {
                    Industries * industryObj = [self.arrayIndustry objectAtIndex:indexPath.row];
                    [textField setText:[NSString stringWithFormat:@"%@",industryObj.industryName]];
                    break;
                }
            }
        }
    }
    else
    {
        MyAddressBook *aContact = [self.mArrayFunnelItems objectAtIndex:indexPath.row];
    //    if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(changeNavigationTitle)])
    //    {
    //        [self.aDelegate changeNavigationTitle];
    //    }
        ContactDetailViewController *obj = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
        [obj setAContactDetails:aContact];
        [self.navigationController pushViewController:obj animated:YES];
        [obj release];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    return 44;
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
	
	NSArray *array = [CoreDataHelper searchObjectsForEntity:@"Industries" withPredicate:predicate andSortKey:@"industryName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
	
	self.arrayIndustry = [NSMutableArray arrayWithArray:array];
	
	[tableIndustry reloadData];
}

#pragma mark - Graph
-(void)generateGraph
{
    
	// first set corner radius of grapView
	[vwGraph.layer setCornerRadius:18.0];
	[vwGraph.layer setMasksToBounds:YES];
	
	//reset all views in side viewGraph
    //	[[vwGraph subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	for (id subViews in vwGraph.subviews)
	{
		if (![subViews isKindOfClass:[UILabel class]])
		{
			[subViews removeFromSuperview];
		}
	}
	
	NSDictionary * dict = [[NSDictionary alloc]initWithDictionary:[self getGraphDetails]];
	
	int total = [[dict valueForKey:KEYTOTAL] intValue];
	
	//This for sorting puorpose
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
	for (NSString * key in dict.allKeys)
	{
		if (![key isEqualToString:KEYTOTAL]) {
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:key,@"Name", nil];
			[array addObject:dict];
		}
	}
	
	NSSortDescriptor * sorter = [NSSortDescriptor sortDescriptorWithKey:@"Name" ascending:NO];
	NSArray * sortedArra = [array sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
	
	//-----
	
	if (total == 0)
	{
		[lblNoData setHidden:NO];
		
		
		NSArray *arColor = @[[UIColor colorWithRed:240.0/255 green:125.0/255 blue:69.0/255 alpha:1],
					   [UIColor colorWithRed:246.0/255 green:206.0/255 blue:62.0/255 alpha:1],
					   [UIColor colorWithRed:80.0/255 green:176.0/255 blue:110.0/255 alpha:1],
					   [UIColor colorWithRed:55.0/255 green:129.0/255 blue:214.0/255 alpha:1],
					   [UIColor colorWithRed:144.0/255 green:238.0/255 blue:144.0/255 alpha:1]];
		
		for (int i = 0; i < [sortedArra count]; i++)
		{
			
			NSDictionary *dictForKey = [sortedArra objectAtIndex:i];
			
			NSString * key = [NSString stringWithFormat:@"%@",[dictForKey objectForKey:@"Name"]];
			
			UIView * viewTutorial = [self.view viewWithTag:151 + i];
			
			if ([viewTutorial isKindOfClass:[UIView class]])
			{
				[viewTutorial setBackgroundColor:[UIColor clearColor]];
				for (id viewsubs in viewTutorial.subviews)
				{
					if ([viewsubs isMemberOfClass:[UILabel class]])
					{
						
						UILabel * lbl = (UILabel*)viewsubs;
						
						[lbl setText:[[NSString stringWithFormat:@"%@",key] stringByReplacingOccurrencesOfString:@"Won" withString:@""]];
						
					}
					
					if ([viewsubs isMemberOfClass:[UIView class]])
					{
						[viewsubs setBackgroundColor:[arColor objectAtIndex:i]];
					}
				}
			}
		}
		
	}
    else
	{
		
		NSArray *arColor = @[[UIColor colorWithRed:240.0/255 green:125.0/255 blue:69.0/255 alpha:1],
                            [UIColor colorWithRed:246.0/255 green:206.0/255 blue:62.0/255 alpha:1],
                            [UIColor colorWithRed:80.0/255 green:176.0/255 blue:110.0/255 alpha:1],
                            [UIColor colorWithRed:55.0/255 green:129.0/255 blue:214.0/255 alpha:1],
                            [UIColor colorWithRed:144.0/255 green:238.0/255 blue:144.0/255 alpha:1]];
		
		[lblNoData setHidden:YES];
		// generate graph
		
		float priWidth = 0.0;
		
		
		for (int i = 0; i < [sortedArra count]; i++)
		{
			NSDictionary *dictForKey = [sortedArra objectAtIndex:i];
			
			NSString * key = [NSString stringWithFormat:@"%@",[dictForKey objectForKey:@"Name"]];
            //			NSLog(@" %@ key : %@ ",[dict valueForKey:key],key);
			
			
			{
				// width  = totalWidthOfView *(int(dict value)/ (dict total))
				float widthGrap = vwGraph.frame.size.width * ([[dict valueForKey:key] floatValue]/[[dict valueForKey:KEYTOTAL] floatValue]);
				
				UIView * viewG  = [[UIView alloc]initWithFrame:CGRectMake(priWidth, 0, widthGrap, vwGraph.frame.size.height)];
				[viewG setBackgroundColor:[arColor objectAtIndex:i]];
                
				UILabel * labelCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewG.frame.size.width, viewG.frame.size.height)];
				[labelCount setBackgroundColor:[UIColor clearColor]];
				[labelCount setTextAlignment:NSTextAlignmentCenter];
				[labelCount setText:[NSString stringWithFormat:@"%@",[dict valueForKeyPath:key]]];
				[labelCount setFont:[UIFont boldSystemFontOfSize:15]];
				
				[viewG addSubview:labelCount];
				[vwGraph addSubview:viewG];
				
				[labelCount release];
				[viewG release];
				priWidth = priWidth + widthGrap;
				
				
				// set Tutorial view
				UIView * viewTutorial = [self.view viewWithTag:151 + i];
				
				if ([viewTutorial isKindOfClass:[UIView class]])
				{
					[viewTutorial setBackgroundColor:[UIColor clearColor]];
					for (id viewsubs in viewTutorial.subviews)
					{
						if ([viewsubs isMemberOfClass:[UILabel class]])
						{
                            
							UILabel * lbl = (UILabel*)viewsubs;
							
							[lbl setText:[[NSString stringWithFormat:@"%@",key] stringByReplacingOccurrencesOfString:@"Won" withString:@""]];
							
						}
						
						if ([viewsubs isMemberOfClass:[UIView class]])
						{
							[viewsubs setBackgroundColor:[arColor objectAtIndex:i]];
						}
					}
				}
			}
			
		}
	}
	
	[dict release];
}
-(NSDictionary *)getDictDatForTesting
{
	
	AppDelegate *adelegate = CRM_AppDelegate;
	NSArray *array = [CoreDataHelper getObjectsForEntity:@"FunnelStageList" withSortKey:nil andSortAscending:NO andContext:[adelegate managedObjectContext]];
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
	
	NSArray * arryValue = @[@"10",@"15",@"30",@"40",@"5"];
	
	int total = 0;
	for (int i =0; i < [array count]; i++)
	{
		FunnelStageList * funlObj = [array objectAtIndex:i];
		
		[dict setValue:[arryValue objectAtIndex:i] forKey:[NSString stringWithString:funlObj.stageName]];
		total = total + [[arryValue objectAtIndex:i] intValue];
	}
	[dict setValue:[NSString stringWithFormat:@"%d",total] forKey:KEYTOTAL];
	return dict;
	
}
-(NSDictionary *)getGraphDetails
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
	
	AppDelegate *adelegate = CRM_AppDelegate;
	NSArray *array = [CoreDataHelper getObjectsForEntity:@"FunnelStageList" withSortKey:nil andSortAscending:NO andContext:[adelegate managedObjectContext]];
	
	int total = 0;
	
	for (int i =0; i < [array count]; i++)
	{
		FunnelStageList * funlObj = [array objectAtIndex:i];
        
        
        //as per the client requirement
		// we removed the proposal from graph calclation for phase 2 only
		if ([funlObj.stageID  isEqualToNumber:[NSNumber numberWithInt:13]])
		{
			continue;
		}
        
        
//		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ANY stageName contains d",[funlObj.stageName intValue]];

        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ANY funnelStageID CONTAINS[cd] %@",funlObj.stageName];
//		MyAddressBook
		NSArray * arrayMy = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:adelegate.managedObjectContext];

		[dict setValue:[NSString stringWithFormat:@"%d",[arrayMy count]] forKey:[NSString stringWithString:funlObj.stageName]];
		total = total + [arrayMy count];
	}
	
	
	//Set totle records
	[dict setValue:[NSString stringWithFormat:@"%d",total] forKey:KEYTOTAL];
	
	return dict;
}
#pragma mark - Network connection

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
#pragma mark - Get Latitude and Longitude
-(CLLocationCoordinate2D) addressLocation:(NSString *)searchedLocation
{
    //    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];http://maps.googleapis.com/maps/api/geocode/json?address=durgapura%2C%20jaipur&sensor=true
    
    
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
        
        return location;
		
	}
    else
    {
        location.latitude = latitude;
		location.longitude = longitude;
    }
    
    return location;
    
    
}
#pragma mark - IBActions
- (IBAction)btnIndustryTapped:(UIButton *)sender
{
    for (UITextField * textFiled in vwFilterView.subviews)
	{
		if ([textFiled isKindOfClass:[UITextField class]])
		{
			if ([textFiled isFirstResponder])
			{
				[textFiled resignFirstResponder];
				break;
			}
		}
	}

	if (!self.popoverIndustry) {
		
		UIViewController * controllerIndstry = [[UIViewController alloc]init];
		controllerIndstry.view = vwIndustrySearch;
		self.popoverIndustry = [[[UIPopoverController alloc]initWithContentViewController:controllerIndstry] autorelease];
		[self.popoverIndustry setPopoverContentSize:vwIndustrySearch.frame.size];
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
	
	[txtIndustrySearch resignFirstResponder];
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	[self.popoverIndustry presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnOptionTapped:(UIButton *)sender
{
//    if(btnFunnelFilter.selected)
//    [self btnResetFilter:nil];
    //Flurry
	NSString * string =  [NSString stringWithFormat:@"Graph Screen %@",sender.titleLabel.text];
	[AppDelegate setFlurryWithText:string];
    
    [lblLastContactedDays setText:@"-:-"];
    self.lastIndexpath = nil;
	[self setSelectedOptionButtonWithTag:sender.tag];
}

- (IBAction)btnFunnelFilterTapped:(UIButton*)sender
{
    //Flurry
	NSString * string =  [NSString stringWithFormat:@"Graph Screen %@",sender.titleLabel.text];
	[AppDelegate setFlurryWithText:string];
    
	TouchView *aTouchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [aTouchView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [aTouchView setDelegate:self];
    [self.view addSubview:aTouchView];
    [aTouchView release];
	
	//set X and Y for vwFilter
	
	CGRect rectVw = vwFilterView.frame;
    
    if (rectVw.size.width <=0 || rectVw.size.height <=0)
    {
        rectVw.size.width   = 585;
        rectVw.size.height  = 337;
    }
	
	UIImageView * image = nil;
	for (image in vwFilterView.subviews)
	{
		if (image.tag == 250)
		{
			break;  
		}
	}

	rectVw.origin.x = sender.frame.origin.x - (image.frame.origin.x - sender.frame.size.width/2 ) ;
	rectVw.origin.y = sender.frame.origin.y - vwFilterView.frame.size.height;

//    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
//    {
//        rectVw  = CGRectMake(18.5, 379, 585, 383);
//    }
//    else
//    {
//        rectVw = CGRectMake(274, 123, 585, 383);
//    }
	[vwFilterView setFrame:rectVw];
	self.rectForVWFilter = rectVw;
    [self.view addSubview:vwFilterView];
}

- (IBAction)btnApplyFilterTapped:(UIButton *)sender
{
    isFilterSearch = YES;
    isNewSearch = YES;
	[self HideAnimmation];
    for (id subItems in vwFilterView.subviews)
	{
		if ([subItems isKindOfClass:[UITextField class]])
		{
			UITextField * txtFilter = (UITextField *)subItems;
			
			if ([txtFilter.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
			{
                [self applyFilter:YES];
                break;
            }
        }
    }
	
}

- (IBAction)btnResetFilter:(UIButton *)sender
{
//    isNewSearch = no;
//    [self setHighLightedOptionForStage:0 withHighLightColor:[UIImage imageNamed:@"white-btn.png"]];
    
	[self resetAllFilterTextField];
	[self.popoverView dismissPopoverAnimated:YES];
	[self applyFilter:YES];
}

- (IBAction)btnDropDownTapped:(UIButton *)sender
{
	if (self.dropDownViewInGraph) {
		[dropDownViewInGraph removeFromSuperview];
		[dropDownViewInGraph release];
		dropDownViewInGraph = nil;
	}
	
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	//	CGRect rect = []
	self.dropDownViewInGraph = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
	[self.dropDownViewInGraph setBackgroundColor:[UIColor clearColor]];
	
	if (sender.tag == 300)
	{
		self.dropDownViewInGraph.DDType = DDLeadStatus;
	}else if (sender.tag == 301)
	{
		self.dropDownViewInGraph.DDType = DDLeadSource;
	}
	[self downloadDropDownData];
	[self.view addSubview:self.dropDownViewInGraph];
	[self.view bringSubviewToFront:self.dropDownViewInGraph];
	
	
	// open dropDown with some delay because it won't work otherwise
	[self.dropDownViewInGraph performSelector:@selector(openDropDown) withObject:nil afterDelay:0.1];
}

- (IBAction)btnFilterOptionTapped:(UIButton *)sender {
	
	for (UIButton * btn in vwFilterView.subviews)
	{
		if ([btn isKindOfClass:[UIButton class]])
		{
			if (btn.tag > 1000)
			{
				[btn setSelected:NO];
			}
		}
	}
	[sender setSelected:YES];
}
#pragma mark - UIKeyboard Notification
-(void)keyboardWasShown:(NSNotification*)notification
{
	
	// if its a industry textfield don't bring the view
	
	if (![txtIndustrySearch isFirstResponder])
	{
		NSDictionary* info = [notification userInfo];
		CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
		
		CGRect rectPopOver = vwFilterView.frame;
		
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
		{
			rectPopOver.origin.y = (self.view.bounds.size.height - kbSize.height) - (rectPopOver.size.height);
		}
		else
		{
			rectPopOver.origin.y = (self.view.bounds.size.height - kbSize.width) - (rectPopOver.size.height);
		}
		
		[UIView animateWithDuration:0.25 animations:^{[vwFilterView setFrame:rectPopOver];}];
	}
    
}

-(void)keyboardWillBeHidden:(NSNotification*)notification
{
	[UIView animateWithDuration:0.25 animations:^{[vwFilterView setFrame:self.rectForVWFilter];}];
	
}
#pragma mark - DropDownView
- (void)downloadDropDownData
{
	NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
	if (self.dropDownViewInGraph.DDType == DDLeadStatus)
	{
		NSArray * arr = @[@"Lead",@"Opportunity",@"Closed Won",@"Closed Lost",@"Cancelled"];
		[List addObjectsFromArray:arr];
	}
	else if (self.dropDownViewInGraph.DDType == DDLeadSource)
	{
		NSArray * arr = @[@"Website",@"Email",@"Tradeshow",@"Referral",@"Direct Mail",@"Call Center",@"Social Media",@"PPC",@"Internal Sales",@"External Sales"];
		[List addObjectsFromArray:arr];
	}
	
	[self.dropDownViewInGraph setDataArray:List];
	[List release];
}
#pragma mark - TouchView delegate
- (void)touchesDown:(NSSet *)touches
{
    [self HideAnimmation];
    UITouch *atouch = [[touches allObjects] lastObject];
    [atouch.view removeFromSuperview];
    
    if(btnFunnelFilter.selected == NO)
		[self resetAllFilterTextField];
}

-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
	
	for (UITextField * txtData in vwFilterView.subviews)
	{
		if([txtData isKindOfClass:[UITextField class]])
		{
			if(txtData.tag == 106 && dropdown.DDType == DDLeadStatus)
			{
				[txtData setText:dropdown.strDropDownValue];
			}else if (txtData.tag == 108 && dropdown.DDType == DDLeadSource)
			{
				[txtData setText:dropdown.strDropDownValue];
			}
		}
	}

	if (self.dropDownViewInGraph)
	{
		[dropDownViewInGraph removeFromSuperview];
		[dropDownViewInGraph release];
		dropDownViewInGraph = nil;
	}

}
#pragma mark - Apply Filter
-(void)applyFilter:(BOOL)filterData
{
	// remove popover
	[self.popoverView dismissPopoverAnimated:YES];
	
	BOOL isAllCustomerSelected = NO;
	
	AppDelegate * aDelegate = CRM_AppDelegate;
	
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    NSString *text = [[txtFromLocation text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL fromLocation = NO;
	if(text != nil && ![text isEqualToString:@""]){
        fromLocation = YES;
    }
	for (id subItems in vwFilterView.subviews)
	{
		if ([subItems isKindOfClass:[UITextField class]])
		{
			UITextField * txtFilter = (UITextField *)subItems;
			
			if (txtFilter.text.length)
			{
				NSDictionary * dict = nil;
				if (txtFilter.tag == 101)//Address
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"relAllAddress.street"];
				}
				else if(txtFilter.tag == 102)//Zip code
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"relAllAddress.zipCode"];
				}
				else if(txtFilter.tag == 103)//Country
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"relAllAddress.countryCode"];
				}
				else if(txtFilter.tag == 104)//Industry
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"industry"];
				}
				else if(txtFilter.tag == 105)//Funnel Stage
				{
					NSPredicate * pred  = [NSPredicate predicateWithFormat:@"ANY stageName CONTAINS[cd] %@",txtFilter.text];
					
					
					NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:pred andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
					
					if ([arrayFunnel count])
					{
						FunnelStageList * funnel = [arrayFunnel lastObject];
						dict = [NSDictionary dictionaryWithObject:funnel.stageID forKey:@"funnelStageID"];
					}
					
					
				}
				else if(txtFilter.tag == 106)//Lead status
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"leadStatus"];
				}
                else if(txtFilter.tag == 107)//State
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"relAllAddress.state"];
				}
				else if(txtFilter.tag == 108)//Lead Source
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"leadSource"];
				}
				else if(txtFilter.tag == 109)//Scoring
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"scoring"];
				}
				else if(txtFilter.tag == 110)//City
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"relAllAddress.city"];
				}

				if (dict != nil)
				{
					[array addObject:dict];
				}
				
			}
		}
		else if ([subItems isKindOfClass:[UIButton class]])
		{
			UIButton * btnOption = (UIButton *)subItems;
			
			if (btnOption.selected)
			{
				if (btnOption.tag == 1001)//All customer selected
				{
					isAllCustomerSelected = YES;
					
				}
				else if (btnOption.tag == 1002)//All viewed customer selected
				{
					NSDictionary * dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"isViewed"];
					[array addObject:dict];
				}
				
			}
		}
	}
	
	if (isAllCustomerSelected)
	{
		[array removeAllObjects];
	}
	
	NSPredicate * predicate = [self getPredicateForFilterWithArray:array];
	
	// send tag for selected button
	[self setDataInTableViewWithFunnelStageID:[self getTagForSelectedButton] andPredicate:predicate];

}
-(NSPredicate*)getPredicateForFilterWithArray:(NSArray*)arrDict
{
	NSPredicate * predicate = nil;
	
	for (NSDictionary * dictValues in arrDict)
	{
		if (!predicate)
		{
			NSString *strArg = [NSString stringWithFormat:@"ANY %@ CONTAINS[cd] ",[dictValues.allKeys lastObject]];
			
			NSString *strReq = @"%@";
			strArg = [strArg stringByAppendingString:strReq];
			
			predicate = [NSPredicate predicateWithFormat:strArg,[dictValues valueForKey:[dictValues.allKeys lastObject]]];
		}else
		{
			
			NSString *strArg = [NSString stringWithFormat:@"ANY %@ CONTAINS[cd] ",[dictValues.allKeys lastObject]];
			
			NSString *strReq = @"%@";
			strArg = [strArg stringByAppendingString:strReq];
			
			NSPredicate *newPredicate = [NSPredicate predicateWithFormat:strArg,[dictValues valueForKey:[dictValues.allKeys lastObject]]];
			
			predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,newPredicate, nil]];
			
		}
	}
	return predicate;
}

#pragma mark - Set Selected Top Options
-(void)setSelectedOptionButtonWithTag:(int)tag
{
	for (UIButton * btn in vwPortrate.subviews)
	{
		if ([btn isMemberOfClass:[UIButton class]])
		{
			if (btn.tag == tag)
			{
				[btn setSelected:YES];
			}else
			{
				[btn setSelected:NO];
			}
		}
		
	}
	
	for (UIButton * btn in vwLandscape.subviews)
	{
		if ([btn isMemberOfClass:[UIButton class]])
		{
			if (btn.tag == tag)
			{
				[btn setSelected:YES];
			}else
			{
				[btn setSelected:NO];
			}
		}
	}

	[self applyFilter:YES];
//	[self setDataInTableViewWithFunnelStageID:tag andPredicate:nil];
}
-(int)getTagForSelectedButton
{
	int selection = 0;
	for (UIButton * btn in vwPortrate.subviews)
	{
		if ([btn isMemberOfClass:[UIButton class]])
		{
			if (btn.selected == YES)
			{
				selection = btn.tag;
				break;
			}
		}
		
	}
	
	return selection;
}
@end
