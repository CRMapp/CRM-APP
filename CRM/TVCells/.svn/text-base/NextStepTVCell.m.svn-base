//
//  NextStepTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 25/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "NextStepTVCell.h"

@implementation NextStepTVCell

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
- (void)updateUITableViewCellForFollowUpdate:(FollowUpdate*)aFollow
{
    [self.lblDate setText:[NSDateFormatter localizedStringFromDate:aFollow.followDate
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle]];
    
    [self.lblDate setBackgroundColor:[UIColor colorWithRed:(float)235/255 green:(float)235/255 blue:(float)235/255 alpha:1.0]];
    self.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    [self.lblTitle setText:aFollow.followTitle];
    self.lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    [self.lblType setText:aFollow.followType];
    self.lblType.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    [self.lblDescription setText:aFollow.followDesc];
    self.lblDescription.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
}
- (void)updateUITableViewCellForNextStep:(FollowUpdate*)aFollow
{
    [self.lblDate setText:[NSDateFormatter localizedStringFromDate:aFollow.followDate
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterNoStyle]];
    
    [self.lblDate setBackgroundColor:[UIColor clearColor]];
    self.lblDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    [self.lblTitle setText:aFollow.followTitle];
    self.lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    [self.lblType setText:aFollow.followType];
    self.lblType.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    
    [self.lblDescription setText:aFollow.followDesc];
    self.lblDescription.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
}
- (void)dealloc {
    [_lblDate release];
    [_lblTitle release];
    [_lblType release];
    [_lblDescription release];
    [super dealloc];
}
@end
