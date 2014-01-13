//
//  ContactListTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 26/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "MyAddressBook.h"
@interface ContactListTVCell : UITableViewCell
//@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet EGOImageView *imgVwUser;
@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblCompany;
@property (retain, nonatomic) IBOutlet UIButton *btnCheck;
@property (retain, nonatomic) IBOutlet UIButton *btnEditContact;
@property (retain, nonatomic) IBOutlet UIImageView *imgArrow;

- (void)updateUITableViewCellWithContact:(MyAddressBook*)aContact withIndexPath:(NSIndexPath*)indexPath;
@end
