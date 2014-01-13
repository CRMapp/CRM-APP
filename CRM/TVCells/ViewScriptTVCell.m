//
//  ViewScriptTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 12/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ViewScriptTVCell.h"

@implementation ViewScriptTVCell

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
    [_lblScriptName release];
    [_lblScriptDesc release];
    [_lblDate release];
    [_btnEditScript release];
    [_btnDeleteScript release];
    [super dealloc];
}
@end
