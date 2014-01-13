//
//  SaleGoalTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 23/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kTarget @"Target"
#define kTimePeriod @"Time period"
#define kTermPeriod @"Term period"
#define kSaleDate @"Sales starting date"
@protocol SaleGoalTVCellDelegate <NSObject>

-(void)textFiledDidEditingWithTextField:(UITextField *)textField;
@end



@interface SaleGoalTVCell : UITableViewCell <UITextFieldDelegate>
@property (assign, nonatomic) id <SaleGoalTVCellDelegate>  adelegate;
@property (retain, nonatomic) IBOutlet UILabel *lblRightTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblSap;
@property (retain, nonatomic) IBOutlet UITextField *txtfTarget;
@property (retain, nonatomic) IBOutlet UIButton *btnDropDown;
@property (retain, nonatomic) IBOutlet UIButton *btnDOB;
@property (retain, nonatomic) IBOutlet UIImageView *imgDDbg;
@property (retain, nonatomic) IBOutlet UIImageView *imgDDbg1;
@property (retain, nonatomic) IBOutlet UIButton *btnDropDownNum;

- (void)updateTableCell:(NSIndexPath*)indexpath info:(NSMutableDictionary*)dict;
@end
