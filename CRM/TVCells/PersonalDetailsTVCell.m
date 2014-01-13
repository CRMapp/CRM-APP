//
//  PersonalDetailsTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 25/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "PersonalDetailsTVCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CRMConfig.h"
@implementation PersonalDetailsTVCell

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
    
    self.lblValue.text=strStringName;
    self.lblValue.textAlignment = UITextAlignmentLeft;
    self.lblValue.lineBreakMode = UILineBreakModeWordWrap;
    self.lblValue.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
//    [self.lblValue setTextColor:[UIColor lightGrayColor]];
    
    CGSize expectedLabelSize = [strStringName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.0f]
                                         constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                                             lineBreakMode:UILineBreakModeWordWrap];
    
    CGRect newFrame = self.lblValue.frame;
    newFrame.size.width = width;
    
    newFrame.size.height = expectedLabelSize.height;
    self.lblValue.frame = newFrame;
    self.lblValue.numberOfLines = 0;
    [self.lblValue sizeToFit];
    
    if(newFrame.size.height <= 20)
        [self.lblValue setCenter:CGPointMake(self.lblValue.center.x, self.center.y)];
    
    [self.lblTitle setText:[[cellTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]capitalizedString]];
    
    [self addCellBtnForAddressEmailNPhoneNumber];
}
-(void)addCellBtnForAddressEmailNPhoneNumber
{
	//For phone number
	
	//if ([self.lblValue.text length] > 10 && [self.lblValue.text length] < 25)
	{
		// that it is near to a phone number length
		NSCharacterSet *charactersToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet ];
		
		NSString *Phonenumber =[[[self.lblValue.text lowercaseString] componentsSeparatedByCharactersInSet:charactersToRemove ]
                                componentsJoinedByString:@""];
		
		if (8 < [Phonenumber length] && [Phonenumber length] <= 16)
		{
			if ([self.lblTitle.text rangeOfString:@"home" options:NSCaseInsensitiveSearch].length||
				[self.lblTitle.text rangeOfString:@"iphone" options:NSCaseInsensitiveSearch].length||
				[self.lblTitle.text rangeOfString:@"main" options:NSCaseInsensitiveSearch].length||
				[self.lblTitle.text rangeOfString:@"work" options:NSCaseInsensitiveSearch].length||
				[self.lblTitle.text rangeOfString:@"mobile" options:NSCaseInsensitiveSearch].length||
				[self.lblTitle.text rangeOfString:@"other" options:NSCaseInsensitiveSearch].length||
				[self.lblTitle.text rangeOfString:@"Custom Field" options:NSCaseInsensitiveSearch].length)
			{
				[self.btnNavigateTo setTag:6];
				[self addButtonOnCell];
			}
			
		}
		
	}
	
	if ([self.lblTitle.text rangeOfString:@"twitter" options:NSCaseInsensitiveSearch].length)
	{
		//That means we have twitter
		[self.btnNavigateTo setTag:1];
		[self addButtonOnCell];
	}
	
	//Address
	else if ([self.lblTitle.text rangeOfString:@"state" options:NSCaseInsensitiveSearch].length)
	{
		//That means address
		[self.btnNavigateTo setTag:2];
		[self addButtonOnCell];
	}
	else if ([self.lblTitle.text rangeOfString:@"zip" options:NSCaseInsensitiveSearch].length)
	{
		//That means we zip
		[self.btnNavigateTo setTag:2];
		[self addButtonOnCell];
	}
    else if ([self.lblTitle.text rangeOfString:@"street" options:NSCaseInsensitiveSearch].length)
	{
		//That means we street
		[self.btnNavigateTo setTag:2];
		[self addButtonOnCell];
	}
    else if ([self.lblTitle.text rangeOfString:@"city" options:NSCaseInsensitiveSearch].length)
	{
		//That means we city
		[self.btnNavigateTo setTag:2];
		[self addButtonOnCell];
	}
	else if ([self.lblTitle.text rangeOfString:@"country" options:NSCaseInsensitiveSearch].length)
	{
		//That means we country
		[self.btnNavigateTo setTag:2];
		[self addButtonOnCell];
	}
	
	//--
	
	
	else if ([self.lblTitle.text rangeOfString:@"Facebook" options:NSCaseInsensitiveSearch].length||
			 [self.lblTitle.text rangeOfString:@"linkedin" options:NSCaseInsensitiveSearch].length||
			 [self.lblTitle.text rangeOfString:@"google" options:NSCaseInsensitiveSearch].length)
	{
		//That means we country
		[self.btnNavigateTo setTag:3];
		[self addButtonOnCell];
	}
	
	//Email
	
	else if ([self.lblTitle.text rangeOfString:@"Email" options:NSCaseInsensitiveSearch].length)
	{
		//That means we country
		[self.btnNavigateTo setTag:4];
		[self addButtonOnCell];
	}
	
	//
	
	else if ([self.lblTitle.text rangeOfString:@"home page" options:NSCaseInsensitiveSearch].length||
			 [self.lblTitle.text rangeOfString:@"home url" options:NSCaseInsensitiveSearch].length)
	{
		//That means we country
		[self.btnNavigateTo setTag:5];
		[self addButtonOnCell];
	}
}

-(void)addButtonOnCell
{
	CGSize sizeBtn = [self.lblValue.text sizeWithFont:self.lblValue.font constrainedToSize:self.lblValue.bounds.size lineBreakMode:self.lblValue.lineBreakMode];
	
	[self addSubview:self.btnNavigateTo];
	
	[self.btnNavigateTo setFrame:CGRectMake(self.lblValue.frame.origin.x, self.lblValue.frame.origin.y, sizeBtn.width, sizeBtn.height)];
}
- (void)dealloc {
    [_lblTitle release];
    [_lblValue release];
    [_btnNavigateTo release];
    [super dealloc];
}
@end
