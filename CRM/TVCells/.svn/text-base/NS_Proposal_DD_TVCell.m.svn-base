//
//  NS_Proposal_DD_TVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 05/06/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "NS_Proposal_DD_TVCell.h"

@implementation NS_Proposal_DD_TVCell
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
- (void)updateUITableViewCellForProduct:(ProductList*)aProduct
{
    [_txtfQuantity setDelegate:self];
    [_txtfQuantity setClearButtonMode:UITextFieldViewModeNever];
    [_lblProductName setText:aProduct.productName];
    [_lblProductPrice setText:aProduct.price];
}
#define CHARACTER_LIMIT 20
#define NUMBERS_ONLY @"1234567890"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	[self performSelector:@selector(aMethod:) withObject:textField afterDelay:0.1];
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    }
	return YES;
}
- (void)aMethod:(UITextField *)textField
{
    if (self.adelegate && [self.adelegate respondsToSelector:@selector(sendQuantity:)])
	{
		[self.adelegate performSelector:@selector(sendQuantity:) withObject:textField];
	}
}
- (void)dealloc
{
    [_txtfQuantity setDelegate:nil];
    [_btnCheckBox release];
    [_lblProductName release];
    [_lblProductPrice release];
    [_txtfQuantity release];
    [super dealloc];
}
@end
