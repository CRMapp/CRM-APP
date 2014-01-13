//
//  SalesGoalViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 23/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownView.h"
#import "SaleGoalTVCell.h"
@interface SalesGoalViewController : UIViewController<SaleGoalTVCellDelegate>
{
    IBOutlet UIView *view_header;
    IBOutlet UIView *view_footer;
    IBOutlet UIView *view_date_picker;
    IBOutlet UIDatePicker *dateTimePicker;
    IBOutlet UITableView *tblSaleGoal;
	IBOutlet UIView *vwGraph;
	IBOutlet UILabel *lblSalesGoal;
	
	IBOutlet UILabel *lblTitleValue1;
	IBOutlet UILabel *lblTitleValue2;
	IBOutlet UILabel *lblTitleValue3;
	
	
	IBOutlet UILabel *lblSetGoal;
	IBOutlet UILabel *lblValue1;
	IBOutlet UILabel *lblValue2;
	IBOutlet UILabel *lblValue3;
}
@property (nonatomic , retain) DropDownView *dropDownView;
@property (retain , nonatomic) UIPopoverController *datePickerPopover;
@property (nonatomic , retain) NSMutableDictionary *tableDict;


- (IBAction)btnDeleteTapped:(UIButton *)sender;
- (IBAction)btnDoneToolBar:(id)sender;
- (IBAction)btnSaveSalesGoal:(id)sender;
- (IBAction)btnCancel:(id)sender;
@end
