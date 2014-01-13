//
//  EditContact_EmailTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 03/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressBook.h"

@interface EditContact_EmailTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UITextField *txtfSalutation;
@property (retain, nonatomic) IBOutlet UITextField *txtfPrefix;
@property (retain, nonatomic) IBOutlet UITextField *txtfSuffix;
@property (retain, nonatomic) IBOutlet UITextField *txtfFName;
@property (retain, nonatomic) IBOutlet UITextField *txtfMName;
@property (retain, nonatomic) IBOutlet UITextField *txtfLName;
@property (retain, nonatomic) IBOutlet UIButton *btnCheck;
@property (retain, nonatomic) IBOutlet UILabel *lblInfo;
- (void)updateTableViewCell:(MyAddressBook*)person;
@end
