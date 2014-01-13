//
//  ContactViewTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 18/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblTitleValue;
- (void)updateUITableViewCell:(NSString*)cellTitle cellValue:(NSString*)cellValue;
@end
