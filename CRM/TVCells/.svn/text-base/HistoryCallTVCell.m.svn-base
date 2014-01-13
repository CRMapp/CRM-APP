//
//  HistoryCallTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 05/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "HistoryCallTVCell.h"

@implementation HistoryCallTVCell

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


- (void)updateUITableViewForHistoryEventOption:(AppointmentList*)aAppoint
{
//    NSDate *aDate = NSDate *date = [NSDate dateWithTimeIntervalSince1970:aAppoint.date];
    
    //NOTE
    /*As per the client requirement change we have assign date to title feild and vice-versa */
    [self.lblTitle setText:aAppoint.title];
    
    [self.lblDateTime setText:[NSDateFormatter localizedStringFromDate:aAppoint.date
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle]];
    
//    [_lblDuration setText:aAppoint.title];
    [_lblDescription setText:aAppoint.desc];
}
- (void)updateUITableViewForHistoryEmailOption:(EmailList*)aemail
{
    //    NSDate *aDate = NSDate *date = [NSDate dateWithTimeIntervalSince1970:aAppoint.date];
    
    //NOTE
    /*As per the client requirement change we have assign date to title feild and vice-versa */
    [self.lblTitle setText:aemail.emailTitle];
    
    [self.lblDateTime setText:[NSDateFormatter localizedStringFromDate:aemail.date
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle]];
    
    //    [_lblDuration setText:aAppoint.title];
    [_lblDescription setText:aemail.desc];
}
- (void)updateUITableViewForHistoryReminderOption:(ReminderList*)arem
{
    //    NSDate *aDate = NSDate *date = [NSDate dateWithTimeIntervalSince1970:aAppoint.date];
    
    //NOTE
    /*As per the client requirement change we have assign date to title feild and vice-versa */
    [self.lblTitle setText:arem.remTitle];
    
    [self.lblDateTime setText:[NSDateFormatter localizedStringFromDate:arem.remDate
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle]];
    
    //    [_lblDuration setText:aAppoint.title];
    [_lblDescription setText:arem.remDesc];
}
- (void)updateUITableViewForHistoryCallOption:(NotesList*)aNote
{
    [self.lblTitle setText:@"Call"];
    
    [self.lblDateTime setText:[NSDateFormatter localizedStringFromDate:aNote.noteDate
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle]];
    
    //    [_lblDuration setText:aAppoint.title];
    [_lblDescription setText:aNote.noteDesc];
}
- (void)dealloc {
    [_lblDateTime release];
//    [_lblDuration release];
    [_lblDescription release];
    [_lblTitle release];
    [super dealloc];
}
@end
