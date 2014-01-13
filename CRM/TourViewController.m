//
//  TourViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 04/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "TourViewController.h"
#import "SaleContactListTVCell.h"
#import "MyAddressBook.h"
#import "CoreDataHelper.h"
//#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AddressBook.h"
@interface TourViewController ()

@end

@implementation TourViewController
@synthesize arrContacts;
@synthesize currentOrientation;
@synthesize shouldStopTour;
#pragma mark - View Life Cycle
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
    
    [self addObserver_NotificationCenter];
    
    UIInterfaceOrientation interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    [self updateOptionView:orientation];
    [self btnTourTapped:btnTakeTour];
    
    self.arrContacts = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    [self updateOptionView:orientation];
    
    if(!shouldStopTour)
    [self btnTourTapped:btnTakeTour];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"TourViewController dealloc");
    [view_top_option release];
    [view_for_option release];
//    [tblContactList release];
    [self removeObserver_NotificationCenter];
    [btnTakeTour release];
//    [btnSort release];
    [btnVedio release];
    [btnSupport release];
    [imgVwOptionbar release];
    
    [iCarouselView release];
    
    [player release];
    player = nil;
    
    [aWebview setDelegate:nil];
    [aWebview release];
    
    [arrContacts release];
    arrContacts = nil;
    [activityIndicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [view_top_option release];
    view_top_option = nil;
    [view_for_option release];
    view_for_option = nil;
//    [tblContactList release];
//    tblContactList = nil;
    [btnTakeTour release];
    btnTakeTour = nil;
//    [btnSort release];
//    btnSort = nil;
    [btnVedio release];
    btnVedio = nil;
    [btnSupport release];
    btnSupport = nil;
    [imgVwOptionbar release];
    imgVwOptionbar = nil;
    [iCarouselView release];
    iCarouselView = nil;
    [aWebview release];
    aWebview = nil;
    [activityIndicator release];
    activityIndicator = nil;
    [super viewDidUnload];
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    return [self.arrContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddressBook *aContact = [self.arrContacts objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"SaleContactListTVCell";
    SaleContactListTVCell* cell = nil;
    cell = (SaleContactListTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // NSLog(@"%@",self.arrHistoryData);
    // NSLog(@"%@",objHis);
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SaleContactListTVCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            
            if([currentObject isKindOfClass:[SaleContactListTVCell class]])
            {
                
                cell = (SaleContactListTVCell*)currentObject;
                
            }
        }
    }
    [cell SetContactInfo:aContact atIndexPath:indexPath];
    [cell setSelectedStage];
//    [cell.btnCheck addTarget:self action:@selector(btnCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCheck setHidden:YES];
    
    
//    [cell.btnEditContact addTarget:self action:@selector(btnEditContact:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEditContact setHidden:YES];
    
    [cell.imgArrow setHidden:YES];
    return cell;
}
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 19;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //main Cover page view
    
    UIView *coverview=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 700)]autorelease];
    
    [coverview setBackgroundColor:[UIColor whiteColor]];
    
    
    UIImageView *imgCoverback = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 640, 700)];
    [imgCoverback setUserInteractionEnabled:YES];
    [imgCoverback setContentMode:UIViewContentModeScaleAspectFit];
    [imgCoverback setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleWidth];
    if (index < 9)
    {
        [imgCoverback setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Clue Slide Presentation 00%d.png",index+1]]];
    }
    else
    {
        [imgCoverback setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Clue Slide Presentation 0%d.png",index+1]]];
    }
    
    if (index >= 18)
    {
        UIButton *btnSupportMat = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSupportMat setFrame:CGRectMake(305, 353, 148, 25)];
//        [btnSupportMat setBackgroundColor:[UIColor redColor]];
        [btnSupportMat addTarget:self action:@selector(btnSupportTapped:) forControlEvents:UIControlEventTouchUpInside];
        [imgCoverback addSubview:btnSupportMat];
    }
    [coverview addSubview:imgCoverback];
    
    [imgCoverback release];
    
    return coverview;
    
    
    
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    
    //return 260;
    return 650;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
}
#pragma mark - Add OR Remove Notificatoin Observers
- (void)addObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
    
    //notification for end of movie
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}
- (void)removeObserver_NotificationCenter
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeLayout" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}
#pragma mark - NSNotification methods
-(void)changeLayout:(NSNotification*)info
{
    NSLog(@"%@",view_for_option);
    NSDictionary *themeInfo     =   [info userInfo];
    int orintation = [[themeInfo objectForKey:@"kOrientation"] intValue];
    [self updateOptionView:orintation];
    self.currentOrientation = orintation;
    
    if(btnTakeTour.selected)
    [self btnTourTapped:btnTakeTour];
}
- (void)updateOptionView:(int)orientation
{
    
//    According to four button on top bar
   /* if (orientation <=2)
    {
        [imgVwOptionbar setFrame:CGRectMake(0, 0, 596, 65)];
        [btnTakeTour    setFrame:CGRectMake(6, 9, 140, 48)];
        [btnSort        setFrame:CGRectMake(154, 9, 140, 48)];
        [btnVedio       setFrame:CGRectMake(302, 9, 140, 48)];
        [btnSupport     setFrame:CGRectMake(450, 9, 140, 48)];
    }
    else
    {
        [imgVwOptionbar setFrame:CGRectMake(0, 0, 844, 65)];
        [btnTakeTour    setFrame:CGRectMake(94, 9, 158, 48)];
        [btnSort        setFrame:CGRectMake(260, 9, 158, 48)];
        [btnVedio       setFrame:CGRectMake(427, 9, 158, 48)];
        [btnSupport     setFrame:CGRectMake(593, 9, 158, 48)];
    }*/
    //    According to three button on top bar
    if (orientation <=2)
    {
        [imgVwOptionbar setFrame:CGRectMake(0, 0, 596, 65)];
        [btnTakeTour    setFrame:CGRectMake(53, 9, 140, 48)];
        //        [btnSort        setFrame:CGRectMake(154, 8, 140, 48)];
        [btnVedio       setFrame:CGRectMake(219, 9, 140, 48)];
        [btnSupport     setFrame:CGRectMake(385, 9, 140, 48)];
    }
    else
    {
        [imgVwOptionbar setFrame:CGRectMake(0, 0, 844, 65)];
        [btnTakeTour    setFrame:CGRectMake(177, 9, 158, 48)];
        //        [btnSort        setFrame:CGRectMake(260, 8, 158, 48)];
        [btnVedio       setFrame:CGRectMake(343, 9, 158, 48)];
        [btnSupport     setFrame:CGRectMake(509, 9, 158, 48)];
    }
}
- (void)moviePlaybackDidFinish:(NSNotification*) aNotification
{
    
}
- (void)MPMoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if ((player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"content play length is %g seconds", player.duration);
    }
}
#pragma mark - IBAction methods
- (IBAction)btnTourTapped:(id)sender
{
    shouldStopTour = NO;
    [self resetAllBtns:(UIButton*)sender];
    [self removeAllViews];
//    [iCarouselView setFrame:CGRectMake(0, 0, view_for_option.frame.size.width, view_for_option.frame.size.height)];
//    [view_for_option addSubview:iCarouselView];
}

/*- (IBAction)btnSortTapped:(id)sender
{
    shouldStopTour = NO;
    [self resetAllBtns:(UIButton*)sender];
    [self removeAllViews];
    
//    [tblContactList setFrame:CGRectMake(0, 0, view_for_option.frame.size.width, view_for_option.frame.size.height)];
//    [view_for_option addSubview:tblContactList];
    
    self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    if ([self.arrContacts count] <= 0)
    {
        [SVProgressHUD showWithStatus:@"Importing your address book"];
        
        [self performSelector:@selector(loadContactList) withObject:nil afterDelay:0.1];
    }
    else
    {
//        [tblContactList reloadData];
    }
}*/

- (IBAction)btnVedioTapped:(id)sender
{
    shouldStopTour = YES;
    [self removeAllViews];
    [self resetAllBtns:(UIButton*)sender];
    if (player == nil)
    {
       player = [[MPMoviePlayerController alloc]init];
    }
    
    
//    //notification for end of movie
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    [player setFullscreen:NO animated:YES];
    
    [player.view setFrame:CGRectMake(0, 0, view_for_option.frame.size.width, view_for_option.frame.size.height)];
    //player.view.transform = CGAffineTransformRotate(player.view.transform, M_PI/2);
//    player.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    player.controlStyle = MPMovieControlStyleDefault;
    
    [player.view setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [player.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [view_for_option addSubview:player.view];
    NSString *vdoPath = [[NSBundle mainBundle] pathForResource:@"Clue_FinalCut" ofType:@"mov"];
    if (vdoPath)
    {
        if (!player.contentURL)
        {
            NSURL *url = [NSURL fileURLWithPath:vdoPath];
            [player setContentURL:url];
            
        }
       [player play];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sorry we are unable to play video file." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

- (IBAction)btnSupportTapped:(id)sender
{
    [self resetAllBtns:(UIButton*)sender];
    [btnSupport setSelected:YES];
    [self removeAllViews];
    [aWebview setDelegate:self];
//    [aWebview setScalesPageToFit:YES];
    [aWebview setFrame:CGRectMake(0, 0, view_for_option.frame.size.width, view_for_option.frame.size.height)];
    [aWebview setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    [aWebview setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [view_for_option addSubview:aWebview];
    
//    if (!aWebview.request)
    {
        NSString* url = @"http://cluecrm.com/app-support/";
        
        NSURL* nsUrl = [NSURL URLWithString:url];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl];
        
        
        [aWebview loadRequest:request];
        
    }
    
    
}
- (void)loadContactList
{
        
    [AddressBook arrayOfAddressBook];
    
    arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
//    [tblContactList reloadData];
    
    [SVProgressHUD dismiss];
    
}
- (void)resetAllBtns:(UIButton*)sender
{
    [btnTakeTour setSelected:NO];
//    [btnSort setSelected:NO];
    [btnVedio setSelected:NO];
    [btnSupport setSelected:NO];
    
    [sender setSelected:YES];
}
- (void)removeAllViews
{
//    [tblContactList removeFromSuperview];
    [activityIndicator stopAnimating];
    [aWebview stopLoading];
    [aWebview setDelegate:nil];
//    [iCarouselView removeFromSuperview];
    [aWebview removeFromSuperview];
    if (player)
    {
        [player.view removeFromSuperview];
        [player stop];
    }
}
#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [view_for_option bringSubviewToFront:activityIndicator];
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [activityIndicator stopAnimating];
}
@end
