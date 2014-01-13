//
//  DashboardViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "DashboardViewController.h"
#import "ListViewController.h"
@interface DashboardViewController ()

@end

@implementation DashboardViewController

@synthesize allListsArray;
@synthesize pageControl;
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
    pageControlBeingUsed = NO;
    [super viewDidLoad];
    [self fillListsArray];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    
    NSLog(@"self frame  %@",NSStringFromCGRect(self.view.frame));
    [self updateUI:orientation];
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)dealloc
{
    [allListsArray release];
    allListsArray = nil;
    
    [aScrollView release];
    aScrollView = nil;
    
    [pageControl release];
    pageControl =nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeLayout" object:nil];
    [super dealloc];
}
#pragma mark - NSNotification methods
-(void)changeLayout:(NSNotification*)info
{
    
    NSDictionary *themeInfo     =   [info userInfo];
    int orintation = [[themeInfo objectForKey:@"kOrientation"] intValue];
    [self updateUI:orintation];
    
}
#pragma mark - Scrollview layout methods
-(void)updateUI:(int)orintation
{
    float ht = 700;  // check for landscape orientation
    float wt = 853;  // check for landscape orientation
    int y_axis = 10; // check for landscape orientation
    
    
    [self.pageControl setFrame:CGRectMake(150, 650, 594, 36)];
    self.pageControl.numberOfPages = (self.allListsArray.count/3)+1;
    if (orintation <=2)   // check for portrait orientation
    {
        [self.pageControl setFrame:CGRectMake(15, 904, 594, 36)];
        self.pageControl.numberOfPages = (self.allListsArray.count/2);
        ht = 900;
        y_axis = 20;
        wt = 600;
    }
    CGRect rect = aScrollView.frame;
    
//     NSLog(@"self frame  %@",NSStringFromCGRect(aScrollView.frame));
    rect.size.height = ht;
    rect.size.width = wt;
    aScrollView.frame = rect;
    
//    [aScrollView setFrame:CGRectMake(0, 0, wt, ht)];
    [self loadScrollView:y_axis];
}

-(void)fillListsArray
{
	//Please always remember to ask narendra before making any change..
	
    NSArray *arrayHeaders = [NSArray arrayWithObjects:@"Call List",/*@"Email List",*/@"Reminders List",@"Appointment List",@"Proposal List",@"Task List", nil];
    self.pageControl.currentPage = 0;
    self.allListsArray = [NSMutableArray array];
    for (int i =0; i<[arrayHeaders count]; i++)
    {
        ListViewController *aList = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
        aList.tagValue = i;
        [aList setHeader:[arrayHeaders objectAtIndex:i]];
        [aList setANavigation:self.navigationController];
        [aList.view setFrame:CGRectMake(aList.view.frame.origin.x, aList.view.frame.origin.x, aList.view.frame.size.width, aList.view.frame.size.height)];
        [allListsArray addObject:aList];
        [aList release];
    }
}
-(void)loadScrollView:(int)y_axis
{
    if ([aScrollView.subviews count])
    {
        NSArray *viewsToRemove = [aScrollView  subviews];
        for (UIView *v in viewsToRemove) [v removeFromSuperview];
    }
    //for showing single list set xOffSet = 280;
    int xOffSet = 13; int yOffSet = y_axis;
    NSLog(@"aScrollView.frame.size.height = %f",aScrollView.frame.size.height);
    [aScrollView setContentSize:CGSizeMake(xOffSet+(315+15)*self.allListsArray.count, aScrollView.frame.size.height)];
    
    for (ListViewController *aList in self.allListsArray)
    {
        [aList.view setFrame:CGRectMake(xOffSet, yOffSet, aList.view.frame.size.width, aScrollView.frame.size.height - 80)];
        aList.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
//        UIButton *crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [crossButton setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
//        
//        [crossButton setFrame:CGRectMake(xOffSet+290, yOffSet-10, [UIImage imageNamed:@"close_btn.png"].size.width, [UIImage imageNamed:@"close_btn.png"].size.height)];
        
        [aScrollView addSubview:aList.view];
        
//        [aScrollView addSubview:crossButton];
        
        xOffSet = xOffSet + 315+15;

    }
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = aScrollView.frame.size.width;
		int page = floor((aScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	pageControlBeingUsed = NO;
}
 - (IBAction)changePage {
 // Update the scroll view to the appropriate page
 CGRect frame;
 frame.origin.x = aScrollView.frame.size.width * self.pageControl.currentPage;
 frame.origin.y = 0;
 frame.size = aScrollView.frame.size;
 [aScrollView scrollRectToVisible:frame animated:YES];
 
 // Keep track of when scrolls happen in response to the page control
 // value changing. If we don't do this, a noticeable "flashing" occurs
 // as the the scroll delegate will temporarily switch back the page
 // number.
 pageControlBeingUsed = YES;
 }

@end
