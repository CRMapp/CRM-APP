//
//  HistoryCallTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 05/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentList.h"
#import "EmailList.h"
#import "ReminderList.h"
#import "NotesList.h"
@interface HistoryCallTVCell : UITableViewCell


//@property (retain, nonatomic) IBOutlet UILabel *lblDuration;
@property (retain, nonatomic) IBOutlet UILabel *lblDescription;

@property (retain, nonatomic) IBOutlet UILabel *lblDateTime;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;


- (void)updateUITableViewForHistoryEventOption:(AppointmentList*)aAppoint;
- (void)updateUITableViewForHistoryEmailOption:(EmailList*)aemail;
- (void)updateUITableViewForHistoryReminderOption:(ReminderList*)arem;
- (void)updateUITableViewForHistoryCallOption:(NotesList*)aNote;
@end
