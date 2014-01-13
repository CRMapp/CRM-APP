//
//  ProposalTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 24/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ProposalTVCell.h"

@implementation ProposalTVCell

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
    [_lblName release];
    [_lblDesc release];
    [_lblDate release];
    [_btnEdit release];
    [_btnDelete release];
    [super dealloc];
}
@end
