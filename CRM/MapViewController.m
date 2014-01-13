//
//  MapViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 12/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#define MAP_MESSAGE @"Clue found some addresses which are not properly labeled, or incorrect, or incomplete in the address book and these will show in the Atlantic Ocean. Please check those addresses for accuracy."

#define SecondTimeLoading @"MapLoadedAlready"
#import "MapViewController.h"

#import <QuartzCore/QuartzCore.h>
//#import "AppDelegate.h"
#import "CRMConfig.h"
#import "MyAddressBook.h"
#import "GoogleCategory.h"
#import "SVProgressHUD.h"
#import "AllAddress.h"
#import "AllEmail.h"
#import "AllPhone.h"
#import "AllUrl.h"
#import "AllDate.h"
#import "AllRelatedName.h"
#import "GlobalDataPersistence.h"
#import "SettingsViewController.h"
#import "FunnelStageList.h"
#import "Reachability.h"
#import "ProposalList.h"
#import "Global.h"
#import "Industries.h"
#import "ContactDetailViewController.h"
#import "GroupMemberList.h"
@class Emails;
@class AppointmentList;
@class NotesList;
@class FollowUpdate;
@interface MapViewController ()

@end

@implementation MapViewController
{
	CGRect rectVwFilter;
	BOOL shouldMoveUp;
    BOOL alreadyShown;
}
@synthesize popoverIndustry;
@synthesize arrayIndustry;
@synthesize arrMyAddressBook;
@synthesize arrSelected;
@synthesize dropDownVw;
@synthesize dropDownVWOnTop;
@synthesize typePopover;
@synthesize displayObj;
@synthesize typeOfCallout;
@synthesize coordinateLocGoogleCategory;
@synthesize queue;
@synthesize strSelectedGoogleCategory;
@synthesize locationManager;
@synthesize pagetoken;
@synthesize categoryResultArray;

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
    BOOL alreadyLoaded = [[NSUserDefaults standardUserDefaults] boolForKey:SecondTimeLoading];
    alreadyShown = NO;
    if(!alreadyLoaded){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice!" message:@"The addresses which are not properly labeled, or incorrect, or incomplete in the address book will show in the Atlantic Ocean. Please check those addresses for accuracy." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        alreadyShown = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SecondTimeLoading];
    }
    aMapView.showsUserLocation = YES;
    
    [self createDropDownOnTop];
    [self startLocationManager];
    
    //Insert Google Category List
    [self insertGoogleCategoryList];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertIndusrtiesInDatabase];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] insertFunnelStageList];
    
    [[aMapView layer]setCornerRadius:5.0];
    [[aMapView layer]setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[aMapView layer]setBorderWidth:0.5];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
//    NSLog(@"%@",MyAddressBook);

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [mapCallOutView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillShowNotification object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillBeHidden:)
                                                  name:UIKeyboardWillHideNotification object:nil];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [self updateUI:orientation];
    
    
    aMapView.showsUserLocation = YES;
    
    [self performSelector:@selector(loadAddressBook) withObject:nil afterDelay:0.1];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
	[[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}
#pragma mark - Addressbook fetch and load methods
- (void)fetchAddressBook
{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    [AddressBook arrayOfAddressBook]; //if no data then access from address book of device.
    
    GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    if([self checkNetworkConnection])
    {
        BOOL isInValidFound = NO;
        for(MyAddressBook *myAdd in  GDP.arrMyAddressBookData)
        {
            AllAddress *allAddress = [[[myAdd relAllAddress]allObjects] lastObject];
            
            CLLocationCoordinate2D location = [self addressLocation:[self getAddressString:allAddress]];
            
            
            if (location.latitude == 0.0 || location.longitude == 0.0)
            {
                isInValidFound = YES;
            }
                        
            [allAddress setLatitude:[NSString stringWithFormat:@"%f",location.latitude]];
            [allAddress setLongitude:[NSString stringWithFormat:@"%f",location.longitude]];
            
            [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
            
        }
        //Nikhil:15335
        if (isInValidFound && !alreadyShown)
        {
            alreadyShown = YES;
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice!" message:MAP_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
    self.arrMyAddressBook  = GDP.arrMyAddressBookData;
    [SVProgressHUD dismiss];
    
    if([aMapView.annotations count])
    {
        [aMapView removeAnnotations:aMapView.annotations];
        [self performSelector:@selector(addAnnotations) withObject:nil afterDelay:0.0];
    }
    else
    {
        [self addAnnotations];
    }
    
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
- (void)loadAddressBook
{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSLog(@"%f %f",aMapView.userLocation.coordinate.latitude,aMapView.userLocation.coordinate.longitude);
	region.center.latitude = aMapView.userLocation.coordinate.latitude ;
	region.center.longitude = aMapView.userLocation.coordinate.longitude;
	region.span.longitudeDelta = 1.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
	region.span.latitudeDelta = 1.0f;
	[aMapView setRegion:region animated:YES];
    
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    if([self.arrMyAddressBook count] <= 0 || ![Global GetSyncLocationsFlag])
    {
        GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        if ([GDP.arrMyAddressBookData count] <= 0)  //check data is avail in database
        {
            if([self checkNetworkConnection])
            {
                [SVProgressHUD showWithStatus:@"Retrieving Geolocation Data..."];
                [self performSelector:@selector(fetchAddressBook) withObject:nil afterDelay:0.1];
            }
        }
        else
        {
            if([self checkNetworkConnection])
            {
                [SVProgressHUD showWithStatus:@"Retrieving Geolocation Data..."];
                [self performSelector:@selector(loadLocations) withObject:nil afterDelay:0.1];
            }
        }
    }
    
}
- (void)loadLocations
{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    if(![Global GetSyncLocationsFlag])
    {
        BOOL isInValidFound = NO;
        for(MyAddressBook *myAdd in  GDP.arrMyAddressBookData)
        {
            if ([myAdd.firstName isEqualToString:@"Albert-John"])
            {
                NSLog(@"%@",myAdd);
            }
            
            NSArray *arr = [NSArray arrayWithArray:[[myAdd relAllAddress]allObjects]];
            
            for (AllAddress *allAddress in arr)
            {
                if([allAddress.latitude doubleValue] == 0.0 && [allAddress.longitude doubleValue] == 0.0)
                {
                    
                    CLLocationCoordinate2D location = [self addressLocation:[self getAddressString:allAddress]];
                    
                    if (location.latitude == 0.0 || location.longitude == 0.0)
                    {
                        isInValidFound = YES;
                    }
                    
                    [allAddress setLatitude:[NSString stringWithFormat:@"%f",location.latitude]];
                    [allAddress setLongitude:[NSString stringWithFormat:@"%f",location.longitude]];
                    
                    [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                }
            }
            
        }
        //Nikhil:15335
         if (isInValidFound && !alreadyShown)
        {
            alreadyShown = YES;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:MAP_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    [Global SaveSyncLocationsFlag:YES];
    
    self.arrMyAddressBook  = GDP.arrMyAddressBookData;
    [SVProgressHUD dismiss];
    
    
    if([aMapView.annotations count])
    {
        //        [aMapView removeAnnotations:aMapView.annotations];
        [self performSelector:@selector(addAnnotations) withObject:nil afterDelay:0.0];
    }
    else
    {
        [self addAnnotations];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [strSelectedGoogleCategory release];
    strSelectedGoogleCategory = nil;
	[dropDownVWOnTop release];
	[dropDownVw release];
    [arrMyAddressBook release];
    arrMyAddressBook = nil;
    
    [vwIndustrySearch release];
    [tableIndustry release];
    [txtIndustrySearch release];
    [arrayIndustry release];
    [popoverIndustry release];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeLayout" object:nil];
	[switchProposal release];
	[txtRestrectedMile release];
	[txtFromLocation release];
	[txtSearchField release];
    
    [vwCategoryView release];
	[txtcategoryLocation release];
	[txtCategory release];
	[imgBackGround release];

    [lblFunnelStage release];
    [btnFetchMore release];
    [btnCreateGroup release];
    [btnDone release];
	   [super dealloc];
}
#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// if mapCalloutView is on self.view and callout type is callOutGoogle Category
	if (mapCallOutView.superview)
	{
		UITouch *touch = [touches anyObject];
		CGPoint touch_point = [touch locationInView:self.view];
		
		//we tapped in side the call out view
		if (CGRectContainsPoint(mapCallOutView.frame, touch_point))
		{
			
			//if the callout is of type google category
			if (self.typeOfCallout == CallOutTypeGoogleCategory)
			{
				UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Import" message:@"Do you want to add selected contacts to CRM address book?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil];
				
				[alert setTag:101];
				[alert show];
				[alert release];
			}
			else
			{
				// if the callout is for user details
                ContactDetailViewController *obj = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
                [obj setAContactDetails:displayObj.aPerson];
                [self.navigationController pushViewController:obj animated:YES];
                [obj release];
			}
			
		}
		else
		{
			[mapCallOutView removeFromSuperview];
		}
		
	}
	
}

-(void)changeLayout:(NSNotification*)info
{
    [mapCallOutView removeFromSuperview];
    NSDictionary *themeInfo     =   [info userInfo];
    int orintation = [[themeInfo objectForKey:@"kOrientation"] intValue];
    if(orintation <= 2)
    {
        [imgVMapArrow setFrame:CGRectMake(350, 0, 30, 17)];
        [imgVSearchBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
    }
    else
    {
        [imgVMapArrow setFrame:CGRectMake(518, 0, 30, 17)];
        [imgVSearchBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
    }

}
-(void)updateUI:(int)orientation
{
    if(orientation <= 2)
    {
        [imgVMapArrow setFrame:CGRectMake(350, 0, 30, 17)];
        [imgVSearchBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
    }
    else
    {
        [imgVMapArrow setFrame:CGRectMake(518, 0, 30, 17)];
        [imgVSearchBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
    }
}
#pragma mark - UIKeyboard Notification
-(void)keyboardWasShown:(NSNotification*)notification
{
	
	shouldMoveUp = NO;
	for (UITextField * textFileds in mapFilterView.subviews)
	{
		if ([textFileds isKindOfClass:[UITextField class]])
		{
			if ([textFileds isFirstResponder])
			{
				if (textFileds.tag == 109|| textFileds.tag == 104 || textFileds.tag == 111 || textFileds.tag == 112)
				{
					NSLog(@"%@",textFileds.placeholder);
					shouldMoveUp = YES;
					break;
				}
			}
			
		}
	}
	if (shouldMoveUp)
	{
		NSDictionary* info = [notification userInfo];
		CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
		
		CGRect rectPopOver = mapFilterView.frame;
		
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
		{
//			rectPopOver.origin.y = (self.view.bounds.size.height - kbSize.height) - (rectPopOver.size.height);
		}
		else
		{
			rectPopOver.origin.y = (self.view.bounds.size.height - kbSize.width) - (rectPopOver.size.height);
		}
		
		[UIView animateWithDuration:0.25 animations:^{[mapFilterView setFrame:rectPopOver];}];
	}
	
	
	
}
-(void)keyboardWillBeHidden:(NSNotification*)notification
{
    
	if (shouldMoveUp)
	{
		shouldMoveUp = NO;
		[UIView animateWithDuration:0.25 animations:^
        {
            [mapFilterView setFrame:rectVwFilter];
        }];
		
	}
	
	
}

#pragma mark - MKMapView Delegate
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    // reuse a view, if one exists
    
    DisplayMap *locations = (DisplayMap*)annotation;
    MKAnnotationView* aView = nil;
    aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if ([locations isKindOfClass:[DisplayMap class]])
    {
        if (!aView) {
            aView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"] autorelease];
        }
        
        // now configure the view
        
        aView.canShowCallout = NO;
        aView.enabled = YES;
		
		if (locations.imgEgo)
		{
			UIImage * annotationImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.strSelectedGoogleCategory]];

			
			aView.image = annotationImage;
		}
		else
		{
			aView.image = [UIImage imageNamed:@"map-red-button.png"];
		}
        
        
        return aView;
    }
    else
    {
        return nil;
    }
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    DisplayMap *csMapAnn = (DisplayMap *)view.annotation;
    
    
    if (![csMapAnn isKindOfClass:[MKUserLocation class]])
    {
        [mapView deselectAnnotation:view.annotation animated:NO];
        
        self.displayObj = csMapAnn;
        
		[self addCalloutOnMap:csMapAnn];
		
		//Drag map if required
        if([self isDragMapForCalloutRequired:csMapAnn])
        {
            // if draging is required need to replace the callout
            [self performSelector:@selector(addCalloutOnMap:) withObject:csMapAnn afterDelay:0.5];
        }
		
		
    }
    
}
-(void)addCalloutOnMap:(DisplayMap*)csMapAnn
{
	CGPoint newCenter = [aMapView convertCoordinate:csMapAnn.coordinate toPointToView:aMapView];
	
	NSLog(@" point %@",NSStringFromCGPoint(newCenter));
	[mapCallOutView setFrame:CGRectMake(newCenter.x-100, newCenter.y-60, mapCallOutView.frame.size.width, mapCallOutView.frame.size.height)];
	MyAddressBook *aContact = csMapAnn.aPerson;
	BOOL file  =   [[NSFileManager defaultManager] fileExistsAtPath:aContact.image];
	if (file)
	{
		[imgVContact setImage:[UIImage imageWithContentsOfFile:aContact.image]];
	}
	else
	{
		[imgVContact setImage:[UIImage imageNamed:@"ipad_user_img.png"]];
	}
   NSPredicate* predicate = [NSPredicate predicateWithFormat:@"stageID == %d",[aContact.funnelStageID integerValue]];
    NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    FunnelStageList *aFunnel = [arrayFunnel lastObject];
	[lblUsername setText:csMapAnn.title];
	[lblAddress setText:aContact.organisation];
    [lblFunnelStage setText:aFunnel.stageName];
	NSLog(@" Callout point %@",NSStringFromCGRect(mapCallOutView.frame));
	
	[self.view addSubview:mapCallOutView];
}
-(BOOL)isDragMapForCalloutRequired:(DisplayMap*)ann
{
	BOOL isRequired = NO;
	
	//definate rect where the
	if (!(CGRectContainsRect(aMapView.frame,mapCallOutView.frame )))
	{
		NSLog(@"Drag required");
		isRequired = YES;
		// if the rect is not inside view properly
        
		//remove the previous
		[mapCallOutView removeFromSuperview];
		
		// getting cgpoint of mapview center
		CGPoint centerOfMap = [aMapView convertCoordinate:aMapView.region.center toPointToView:aMapView];
		
		
		
		if (mapCallOutView.frame.origin.x < 0)//check for left edge
		{
			centerOfMap.x -= (16 + fabsf(mapCallOutView.frame.origin.x));
		}
		//this is the last point of callout											//and this is map width
		else if (mapCallOutView.frame.origin.x + mapCallOutView.frame.size.width > aMapView.frame.size.width)//check for right edge
		{
			NSLog(@" %f",(aMapView.frame.size.width - (mapCallOutView.frame.origin.x + mapCallOutView.frame.size.width)));
			float diff = (aMapView.frame.size.width - (mapCallOutView.frame.origin.x + mapCallOutView.frame.size.width));
			centerOfMap.x += fabsf(diff);
		}
		
		NSLog(@"Map point %@ callout : %@",NSStringFromCGPoint(aMapView.frame.origin),NSStringFromCGPoint(mapCallOutView.frame.origin));
		if (aMapView.frame.origin.y > mapCallOutView.frame.origin.y )
		{
			centerOfMap.y -= (aMapView.frame.origin.y - mapCallOutView.frame.origin.y);
			centerOfMap.x =	[aMapView convertCoordinate:aMapView.region.center toPointToView:aMapView].x;
		}
		
		CLLocationCoordinate2D coordinate = [aMapView convertPoint:centerOfMap toCoordinateFromView:aMapView];
		
		MKCoordinateRegion region;
		region.center = coordinate;
		region.span = aMapView.region.span;
		
		[aMapView setRegion:region animated:YES];
		
		
	}
	
	return isRequired;
}

-(void)addAnnotations
{
    // set call out to default
	self.typeOfCallout = CallOutTypeUserDetails;
    [aMapView setMapType:MKMapTypeStandard];
	[aMapView setZoomEnabled:YES];
	[aMapView setScrollEnabled:YES];
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSLog(@"%f %f",aMapView.userLocation.coordinate.latitude,aMapView.userLocation.coordinate.longitude);
	region.center.latitude = aMapView.userLocation.coordinate.latitude ;
	region.center.longitude = aMapView.userLocation.coordinate.longitude;
	region.span.longitudeDelta = 1.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
	region.span.latitudeDelta = 1.0f;
	[aMapView setRegion:region animated:YES];
	
    NSMutableArray *annotaions = [NSMutableArray array];
	for(int i=0 ; i<[self.arrMyAddressBook count] ; i++)
    {
        MyAddressBook *aContact = [self.arrMyAddressBook objectAtIndex:i];
        
        NSArray *arr = [NSArray arrayWithArray:[[aContact relAllAddress]allObjects]];
        NSLog(@"%@",aContact);
		for (AllAddress *aAddress in arr)
		{
			DisplayMap *ann = [[DisplayMap alloc] init];
			
			ann.title = aAddress.personName;
			
			ann.subtitle = [(aAddress.countryCode)?aAddress.countryCode:@"" stringByAppendingFormat:@" %@",(aAddress.state)?aAddress.state:@""];
			ann.aPerson = aContact;
			
			CLLocationCoordinate2D location ;
			location.latitude = [aAddress.latitude doubleValue];
			location.longitude= [aAddress.longitude doubleValue];
			
			ann.coordinate =location;
			[annotaions addObject:ann];
			[ann release];
		}
       
    }
    
	[aMapView addAnnotations:annotaions];
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
#pragma mark- CLLocationManagerDelegate Method
- (void)startLocationManager
{
    self.locationManager	=	[[[CLLocationManager alloc] init] autorelease];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
	[self.locationManager setDelegate:self];
	[self.locationManager setDistanceFilter:20];
    
    [self.locationManager startUpdatingLocation];
}
- (void)stopLocationManager
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    [locationManager release];
    locationManager = nil;
}
//iOS-5 and earlier
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"location");
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSLog(@"%f %f",aMapView.userLocation.coordinate.latitude,aMapView.userLocation.coordinate.longitude);
	region.center.latitude = newLocation.coordinate.latitude ;
	region.center.longitude = newLocation.coordinate.longitude;
	region.span.longitudeDelta = 1.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
	region.span.latitudeDelta = 1.0f;
	[aMapView setRegion:region animated:YES];
    
    [self stopLocationManager];
}

//iOS-6 and later
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	NSLog(@"location");
    CLLocation *newLocation					=	[locations lastObject];
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSLog(@"%f %f",aMapView.userLocation.coordinate.latitude,aMapView.userLocation.coordinate.longitude);
	region.center.latitude = newLocation.coordinate.latitude ;
	region.center.longitude = newLocation.coordinate.longitude;
	region.span.longitudeDelta = 1.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
	region.span.latitudeDelta = 1.0f;
	[aMapView setRegion:region animated:YES];    
    [self stopLocationManager];
    
}
#pragma mark - Get Latitude and Longitude
-(CLLocationCoordinate2D) addressLocation:(NSString *)searchedLocation
{
  /************************  NOTICE HERE  *************************/
    
//    If we found this message in response then we need to handle this but is very very rare case.This is due to we have completed 2500 api calls in one day that is allowed by google.
    /*
     {
     "results" : [],
     "status" : "OVER_QUERY_LIMIT"
     }
 */
    
    NSLog(@"%@",searchedLocation);
    
    if ([searchedLocation isEqualToString:@"2962 Dunedin Cv New York NY USA 21369"])
    {
        NSLog(@"%@",searchedLocation);
    }
    
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

#pragma mark - Create Filter
-(void)resetAllFilterTextField
{
	for (id subViews in mapFilterView.subviews)
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
    for (id subViews in vwCategoryView.subviews)
	{
		if ([subViews isKindOfClass:[UITextField class]])
		{
			UITextField * txtFilter = (UITextField*)subViews;
			[txtFilter setText:@""];
		}
	}
	
	[switchProposal setOn:NO];

}
-(void)applyFilter:(BOOL)filterData
{
	
	// remove any data from dropDown
	[self.dropDownVWOnTop.myLabel setText:@""];
	
	BOOL isAllCustomerSelected = NO;
	
	AppDelegate * aDelegate = CRM_AppDelegate;

	NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
	
	for (id subItems in mapFilterView.subviews)
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
						dict = [NSDictionary dictionaryWithObject:funnel.stageName forKey:@"funnelStageID"];
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
				else if(txtFilter.tag == 110)// City
				{
					dict = [NSDictionary dictionaryWithObject:txtFilter.text forKey:@"relAllAddress.city"];
				}
                else if(txtFilter.tag == 111)// Distance
				{
                    CLLocationCoordinate2D restrictLocation = [self addressLocation:txtFilter.text];
					dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:restrictLocation.latitude], @"relAllAddress.latitude", [NSNumber numberWithFloat:restrictLocation.longitude], @"relAllAddress.longitude", nil];
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
	
    //if we are getting any crash like (RHS of Any Or all should be an array or set)
	// then we need to constrat on the Any which is placed in this methord
	
	// we can check the key in the dictionary where keys can be with or without dot (.)
	// can use this to differentiate..

	NSPredicate * predicate = [self getPredicateForFilterWithArray:array];
	
	NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];

	NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
	
	if (switchProposal.on)
	{
		for (MyAddressBook * addressBookObj in arraData)
		{
			NSArray * arrayProposal = [[addressBookObj relProposal] allObjects];
			
			for (ProposalList * proposalObj in arrayProposal)
			{
				[mArray addObject:addressBookObj];
			}
		}
	}
	else
	{
		[mArray addObjectsFromArray:arraData];
	}
	
	if (filterData)
	{
		self.arrMyAddressBook = [NSMutableArray arrayWithArray:mArray];
		
		if([aMapView.annotations count])
		{
			[aMapView removeAnnotations:aMapView.annotations];
			[self performSelector:@selector(addanotationAccordingToFilter:) withObject:array afterDelay:0.0];
		}
		else
		{
			[self addanotationAccordingToFilter:array];
		}
	}else
	{
		GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
        
        GDP.arrMyAddressBookData  = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
		self.arrMyAddressBook  = GDP.arrMyAddressBookData;
		
		if([aMapView.annotations count])
		{
			[aMapView removeAnnotations:aMapView.annotations];
			[self performSelector:@selector(addAnnotations) withObject:nil afterDelay:0.0];
		}
		else
		{
			[self addAnnotations];
		}
	}
	
	
}

// this methord will generate a pridicate with AND (LIKE) query
//Don't get confuse
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
-(NSPredicate *)getORPredicateForFilterWithArray:(NSArray*)arrDict
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
			
			predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObjects:predicate,newPredicate, nil]];
			
		}
	}
	return predicate;
}
-(void)addanotationAccordingToFilter:(NSArray *)arrayFilter
{
    // set call out to default
	self.typeOfCallout = CallOutTypeUserDetails;
    
	// remove any privious callout view
	
    [mapCallOutView removeFromSuperview];
	@try {
		NSMutableArray * addressArray = [NSMutableArray arrayWithCapacity:0];
		MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
		[aMapView setMapType:MKMapTypeStandard];
		[aMapView setZoomEnabled:YES];
		[aMapView setScrollEnabled:YES];
		
		NSMutableArray *annotaions = [NSMutableArray array];
		
		// if distance is restrected in perticular location
		BOOL isDistRestrict = NO;
		CLLocationCoordinate2D restrictLocation;
		if ([txtFromLocation.text length] && [txtRestrectedMile.text length])
		{
			restrictLocation = [self addressLocation:txtFromLocation.text];
			isDistRestrict = YES;
		}
		
		for(int i=0 ; i<[self.arrMyAddressBook count] ; i++)
		{
			MyAddressBook *aContact = [self.arrMyAddressBook objectAtIndex:i];
			
			
			//        NSLog( @"Set %@",[aContact relAllAddress]);
			NSArray *arr = [NSArray arrayWithArray:[[aContact relAllAddress]allObjects]];
			
			for (AllAddress *aAddress in arr)
			{
				
				//--
				// Case when the same user have multiple Location
				// so we reqire to skip the locations which is not according to the filter
				//--
				
				BOOL shouldAddAnnotation  = YES;
				for (NSDictionary * dictRecived in arrayFilter)
				{
					NSString * key = [[dictRecived allKeys] lastObject];
					if ([key rangeOfString:@"countryCode"].length)
					{
						// Fiter for contry
						if (![aAddress.countryCode rangeOfString:[dictRecived objectForKey:key] options:NSCaseInsensitiveSearch].length)
						{
							shouldAddAnnotation = NO;
						}
					}
					else if ([key rangeOfString:@"zipCode"].length)
					{
						// Fiter for Zip Code
						if (![aAddress.zipCode rangeOfString:[dictRecived objectForKey:key] options:NSCaseInsensitiveSearch].length)
						{
							shouldAddAnnotation = NO;
						}
					}
					else if ([key rangeOfString:@"street"].length)
					{
						// Fiter for Street
						if (![aAddress.street rangeOfString:[dictRecived objectForKey:key] options:NSCaseInsensitiveSearch].length)
						{
							shouldAddAnnotation = NO;
						}
					}
					if ([key rangeOfString:@"City"].length)
					{
						// Fiter for City
						if (![aAddress.city rangeOfString:[dictRecived objectForKey:key] options:NSCaseInsensitiveSearch].length)
						{
							shouldAddAnnotation = NO;
						}
					}
					
				}
				
				if (!shouldAddAnnotation)
				{
					continue;
				}
				CLLocationCoordinate2D location ;
				location.latitude = [aAddress.latitude doubleValue];
				location.longitude= [aAddress.longitude doubleValue];
				
				
				//Check for location disance
				if (isDistRestrict)
				{
					CLLocation  * fromocation = [[[CLLocation alloc]initWithLatitude:restrictLocation.latitude longitude:restrictLocation.longitude] autorelease];
					
					CLLocation  * addBookuserLocation = [[[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude] autorelease];
					CLLocationDistance Km = [addBookuserLocation distanceFromLocation:fromocation]/1609.34; //convert into miles
					
					NSLog(@"Distance : %f",Km);
					if (Km > [txtRestrectedMile.text doubleValue])
					{
						continue;
					}
					
				}
				
				[addressArray addObject:aAddress];
				DisplayMap *ann = [[[DisplayMap alloc] init] autorelease];
				ann.title = aAddress.personName;
				
				ann.subtitle = [(aAddress.countryCode)?aAddress.countryCode:@"" stringByAppendingFormat:@" %@",(aAddress.state)?aAddress.state:@""];
				ann.aPerson = aContact;
				ann.coordinate =location;
				[annotaions addObject:ann];
			}
			
		}
		
		[aMapView addAnnotations:annotaions];
		
		
		//Setting Location on Map
		
		if ([self.arrMyAddressBook count]==0)
		{
			// In case we haven't find any contact in the address book according to the filter search
			// So we need to move to filter locations.
			
			
			//First we try to move to country
            UITextField * txtCity = (UITextField*)[mapFilterView viewWithTag:110];
            UITextField * txtState = (UITextField*)[mapFilterView viewWithTag:107];
			UITextField * txtCountry = (UITextField*)[mapFilterView viewWithTag:103]; 
			
			if ([txtCity isKindOfClass:[UITextField class]] && [txtCity.text length])
			{
//				if ([txtCity.text length])
				{
					CLLocationCoordinate2D location = [self addressLocation:[txtCity.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    region.center = location;
                    MKCoordinateSpan span;
                    
                    double miles = 20 + 2.015;
                    double scalingFactor = ABS( (cos(2 * M_PI * location.latitude / 360.0) ));
                    
                    span.latitudeDelta = miles/69.0;
                    span.longitudeDelta = miles/(scalingFactor * 69.0);
                    region.span = span;
				}
			}
            else if ([txtState isKindOfClass:[UITextField class]] && [txtState.text length])
			{
//				if ([txtState.text length])
				{
					CLLocationCoordinate2D location = [self addressLocation:[txtState.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    region.center = location;
                    MKCoordinateSpan span;
                    
                    double miles = 50 + 2.015;
                    double scalingFactor = ABS( (cos(2 * M_PI * location.latitude / 360.0) ));
                    
                    span.latitudeDelta = miles/69.0;
                    span.longitudeDelta = miles/(scalingFactor * 69.0);
                    region.span = span;
				}
			}
            else if ([txtCountry isKindOfClass:[UITextField class]] && [txtCountry.text length])
			{
//				if ([txtCountry.text length])
				{
					CLLocationCoordinate2D location = [self addressLocation:[txtCountry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    region.center = location;
                    MKCoordinateSpan span;
                    
                    double miles = 1500 + 2.015;
                    double scalingFactor = ABS( (cos(2 * M_PI * location.latitude / 360.0) ));
                    
                    span.latitudeDelta = miles/69.0;
                    span.longitudeDelta = miles/(scalingFactor * 69.0);
                    region.span = span;
				}
			}
            else if ([txtSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length)
			{
                //				if ([txtCountry.text length])
				{
					CLLocationCoordinate2D location = [self addressLocation:[txtSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    region.center = location;
                    MKCoordinateSpan span;
                    
                    double miles = 1500 + 2.015;
                    double scalingFactor = ABS( (cos(2 * M_PI * location.latitude / 360.0) ));
                    
                    span.latitudeDelta = miles/69.0;
                    span.longitudeDelta = miles/(scalingFactor * 69.0);
                    region.span = span;
				}
			}
            else
            {
                [self startLocationManager];
            }
            
			
//			region.span.longitudeDelta = 180.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
//			region.span.latitudeDelta = 180.0f;
		}
		else if ([addressArray count] == 1)// single user recived mark the region as center
		{
			
			AllAddress *aAddress = [addressArray lastObject];
			
			region.center.latitude = [aAddress.latitude doubleValue];
			region.center.longitude = [aAddress.longitude doubleValue];
			region.span.longitudeDelta = 1.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
			region.span.latitudeDelta = 1.0f;
		}
		else if(([addressArray count] > 1) && !isDistRestrict)// multiple members
		{
			double minLat   =   0.0;
			double maxLat   =   0.0;
			double minLong  =   0.0;
			double maxLong  =   0.0;
			
			for (AllAddress *aAddress in addressArray)
			{
				if(!minLat || (minLat > [aAddress.latitude doubleValue]))
					minLat = [aAddress.latitude doubleValue];
				
				if(!maxLat || (maxLat < [aAddress.latitude doubleValue]))
					maxLat = [aAddress.latitude doubleValue];
				
				if(!minLong || (minLong > [aAddress.longitude doubleValue]))
					minLong = [aAddress.longitude doubleValue];
				
				if(!maxLong || (maxLong < [aAddress.longitude doubleValue]))
					maxLong = [aAddress.longitude doubleValue];
			}
			
			double lat = (minLat+ maxLat)/2;
			double log = (minLong + maxLong)/2;
			NSLog(@"%f %f",lat,log);
			
			CLLocation *midLocation = [[CLLocation alloc] initWithLatitude:lat longitude:log];
			CLLocationCoordinate2D coord = [midLocation coordinate];
			region.center = coord;
			
			[midLocation release];
			
			
			//Define spam
			region.span.latitudeDelta = (maxLat - minLat) * 1.1;
			region.span.latitudeDelta = (region.span.latitudeDelta < 0.01)?0.01:region.span.latitudeDelta;
			region.span.longitudeDelta = (maxLong  - minLong) * 1.1;
			
			
			region = [aMapView regionThatFits:region];
			
		}
		else if(isDistRestrict)
		{
			region.center = restrictLocation;
			
			double miles = [txtRestrectedMile.text doubleValue] + 2.015;
			double scalingFactor = ABS( (cos(2 * M_PI * restrictLocation.latitude / 360.0) ));
			
			MKCoordinateSpan span;
			
			span.latitudeDelta = miles/69.0;
			span.longitudeDelta = miles/(scalingFactor * 69.0);
			
			if (span.latitudeDelta > 180 && span.longitudeDelta > 180)
			{
				span.latitudeDelta = 180;
				span.longitudeDelta = 180;
			}
			region.span = span;
			
		}
		
		region = [self checkValidRegion:region];
		[aMapView setRegion:region animated:YES];
	}
	@catch (NSException *exception) {
		NSLog(@"Exception %@",exception.reason);
	}
	@finally {
		
	}
}
#pragma mark - UITextFiled
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtSearchField)
    {
        for (UIView *vw in aMapView.subviews)
        {
            if ([vw isKindOfClass:[SPUserResizableView class]])
            {
                UIButton *sender = (UIButton*)[self.view viewWithTag:100];
                [sender setSelected:NO];
                [vw removeFromSuperview];
                break;
            }
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag == 200 && [textField.text length])//search textFiled
	{
		[self resetAllFilterTextField];
		
		AppDelegate * aDelegate = CRM_AppDelegate;
		
		self.arrMyAddressBook = [NSMutableArray arrayWithCapacity:0];
        
		{
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
			
			// MyAddressBook
			NSDictionary *attributes = [[NSEntityDescription entityForName:@"MyAddressBook" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * key in attributes)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@" ,key]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			[self.arrMyAddressBook addObjectsFromArray:arraData];
		}
        
        // AllAddress
		{
            
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
			
			
			NSDictionary *attAddress = [[NSEntityDescription entityForName:@"AllAddress" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * keys in attAddress)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@",keys]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"AllAddress" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			for (AllAddress * address in arraData)
			{
				if (![self.arrMyAddressBook containsObject:address.relMyAddressBook])
				{
					[self.arrMyAddressBook addObject:address.relMyAddressBook];
				}
				
			}
		}
        
        // AllPhone
		{
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
			
			
			
			NSDictionary *attrPhone = [[NSEntityDescription entityForName:@"AllPhone" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * keys in attrPhone)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@",keys]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"AllPhone" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			for (AllPhone * phones in arraData)
			{
				if (![self.arrMyAddressBook containsObject:phones.relMyAddressBook])
				{
					[self.arrMyAddressBook addObject:phones.relMyAddressBook];
				}
				
			}
			
			
		}
        
        // All email
		{
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];

			NSDictionary *attAllEmail = [[NSEntityDescription entityForName:@"AllEmail" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * keys in attAllEmail)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@",keys]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"AllEmail" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			
			for (AllEmail * email in arraData)
			{
				if (![self.arrMyAddressBook containsObject:email.relMyAddressBook])
				{
					[self.arrMyAddressBook addObject:email.relMyAddressBook];
				}
				
			}
			
			
		}
        
        // dates
		{
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];

			NSDictionary *attAddress = [[NSEntityDescription entityForName:@"AllDate" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * keys in attAddress)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@",keys]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"AllDate" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			for (AllDate * address in arraData)
			{
				if (![self.arrMyAddressBook containsObject:address.relMyAddressBook])
				{
					[self.arrMyAddressBook addObject:address.relMyAddressBook];
				}
				
			}
		}
        
        // url
		{
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
			
			NSDictionary *attAddress = [[NSEntityDescription entityForName:@"AllUrl" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * keys in attAddress)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@",keys]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"AllUrl" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			for (AllUrl * address in arraData)
			{
				if (![self.arrMyAddressBook containsObject:address.relMyAddressBook])
				{
					[self.arrMyAddressBook addObject:address.relMyAddressBook];
				}
				
			}
		}
        
		
        // releated name
		{
			
			NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
			
			NSDictionary *attAddress = [[NSEntityDescription entityForName:@"AllRelatedName" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]] attributesByName];
			
			for (NSString * keys in attAddress)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObject:txtSearchField.text forKey:[NSString stringWithFormat:@"%@",keys]];
				[array addObject:dict];
			}
			
			NSPredicate * predicate = [self getORPredicateForFilterWithArray:array];
			
			NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"AllRelatedName" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
			
			for (AllRelatedName * address in arraData)
			{
				if (![self.arrMyAddressBook containsObject:address.relMyAddressBook])
				{
					[self.arrMyAddressBook addObject:address.relMyAddressBook];
				}
				
			}
		}
        
		
		[self performSelector:@selector(start) withObject:nil afterDelay:0.1];
		
        
		
		//textFiled search disable
		[txtSearchField setEnabled:NO];
//		[imgSearch setHidden:YES];
//		[indicator startAnimating];
	}
	[textField resignFirstResponder];
	return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *rawString = [[textField text] stringByAppendingString:string];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        return NO;
    }
    if(textField.superview == vwCategoryView)
    {
        self.pagetoken = nil;
        self.categoryResultArray = nil;
    }
    return YES;
}
//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//                         change:(NSDictionary *)change context:(void *)context
//{
//    if (object == self.queue && [keyPath isEqualToString:@"operations"]) {
//        if ([self.queue.operations count] == 0) {
//            // Do something here when your queue has completed
//            NSLog(@"queue has completed");
//			
//			
//			[self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
//        }
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object
//                               change:change context:context];
//    }
//}

-(void)start
{
	
	if([aMapView.annotations count])
	{
		[aMapView removeAnnotations:aMapView.annotations];
		[self performSelector:@selector(addanotationAccordingToFilter:) withObject:nil afterDelay:0.0];
	}
	else
	{
		[self addanotationAccordingToFilter:nil];
	}
	
	[self.dropDownVWOnTop.myLabel setText:@""];
	
	//textFiled search enable
	[txtSearchField setEnabled:YES];
//	[imgSearch setHidden:NO];
//	[indicator stopAnimating];
}

#pragma mark - UISearchBar Delegate

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
	if (self.typePopover == typeIndustry)
	{
		//Search for Industry
		
		NSPredicate *predicate = nil;
		if ([txtIndustrySearch.text length])
		{
			predicate = [NSPredicate predicateWithFormat:@"ANY industryName CONTAINS[cd] %@",txtIndustrySearch.text];
		}
		
		NSArray *array = [CoreDataHelper searchObjectsForEntity:@"Industries" withPredicate:predicate andSortKey:@"industryName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		
		self.arrayIndustry = [NSMutableArray arrayWithArray:array];
	}
	else
	{
		// Search for google category
		
		NSPredicate *predicate = nil;
		if ([txtIndustrySearch.text length])
		{
			predicate = [NSPredicate predicateWithFormat:@"ANY categoryName CONTAINS[cd] %@",txtIndustrySearch.text];
		}
		
		NSArray *array = [CoreDataHelper searchObjectsForEntity:@"GoogleCategory" withPredicate:predicate andSortKey:@"categoryName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		
		self.arrayIndustry = [NSMutableArray arrayWithArray:array];
	}
	
	[tableIndustry reloadData];
}


#pragma mark - IBAction methods
- (void)resignMapFilterFields
{
    for (UITextField * textFiled in mapFilterView.subviews)
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
}
- (IBAction)btnIndTapped:(UIButton *)sender
{
	//Define the type of popover for searchView
	self.typePopover = typeIndustry;
	
    [self resignMapFilterFields];
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
		[tableIndustry reloadData];
	}
	
	[txtIndustrySearch resignFirstResponder];
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	[self.popoverIndustry presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (IBAction)btnFunnelStageTapped:(UIButton*)sender
{
    [self resignMapFilterFields];
	if (self.dropDownVw) {
		[dropDownVw removeFromSuperview];
		[dropDownVw release];
		dropDownVw = nil;
	}
	
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	//	CGRect rect = []
	self.dropDownVw = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
	[self.dropDownVw setBackgroundColor:[UIColor clearColor]];
	self.dropDownVw.DDType = DDFunnelStage;
	[self downloadDropDownData];
	[self.view addSubview:self.dropDownVw];
	
	// open dropDown with som delay because it won't work otherwise
	[self.dropDownVw performSelector:@selector(openDropDown) withObject:nil afterDelay:0.1];
}

- (IBAction)btnLeadStatus:(UIButton*)sender
{
    [self resignMapFilterFields];
	if (self.dropDownVw) {
		[dropDownVw removeFromSuperview];
		[dropDownVw release];
		dropDownVw = nil;
	}
	
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	//	CGRect rect = []
	self.dropDownVw = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
	[self.dropDownVw setBackgroundColor:[UIColor clearColor]];
	self.dropDownVw.DDType = DDLeadStatus;
	[self downloadDropDownData];
	[self.view addSubview:self.dropDownVw];
	
	// open dropDown with som delay because it won't work otherwise
	[self.dropDownVw performSelector:@selector(openDropDown) withObject:nil afterDelay:0.1];
}

- (IBAction)btnLeadSourceTapped:(UIButton *)sender {
    [self resignMapFilterFields];
	if (self.dropDownVw) {
		[dropDownVw removeFromSuperview];
		[dropDownVw release];
		dropDownVw = nil;
	}
	
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	//	CGRect rect = []
	self.dropDownVw = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
	[self.dropDownVw setBackgroundColor:[UIColor clearColor]];
	self.dropDownVw.DDType = DDLeadSource;
	[self downloadDropDownData];
	[self.view addSubview:self.dropDownVw];
	
	// open dropDown with som delay because it won't work otherwise
	[self.dropDownVw performSelector:@selector(openDropDown) withObject:nil afterDelay:0.1];
}
- (IBAction)btnApplyFilter:(UIButton *)sender
{
    if(btnCreateGroup.isHidden)
        [btnCreateGroup setHidden:NO];
    
    if(btnDone.isHidden)
        [btnDone setHidden:NO];
    
	[self removeFilterViewAndTouch];
	
	[self applyFilter:YES];
}
-(void)removeFilterViewAndTouch
{
	for (int i = 0; i < [self.view.subviews count]; i++)
	{
		UIView * viewSub = [self.view.subviews objectAtIndex:i];
		if ([viewSub isMemberOfClass:[TouchView class]]) {
			[viewSub removeFromSuperview];
		}
	}
	
	[mapFilterView  removeFromSuperview];
    [mapCallOutView removeFromSuperview];
    [vwCategoryView removeFromSuperview];
	
}
- (IBAction)btnDoneTapped:(id)sender
{
    //Flurry
	UIButton * btn = (UIButton*)sender;
	NSString * string =  [NSString stringWithFormat:@"Graph Screen %@",btn.titleLabel.text];
	
	[AppDelegate setFlurryWithText:string];
    
	BOOL find = NO;
	for (UIView *vw in aMapView.subviews)
	{
		if ([vw isKindOfClass:[SPUserResizableView class]])
		{
			find = YES;
			break;
		}
	}
	
    
	if (find)
	{
        NSString *tittle = @"";
        self.arrSelected = [NSMutableArray array];
        int count = 0;
		for (id annotation in aMapView.annotations)
		{
            DisplayMap *csMapAnn = (DisplayMap *)annotation;
            
            // if its a google category
            if (![csMapAnn isKindOfClass:[MKUserLocation class]])
            {
                if (csMapAnn.imgEgo)
                {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please add these contacts into app address book to supply for the group." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    break;
                }
                CGPoint newCenter = [aMapView convertCoordinate:csMapAnn.coordinate toPointToView:aMapView];
                
                if (CGRectContainsPoint(userResizableView.frame, newCenter))
                {
                    
                    NSLog(@"csMap :%@",csMapAnn.title);
                    
                    if (csMapAnn.title.length)
                    {
                        if([tittle rangeOfString:csMapAnn.title options:NSCaseInsensitiveSearch].length == 0)
                        {
                            count++;
                            tittle = [tittle stringByAppendingFormat:@"%@\n",csMapAnn.title];
                            [self.arrSelected addObject:csMapAnn.aPerson];
                        }
                    }
                    else
                    {
                        count++;
                        [self.arrSelected addObject:csMapAnn.aPerson];
                    }
                    
                }
            }
		}
        if (count)
        {
            NSString *message = [NSString stringWithFormat:@"%@\nDo you want to add to group?",tittle];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"You have selected:" message:message delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            [alert show];
            [alert release];
        }
        
        
	}
}

- (IBAction)btnCreateGroupTapped:(UIButton*)sender
{
    if ([txtSearchField isFirstResponder])
    {
        [txtSearchField resignFirstResponder];
    }
    //Flurry
	NSString * string =  [NSString stringWithFormat:@"Map Screen %@",sender.titleLabel.text];
	[AppDelegate setFlurryWithText:string];
    
	BOOL find = NO;
	
	sender.selected = !sender.selected;
	for (UIView *vw in aMapView.subviews)
	{
		if ([vw isKindOfClass:[SPUserResizableView class]])
		{
			
			sender.titleLabel.text = @"Create Group";
			[vw removeFromSuperview];
			find = YES;
			break;
		}
	}
    
	if (!find) {
		CGRect gripFrame = CGRectMake(50, 50, 200, 150);
		userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
		
		UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
		[contentView setBackgroundColor:[UIColor grayColor]];
		[contentView setAlpha:0.6];
		userResizableView.contentView = contentView;
		
		userResizableView.delegate = self;
		[userResizableView showEditingHandles];
		
		[aMapView addSubview:userResizableView];
		[userResizableView release];
		[contentView release];
	}

}
- (IBAction)btnFetchMore:(id)sender
{
    [self btnApplyGoogleCategorySearch:nil];
}

-(IBAction)btnMapFilterTapped:(UIButton*)sender
{
    TouchView *aTouchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [aTouchView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [aTouchView setDelegate:self];
//	[aTouchView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:aTouchView];
    [aTouchView release];
    [mapFilterView setFrame:CGRectMake(22, 52, mapFilterView.frame.size.width, mapFilterView.frame.size.height)];
//	[mapFilterView setAlpha:1.0];
    [self.view addSubview:mapFilterView];
    
    rectVwFilter = mapFilterView.frame;

}

- (IBAction)btnresetFilter:(UIButton *)sender
{
    // set call out to default
    if(btnCreateGroup.isHidden)
        [btnCreateGroup setHidden:NO];
    
    if(btnDone.isHidden)
        [btnDone setHidden:NO];
    
    self.pagetoken = nil;
    self.categoryResultArray = nil;
	self.typeOfCallout = CallOutTypeUserDetails;
    
	[self resetAllFilterTextField];
    [self removeFilterViewAndTouch];
    [self applyFilter:NO];
    
}

- (IBAction)btnOptionButtonsTapped:(UIButton *)sender
{
	for (UIButton * btn in mapFilterView.subviews)
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
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 101)
	{
		if (buttonIndex == 1)
		{
			// save call out user details as contact
			
			[self addCategoryAsContact];
		}
	}
	else
	{
		if (buttonIndex == 0)
		{
			SettingsViewController *settings = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
			[settings setArrMapSelectedContact:arrSelected];
			[settings setIsFromMapView:YES];
			[self.navigationController pushViewController:settings animated:YES];
			[settings release];
			arrSelected = nil;
		}
	}
	
}
#pragma mark - DropDownView
- (void)createDropDownOnTop
{
    CGRect rect = [imgVDropDownBg convertRect:imgVDropDownBg.bounds toView:self.view];
	self.dropDownVWOnTop = [[[DropDownView alloc] initWithFrame:rect target:self] autorelease];
	[self.dropDownVWOnTop setBackgroundColor:[UIColor clearColor]];
	self.dropDownVWOnTop.DDType = DDFilterOnMap;
	NSArray * arr = @[@"Email",
                   @"Call",
                   @"Follow up",
                   @"Appointment",
                   @"Group",
                   @"Subgroup"];
	[self.dropDownVWOnTop setDataArray:arr];
	[self.view addSubview:self.dropDownVWOnTop];
	
	// Autoresizing
	
	[self.dropDownVWOnTop setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth];
}
- (void)downloadDropDownData
{
	NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
	if (self.dropDownVw.DDType == DDFunnelStage)
	{
		AppDelegate * adel = CRM_AppDelegate;
		NSArray * arrayFunnel = [CoreDataHelper searchObjectsForEntity:@"FunnelStageList" withPredicate:nil andSortKey:@"stageName" andSortAscending:NO andContext:[adel managedObjectContext]];
		
		NSMutableArray * arrayForDrop = [NSMutableArray arrayWithCapacity:0];
		
		
		for (FunnelStageList * funObj in arrayFunnel)
		{
//            if ([funObj.stageID integerValue] != 13)
            {
                [arrayForDrop addObject:funObj.stageName];
            }
			
		}
		
		[List addObjectsFromArray:arrayForDrop];
		
	}
	else if (self.dropDownVw.DDType == DDLeadStatus)
	{
		NSArray * arr = @[@"Lead",@"Opportunity",@"Closed Won",@"Closed Lost",@"Cancelled"];
		[List addObjectsFromArray:arr];
	}
	else if (self.dropDownVw.DDType == DDLeadSource)
	{
		NSArray * arr = @[@"Website",@"Email",@"Tradeshow",@"Referral",@"Direct Mail",@"Call Center",@"Social Media",@"PPC",@"Internal Sales",@"External Sales"];
		[List addObjectsFromArray:arr];
	}
	
	[self.dropDownVw setDataArray:List];
	[List release];
}
-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
	
	if (dropdown == self.dropDownVWOnTop && dropdown.strDropDownValue.length)
	{
		
		// reset filter data
		[self resetAllFilterTextField];
		[txtSearchField setText:@""];
		
		// if dropdown string is equal to group or subgroup
		// we have to search within myadressbook as we can get data through myaddBook.
		// check for not nil;
		
		AppDelegate * aDelegate = CRM_AppDelegate;
		NSPredicate * predicate = nil;
		
		if ([dropdown.strDropDownValue isEqualToString:@"Group"])
		{
			//group selected
            NSArray *groupMembers =  [CoreDataHelper getObjectsForEntity:@"GroupMemberList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            if ([groupMembers count])
            {
                predicate = [NSPredicate predicateWithFormat:@"relGroupList != nil"];
                
                groupMembers = [groupMembers filteredArrayUsingPredicate:predicate];
                
                predicate = nil;
                for (GroupMemberList *grpMem in groupMembers)
                {
                    if (!predicate)
                    {
                        predicate = [NSPredicate predicateWithFormat:@"(recordID CONTAINS[cd] %@)",grpMem.memRecordID];
                    }
                    else
                    {
                        NSPredicate *pdct = [NSPredicate predicateWithFormat:@"(recordID CONTAINS[cd] %@)",grpMem.memRecordID];
                        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObject:pdct]];
                    }
                }
            }
            else
            {
                predicate = [NSPredicate predicateWithFormat:@"(recordID CONTAINS[cd] %@)",@"-999"];
            }
        }
		else if ([dropdown.strDropDownValue isEqualToString:@"Subgroup"])
		{
			//subGroup selected
			NSArray *groupMembers =  [CoreDataHelper getObjectsForEntity:@"GroupMemberList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            if ([groupMembers count])
            {
                predicate = [NSPredicate predicateWithFormat:@"relSubGroup != nil"];
                
                groupMembers = [groupMembers filteredArrayUsingPredicate:predicate];
                
                predicate = nil;
                for (GroupMemberList *grpMem in groupMembers)
                {
                    if (!predicate)
                    {
                        predicate = [NSPredicate predicateWithFormat:@"(recordID CONTAINS[cd] %@)",grpMem.memRecordID];
                    }
                    else
                    {
                        NSPredicate *pdct = [NSPredicate predicateWithFormat:@"(recordID CONTAINS[cd] %@)",grpMem.memRecordID];
                        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:[NSArray arrayWithObject:pdct]];
                    }
                }
            }
            else
            {
                predicate = [NSPredicate predicateWithFormat:@"(recordID CONTAINS[cd] %@)",@"-999"];
            }
		}
        NSArray * arraData = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:predicate andSortKey:nil andSortAscending:YES andContext:[aDelegate managedObjectContext]];
		
		
		// test for email
		NSMutableArray * arrayToPost = [NSMutableArray arrayWithCapacity:0];
		
		/*NSArray * arr = @[@"Email",
		 @"Call",
		 @"Follow up",
		 @"Appointment",
		 @"Group",
		 @"Subgroup"];*/
		
		if (![dropdown.strDropDownValue isEqualToString:@"Group"] && ![dropdown.strDropDownValue isEqualToString:@"Subgroup"])
		{
			for (MyAddressBook * myAddObject in arraData)
			{
				if ([dropDownVWOnTop.strDropDownValue isEqualToString:@"Email"])
				{
					NSArray * array = [[myAddObject relEmailList] allObjects];
					
					if ([array count])
                    {
						[arrayToPost addObject:myAddObject];
                    }
					
				}
				else if ([dropDownVWOnTop.strDropDownValue isEqualToString:@"Call"])
				{
					NSArray * array = [[myAddObject relNotes] allObjects];
					
					if ([array count])
						[arrayToPost addObject:myAddObject];
					
				}
				else if ([dropDownVWOnTop.strDropDownValue isEqualToString:@"Appointment"])
				{
					NSArray * array = [[myAddObject relAppointment] allObjects];
					
					if ([array count])
						[arrayToPost addObject:myAddObject];
					
				}
				else if ([dropDownVWOnTop.strDropDownValue isEqualToString:@"Follow up"])
				{
					NSArray * array = [[myAddObject relFollowUpdate] allObjects];
					
					if ([array count])
						[arrayToPost addObject:myAddObject];
				}
			}

		}
		else
		{
			[arrayToPost addObjectsFromArray:arraData];
		}
	
		self.arrMyAddressBook = [NSMutableArray arrayWithArray:arrayToPost];
	
		if([aMapView.annotations count])
		{
			[aMapView removeAnnotations:aMapView.annotations];
		}
		
		[self performSelector:@selector(addanotationAccordingToFilter:) withObject:nil afterDelay:0.0];
	}
	else
	{
		[self.dropDownVw removeFromSuperview];
		
		for (UITextField * txtF in mapFilterView.subviews)
		{
			if ([txtF isKindOfClass:[UITextField class]])
			{
				if (txtF.tag == 105 && [dropDownVw.strDropDownValue length] && dropdown.DDType == DDFunnelStage)
				{
					txtF.text = [NSString stringWithFormat:@"%@",dropDownVw.strDropDownValue];
					break;
				}
				else if (txtF.tag == 106 && [dropDownVw.strDropDownValue length] && dropdown.DDType == DDLeadStatus)
				{
					txtF.text = [NSString stringWithFormat:@"%@",dropDownVw.strDropDownValue];
					break;
				}
				else if (txtF.tag == 108 && [dropDownVw.strDropDownValue length] && dropdown.DDType == DDLeadSource)
				{
					txtF.text = [NSString stringWithFormat:@"%@",dropDownVw.strDropDownValue];
					break;
				}
			}
		}
	}
	
}
- (void)openDropDown:(DropDownView*)dropdown
{
    
}
#pragma mark - TouchView delegate
- (void)touchesDown:(NSSet *)touches
{
    [mapFilterView removeFromSuperview];
    [vwCategoryView removeFromSuperview];
    UITouch *atouch = [[touches allObjects] lastObject];
    [atouch.view removeFromSuperview];
//	[self resetAllFilterTextField];
}
- (void)touchesUp:(NSSet *)touches
{
}
- (void)viewDidUnload {
	dropDownVWOnTop = nil;
	[switchProposal release];
	switchProposal = nil;
	[txtRestrectedMile release];
	txtRestrectedMile = nil;
	[txtFromLocation release];
	txtFromLocation = nil;
	[txtSearchField release];
	txtSearchField = nil;
    [vwCategoryView release];
	vwCategoryView = nil;
	[txtcategoryLocation release];
	txtcategoryLocation = nil;
	[txtCategory release];
	txtCategory = nil;
	[imgBackGround release];
	imgBackGround = nil;
    [lblFunnelStage release];
    lblFunnelStage = nil;
    [btnFetchMore release];
    btnFetchMore = nil;
	[super viewDidUnload];
}
#pragma mark - UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.arrayIndustry count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		
    }
	if (self.typePopover == typeIndustry)
	{
		Industries * industryObj = [self.arrayIndustry objectAtIndex:indexPath.row];
		[cell.textLabel setText:[NSString stringWithFormat:@"%@",industryObj.industryName]];
	}
	else
	{
		GoogleCategory * googleCat = [self.arrayIndustry objectAtIndex:indexPath.row];
		NSString * string = [googleCat.categoryName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
		[cell.textLabel setText:[NSString stringWithFormat:@"%@",[string capitalizedString]]];
	}
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
	[cell.textLabel setTextColor:[UIColor darkGrayColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.popoverIndustry dismissPopoverAnimated:YES];
	
	if (self.typePopover == typeIndustry)
	{
		for (UITextField * textField in mapFilterView.subviews)
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
        self.pagetoken = nil;
        
		GoogleCategory * category = [self.arrayIndustry objectAtIndex:indexPath.row];
		
		//Prior
        //		[self didSelectGoogleCategory:category.categoryName];
		
		//New
		// Need to set the selected category in the textfiled
		NSString * string = [category.categoryName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
		[txtCategory setText:[string capitalizedString]];
	}
	
}


#pragma mark - Google Category
-(void)insertGoogleCategoryList
{
	AppDelegate * aDelegate = CRM_AppDelegate;
	// if data for industry
	
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"GoogleCategory" withPredicate:nil andSortKey:nil andSortAscending:YES andContext:aDelegate.managedObjectContext];
	
	if (![array count])
	{
		NSString* filePath = [[NSBundle mainBundle] pathForResource:@"GoogleCategoryList" ofType:@"txt"];
		NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		
		NSArray * arrIndustry = [myText componentsSeparatedByString:@"\n"];
		
		for (NSString * text in arrIndustry)
		{
			text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([text length])
			{
				
				GoogleCategory * category = [NSEntityDescription insertNewObjectForEntityForName:@"GoogleCategory" inManagedObjectContext:aDelegate.managedObjectContext];
				
				category.categoryName = [NSString stringWithString:text];
				
				if (![aDelegate.managedObjectContext save:nil])
				{
					NSLog(@"NOT Saved");
				}
				
				
			}
			
		}
	}
}

- (IBAction)btnGoogleCategoryTapped:(UIButton *)sender
{
    
    // so we can differentiate b/w two callouts
	self.typeOfCallout = CallOutTypeGoogleCategory;
    
	self.typePopover = typeGoogleCategory;
	
	[self resignMapFilterFields];
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
		
		NSArray * array  = [CoreDataHelper searchObjectsForEntity:@"GoogleCategory" withPredicate:nil andSortKey:@"categoryName" andSortAscending:YES andContext:adelegate.managedObjectContext];
		
		self.arrayIndustry = [NSMutableArray arrayWithArray:array];
		
		[tableIndustry reloadData];
	}
	
	[txtIndustrySearch resignFirstResponder];
    
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	[self.popoverIndustry presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

-(void)didSelectGoogleCategory:(NSString*)categoryName
{
	//Hide the vwFilter
	[self removeFilterViewAndTouch];
	
	[SVProgressHUD showWithStatus:@"Retrieving Geolocation Data"];
	[self performSelector:@selector(loadcatgoryWithCategory:) withObject:categoryName afterDelay:0.1];
    
	
	
}
-(void)loadcatgoryWithCategory:(NSString*)category
{
	
	// Set selected google category
	self.strSelectedGoogleCategory = [NSString stringWithString:category];
	
//	double lat = aMapView.userLocation.coordinate.latitude;
//	double longi = aMapView.userLocation.coordinate.longitude;
    
    //new
	double lat = coordinateLocGoogleCategory.latitude;
	double longi = coordinateLocGoogleCategory.longitude;

	
	NSArray * array = [self getArrayForGoogleCategory:category
									  withLocationLat:[NSString stringWithFormat:@"%f",lat]
											  andLong:[NSString stringWithFormat:@"%f",longi]
											   radius:[NSString stringWithFormat:@"%@",kMinRadius]];
	
	
	//remove all annotations
	[aMapView removeAnnotations:aMapView.annotations];
	
	//If callout remove from superview
	if (mapCallOutView.superview)
	{
		[mapCallOutView removeFromSuperview];
	}
	
	//Addanotations
	if ([array count])
	{
		[self performSelector:@selector(addanotationForGooglecategory:) withObject:array afterDelay:0.1];
	}
	else
	{
		NSString * strMsg = [NSString stringWithFormat:@"No %@ near by",self.strSelectedGoogleCategory];
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:strMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
	
	[SVProgressHUD dismiss];
}

-(NSArray *)getArrayForGoogleCategory:(NSString*)category
					  withLocationLat:(NSString*)lat
                              andLong:(NSString*)lLong
							   radius:(NSString*)radius
{
    if(btnCreateGroup.isHidden == NO)
        [btnCreateGroup setHidden:YES];
    
    if(btnDone.isHidden == NO)
        [btnDone setHidden:YES];
    
	BOOL isNewQuery = NO;
    
    NSString * createdUrl = nil;
    if (self.pagetoken == nil)
    {
        isNewQuery = YES;
        createdUrl = [NSString stringWithFormat:@"https:maps.googleapis.com/maps/api/place/search/json?location=%@,%@&radius=%@&types=%@&sensor=true&key=%@",lat,lLong,radius,category,kGooglecategory];
    }
    else
    {
        createdUrl = [NSString stringWithFormat:@"https:maps.googleapis.com/maps/api/place/search/json?location=%@,%@&radius=%@&types=%@&sensor=true&key=%@&pagetoken=%@",lat,lLong,radius,category,kGooglecategory,self.pagetoken];
    }
	
	
	NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:createdUrl]];
    
    NSError *err;
    
	// get crash in case we get resuldata as nil
	// so we implemented below code
	
	if (resultData)
	{
		NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&err];
        
		self.pagetoken = [jsonDict objectForKey:@"next_page_token"];
        
        NSLog(@"%@",self.pagetoken);
        
        [btnFetchMore setHidden:YES];
        if(self.pagetoken)
           [btnFetchMore setHidden:NO];
        
        if (isNewQuery)
        {
            self.categoryResultArray = [NSMutableArray arrayWithArray:[jsonDict objectForKey:@"results"]];
        }
        else
        {
            [self.categoryResultArray addObjectsFromArray:[jsonDict objectForKey:@"results"]];
        }
		
		return categoryResultArray;
	}
	
	return nil;
}
-(void)addanotationForGooglecategory:(NSArray *)categoryArray
{
	@try {
		
		NSMutableArray * arrayAnnotation = [NSMutableArray arrayWithCapacity:0];
		
		for (NSDictionary * dict in categoryArray)
		{
			// get Location cordinate
			NSDictionary * dictLocation = [[dict valueForKey:@"geometry"] valueForKey:@"location"];
			
			CLLocationCoordinate2D location ;
			location.latitude = [[dictLocation valueForKey:@"lat"] doubleValue];
			location.longitude= [[dictLocation valueForKey:@"lng"] doubleValue];
			
			
			DisplayMap *ann = [[[DisplayMap alloc] init] autorelease];
			
			// Dict for userdetails;
			ann.dictContactDetails = [NSMutableDictionary dictionaryWithCapacity:0];
			ann.coordinate =location;
            
			[ann.dictContactDetails addEntriesFromDictionary:dictLocation];
			[ann.dictContactDetails setValue:[dict valueForKey:@"vicinity"] forKey:@"Street"];
			
			NSDictionary * dictPhoto = [dict valueForKey:@"photos"];
			[ann.dictContactDetails setValue:[dictPhoto valueForKey:@"photo_reference"] forKey:@"PhotoReference"];
            
			
			// set ego image
			NSURL * url = [NSURL URLWithString:[dict valueForKey:@"icon"]];
			
			EGOImageView * imageF = [[EGOImageView alloc]init];
	
            imageF.imageURL = url;
			
			ann.imgEgo = imageF;
			
			[imageF release];
			
			//Title
			[ann setTitle:[NSString stringWithString:[dict objectForKey:@"name"]]];
			
			
			
			[arrayAnnotation addObject:ann];
		}
		
		//Add annotations
		[aMapView addAnnotations:arrayAnnotation];
		
		//Appox region spam
		MKCoordinateRegion region;
		
		region.span.latitudeDelta = MinSpanLevel;
		region.span.longitudeDelta = MinSpanLevel;
		region.center = coordinateLocGoogleCategory;
		region = [aMapView regionThatFits:region];
		
		[aMapView setRegion:region animated:YES];
        
        
	}
	@catch (NSException *exception) {
		NSLog(@"Exception : %@",exception.reason);
	}
	@finally {
		
	}
}
#pragma mark - Add Google Category to Contact
-(void)addCategoryAsContact
{
	AppDelegate * aDelegate = CRM_AppDelegate;
	
	MyAddressBook * addressBook = [NSEntityDescription insertNewObjectForEntityForName:@"MyAddressBook" inManagedObjectContext:aDelegate.managedObjectContext];
	
	[addressBook setOrganisation:self.displayObj.title];
	
	
	AllAddress * listAdd = [NSEntityDescription insertNewObjectForEntityForName:@"AllAddress" inManagedObjectContext:[aDelegate managedObjectContext ]];
	
	NSString * latitude = [self.displayObj.dictContactDetails valueForKey:@"lat"];
	[listAdd setLatitude:[NSString stringWithFormat:@"%f",[latitude doubleValue]]];
	
	NSString * longitude = [self.displayObj.dictContactDetails valueForKey:@"lng"];
	[listAdd setLongitude:[NSString stringWithFormat:@"%f",[longitude doubleValue]]];
	
	[listAdd setStreet:[self.displayObj.dictContactDetails valueForKey:@"Street"]];
	
//	[listAdd setPersonName:self.displayObj.title];
	[listAdd setRelMyAddressBook:addressBook];
	
	
	if (![[aDelegate managedObjectContext] save:nil])
	{
		NSLog(@"Error ");
	}
    else
	{
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Contact added successfully" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	
}

-(MKCoordinateRegion)checkValidRegion:(MKCoordinateRegion)region
{
	if (region.span.longitudeDelta > 180)
	{
		region.span.longitudeDelta = 180;
	}
	
	if (region.span.latitudeDelta > 180)
	{
		region.span.latitudeDelta = 180;
	}
	
	if (region.span.latitudeDelta < 0.1)
	{
		region.span.longitudeDelta = 0.1;
	}
	
	if (region.span.longitudeDelta < 0.1)
	{
		region.span.longitudeDelta = 0.1;
	}
	
	return region;
}

- (IBAction)btnCategorySearch:(id)sender
{
	//Touch view
    if ([txtSearchField isFirstResponder])
    {
        [txtSearchField resignFirstResponder];
    }
	TouchView *aTouchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [aTouchView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [aTouchView setDelegate:self];
    //	[aTouchView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:aTouchView];
	
    [aTouchView release];
	[vwCategoryView setFrame:CGRectMake(22, 52, vwCategoryView.frame.size.width, vwCategoryView.frame.size.height)];
	[self.view addSubview:vwCategoryView];
	
}

- (IBAction)btnApplyGoogleCategorySearch:(id)sender
{
	if (![txtCategory.text length] || ![txtcategoryLocation.text length])
	{
		UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Location and category can't be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alert show];
		[alert release];
	}
	else
	{
		// remove the vwCategory from super
        
        self.typeOfCallout = CallOutTypeGoogleCategory;

		[vwCategoryView removeFromSuperview];
		
		// fetch the location for the location name
		coordinateLocGoogleCategory = [self addressLocation:txtcategoryLocation.text];
		
		if (coordinateLocGoogleCategory.latitude || coordinateLocGoogleCategory.longitude)
		{
            [txtSearchField setText:@""];
			NSString * string = [txtCategory.text lowercaseString];
			string = [string stringByReplacingOccurrencesOfString:@" " withString:@"_"];
			[self didSelectGoogleCategory:string];
		}
	}
}
- (IBAction)btnCategoryDropDown:(UIButton *)sender
{
    
	//resign first responder
	if ([txtcategoryLocation isFirstResponder])
	{
		[txtcategoryLocation resignFirstResponder];
	}
	
	// so we can differentiate b/w two callouts
	self.typeOfCallout = CallOutTypeGoogleCategory;
    
	self.typePopover = typeGoogleCategory;
	
	[self resignMapFilterFields];
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
		
		NSArray * array  = [CoreDataHelper searchObjectsForEntity:@"GoogleCategory" withPredicate:nil andSortKey:@"categoryName" andSortAscending:YES andContext:adelegate.managedObjectContext];
		
		self.arrayIndustry = [NSMutableArray arrayWithArray:array];
		
		[tableIndustry reloadData];
	}
	
	[txtIndustrySearch resignFirstResponder];
	CGRect rect = [sender convertRect:sender.bounds toView:self.view];
	[self.popoverIndustry presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


@end
