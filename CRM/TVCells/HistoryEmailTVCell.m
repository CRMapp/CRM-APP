//
//  HistoryEmailTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 05/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "HistoryEmailTVCell.h"

@implementation HistoryEmailTVCell

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

- (void)updateUITableViewForHistoryCallOption:(NotesList*)aNote
{
    [self.lblDateTime setText:[NSDateFormatter localizedStringFromDate:aNote.noteDate
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle]];
    
    [self.lblDesc setText:aNote.noteDesc];
}
- (void)dealloc {
    [_lblDateTime release];
    [_lblDesc release];
    [super dealloc];
}
@end
