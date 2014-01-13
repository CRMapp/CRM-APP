//
//  ContactListTVCell.m
//  CRM
//
//  Created by Sheetal's iMac on 26/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ContactListTVCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageData.h"
@implementation ContactListTVCell

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

    [[_imgVwUser layer]setCornerRadius:8.0];
    [[_imgVwUser layer]setBorderWidth:1.0];
    [[_imgVwUser layer]setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [_imgVwUser.layer setMasksToBounds:YES]; ;

    // Configure the view for the selected state
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
		//ImageData Narendra
		//if file not found
		//and check if we have image url in database (image data)
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"image_Path == %@",aContact.image];
		
		NSArray * array = [CoreDataHelper searchObjectsForEntity:@"ImageData" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
		
		if ([array count])//we have image data in data base
		{
			ImageData * imgObj = [array lastObject];
			if (imgObj.image_Data)
			{
				[self.imgVwUser setImage:[UIImage imageWithData:imgObj.image_Data]];
                
				//Now we save the image in the document dir
				//So that it can be accessed for there afetr words
				BOOL success =   [imgObj.image_Data writeToFile:aContact.image atomically:NO];
				
				if (success)
				{
					NSLog(@"Image saved successFully");
				}
				
			}
			else
			{
                self.imgVwUser.image = [UIImage imageNamed:@"ipad_user_img.png"];
			}
			
		}
		else// we dont have image data in database as well
		{
            self.imgVwUser.image = [UIImage imageNamed:@"ipad_user_img.png"];
		}
    }

    
    self.lblCompany.text  = (aContact.organisation)?aContact.organisation:@"";
    self.lblTitle.text    = (aContact.jobTitle)?aContact.jobTitle:@"";
    self.lblUserName.text = [(aContact.firstName)?aContact.firstName:@"" stringByAppendingFormat:@" %@",(aContact.lastName)?aContact.lastName:@""];
}
- (void)dealloc {
    [_imgVwUser release];
    [_lblUserName release];
    [_lblTitle release];
    [_lblCompany release];
    [_btnCheck release];
    [_btnEditContact release];
    [_imgArrow release];
    [super dealloc];
}

@end
