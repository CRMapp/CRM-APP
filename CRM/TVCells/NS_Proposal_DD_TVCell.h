//
//  NS_Proposal_DD_TVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 05/06/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductList.h"
@protocol NS_Proposal_DD_TVCellDelegate <NSObject>

-(void)sendQuantity:(UITextField*)textFiled;

@end

@interface NS_Proposal_DD_TVCell : UITableViewCell<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (retain, nonatomic) IBOutlet UILabel *lblProductName;
@property (retain, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (retain, nonatomic) IBOutlet UITextField *txtfQuantity;

@property (assign, nonatomic) id <NS_Proposal_DD_TVCellDelegate>  adelegate;


- (void)updateUITableViewCellForProduct:(ProductList*)aProduct;
@end
