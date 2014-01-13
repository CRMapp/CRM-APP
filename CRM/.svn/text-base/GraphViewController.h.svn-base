//
//  GraphViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 04/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "AddNewContactViewController.h"

@interface GraphViewController : UIViewController//<AddNewVCDelegate>
{
	IBOutlet UIView *vwPortrate;
	IBOutlet UIView *vwLandscape;
	IBOutlet UITableView *tableDetails;
	IBOutlet UIView *vwGraph;
	IBOutlet UILabel *lblNoData;
    IBOutlet UILabel *lblLastContactedDays;
	IBOutlet UIView *vwFliterPopOver;
	IBOutlet UISwitch *switchProposal;
	IBOutlet UIView *vwFilterView;
	
    IBOutlet UIView *view_header;
	IBOutlet UIButton *btnFunnelFilter;
	
	IBOutlet UITextField *txtFromLocation;
	IBOutlet UITextField *txtRestrictDistance;
    //View industry
	IBOutlet UISearchBar *txtIndustrySearch;
	IBOutlet UITableView *tableIndustry;
	IBOutlet UIView *vwIndustrySearch;
    BOOL isFilterSearch;
    BOOL isNewSearch;
}
@property (nonatomic, retain) NSMutableArray * arrayIndustry;
@property (nonatomic, retain) UIPopoverController * popoverIndustry;

@property (assign, nonatomic) int editItemTag;
@property (retain, nonatomic) NSIndexPath * lastIndexpath;
@property (assign, nonatomic) CGRect rectForVWFilter;
@property (retain, nonatomic) DropDownView * dropDownViewInGraph;
@property (retain, nonatomic) UIPopoverController * popoverView;
@property (retain, nonatomic) NSMutableArray * mArrayFunnelItems;
- (IBAction)btnOptionTapped:(UIButton *)sender;
- (IBAction)btnIndustryTapped:(UIButton *)sender;
- (IBAction)btnFunnelFilterTapped:(UIButton*)sender;
- (IBAction)btnApplyFilterTapped:(UIButton *)sender;
- (IBAction)btnResetFilter:(UIButton *)sender;

- (IBAction)btnDropDownTapped:(UIButton *)sender;
- (IBAction)btnFilterOptionTapped:(UIButton *)sender;
@end
