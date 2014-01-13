//
//  MapViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 12/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"
#import "AddressBook.h"
#import "TouchView.h"
#import "DropDownView.h"
#import "DisplayMap.h"

typedef enum
{
	typeGoogleCategory = 0,
	typeIndustry
} PopupType;

typedef enum
{
	CallOutTypeUserDetails = 0,
	CallOutTypeGoogleCategory
} CallOutType;
@interface MapViewController : UIViewController<SPUserResizableViewDelegate,DropDownDelegate,CLLocationManagerDelegate>
{
    IBOutlet MKMapView *aMapView;
    SPUserResizableView *userResizableView;
    IBOutlet UIView *mapCallOutView;
    IBOutlet UIView *mapFilterView;
    IBOutlet UILabel *lblUsername;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblFunnelStage;
    IBOutlet UIImageView *imgVMapArrow;
    IBOutlet UIImageView *imgVSearchBg;
    IBOutlet UIImageView *imgVDropDownBg;
    IBOutlet UIButton *btnFetchMore;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIButton *btnCreateGroup;
    IBOutlet UIImageView *imgVContact;
    
    NSMutableArray *arrSelected;
    
	IBOutlet UISwitch *switchProposal;
	
	IBOutlet UITextField *txtSearchField;
	IBOutlet UITextField *txtFromLocation;
	IBOutlet UITextField *txtRestrectedMile;
    
    IBOutlet UIView         *vwIndustrySearch;
	IBOutlet UITableView    *tableIndustry;
	IBOutlet UISearchBar    *txtIndustrySearch;
    
    //Selected Google Category
	
    
    IBOutlet UIView *vwCategoryView;
	IBOutlet UITextField *txtcategoryLocation;
	IBOutlet UITextField *txtCategory;
	IBOutlet UIImageView *imgBackGround;

}
// For industry search view
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString * strSelectedGoogleCategory;
@property (nonatomic, retain) NSString * pagetoken;
@property (nonatomic, retain) UIPopoverController * popoverIndustry;
@property (nonatomic, retain) NSMutableArray * arrayIndustry;
@property (nonatomic, retain) NSMutableArray * categoryResultArray;

@property (nonatomic , assign) BOOL isNetworkOn;
@property (nonatomic , retain) NSMutableArray *arrSelected;
@property (nonatomic, retain) DropDownView *dropDownVw;
@property (nonatomic, retain) DropDownView *dropDownVWOnTop;

@property (nonatomic , retain) NSMutableArray *arrMyAddressBook;
@property (assign, nonatomic) CallOutType typeOfCallout;

@property (assign, nonatomic) PopupType typePopover;
@property (assign, nonatomic) DisplayMap * displayObj;

@property (retain, nonatomic) NSOperationQueue * queue;
@property (assign, nonatomic) CLLocationCoordinate2D coordinateLocGoogleCategory;

- (IBAction)btnFunnelStageTapped:(UIButton*)sender;
- (IBAction)btnLeadStatus:(UIButton*)sender;
- (IBAction)btnLeadSourceTapped:(UIButton *)sender;
- (IBAction)btnDoneTapped:(id)sender;
- (IBAction)btnCreateGroupTapped:(UIButton*)sender;
- (IBAction)btnApplyFilter:(UIButton *)sender;
-(IBAction)btnMapFilterTapped:(UIButton*)sender;
- (IBAction)btnresetFilter:(UIButton *)sender;
- (IBAction)btnIndTapped:(UIButton *)sender;
- (IBAction)btnOptionButtonsTapped:(UIButton *)sender;
- (IBAction)btnFetchMore:(id)sender;

@end
