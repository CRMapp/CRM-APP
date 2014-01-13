//
//  SaleGoalTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 23/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "SaleGoalTVCell.h"
#import "Global.h"
@implementation SaleGoalTVCell
@synthesize adelegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateTableCell:(NSIndexPath*)indexpath info:(NSMutableDictionary*)dict
{
    [_txtfTarget setDelegate:self];
    switch (indexpath.row) {
        case 0:
            [_lblRightTitle setText:@"Target"];
            [_txtfTarget setHidden:NO];
            [_btnDOB setHidden:YES];
            [_txtfTarget setText:[Global convertStringToNumberFormatter:[dict objectForKey:kTarget]
														 withDollerSign:YES]];
            [_txtfTarget setKeyboardType:UIKeyboardTypeNumberPad];
            break;
        case 1:
            [_lblRightTitle setText:@"Target period"];
            [_txtfTarget setHidden:YES];
            [_btnDropDown setHidden:NO];
            [_imgDDbg setHidden:NO];
            [_btnDropDownNum setHidden:NO];
            [_imgDDbg1 setHidden:NO];
            [_btnDOB setHidden:YES];
            
            [_btnDropDown setTitle:[dict objectForKey:kTimePeriod] forState:UIControlStateNormal];
            _btnDropDown.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            [_btnDropDownNum setTitle:[dict objectForKey:kTermPeriod] forState:UIControlStateNormal];
            _btnDropDownNum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;
        case 2:
            [_lblRightTitle setText:@"Sales starting date"];
            [_txtfTarget setHidden:NO];
            [_txtfTarget setUserInteractionEnabled:NO];
            [_btnDOB setHidden:NO];
            [_txtfTarget setText:[dict objectForKey:kSaleDate]];
            break;
        default:
            break;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[textField setText:[Global convertPriceBackToNumbersWithPriceText:textField.text]];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
	[self performSelector:@selector(saveFromTextFiledDelegateWithDelay) withObject:nil afterDelay:0.1];
	return [Global checkForNumbersOnlyInTextField:textField withRange:range replacementString:string withNumDigitLimits:20 allowPeriod:YES];
	
	return YES;
}

-(void)saveFromTextFiledDelegateWithDelay
{
	
	if (self.adelegate && [self.adelegate respondsToSelector:@selector(textFiledDidEditingWithTextField:)])
	{
		
		[self.adelegate performSelector:@selector(textFiledDidEditingWithTextField:) withObject:self.txtfTarget];
	}
    
}

- (void)dealloc {
    [_lblRightTitle release];
    [_lblSap release];
    [_txtfTarget setDelegate:nil];
    [_txtfTarget release];
    [_btnDropDown release];
    [_btnDOB release];
    [_imgDDbg release];
    [_imgDDbg1 release];
    [_btnDropDownNum release];
    [super dealloc];
}
@end
