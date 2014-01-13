//
//  HistoryTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 26/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "HistoryTVCell.h"

@implementation HistoryTVCell

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
    [_bgView release];
    [_lblProposalNumber release];
    [_lblAmount release];
    [_lblDate release];
    [super dealloc];
}
@end
