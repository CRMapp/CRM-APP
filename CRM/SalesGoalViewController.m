
//
//  SalesGoalViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 23/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//


#define kAllProposalData	@"allProposalData"
#define kNewCustomerProrposal @"NewCustomerProrposal"
#define kReminIng		@"Remining"

#import "ProposalList.h"
#import "SalesGoalViewController.h"
#import "SaleGoal.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
#import "MyAddressBook.h"
#import "FunnelStageList.h"
@interface SalesGoalViewController ()
{
	BOOL isTargetAchived;
}

@end

@implementation SalesGoalViewController
@synthesize dropDownView;
@synthesize datePickerPopover;
@synthesize tableDict;

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
    
    for (UIView * viewForBorders in self.view.subviews)
	{
		
        for (UIView * viewForBorder in viewForBorders.subviews)
        {
            if (viewForBorder.tag == 1000)
            {
                [viewForBorder.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [viewForBorder.layer setBorderWidth:1.0];
            }
        }
	}
    self.tableDict = [NSMutableDictionary dictionary];
    
    [self addObserver_NotificationCenter];
	
	// Start Graph
	[self initGraph];
	
	NSArray *array = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
	if ([array count])
	{
		SaleGoal *sale = [array lastObject];
		
		NSDate * dateToday = [NSDate date];
		//		NSTimeInterval ti = [dateToday timeIntervalSince1970];
		NSDate * endDate = sale.saleEndDate;
		
		NSLog(@"%@ %@",endDate,dateToday);
		if ([endDate compare:dateToday] == NSOrderedSame|| [endDate compare:dateToday] == NSOrderedAscending )
		{
			
			UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice!" message:@"Oops! Target period has completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert show];
			[alert release];
			
			
		}
	}
	
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
	NSArray *array = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
	
	
	if ([array count])
	{
		SaleGoal *sale = [array lastObject];
		[self.tableDict setObject:[NSDateFormatter localizedStringFromDate:sale.saleDate
																 dateStyle:NSDateFormatterShortStyle
																 timeStyle:NSDateFormatterNoStyle] forKey:kSaleDate];
		[self.tableDict setValue:sale.target forKey:kTarget];
		[self.tableDict setValue:sale.timePeriod forKey:kTimePeriod];
        [self.tableDict setValue:sale.termPeriod forKey:kTermPeriod];
		
       
	}

	[self performSelector:@selector(generateGraphForSales) withObject:nil afterDelay:0.1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NSNotification methods
-(void)changeLayout:(NSNotification*)info
{
    if ([self.datePickerPopover isPopoverVisible])
    {
        [self.datePickerPopover dismissPopoverAnimated:YES];
    }
    
    [self.dropDownView closeTableView];
    
	[self performSelector:@selector(setGraphContentAfterRotation) withObject:nil afterDelay:0.2];
	[self performSelector:@selector(generateGraphForSales) withObject:nil afterDelay:0.1];
}
#pragma mark - IBAction methods
- (IBAction)btnDeleteTapped:(UIButton *)sender
{
	NSArray *array = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    if ([array count])
	{
        //Flurry
        [AppDelegate setFlurryWithText:@"Sales Goal Button Delete Target"];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Are you sure you want to delete the target?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert setTag:10];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No target found!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert setTag:10];
        [alert show];
        [alert release];
    }
	
	
}
- (IBAction)btnSaveSalesGoal:(id)sender
{
   
    if (![self isFieldEmpty])
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Sales Goal Button Set Target"];
        
		NSArray *array = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		SaleGoal *sale = nil;
		
		if ([array count])
		{
			sale = [array lastObject];
		}else
		{
			sale = (SaleGoal *)[NSEntityDescription insertNewObjectForEntityForName:@"SaleGoal" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		}
        
        
        [sale setTarget:[self.tableDict objectForKey:kTarget]];
        [sale setSaleDate:dateTimePicker.date];
        [sale setTermPeriod:[self.tableDict objectForKey:kTermPeriod]];
        [sale setTimePeriod:[self.tableDict objectForKey:kTimePeriod]];
        
		//Save end date
		NSDateComponents* dateComponents = [self getDateComponent:sale];
        
//        NSLog(@"%@ and %d",[sale timePeriod],[[sale timePeriod] integerValue]);
//		[dateComponents setMonth:[[sale timePeriod] integerValue]];
        
		NSCalendar* calendar = [NSCalendar currentCalendar];
		NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dateTimePicker.date options:0];
		
//		for testing uncomment the below lines
//		NSDate* newDate = [[NSDate date] dateByAddingTimeInterval:60];
		[sale setSaleEndDate:newDate];
//		[dateComponents release];
		
		isTargetAchived = NO;
		[tblSaleGoal reloadData];
		[self performSelector:@selector(generateGraphForSales) withObject:nil afterDelay:0.1];
		
		if (![((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil])
		{
			NSLog(@"DATA NOT SAVED");
		}
    }
    	
	
    
}
- (NSDateComponents*)getDateComponent:(SaleGoal*)sale
{
    NSDateComponents* dateComponents = [[[NSDateComponents alloc]init] autorelease];
    
    if ([sale.timePeriod isEqualToString:@"Week"])
    {
        [dateComponents setWeek:[[sale termPeriod] integerValue]];
    }
    if ([sale.timePeriod isEqualToString:@"Month"])
    {
        [dateComponents setMonth:[[sale termPeriod] integerValue]];
    }
    if ([sale.timePeriod isEqualToString:@"Quarter"])
    {
        [dateComponents setQuarter:[[sale termPeriod] integerValue]];
    }
    if ([sale.timePeriod isEqualToString:@"Year"])
    {
        [dateComponents setYear:[[sale termPeriod] integerValue]];
    }
    
//    NSLog(@"%@ and %d",[sale timePeriod],[[sale timePeriod] integerValue]);
//    [dateComponents setMonth:[[sale timePeriod] integerValue]];
    
    return dateComponents;
}
- (BOOL)isFieldEmpty
{
    BOOL isEmpty = NO;
     NSString *message = nil;
    if (![self.tableDict objectForKey:kTarget])
    {
        message = @"Please enter your target amount.";
        isEmpty = YES;
    }
    if (![self.tableDict objectForKey:kSaleDate] && !message)
    {
        message = @"Please enter your start date.";
        isEmpty = YES;
    }
    if (![self.tableDict objectForKey:kTermPeriod] && !message)
    {
        message = @"Please enter your term period.";
        isEmpty = YES;
    }
    if (![self.tableDict objectForKey:kTimePeriod] && !message)
    {
        message = @"Please enter your time period.";
        isEmpty = YES;
    }
    if (isEmpty)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:message delegate:nil cancelButtonTitle:@"No" otherButtonTitles:nil, nil];
        [alert setTag:10];
        [alert show];
        [alert release];
    }

    return isEmpty;
}
- (IBAction)btnCancel:(id)sender
{
    [self.tableDict removeAllObjects];
    [tblSaleGoal reloadData];
}
#pragma mark - Add OR Remove Notificatoin Observers
- (void)addObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(keyboardWasShown:)
//												 name:UIKeyboardWillShowNotification object:nil];
//	
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(keyboardWillBeHidden:)
//												 name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeLayout" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
//	[[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}
#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier = @"SaleGoalTVCell";
    
    SaleGoalTVCell *cell = (SaleGoalTVCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil)
	{
		NSString *nibname = @"SaleGoalTVCell";
		NSArray *arrItems = [[NSBundle mainBundle]loadNibNamed:nibname owner:nil options:nil ];
		for (id object in arrItems)
		{
			if([object isKindOfClass:[SaleGoalTVCell class]])
			{
				cell = (SaleGoalTVCell *)object;
                [cell setAdelegate:self];
				break;
			}
		}
    }
    NSLog(@"tableDict %@",self.tableDict);
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    [cell updateTableCell:indexPath info:self.tableDict];
    
    [cell.btnDropDown addTarget:self action:@selector(btndropDownTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.btnDropDown setTag:indexPath.row];
    
    [cell.btnDropDownNum addTarget:self action:@selector(btndropDownNumTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.btnDropDownNum setTag:indexPath.row];
    
    [cell.btnDOB addTarget:self action:@selector(btnDateTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDOB setTag:indexPath.row];
    
    return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
#pragma mark - DropDown List methods  
-(void)btndropDownTapped:(UIButton*)sender
{
    
	[self generateDropDown:sender];
	[self downloadDropDownData:sender];
    [tblSaleGoal reloadData];
}
-(void)btndropDownNumTapped:(UIButton*)sender
{
    
	[self generateDropDown:sender];
	[self downloadDropDownData:sender];
    [tblSaleGoal reloadData];
}
- (void)generateDropDown:(UIButton*)sender
{
//		if (self.dropDownView) {
//			[self.dropDownView removeFromSuperview];
//            [dropDownView release];
//            self.dropDownView = nil;
//        }
    
    NSLog(@"%@",sender.superview);
    CGRect rect = [sender convertRect:sender.bounds toView:self.view];
    
    if (sender.tag == 102)
    {
        rect.origin.x = rect.origin.x + 10;
        rect.size.width = rect.size.width - 30;
    }
		
    self.dropDownView = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
    [self.dropDownView setBackgroundColor:[UIColor clearColor]];
    [self.dropDownView setTag:sender.tag];
    
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
- (void)downloadDropDownData:(UIButton*)sender
{
	NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
    
    if(sender.tag == 101)
	[List addObjectsFromArray:@[@"Week",@"Month",@"Quarter",@"Year"]];
    
    if(sender.tag == 102)
    {
        for (int i = 1; i <=52; i ++)
        {
            [List addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
	
	[self.dropDownView setDataArray:List];
	[List release];
	//else if ([title rangeOfString:@"Salutation" options:NSCaseInsensitiveSearch].length)
}
-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
	[self.dropDownView removeFromSuperview];
	
    if ([dropdown.strDropDownValue length] && dropdown.tag == 101)
    {
        [self.tableDict setObject:dropdown.strDropDownValue forKey:kTimePeriod];
    }
    if ([dropdown.strDropDownValue length] && dropdown.tag == 102)
    {
        [self.tableDict setObject:dropdown.strDropDownValue forKey:kTermPeriod];
    }
	
	[tblSaleGoal reloadData];
}
#pragma mark - Cell methods
-(void)btnDateTapped:(UIButton*)sender
{
	
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


- (IBAction)btnDoneToolBar:(id)sender
{
    [self.tableDict setObject:[NSDateFormatter localizedStringFromDate:dateTimePicker.date
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle] forKey:kSaleDate];
    
    [tblSaleGoal reloadData];
    if ([self.datePickerPopover isPopoverVisible])
    {
        [self.datePickerPopover dismissPopoverAnimated:YES];
    }
}
#pragma mark - SaleGoalTVCellDelegate method
-(void)textFiledDidEditingWithTextField:(UITextField *)textField
{
    [self.tableDict setObject:textField.text forKey:kTarget];
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 10)
	{
		if (buttonIndex == 1)
		{
			[self.tableDict removeAllObjects];
			NSArray *array = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
			if ([array count])
			{
				[((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:[array lastObject]];
				if(![((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil])
					NSLog(@"Not saved");
			}
			[tblSaleGoal reloadData];
			[self performSelector:@selector(generateGraphForSales) withObject:nil afterDelay:0.1];
		}
	}
}
#pragma mark - Generate Graph
-(void)initGraph
{
	[vwGraph.layer setCornerRadius:20.0];
	[vwGraph.layer setMasksToBounds:YES];
	[vwGraph.layer setBorderColor:[UIColor blackColor].CGColor];
	[vwGraph.layer setBorderWidth:1.0];

	[self performSelector:@selector(setGraphContentAfterRotation) withObject:nil afterDelay:0.2];
}
-(void)setGraphContentAfterRotation
{
	CGRect rect = lblSalesGoal.frame;
	rect.origin.x = vwGraph.frame.origin.x + 10;
	rect.origin.y = vwGraph.frame.origin.y - rect.size.height - 10;
	[lblSalesGoal setFrame:rect];
}
-(void)setLabelPriceData
{
    
	NSDictionary * dictionary = [NSDictionary dictionaryWithDictionary:[self getDict]];
	
	NSString * priceNewCustomer = [dictionary valueForKey:kNewCustomerProrposal];
	NSString * priceProposals = [dictionary valueForKey:kAllProposalData];
	NSString * priceremain = [dictionary valueForKey:kReminIng];
	
	//Number format
    //	[lblValue1 setText:[NSString stringWithFormat:@"$ %0.2f",[priceNewCustomer floatValue]]];
	[lblValue1 setText:[Global convertStringToNumberFormatter:[NSString stringWithFormat:@"%0.2f",[priceNewCustomer floatValue]]withDollerSign:YES]];
	
    //	[lblValue2 setText:[NSString stringWithFormat:@"$ %0.2f",[priceProposals floatValue]]];
	[lblValue2 setText:[Global convertStringToNumberFormatter:[NSString stringWithFormat:@"%0.2f",[priceProposals floatValue]]withDollerSign:YES]];
	
	if ([self.tableDict valueForKey:kTarget])
	{
        //		[lblValue3 setText:[NSString stringWithFormat:@"$ %0.2f", fabs([priceremain floatValue])]];
		[lblValue3 setText:[Global convertStringToNumberFormatter:[NSString stringWithFormat:@"%0.2f", fabs([priceremain floatValue])] withDollerSign:YES]];
		
		NSString * salesGoal = [NSString stringWithFormat:@"Sales Goal : %@",
								[Global convertStringToNumberFormatter:[self.tableDict objectForKey:kTarget]
														withDollerSign:YES]];
		
		[lblSetGoal setText:salesGoal];
	}
	else
	{
		[lblValue3 setText:[Global convertStringToNumberFormatter:[NSString stringWithFormat:@"%0.2f", 0.00] withDollerSign:YES]];
		[lblSetGoal setText:@"Set your goal"];
	}
	
	
	for (int i = 0; i < [vwGraph.subviews count]; i++ )
	{
		UILabel * lblSub = (UILabel *)[vwGraph.subviews objectAtIndex:i];
		
		if ([lblSub isKindOfClass:[UILabel class]])
		{
			if (lblSub.tag == 1)
			{
				[lblTitleValue1 setText:[NSString stringWithFormat:@"Sales (%@)",lblSub.text]];
			}
			if (lblSub.tag == 2)
			{
				[lblTitleValue2 setText:[NSString stringWithFormat:@"Total Open Proposals (%@)",lblSub.text]];
			}
			if (lblSub.tag == 3)
			{
				if ([priceremain intValue] < 0)
				{
					[lblTitleValue3 setText:[NSString stringWithFormat:@"Gap For Period Exceed By (%@)",lblSub.text]];
				}else
					[lblTitleValue3 setText:[NSString stringWithFormat:@"Gap For Period (%@)",lblSub.text]];
			}
		}
	}
	
}
-(void)generateGraphForSales
{

	// first remove all subviews from graph
	[vwGraph.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	NSArray * arrayView = [[NSArray alloc]initWithArray:[self getRectsForAllGraphViews]];
	
	
		for (int i = 0; i < [arrayView count]; i++)
		{
			NSValue * valueRect = [arrayView objectAtIndex:i];
			CGRect rect = [valueRect CGRectValue];
			
			UIView * viewColour = [self.view viewWithTag:[[NSString stringWithFormat:@"50%d",i] intValue]];
			
			// UILabel to show percentage portion
			UILabel * lblPer = [[UILabel alloc]initWithFrame:rect];
			[lblPer setBackgroundColor:(viewColour)?[viewColour backgroundColor]:[UIColor yellowColor]];
			[lblPer setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
			[lblPer setTextAlignment:NSTextAlignmentCenter];
			[lblPer setTag:i+1];
			
			//calculate the percantage
			float per = (lblPer.frame.size.width/vwGraph.frame.size.width)*100;
			[lblPer setText:[NSString stringWithFormat:@"%ld%%",lroundf(per)]];
			
			// if per is less then 3% hide the percentage
			if ((UIInterfaceOrientationIsPortrait(self.interfaceOrientation) && lroundf(per) < 4) || lroundf(per) < 3)
			{
				[lblPer setTextColor:[UIColor  clearColor]];
			}
			
			
			[vwGraph addSubview:lblPer];
			
			[lblPer release];
			
		}
	
		if (isTargetAchived)
		{
			// UILabel Terget Achived
			UILabel * lblPer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vwGraph.frame.size.width, vwGraph.frame.size.height)];
			[lblPer setBackgroundColor:[UIColor orangeColor]];
			[lblPer setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
			[lblPer setTextAlignment:NSTextAlignmentCenter];
			
			[lblPer setText:[NSString stringWithFormat:@"Target Achived"]];
			
			[vwGraph addSubview:lblPer];
			
			[lblPer release];
			
			
			
			NSArray *array = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
			
			
			if ([array count])
			{
				SaleGoal *sale = [array lastObject];
				
				NSDate * dateToday = [NSDate date];
				//		NSTimeInterval ti = [dateToday timeIntervalSince1970];
				NSDate * endDate = sale.saleEndDate;
				
				NSLog(@"%@ %@",endDate,dateToday);
				if ([endDate compare:dateToday] == NSOrderedSame || [endDate compare:dateToday] == NSOrderedAscending )
				{}
				else
				{
					UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Congratulation!" message:@"You have achived the target" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alert show];
					[alert release];
				}
			}
		}
	
	[arrayView release];
	
	[self setLabelPriceData];
}
-(NSArray *)getRectsForAllGraphViews
{
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary * dictionary = [NSDictionary dictionaryWithDictionary:[self getDict]];
	

	
	float preWidth = 0.0;
	for (int i = 0 ; i < [[dictionary allKeys] count]; i++)
	{
		
		NSString * key = [NSString stringWithFormat:@"%@",[dictionary.allKeys objectAtIndex:i]];
		
		if (![key isEqualToString:kTarget])
		{
			
			float newWidth = vwGraph.frame.size.width * ([[dictionary valueForKey:key] floatValue]/[[dictionary valueForKey:kTarget] floatValue]);
			
			NSLog(@"Width : %f",newWidth);
			CGRect rect;
			
			// if total is zero don't need to move forward
			if ([[dictionary valueForKey:kTarget] intValue] == 0)
			{
				rect = CGRectMake(0, 0, 0, 0);
			}else
			{
				rect = CGRectMake(preWidth, 0, newWidth, vwGraph.frame.size.height);
			}
			 
			preWidth += newWidth;
			
			[array addObject:[NSValue valueWithCGRect:rect]];
			
		}
	}
	
	
	
	
	
	return array;
}
-(NSDictionary *)getDict
{
	AppDelegate *adelegate = CRM_AppDelegate;
	
	// Get count for Proposallist
	double countProposal = 0.0;
	
	// Get cout for new AddressBook
	double countAdd = 0.0;
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:0];
	
	//Target Value
	NSString * target = [self.tableDict valueForKey:kTarget];
	
	if (target)
	/*{
		NSArray *array = [CoreDataHelper getObjectsForEntity:@"ProposalList" withSortKey:nil andSortAscending:NO andContext:[adelegate managedObjectContext]];
		
		
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ANY stageName CONTAINS[cd] %@",@" customer"];
		
		NSArray *arrayFunnlName = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[adelegate managedObjectContext]];
		
		FunnelStageList * funn = [arrayFunnlName lastObject];
		
		for (ProposalList *proposal in array)
		{
			countProposal += [proposal.proposalPrice doubleValue];
			
			//Get count for ProposalList from myAddressBook
			
			MyAddressBook * addressBook = [proposal relMyAddressBook];
			
			if ([addressBook.funnelStageID isEqual:funn.stageID])
			{
				countAdd += [proposal.proposalPrice doubleValue];
			}
			//--
		}
	}*/
    {
        //get sales details
        NSArray *array = [CoreDataHelper getObjectsForEntity:@"ProposalList" withSortKey:nil andSortAscending:NO andContext:[adelegate managedObjectContext]];
        
		NSArray * arrSale = [CoreDataHelper getObjectsForEntity:@"SaleGoal" withSortKey:nil andSortAscending:NO andContext:[adelegate managedObjectContext]];
		
		SaleGoal * sale = [arrSale lastObject];
		
		NSDateComponents* dateComponents = [self getDateComponent:sale];
        
		NSCalendar* calendar = [NSCalendar currentCalendar];
        
		NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dateTimePicker.date options:0];
		
		
		for (ProposalList *proposal in array)
		{
			
			if ([proposal.funnelStage length] && [proposal.funnelStage rangeOfString:@"customer won" options:NSCaseInsensitiveSearch].length)
			{
				//found customer won
				countAdd += [proposal.proposalPrice doubleValue];
			}
			else
			{
				//if user has funnal stage other then customer won
				//now check if the proposal target is not in range of our  sales target
                
                NSLog(@"%d",[newDate compare:proposal.proposalTargetDate]);
                
                NSTimeInterval t1 = [newDate timeIntervalSince1970];
                NSTimeInterval t2 = [proposal.proposalTargetDate timeIntervalSince1970];
                
//				if ([newDate compare:proposal.proposalTargetDate])
                if (t2 <= t1)
				{
					NSLog(@"date1 is earlier than date2");
					countProposal += [proposal.proposalPrice doubleValue];
				}
				
			}
        }

    }
	[dict setValue:[NSString stringWithFormat:@"%f",countProposal] forKey:kAllProposalData];
	//--
	
	//NewCustomer value
	[dict setValue:[NSString stringWithFormat:@"%f",countAdd] forKey:kNewCustomerProrposal];
	
	//--
	[dict setValue:([target length]?target:@"100") forKey:kTarget];
	
	//Remaining
	
	float remain = [[dict valueForKey:kTarget] doubleValue] - (countAdd + countProposal);
	
	if (remain < 1)
	{
		isTargetAchived = YES;
	}
	
	[dict setValue:[NSString stringWithFormat:@"%f",remain] forKey:kReminIng];
	
	return dict;
	
}
- (void)dealloc {
    [vwGraph release];
	[lblSalesGoal release];
	[lblValue1 release];
	[lblValue2 release];
	[lblValue3 release];
	[lblTitleValue1 release];
	[lblTitleValue2 release];
	[lblTitleValue3 release];
	[lblSetGoal release];
    [super dealloc];
}
- (void)viewDidUnload {
    [vwGraph release];
    vwGraph = nil;
	[lblSalesGoal release];
	lblSalesGoal = nil;
	[lblValue1 release];
	lblValue1 = nil;
	[lblValue2 release];
	lblValue2 = nil;
	[lblValue3 release];
	lblValue3 = nil;
	[lblTitleValue1 release];
	lblTitleValue1 = nil;
	[lblTitleValue2 release];
	lblTitleValue2 = nil;
	[lblTitleValue3 release];
	lblTitleValue3 = nil;
	[lblSetGoal release];
	lblSetGoal = nil;
    [super viewDidUnload];
}
@end
