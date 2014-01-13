//
//  FunnelTVCell.m
//  CRM
//
//  Created by Narendra Verma on 16/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "FunnelTVCell.h"

@implementation FunnelTVCell

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
-(void)setDataInCell:(MyAddressBook*)myAddObj
{
	[self.stagememberName setText:[NSString stringWithFormat:@"%@ %@",(myAddObj.firstName)?myAddObj.firstName:@"",(myAddObj.lastName)?myAddObj.lastName:@""]];
	
	[self.stageCompName setText:[NSString stringWithFormat:@"%@",(myAddObj.organisation)?myAddObj.organisation:@""]];
}
- (void)dealloc {
	[_stagememberName release];
	[_stageCompName release];
	[_btnDelete release];
	[_btnEdittapped release];
	[_btnChackMark release];
	[super dealloc];
}
@end
