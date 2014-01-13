//
//  EditContact_EmailTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 03/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "EditContact_EmailTVCell.h"
#import "CRMConfig.h"
@implementation EditContact_EmailTVCell

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
- (void)updateTableViewCell:(MyAddressBook*)person
{
    NSString *text = @"";
    
    if(person.salutation)
        text = [text stringByAppendingFormat:@"    %@",person.salutation];
    if(person.prefix)
        text = [text stringByAppendingFormat:@"    %@",person.prefix];
    if(person.firstName)
        text = [text stringByAppendingFormat:@"    %@",person.firstName];
    if(person.middleName)
        text = [text stringByAppendingFormat:@"    %@",person.middleName];
    if(person.lastName)
        text = [text stringByAppendingFormat:@"    %@",person.lastName];
    if(person.suffix)
        text = [text stringByAppendingFormat:@"    %@",person.suffix];
    
    [self.btnCheck          setSelected:person.isSelected];
    
    if(text.length)
    {
        [self.lblInfo setText:text];
    }
    else
    {
        [self.lblInfo setText:[SALUTATION_STRING stringByAppendingFormat:@"    %@    %@    %@    %@    %@",PREFIX_STRING,FIRST_NAME_STRING,MIDDLE_NAME_STRING,LAST_NAME_STRING,SUFFIX_STRING]];
        [self.lblInfo setTextColor:[UIColor lightGrayColor]];
    }
//
//    [self.txtfSalutation    setText:person.salutation];
//    [self.txtfPrefix        setText:person.prefix];
//    [self.txtfFName         setText:person.firstName];
//    [self.txtfMName         setText:person.middleName];
//    [self.txtfLName         setText:person.lastName];
//    [self.txtfSuffix        setText:person.suffix];
}
- (void)dealloc {
    [_txtfSalutation release];
    [_txtfPrefix release];
    [_txtfSuffix release];
    [_txtfFName release];
    [_txtfMName release];
    [_txtfLName release];
    [_btnCheck release];
    [_lblInfo release];
    [super dealloc];
}
@end
