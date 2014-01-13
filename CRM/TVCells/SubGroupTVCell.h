//
//  SubGroupTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 14/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubGroupTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblSubGroupName;
@property (retain, nonatomic) IBOutlet UILabel *lblSubGrpDesc;
@property (retain, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UIButton *btnDelete;

@end
