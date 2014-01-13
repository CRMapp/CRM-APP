//
//  GroupMemberTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 17/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "GroupMemberTVCell.h"

@implementation GroupMemberTVCell

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
    [_lblContactName release];
    [_lblCompany release];
    [_lblTitle release];
    [_btnViewContact release];
    [_btnDeleteContact release];
    [super dealloc];
}
@end
