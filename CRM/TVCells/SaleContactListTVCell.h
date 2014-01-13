//
//  SaleContactListTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 21/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MyAddressBook.h"
@interface SaleContactListTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet EGOImageView *imgVwUser;
@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblCompany;
@property (retain, nonatomic) IBOutlet UIButton *btnCheck;
@property (retain, nonatomic) IBOutlet UIButton *btnEditContact;
@property (retain, nonatomic) IBOutlet UIImageView *imgArrow;
@property (retain, nonatomic) IBOutlet UIButton *btnCheckCustomer;
@property (retain, nonatomic) IBOutlet UIButton *btnCheckSuspect;
@property (retain, nonatomic) IBOutlet UIButton *btnCheckProspect;


@property (retain, nonatomic) MyAddressBook *aContactInfo;
- (IBAction)btnCheckCategory:(UIButton*)sender;
- (void)setSelectedStage;


- (void)updateUITableViewCellWithContact:(MyAddressBook*)aContact withIndexPath:(NSIndexPath*)indexPath;
- (void)SetContactInfo:(MyAddressBook*)aContact atIndexPath:(NSIndexPath*)indexPath;

@end
