//
//  NS_ReminderTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 21/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "NS_ReminderTVCell.h"

@implementation NS_ReminderTVCell

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

- (void)dealloc {
    [_lblRemTitle release];
    [_lblRemDesc release];
    [_lblRemDate release];
    [_lblRemLocation release];
    [_btnEdit release];
    [_btnDelete release];
    [super dealloc];
}
@end
