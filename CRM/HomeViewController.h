//
//  HomeViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftOptionView.h"
#import "RightDetailsView.h"
@class SettingsViewController;
@class TourViewController;
@interface HomeViewController : UIViewController
{
    SettingsViewController *settings;
    TourViewController *tourObj;
}
@property (nonatomic, retain) IBOutlet UILabel     *lblTopTitle;
@property (nonatomic, retain) IBOutlet LeftOptionView     *leftOptionView;
@property (nonatomic, retain) IBOutlet RightDetailsView   *rightDetailView;
-(IBAction)btnSettingsTapped:(id)sender;
- (void)settingRemoveFromSuperView;
- (void)tourRemoveFromSuperView;
-(IBAction)btnTourTapped:(id)sender;
- (IBAction)btnFeedbacksTapped:(id)sender;

@end
