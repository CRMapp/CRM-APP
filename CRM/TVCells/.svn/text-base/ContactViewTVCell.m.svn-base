//
//  ContactViewTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 18/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ContactViewTVCell.h"

@implementation ContactViewTVCell

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
- (void)updateUITableViewCell:(NSString*)cellTitle cellValue:(NSString*)cellValue
{
	//    if ([cellTitle isEqualToString:NOTE_STRING])
	//    {
	//        cellTitle = @"Google+";
	//    }
    cellTitle = [[cellTitle componentsSeparatedByCharactersInSet: [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@" "];
    
    UIInterfaceOrientation *interface = [[UIApplication sharedApplication] statusBarOrientation];
    int orientation = interface;
    CGFloat width  = 660;
    if (orientation <=2)
    {
        width  = 395;
    }
    NSString *strStringName = cellValue;
    
    self.lblTitleValue.text=strStringName;
    self.lblTitleValue.textAlignment = UITextAlignmentLeft;
    self.lblTitleValue.lineBreakMode = UILineBreakModeWordWrap;
    self.lblTitleValue.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	//    [self.lblValue setTextColor:[UIColor lightGrayColor]];
    
    CGSize expectedLabelSize = [strStringName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f]
                                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                             lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = self.lblTitleValue.frame;
    newFrame.size.width = width;
    
    newFrame.size.height = expectedLabelSize.height;
    self.lblTitleValue.frame = newFrame;
    self.lblTitleValue.numberOfLines = 0;
    [self.lblTitleValue sizeToFit];
    
    if(newFrame.size.height <= 20)
        [self.lblTitleValue setCenter:CGPointMake(self.lblTitleValue.center.x, self.center.y)];
    
    [self.lblTitle setText:[cellTitle capitalizedString]];
}
- (void)dealloc {
    [_lblTitle release];
    [_lblTitleValue release];
    [super dealloc];
}
@end
