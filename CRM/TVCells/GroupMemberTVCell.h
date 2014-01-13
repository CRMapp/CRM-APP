//
//  GroupMemberTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 17/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblContactName;
@property (retain, nonatomic) IBOutlet UILabel *lblCompany;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnViewContact;
@property (retain, nonatomic) IBOutlet UIButton *btnDeleteContact;

@end
