//
//  SaleContactListTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 21/05/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "SaleContactListTVCell.h"
//#import "AppDelegate.h"
@implementation SaleContactListTVCell
@synthesize aContactInfo;

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
- (void)SetContactInfo:(MyAddressBook*)aContact atIndexPath:(NSIndexPath*)indexPath
{
    self.aContactInfo = aContact;
    [self updateUITableViewCellWithContact:self.aContactInfo withIndexPath:indexPath];
    AppDelegate *aDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[aDelegate managedObjectContext] save:nil];
}
- (IBAction)btnCheckCategory:(UIButton*)sender
{
    self.aContactInfo.funnelStageID = 0;
    sender.selected = !sender.selected;

    [self resetSender:nil];
    
   /* if ([sender.titleLabel.text rangeOfString:@"Customer" options:NSCaseInsensitiveSearch].length)
    {
        [self resetSender:_btnCheckCustomer];
        [self.aContactInfo setFunnelStageID:[NSNumber numberWithInt:14]];
    }
    else if ([sender.titleLabel.text rangeOfString:@"Suspect" options:NSCaseInsensitiveSearch].length)
    {
        [self resetSender:_btnCheckSuspect];
        self.aContactInfo.funnelStageID = [NSNumber numberWithInt:15];
    }
    else if ([sender.titleLabel.text rangeOfString:@"Prospect" options:NSCaseInsensitiveSearch].length)
    {
        [self resetSender:_btnCheckProspect];
        self.aContactInfo.funnelStageID = [NSNumber numberWithInt:11];
    }*/
    AppDelegate *aDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[aDelegate managedObjectContext] save:nil];
}
- (void)setSelectedStage
{
    if ([self.aContactInfo.funnelStageID integerValue] == 14)
    {
        [self resetSender:_btnCheckCustomer];
    }
    else if ([self.aContactInfo.funnelStageID integerValue] == 15)
    {
        [self resetSender:_btnCheckSuspect];
    }
    else if ([self.aContactInfo.funnelStageID integerValue] == 11)
    {
        [self resetSender:_btnCheckProspect];
    }
}
- (void)resetSender:(UIButton*)sender
{
    [_btnCheckCustomer setSelected:NO];
    [_btnCheckSuspect  setSelected:NO];
    [_btnCheckProspect setSelected:NO];
    
    [sender setSelected:YES];
}
- (void)updateUITableViewCellWithContact:(MyAddressBook*)aContact withIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row % 2 == 0)
    {
        CGFloat color  = (float)247/255;
        [self.contentView setBackgroundColor:[UIColor colorWithRed:color green:color blue:color alpha:1.0]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    [self.btnCheck setSelected:aContact.isSelected];
    
    BOOL file  =   [[NSFileManager defaultManager] fileExistsAtPath:aContact.image];
    if (file)
    {
        self.imgVwUser.image = [UIImage imageWithContentsOfFile:aContact.image];
    }
    else
    {
        self.imgVwUser.image = [UIImage imageNamed:@"ipad_user_img.png"];
    }
    
    self.lblCompany.text  = (aContact.organisation)?aContact.organisation:@"";
    self.lblTitle.text    = (aContact.jobTitle)?aContact.jobTitle:@"";
    self.lblUserName.text = [(aContact.firstName)?aContact.firstName:@"" stringByAppendingFormat:@" %@",(aContact.lastName)?aContact.lastName:@""];
}
- (void)dealloc
{
    [_imgVwUser release];
    [_lblUserName release];;
    [_lblTitle release];
    [_lblCompany release];
    [_btnCheck release];
    [_btnEditContact release];
    [_imgArrow release];
    [_btnCheckCustomer release];
    [_btnCheckSuspect release];
    [_btnCheckProspect release];
    
    [super dealloc];
}
@end
