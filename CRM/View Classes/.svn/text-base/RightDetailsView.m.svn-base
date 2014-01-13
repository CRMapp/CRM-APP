//
//  RightDetailsView.m
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "RightDetailsView.h"
#import "HomeViewController.h"
#import "DashboardViewController.h"
#import "MapViewController.h"
#import "FeedbackViewController.h"
#import "GraphViewController.h"
#import "SalesGoalViewController.h"
#import "CRMConfig.h"
//#import "AppDelegate.h"
#import "AddLinkedInContactVC.h"
@implementation RightDetailsView
@synthesize mainController;
@synthesize lastOption;
@synthesize NavDashBoard;
@synthesize NavContact;
@synthesize NavMap;
@synthesize NavGraph;
@synthesize NavTour;
@synthesize NavFeedback;
//@synthesize NavCurrentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)changeViewForOption:(int)option
{
    if (option != 5)
   	[self removeAllViews];
    
	switch (option)
    {
		case 0:
        {
            //Flurry
			[AppDelegate setFlurryWithText:@"Tab Dashboard"];
            
            if(NavDashBoard == nil)  //dashboard
            {
                DashboardViewController *objDashBoard = [[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:nil];
                
            
                NavDashBoard = [[UINavigationController alloc] initWithRootViewController:objDashBoard];
                [objDashBoard release];
            }
            Class contactDesc = NSClassFromString(@"ContactDetailViewController");
            Class saleClass = NSClassFromString(@"SalesGoalViewController");
            if ([NavDashBoard.visibleViewController isKindOfClass:[contactDesc class]] || [NavDashBoard.visibleViewController isKindOfClass:[saleClass class]])
            {
                [NavDashBoard popToRootViewControllerAnimated:NO];
            }
            [NavDashBoard.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            NavDashBoard.navigationBarHidden = YES;
            [self addSubview:NavDashBoard.view];
            [self.mainController.lblTopTitle setText:DASHBOARD_STRING];
            break;
        }
		case 1:
        {
            //Flurry
			[AppDelegate setFlurryWithText:@"Tab Contact"];
            
            if(NavContact == nil)  //contact
            {
                ContactListViewController *objContactDeatails = [[ContactListViewController alloc]initWithNibName:@"ContactListViewController" bundle:nil];
                objContactDeatails.aDelegate = self;
                
                NavContact = [[UINavigationController alloc] initWithRootViewController:objContactDeatails];
                [objContactDeatails release];
            }           
            
            Class contactDesc = NSClassFromString(@"ContactDetailViewController");
            if (self.lastOption == option && [NavContact.visibleViewController isKindOfClass:[contactDesc class]])
            {
                [NavContact popToRootViewControllerAnimated:NO];
            }
            
                [NavContact.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                NavContact.navigationBarHidden = YES;
                [self addSubview:NavContact.view];
                [self.mainController.lblTopTitle setText:CONTACT_LIST_STRING];
            
			break;
        }
		case 2:
            //Flurry
			[AppDelegate setFlurryWithText:@"Tab Map"];
            
            if(NavMap == nil)  //map
            {
                MapViewController *objMap = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
                

                NavMap = [[UINavigationController alloc] initWithRootViewController:objMap];
                [objMap release];
            }
            
//            Class setting = NSClassFromString(@"SettingsViewController");
            if (self.lastOption == option)
            {
                [NavMap popToRootViewControllerAnimated:NO];
            }
            [NavMap.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            NavMap.navigationBarHidden = YES;
            [self addSubview:NavMap.view];
            [self.mainController.lblTopTitle setText:MAP_STRING];
			break;
		case 3:
            //Flurry
			[AppDelegate setFlurryWithText:@"Tab Graph"];
            
            if(NavGraph == nil)  //Graph
            {
                GraphViewController *objGraph = [[GraphViewController alloc]initWithNibName:@"GraphViewController" bundle:nil];
                
                
                NavGraph = [[UINavigationController alloc] initWithRootViewController:objGraph];
                [objGraph release];
            }
            if (self.lastOption == option)
            {
                [NavGraph popToRootViewControllerAnimated:NO];
            }
            [NavGraph.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            NavGraph.navigationBarHidden = YES;
            [self addSubview:NavGraph.view];
            [self.mainController.lblTopTitle setText:GRAPH_STRING];
			break;
		case 4:
            //Flurry
			[AppDelegate setFlurryWithText:@"Tab Sales Goal"];
            
            if(NavTour == nil)  //tour
            {
                SalesGoalViewController *objTour = [[SalesGoalViewController alloc]initWithNibName:@"SalesGoalViewController" bundle:nil];
                
                
                NavTour = [[UINavigationController alloc] initWithRootViewController:objTour];
                [objTour release];
            }
            [NavTour.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            NavTour.navigationBarHidden = YES;
            [self addSubview:NavTour.view];
            [self.mainController.lblTopTitle setText:GOAL_STRING];
			break;
		case 5:
            //Flurry
			[AppDelegate setFlurryWithText:@"Tab Feedbacks"];
            /*if(NavFeedback == nil)  //feedback
            {
                AddLinkedInContactVC *objLinkedIN = [[AddLinkedInContactVC alloc]initWithNibName:@"AddLinkedInContactVC" bundle:nil];
                
                
                NavFeedback = [[UINavigationController alloc] initWithRootViewController:objLinkedIN];
                [objLinkedIN release];
            }
            [NavFeedback.view setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            
            NavFeedback.navigationBarHidden = YES;
            [self addSubview:NavFeedback.view];
            [self.mainController.lblTopTitle setText:COMPANY_STRING];*/
            //Flurry
            
            //Uservoice invocation here
            [((AppDelegate*)CRM_AppDelegate) launchFeedback:self.mainController];
			break;
    }
    
    self.lastOption = option;
}
- (void)removeAllViews
{
    NSLog(@"%@",self.subviews);
    
    if([self.subviews count])
    {
        for (UIView *aView in self.subviews)
        {
            if (aView.tag != -999)
            {
                [aView removeFromSuperview];
            }
        }
    }

    [self removeSettingView];
    [self removeTourView];
}
- (void)removeSettingView
{
    [self.mainController settingRemoveFromSuperView];
    Class setting = NSClassFromString(@"SettingsViewController");
    if ([NavMap.visibleViewController isKindOfClass:[setting class]])
    {
        [NavMap popToRootViewControllerAnimated:NO];
    }
}
- (void)removeTourView
{
    
    [self.mainController tourRemoveFromSuperView];
    Class tour = NSClassFromString(@"TourViewController");
    if ([NavMap.visibleViewController isKindOfClass:[tour class]])
    {
        [NavMap popToRootViewControllerAnimated:NO];
    }
}
#pragma mark - ContactListVCDelegate methods
- (void)changeNavigationTitle
{
    [self.mainController.lblTopTitle setText:CONTACT_STRING];
}
- (void)dealloc
{
    [NavDashBoard release];
    [NavContact release];
    [NavMap release];
    [NavGraph release];
    [NavTour release];
    [NavFeedback release];
    
    NavDashBoard = nil;
    NavContact = nil;
    NavMap = nil;
    NavGraph = nil;
    NavTour = nil;
    NavFeedback = nil;
    
    [mainController release];
    mainController = nil;
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
