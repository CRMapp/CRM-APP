//
//  AddLinkedInContactVC.m
//  CRM
//
//  Created by Narendra Verma on 20/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//
//9314502569
//User dictKeys
#define kFirstName @"Name"
#define kLastName @"LastName"
#define kID	@"ID"
#define kLocation @"Location"
#define kPicture @"Picture"
#define kTitle @"Title"
#define kCompany @"Company"

#import <MapKit/MapKit.h>
#import "AddLinkedInContactVC.h"
#import <QuartzCore/QuartzCore.h>
//#import "ContactDataCell.h"
#import "ContactListTVCell.h"
#import "CoreDataHelper.h"
//#import "AppDelegate.h"

//Core Data
#import "MyAddressBook.h"
#import "AllAddress.h"
#import "CountryNCodeList.h"

@interface AddLinkedInContactVC ()

@end

@implementation AddLinkedInContactVC
@synthesize tableAddress;
@synthesize linkedInVC;
@synthesize arrayContact;

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
	
	[tableAddress.layer setBorderWidth:1.0];
	[tableAddress.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
//    [tableAddress setTableFooterView:tblFooterView];
	
	self.arrayContact = [NSMutableArray arrayWithCapacity:0];
	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
	//Present Linked in
	//If the table list is empty
//	if (![arrayContact count])
//	{
		if (!self.linkedInVC)
		{
			self.linkedInVC = [[[OAuthLoginView alloc]initWithNibName:@"OAuthLoginView" bundle:nil] autorelease];
			self.linkedInVC.delegate = self;
            [self presentModalViewController:self.linkedInVC animated:YES];
		}
		
		
		
//	}
	
	[super viewDidAppear:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
	[arrayContact release];
	arrayContact = nil;
	
	[linkedInVC release];
    [tableAddress release];

    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableAddress:nil];

    [super viewDidUnload];
}

#pragma mark - Linkedin delegate
- (void)linkedinResponse:(OAServiceTicket *)ticket didFinish:(NSDictionary *)result
{
	NSLog(@"Result : %@",result);
	
	NSArray * array = [result objectForKey:@"values"];
    
    if ([array count])
    {
        [self.arrayContact removeAllObjects];
    }
	
	for (NSDictionary * aDict in array)
	{
		
		NSDictionary * dictWithData = [NSDictionary dictionaryWithObjectsAndKeys:
									   ([aDict valueForKey:@"firstName"])	?[aDict valueForKey:@"firstName"]:@"",		kFirstName,
									   ([aDict valueForKey:@"lastName"])	?[aDict valueForKey:@"lastName"]:@"",		kLastName,
									   ([aDict valueForKey:@"pictureUrl"])	?[aDict valueForKey:@"pictureUrl"]:@"",		kPicture,
									   ([aDict valueForKey:@"headline"])	?[aDict valueForKey:@"headline"]:@"",		kTitle,
									   ([aDict valueForKey:@"industry"])	?[aDict valueForKey:@"industry"]:@"",		kCompany,
									   ([aDict valueForKey:@"location"])	?[aDict objectForKey:@"location"]:@"",		kLocation,
									   ([aDict valueForKey:@"id"])			?[aDict valueForKey:@"id"]:@"",				kID,
									   nil];
		[self.arrayContact addObject:dictWithData];
		
	}
	
	[tableAddress reloadData];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [arrayContact count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ContactListTVCell";
    
    ContactListTVCell *cell = (ContactListTVCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
		NSString *nibname = @"ContactListTVCell";
		NSArray *arrItems = [[NSBundle mainBundle]loadNibNamed:nibname owner:nil options:nil ];
		for (id object in arrItems)
		{
			if([object isKindOfClass:[ContactListTVCell class]])
			{
				cell = (ContactListTVCell *)object;
				break;
			}
		}
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSDictionary * dict = [self.arrayContact objectAtIndex:indexPath.row];
	
	// image
	[cell.imgVwUser setPlaceholderImage:[UIImage imageNamed:@"ipad_user_img.png"]];
	NSString * picture = [dict valueForKey:kPicture];
	if ([picture length])
	{
		[cell.imgVwUser setImageURL:[NSURL URLWithString:picture]];
	}else
	{
		[cell.imgVwUser setImage:[UIImage imageNamed:@"ipad_user_img.png"]];
	}
	

	//Name
	NSString * name = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:kFirstName],[dict valueForKey:kLastName]];
	[cell.lblUserName setText:name];
		
	
	//Title
	[cell.lblTitle setText:[dict valueForKey:kTitle]];
	
	
	//Company
	[cell.lblCompany setText:[dict valueForKey:kCompany]];
	
	//Accessory
	[cell.imgArrow setHidden:YES];
	
	//Button
    [cell.btnEditContact setImage:[UIImage imageNamed:@"add_contact.png"] forState:UIControlStateNormal];
	[cell.btnEditContact setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	[cell.btnEditContact addTarget:self action:@selector(btnAddContactRowTapped:) forControlEvents:UIControlEventTouchUpInside];
	[cell.btnEditContact setTag:indexPath.row];
	
	return cell;
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return tblFooterView;
//}
#pragma mark -  IBAction
- (IBAction)btnLinkedInTapped:(id)sender
{
    if (!self.linkedInVC)
    {
        self.linkedInVC = [[[OAuthLoginView alloc]initWithNibName:@"OAuthLoginView" bundle:nil] autorelease];
        self.linkedInVC.delegate = self;
    }
    
    
    [self presentModalViewController:self.linkedInVC animated:YES];
}
-(void)btnAddContactRowTapped:(UIButton *)sender
{	
	NSDictionary * dict = [self.arrayContact objectAtIndex:sender.tag];
	NSString * name = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:kFirstName],[dict valueForKey:kLastName]];
	
	//check for user in database
	AppDelegate * aDelegate = CRM_AppDelegate;
	
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"recordID = %@",[dict valueForKey:kID]];
	
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook"
											   withPredicate:predicate
												  andSortKey:nil andSortAscending:NO
												  andContext:[aDelegate managedObjectContext]];
	
	
	if (![array count])
	{
		NSString * msg = [NSString stringWithFormat:@"Do you want to add\n%@\n as contact",name];
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:msg delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
		[alert setTag:sender.tag];
		[alert show];
		[alert release];
	}
	else
	{
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Contact already exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		NSDictionary * dict = [self.arrayContact objectAtIndex:alertView.tag];
		
		
		//check for user in database
		AppDelegate * aDelegate = CRM_AppDelegate;
		
		MyAddressBook * myAddObj = [NSEntityDescription insertNewObjectForEntityForName:@"MyAddressBook" inManagedObjectContext:[aDelegate managedObjectContext]];
		
		[myAddObj setFirstName      :[dict valueForKey:kFirstName]];
		[myAddObj setLastName       :[dict valueForKey:kLastName]];
		[myAddObj setRecordID       :[dict valueForKey:kID]];
		[myAddObj setJobTitle       :[dict valueForKey:kTitle]];
		[myAddObj setOrganisation   :[dict valueForKey:kCompany]];
		[myAddObj setImage          :[dict valueForKey:kPicture]];
		
		
		AllAddress * alladdress = [NSEntityDescription insertNewObjectForEntityForName:@"AllAddress" inManagedObjectContext:[aDelegate managedObjectContext]];
		
		//Country code
		NSString * countryCode = [[[dict valueForKey:kLocation] valueForKey:@"country"] valueForKey:@"code"];
		NSString * streetName  = [[dict valueForKey:kLocation] valueForKey:@"name"];
		
		
		NSPredicate * aPredicate = [NSPredicate predicateWithFormat:@"countryCode = %@",countryCode];
		NSArray * arrayCode = [CoreDataHelper searchObjectsForEntity:@"CountryNCodeList"
													   withPredicate:aPredicate
														  andSortKey:nil andSortAscending:NO
														  andContext:[aDelegate managedObjectContext]];
		
		if ([arrayCode count])
		{
			CountryNCodeList * country = [arrayCode objectAtIndex:0];
			
			[alladdress setCountryCode:country.countryName];
		}
		
		
		[alladdress setStreet:[dict valueForKey:streetName]];
		
		CLLocationCoordinate2D location = [self addressLocation:alladdress.street];
		
		[alladdress setLatitude:[NSString stringWithFormat:@"%f",location.latitude]];
		[alladdress setLongitude:[NSString stringWithFormat:@"%f",location.longitude]];
		
		[alladdress setRelMyAddressBook:myAddObj];
		
		
		if (![[aDelegate managedObjectContext] save:nil]) {
			NSLog(@"Error in saving Linked in Contact");
		}else
		{
			NSString * name = [NSString stringWithFormat:@"%@ %@",[dict valueForKey:kFirstName],[dict valueForKey:kLastName]];
			NSString * msg = [NSString stringWithFormat:@"%@\nadded successfully",name];
			
			UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Success" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			
			[alert show];
			[alert release];
		}
	}
}
-(CLLocationCoordinate2D) addressLocation:(NSString *)searchedLocation
{
	//    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];http://maps.googleapis.com/maps/api/geocode/json?address=durgapura%2C%20jaipur&sensor=true
    
    NSLog(@"%@",searchedLocation);
    
    NSString * urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
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
            NSLog(@"No address found.Invalid address");
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

@end
