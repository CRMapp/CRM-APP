//
//  HomeViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "Global.h"
#import "ABContactsHelper.h"
#import "TourViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


@synthesize leftOptionView;
@synthesize rightDetailView;
@synthesize lblTopTitle;
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
    
    [self.rightDetailView setMainController:self];
    
    [self.leftOptionView setMainController:self];
    
    [self.leftOptionView setSelectedOption:-999];
    
    for (UIView *aView in [self.view subviews])
    {
        if ([aView isKindOfClass:[leftOptionView class]])
        {
            for (UIView *aSubView in [aView subviews])
            {
                if ([aSubView isKindOfClass:[UIButton class]])
                {
                    if (aSubView.tag == 0)
                    {
                        UIButton *aBtn = (UIButton*)aSubView;
                        [self.leftOptionView btnLeftOption_Tapped:aBtn];
                    }
                    break;
                }
            }
            break;
        }
    
    }
    
//  This code will show tour screen at First App launch  
    if (![Global GetFirstLaunchAppFlag])
    {
        [Global SaveFirstLaunchAppFlag:YES];
        [self btnTourTapped:nil];
        NSString *message = @"To Backup Clue CRM data you need to enable Documents and Data in iPad iCloud settings";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else if (((AppDelegate*)CRM_AppDelegate).isFromForgotPasswordScreen)
    {
        [self btnSettingsTapped:nil];
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [leftOptionView release];
    leftOptionView = nil;
    
    [rightDetailView release];
    rightDetailView = nil;
    
    [lblTopTitle release];
    lblTopTitle = nil;
    [super dealloc];
}


#pragma mark - IBAction methods
- (IBAction)btnFeedbacksTapped:(id)sender
{
//    //Flurry
//	[AppDelegate setFlurryEventWithSender:sender];
//    
//    //Uservoice invocation here
//    [AppDelegate launchFeedback:self];
}
-(IBAction)btnSettingsTapped:(id)sender
{
    //Flurry
	[Flurry logEvent:@"Settings Screen View"];
    
    [self tourRemoveFromSuperView];
    
    Class setting = NSClassFromString(@"SettingsViewController");
    if(settings == nil && ![self.rightDetailView.NavMap.visibleViewController isKindOfClass:[setting class]])
    {
        [self.leftOptionView resetAllOptions];
        settings = [[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil];
        [settings.view setFrame:CGRectMake(4, 2, self.rightDetailView.frame.size.width, self.rightDetailView.frame.size.height)];
        [self.rightDetailView addSubview:settings.view];
        [self.lblTopTitle setText:@"Settings"];
//        UIButton *btn = (UIButton*)sender;
//        [btn setSelected:YES];
    }
}
-(IBAction)btnTourTapped:(id)sender
{
    //Flurry log
	[Flurry logEvent:@"Tour Screen view"];
    
    [self settingRemoveFromSuperView];
    
    Class tour = NSClassFromString(@"TourViewController");
    
    if(tourObj == nil && ![self.rightDetailView.NavMap.visibleViewController isKindOfClass:[tour class]])
    {
        [self.leftOptionView resetAllOptions];
        tourObj = [[TourViewController alloc]initWithNibName:@"TourViewController" bundle:nil];
        [tourObj.view setFrame:CGRectMake(4, 2, self.rightDetailView.frame.size.width, self.rightDetailView.frame.size.height)];
        [self.rightDetailView addSubview:tourObj.view];
        [self.lblTopTitle setText:@"Tour"];
        
    }
}
- (void)settingRemoveFromSuperView
{
    if(settings)
    {
        NSLog(@"settingRemoveFromSuperView");
        [settings.view removeFromSuperview];
        [settings release];
        settings = nil;
    }
}
- (void)tourRemoveFromSuperView
{
    if(tourObj)
    {
        NSLog(@"tourRemoveFromSuperView");
        [tourObj.view removeFromSuperview];
        [tourObj release];
        tourObj = nil;
    }
}

#pragma mark - UIInterfaceOrientation methods
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    NSLog(@"%@",[rightDetailView description]);
    NSDictionary *dict  =   [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:toInterfaceOrientation] forKey:@"kOrientation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLayout" object:self userInfo:dict];
//    NSLog(@"%s",__PRETTY_FUNCTION__);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0)
{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
}

// New Autorotation support.
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0)
{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    return UIInterfaceOrientationMaskAll;
}
@end
