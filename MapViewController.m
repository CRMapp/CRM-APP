//
//  MapViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 12/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "MapViewController.h"
#import "DisplayMap.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "CRMConfig.h"
#import "MyAddressBook.h"
#import "CoreDataHelper.h"
#import "SVProgressHUD.h"
#import "AllAddress.h"
#import "AllEmail.h"
#import "GlobalDataPersistence.h"
@interface MapViewController ()

@end

@implementation MapViewController
@synthesize arrMyAddressBook;
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
    
    [[aMapView layer]setCornerRadius:5.0];
    [[aMapView layer]setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[aMapView layer]setBorderWidth:0.5];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
//    NSLog(@"%@",MyAddressBook);

    // Do any additional setup after loading the view from its nib.
}
- (void)fetchAddressBook
{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    [AddressBook arrayOfAddressBook]; //if no data then access from address book of device.
    
    GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
    for(MyAddressBook *myAdd in  GDP.arrMyAddressBookData)
    {
        AllAddress *address = (AllAddress*)[[myAdd relAllAddress]anyObject];
        if(address!=nil)
            [tempArray addObject:[[myAdd relAllAddress]anyObject]];
        
    }
    
    self.arrMyAddressBook  = tempArray;
    [tempArray release];
    
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
- (void)loadAddressBook
{
    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    if([self.arrMyAddressBook count] <= 0)
    {
        GDP.arrMyAddressBookData = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        if ([GDP.arrMyAddressBookData count] <= 0)  //check data is avail in database
        {
            [SVProgressHUD showWithStatus:@"Retrieving..."];
            [self performSelector:@selector(fetchAddressBook) withObject:nil afterDelay:0.1];
        }
        else
        {
        
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithCapacity:0];
            for(MyAddressBook *myAdd in  GDP.arrMyAddressBookData)
            {
                AllAddress *address = (AllAddress*)[[myAdd relAllAddress]anyObject];
                if(address!=nil)
                    [tempArray addObject:[[[myAdd relAllAddress]allObjects]lastObject]];
               
            }
            
            self.arrMyAddressBook  = tempArray;
            [tempArray release];
            
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
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [self updateUI:orientation];
    [self performSelector:@selector(loadAddressBook) withObject:nil afterDelay:0.1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mapCallOutView removeFromSuperview];
}

- (void)dealloc
{
    [arrMyAddressBook release];
    arrMyAddressBook = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeLayout" object:nil];
    [super dealloc];
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
#pragma mark - MKMapView Delegate
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    // reuse a view, if one exists
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    // create a new view else
    if (!aView) {
        aView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"] autorelease];
    }
    
    // now configure the view
    
    
    aView.canShowCallout = NO;
    aView.enabled = YES;
    aView.image = [UIImage imageNamed:@"map-red-button.png"];
    
    return aView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:NO];
    
    DisplayMap *csMapAnn = (DisplayMap *)view.annotation;
    
    CGPoint newCenter = [aMapView convertCoordinate:csMapAnn.coordinate toPointToView:aMapView];
    
   
    NSLog(@"%@",NSStringFromCGRect(aMapView.frame));
    [mapCallOutView setFrame:CGRectMake(newCenter.x-75, newCenter.y-2, mapCallOutView.frame.size.width, mapCallOutView.frame.size.width)];
    [lblUsername setText:csMapAnn.title];
    [lblAddress setText:csMapAnn.subtitle];
    NSLog(@"%@",NSStringFromCGRect(mapCallOutView.frame));
    
    [self.view addSubview:mapCallOutView];
  
}
-(void)addAnnotations
{
    [aMapView setMapType:MKMapTypeStandard];
	[aMapView setZoomEnabled:YES];
	[aMapView setScrollEnabled:YES];
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	region.center.latitude = 37.883983 ;
	region.center.longitude = -122.458047;
	region.span.longitudeDelta = 1.0f;  // increases value map goes far away i.e compress whereas decreases value map come nearer i.e enlarge.
	region.span.latitudeDelta = 1.0f;
	[aMapView setRegion:region animated:YES];
	
    NSMutableArray *annotaions = [NSMutableArray array];
	for(int i=0 ; i<[self.arrMyAddressBook count] ; i++)
    {
        AllAddress *aAddress = [self.arrMyAddressBook objectAtIndex:i];
        DisplayMap *ann = [[DisplayMap alloc] init];
        ann.title = aAddress.personName;
        
        ann.subtitle = [aAddress.countryCode stringByAppendingFormat:@" %@",aAddress.state];
        
        NSString *address = [aAddress.street stringByAppendingFormat:@" %@ %@ %@ %@",aAddress.city,aAddress.state,aAddress.countryCode,aAddress.zipCode];
        CLLocationCoordinate2D location = [self addressLocation:address];
               
        ann.coordinate =location;
        [annotaions addObject:ann];
        [ann release];
    }
    
	[aMapView addAnnotations:annotaions];
}
#pragma mark - Get Latitude and Longitude
-(CLLocationCoordinate2D) addressLocation:(NSString *)searchedLocation
{
//    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];http://maps.googleapis.com/maps/api/geocode/json?address=durgapura%2C%20jaipur&sensor=true
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", [searchedLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSError *err;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&err];
    
    NSMutableArray *resultArray = [jsonDict objectForKey:@"results"];
    
    double latitude = 0.0;
    double longitude = 0.0;
    
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
    
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}
#pragma mark - IBAction methods
- (IBAction)btnCreateGroupTapped:(id)sender
{
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
		for (id annotation in aMapView.annotations)
		{
			//		if ([annotation isKindOfClass:[CSMapAnnotation class]])
//			{
                DisplayMap *csMapAnn = (DisplayMap *)annotation;
				
				CGPoint newCenter = [aMapView convertCoordinate:csMapAnn.coordinate toPointToView:aMapView];
				
				if (CGRectContainsPoint(userResizableView.frame, newCenter))
				{
					NSLog(@"csMap :%@",csMapAnn.title);
                    tittle = [tittle stringByAppendingFormat:@"%@\n",csMapAnn.title];
				}
//            }
		}
        if (tittle)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Selected contacts are " message:tittle delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        
	}
}

- (IBAction)barBtnTapped:(UIButton*)sender
{
    
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
-(IBAction)btnMapFilterTapped:(UIButton*)sender
{
    TouchView *aTouchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [aTouchView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [aTouchView setDelegate:self];
    [self.view addSubview:aTouchView];
    [aTouchView release];
    [mapFilterView setFrame:CGRectMake(22, 52, mapFilterView.frame.size.width, mapFilterView.frame.size.height)];
    [self.view addSubview:mapFilterView];
}
#pragma mark - TouchView delegate
- (void)touchesDown:(NSSet *)touches
{
    [mapFilterView removeFromSuperview];
    UITouch *atouch = [[touches allObjects] lastObject];
    [atouch.view removeFromSuperview];
}
- (void)touchesUp:(NSSet *)touches
{
}
@end
