//
//  AddNewContectDetailCell.m
//  CRM
//
//  Created by Narendra Verma on 09/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//


#import "MyAddressBook.h"

#import "AllEmail.h"
#import "AllPhone.h"
#import "AllAddress.h"
#import "AllUrl.h"
#import "AddNewContactViewController.h"
#import "AddNewContectDetailCell.h"
#import "CRMConfig.h"
//#import "AppDelegate.h"
//#import "CoreDataHelper.h"
#import "FunnelStageList.h"

#import "GlobalDataPersistence.h"

@implementation AddNewContectDetailCell{
  
    NSMutableDictionary *newRecord;

}


@synthesize editMyAddObj;
@synthesize adelegate;
@synthesize indexPathForCell;
@synthesize dictM_MyaddressBookCell;

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




-(void)setlabeldetailTitleWithDict:(NSDictionary *)dictData andWithSize:(CGSize)size
{
   
    
    //Lable for Multi value cell
    if([[dictData objectForKey:kDETAILSTITLE] isEqualToString:EMAIL_STRING]){
        
        [self.lblDetailTitle setHidden:YES];
        //[self.lblDetailTitle setText:[NSString stringWithFormat:@"%@",[dictData objectForKey:kDETAILSTITLE]]];
       
    }
    else if ([[dictData objectForKey:kDETAILSTITLE] isEqualToString:URL_STRING]){
        
        [self.lblDetailTitle setHidden:YES];
        //[self.lblDetailTitle setText:[NSString stringWithFormat:@"%@",[dictData objectForKey:kDETAILSTITLE]]];
     
    }
    else if ([[dictData objectForKey:kDETAILSTITLE] isEqualToString:PHONE_STRING]){
      
        [self.lblDetailTitle setHidden:YES];
        //[self.lblDetailTitle setText:[NSString stringWithFormat:@"%@",[dictData objectForKey:kDETAILSTITLE]]];
       
    }
    else if ([[dictData objectForKey:kDETAILSTITLE] isEqualToString:ADDRESS_STRING]){
        
        [self.lblDetailTitle setHidden:YES];
                [self setAddressView];
                self.addressCity.placeholder = [NSString stringWithFormat:@"City"];
                self.addressCountry.placeholder = [NSString stringWithFormat:@"Country"];
                self.addressState.placeholder = [NSString stringWithFormat:@"State"];
                self.addressStreet.placeholder = [NSString stringWithFormat:@"Street"];
                self.addressType.placeholder = [NSString stringWithFormat:@"Address Label"];
                self.addressZip.placeholder = [NSString stringWithFormat:@"Zip"];
        //[self.lblDetailTitle setText:[NSString stringWithFormat:@"%@",[dictData objectForKey:kDETAILSTITLE]]];
    }
    else{
        [self.lblDetailTitle setText:[NSString stringWithFormat:@"%@",[dictData objectForKey:kDETAILSTITLE]]];
        
        [self.txtdetail setDelegate:self];
        [self.txtTitle setDelegate:self];
//	CGRect rectLblTitle = self.lblDetailTitle.frame;
//	rectLblTitle.size = size;
//	[self.lblDetailTitle setFrame:rectLblTitle];
//	
//	CGRect rectTxt = self.txtdetail.frame;
//	rectTxt.origin.x = rectLblTitle.origin.x + rectLblTitle.size.width + 5;
//	
//	rectTxt.size.width = self.frame.size.width - rectTxt.origin.x;
//	[self.txtdetail setFrame:rectTxt];
	
        [self.txtTitle setHidden:YES];
        
        NSString * strType = [dictData objectForKey:kDETAILSTYPE];
        
        if ([self.lblDetailTitle.text rangeOfString:@"image" options:NSCaseInsensitiveSearch].length)
        {
            [self setImageOnCell];
        }
        else if ([strType rangeOfString:@"typeDOB" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingDateOfBirth];
        }
        else if([strType rangeOfString:@"typeGender" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingGender];
        }
        else if([strType rangeOfString:@"TypeTextView" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingDescription];
        }
        else if([strType rangeOfString:@"typeIndustryDropDown" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingToIndustryDropDown];
        }
        else if([strType rangeOfString:@"typedropdown" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingToSingleDropDownWithDict:dictData];
        }
    /*
     //PreviousAddress 
	else if([strType rangeOfString:@"typePurchase" options:NSCaseInsensitiveSearch].length)
	{
		[self setAccordingToLastPurchase];
	}
	else if([strType rangeOfString:@"typeAddress2" options:NSCaseInsensitiveSearch].length)
	{
		[self setAccordingToAddressLine2];
	}
	else if([strType rangeOfString:@"typeAddress" options:NSCaseInsensitiveSearch].length)
	{
		[self setAccordingToAddress];
	}
    */
        else if([strType rangeOfString:@"TypeTextNumber" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingToNumberField];
        }
        else if([strType rangeOfString:@"TypeAddress" options:NSCaseInsensitiveSearch].length)
        {
            [self setAccordingToTypeAddress];
        }
    }
}
    /*
    else if([strType rangeOfString:@"TypeText" options:NSCaseInsensitiveSearch].length)
    {
        [self setAccordingToTypeText];
    }
    else if ([strType rangeOfString:@"texturl" options:NSCaseInsensitiveSearch].length)
    {
        [self setAccordingToTextURL];
    }

-(void)setAccordingToTypeText
{
//
}
-(void)setAccordingToTextURL
{
//
}
     */


-(void)setAccordingToTypeAddress
{
	[self.txtdetail setHidden:YES];
}
-(void)setAccordingToNumberField
{
	[self.txtdetail setKeyboardType:UIKeyboardTypeNumberPad];
}

-(void)setImageOnCell
{
	// require to add image
	// hide the label and textField
	[self.lblDetailTitle setHidden:YES];
	[self.txtdetail setHidden:YES];
  
	
	CGRect rectImg = imgPhoto.frame;
	rectImg.origin.x = 10;
	rectImg.origin.y = 8;
	[imgPhoto setFrame:rectImg];
	
	CGRect rect = self.btnUpload.frame;
	rect.origin.x = (self.txtdetail.frame.size.width + self.txtdetail.frame.origin.x) - rect.size.width;
	
	[self.btnUpload setFrame:rect];
	
	[self.btnUpload setCenter:CGPointMake(self.btnUpload.center.x, imgPhoto.center.y)];
	[self.btnUpload setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	
	[self addSubview:imgPhoto];
	[self addSubview:self.btnUpload];
}
-(void)setAddressView{
    [self.txtdetail setHidden:YES];
//    CGRect rect = addressEditView.frame;
//
//    [addressEditView setCenter:CGPointMake(7, self.lblDetailTitle.center.y)];
//    [addressEditView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self addSubview:addressEditView];
    
}
-(void)setAccordingDateOfBirth
{
	[self.txtdetail setUserInteractionEnabled:NO];
	
	CGRect rect = self.btnDate.frame;
	rect.origin.x = (self.txtdetail.frame.size.width + self.txtdetail.frame.origin.x) - rect.size.width;
	[self.btnDate setFrame:rect];
	
	[self.btnDate setCenter:CGPointMake(self.btnDate.center.x, self.lblDetailTitle.center.y)];
	[self.btnDate setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	
	CGRect rectDetailsText = self.txtdetail.frame;
	rectDetailsText.size.width -= 50;
	[self.txtdetail setFrame:rectDetailsText];
	
	[self addSubview:self.btnDate];
}
-(void)setAccordingGender
{
	[self.txtdetail setHidden:YES];
	
	CGRect rect = self.btnUpload.frame;
	rect.origin.x = (self.txtdetail.frame.size.width + self.txtdetail.frame.origin.x) - rect.size.width;
	
	[self.btnUpload setFrame:rect];
	
	[vwRadio setCenter:CGPointMake(710,  self.lblDetailTitle.center.y)];
	[vwRadio setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[self addSubview:vwRadio];
}

-(void)setAccordingDescription
{
    
	[self.txtdetail setHidden:YES];
	[self.txtView setDelegate:nil];
	[self.txtView setDelegate:self];
	[self.txtView setFrame:CGRectMake(self.txtdetail.frame.origin.x, 5, self.txtdetail.frame.size.width, 36)];
	
	[self addSubview:self.txtView];
}
-(void)setAccordingToSingleDropDownWithDict:(NSDictionary*)dict
{
	
	// set images in cell
	UIImage * image = [UIImage imageNamed:@"text_box_p.png"];
	
	UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(self.lblDetailTitle.frame.origin.x + self.lblDetailTitle.frame.size.width + 5, 0, image.size.width, image.size.height)];
	[img setImage:image];
	[img setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
	[img setCenter:CGPointMake(img.center.x, self.txtdetail.center.y)];
	
	
	UIImageView * imgArrowDrop = [[UIImageView alloc]initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width - 25, 0, [UIImage imageNamed:@"down_arrow.png"].size.width, [UIImage imageNamed:@"down_arrow.png"].size.height)];
	[imgArrowDrop setImage:[UIImage imageNamed:@"down_arrow.png"]];
	[imgArrowDrop setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
	[imgArrowDrop setCenter:CGPointMake(imgArrowDrop.center.x, self.txtdetail.center.y)];
	
	[self addSubview:img];
	[self addSubview:imgArrowDrop];
	
	self.imgfirstDropDown = img;
	
	[img release];
	[imgArrowDrop release];
	
	
	// Drop Down Button
	
	CGRect rectButton = self.imgfirstDropDown.frame;
	rectButton.origin.x += 10;
	rectButton.size.width -= 32;
	rectButton.size.height -= 10;
	[self.btnDropDown setFrame:rectButton];
	
	[self.btnDropDown setCenter:CGPointMake(self.btnDropDown.center.x, self.imgfirstDropDown.center.y)];
	self.btnDropDown.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	[self addSubview:self.btnDropDown];
	
	//Drop down
;
}
-(void)setAccordingToLastPurchase
{
	[self.txtdetail setHidden:YES];
	
	// ADD Las Purchase
	CGRect rectAdd = self.btnAddLatPurchase.frame;
	rectAdd.origin.x =	self.txtdetail.frame.origin.x ;
	[self.btnAddLatPurchase setFrame:rectAdd];
	
	[self.btnAddLatPurchase setCenter:CGPointMake(self.btnAddLatPurchase.center.x, self.lblDetailTitle.center.y)];
	[self addSubview:self.btnAddLatPurchase];
	
	// VIEW HISTORY
	CGRect rectViewHis = self.btnViewHistory.frame;
	rectViewHis.origin.x =	self.btnAddLatPurchase.frame.origin.x + self.btnAddLatPurchase.frame.size.width + 20;
	[self.btnViewHistory setFrame:rectViewHis];
	
	[self.btnViewHistory setCenter:CGPointMake(self.btnViewHistory.center.x, self.lblDetailTitle.center.y)];
	[self addSubview:self.btnViewHistory];
	
}
-(void)setAccordingToAddress
{
	[lblSaperator setHidden:YES];
	[self.txtdetail setPlaceholder:@"Address Line 1"];	
}
-(void)setAccordingToAddressLine2
{
	[self.txtdetail setPlaceholder:@"Address line 2"];
	[self.lblDetailTitle setHidden:YES];
}
-(void)setAccordingToIndustryDropDown
{
	// hide the textfiled
	[self.txtdetail setHidden:YES];
    
    
	// first dropDown Image
    
	UIImage * image = [UIImage imageNamed:@"text_box_p.png"];
	
	image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
	
	UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(self.lblDetailTitle.frame.origin.x + self.lblDetailTitle.frame.size.width + 5, 0, image.size.width + 100, image.size.height)];
	[img setImage:image];
	[img setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
	[img setCenter:CGPointMake(img.center.x, self.txtdetail.center.y)];
	
	
	UIImageView * imgArrowDrop = [[UIImageView alloc]initWithFrame:CGRectMake(img.frame.origin.x + img.frame.size.width - 25, 0, [UIImage imageNamed:@"down_arrow.png"].size.width, [UIImage imageNamed:@"down_arrow.png"].size.height)];
	[imgArrowDrop setImage:[UIImage imageNamed:@"down_arrow.png"]];
	[imgArrowDrop setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
	[imgArrowDrop setCenter:CGPointMake(imgArrowDrop.center.x, self.txtdetail.center.y)];
	[imgArrowDrop setUserInteractionEnabled:NO];
	
	[self addSubview:img];
	[self addSubview:imgArrowDrop];
    
	self.imgfirstDropDown = img;
	
	[img release];
	[imgArrowDrop release];
    
	// Drop Down Button
	
	CGRect rectButton = self.imgfirstDropDown.frame;
	rectButton.origin.x += 10;
	rectButton.size.width -= 34;
	rectButton.size.height -= 10;
	[self.btnIndustryDropDown setFrame:rectButton];
	
	[self.btnIndustryDropDown setCenter:CGPointMake(self.btnIndustryDropDown.center.x, self.imgfirstDropDown.center.y)];

	[self addSubview:self.btnIndustryDropDown];
	
}

#pragma mark - TextField Notifications
- (void)addObserver_NotificationCenter{
    //notification for title
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditing:)
												 name:UITextFieldTextDidEndEditingNotification object:self.txtTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditing:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.txtTitle];
    
    //notification for field
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditing:)
												 name:UITextFieldTextDidEndEditingNotification object:self.txtdetail];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditing:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.txtdetail];
    
    //-----------------------------notification for Address fields
            //notification for Begin
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditingForAddress:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.addressType];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditingForAddress:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.addressStreet];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditingForAddress:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.addressCity];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditingForAddress:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.addressState];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditingForAddress:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.addressZip];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidBeginEditingForAddress:)
												 name:UITextFieldTextDidBeginEditingNotification object:self.addressCountry];
            //notification for End
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditingForAddress:)
												 name:UITextFieldTextDidEndEditingNotification object:self.addressType];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditingForAddress:)
												 name:UITextFieldTextDidEndEditingNotification object:self.addressStreet];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditingForAddress:)
												 name:UITextFieldTextDidEndEditingNotification object:self.addressCity];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditingForAddress:)
												 name:UITextFieldTextDidEndEditingNotification object:self.addressState];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditingForAddress:)
												 name:UITextFieldTextDidEndEditingNotification object:self.addressZip];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textDidEndEditingForAddress:)
												 name:UITextFieldTextDidEndEditingNotification object:self.addressCountry];
    
}
- (void)removeObserver_NotificationCenter
{
	[[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidEndEditingNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextFieldTextDidBeginEditingNotification];
}

#pragma mark - Notification Methods
    //Notification for Address
-(void)textDidEndEditingForAddress:(NSNotification*)notification{
    
    NSString *addressStreet = self.addressStreet.text;
    NSString *addressCity = self.addressCity.text;
    NSString *addressState = self.addressState.text;
    NSString *addressZip = self.addressZip.text;
    NSString *addressCountry = self.addressCountry.text;
    NSString *addressType = self.addressType.text;
    
    NSMutableDictionary *editData = [NSMutableDictionary dictionary];
    [editData setValue:addressStreet forKey:STREET_STRING];
    [editData setValue:addressCity forKey:CITY_STRING];
    [editData setValue:addressState forKey:STATE_STRING];
    [editData setValue:addressZip forKey:ZIP_STRING];
    [editData setValue:addressCountry forKey:COUNTRY_STRING];
    
    NSMutableDictionary *record = nil;
    record = [NSMutableDictionary dictionary];
    record = [self.dictDetailTitle objectForKey:ADDRESS_STRING];
    [record removeObjectForKey:self.currentEditKey];
    [record setObject:editData forKey:addressType];
    [self.dictDetailTitle setObject:record forKey:ADDRESS_STRING];
    
    NSLog(@"dictionary :  %@",self.dictDetailTitle);
}


-(void)textDidBeginEditingForAddress:(NSNotification*)notification{
    self.currentEditKey = self.addressType.text;
    NSLog(@"Editing Filed : %@",self.currentEditKey);
}

    //Notification for other multivalue fields
-(void)textDidBeginEditing:(NSNotification*)notification{
    
  self.currentEditKey = self.txtTitle.text;
    NSLog(@"Editing Filed : %@",self.currentEditKey);

}
-(void)textDidEndEditing:(NSNotification*)notification{
 
    NSString *currentKey = self.txtTitle.text;
    NSString *currentValue = self.txtdetail.text;
    NSString *currentDict = self.lblDictTitle.text;
    
    NSLog(@"End Editing current key :  %@  %@",currentKey,currentValue);
    
    if(![currentKey isEqualToString:self.currentEditKey]){
        newRecord = nil;
        newRecord = [NSMutableDictionary dictionary];
        newRecord = [self.dictDetailTitle objectForKey:currentDict];
        [newRecord removeObjectForKey:self.currentEditKey];
        [newRecord setValue:currentValue forKey:currentKey];
        if([currentDict isEqualToString:EMAIL_STRING]){
        
            [self.dictDetailTitle setObject:newRecord forKey:EMAIL_STRING];
            NSLog(@"dictionary :  %@",self.dictDetailTitle);
        
        }else if([currentDict isEqualToString:URL_STRING]){
       
            [self.dictDetailTitle setObject:newRecord forKey:URL_STRING];
        
        }else if ([currentDict isEqualToString:PHONE_STRING]){
       
            [self.dictDetailTitle setObject:newRecord forKey:PHONE_STRING];
        
        }
    }
    else{
     
        newRecord = nil;
        newRecord = [NSMutableDictionary dictionary];
        newRecord = [self.dictDetailTitle objectForKey:currentDict];
        [newRecord setValue:currentValue forKey:currentKey];
        
        if([currentDict isEqualToString:EMAIL_STRING]){
            
            [self.dictDetailTitle setObject:newRecord forKey:EMAIL_STRING];
            
        }else if([currentDict isEqualToString:URL_STRING]){
            
            [self.dictDetailTitle setObject:newRecord forKey:URL_STRING];
            
        }else if ([currentDict isEqualToString:PHONE_STRING]){
            
            [self.dictDetailTitle setObject:newRecord forKey:PHONE_STRING];
            
        }

    }
    NSLog(@"NSDictionary  :  %@",self.dictDetailTitle);
}
#pragma mark TextFields methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
	if (self.adelegate && [self.adelegate respondsToSelector:@selector(textFiledDidBeginEditingWithField:)])
	{
		[self.adelegate performSelector:@selector(textFiledDidBeginEditingWithField:) withObject:textField];
	}

}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self performSelector:@selector(saveFromTextFiledDelegateWithDelay) withObject:nil afterDelay:0.2];
    return YES;
}

#define CHARACTER_LIMIT 20
#define NUMBERS_ONLY @"1234567890 "
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *rawString = [[textField text] stringByAppendingString:string];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0) {
        return NO;
    }
	[self performSelector:@selector(saveFromTextFiledDelegateWithDelay) withObject:nil afterDelay:0.2];
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    }
    GlobalDataPersistence * globalObj = [GlobalDataPersistence sharedGlobalDataPersistence];
    [globalObj setIsContactEditted:YES];
	return YES;
}

-(void)saveFromTextFiledDelegateWithDelay
{
	//For dict
	//if textView is not empty that measn we have some data in he textView so we just need to put that data in to the textFiled
	//we'll need to check for the first responder
	//if the first responder is textview we just need to replace that data from our textView to the textfiled
	
	if ([self.txtView isFirstResponder])
	{
		//that means we have a case where we have a textView in the cell
		//put the data inside the textview to textFiled
		
		[self.txtdetail setText:self.txtView.text];
	}
	
	[self setDataInDictionary:self.txtdetail];
}


#pragma mark - UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
	return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSString *rawString = [[textView text] stringByAppendingString:text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    if ([trimmed length] == 0)
    {
        return NO;
    }
	[self performSelector:@selector(saveFromTextFiledDelegateWithDelay) withObject:nil afterDelay:0.2];
    GlobalDataPersistence * globalObj = [GlobalDataPersistence sharedGlobalDataPersistence];
    [globalObj setIsContactEditted:YES];
	return YES;
}

-(void)setDataInDictionary:(UITextField*)textFiled
{
	GlobalDataPersistence * globalObj = [GlobalDataPersistence sharedGlobalDataPersistence];
    [globalObj setIsContactEditted:YES];
	
	if ([textFiled.text length] || [textFiled.text length] ==0)
	{
		[globalObj.dictMyAddressBook setValue:(textFiled.text)?textFiled.text:@"" forKey:self.lblDetailTitle.text];
	}
	else if ([self.txtView.text length])
	{
		[globalObj.dictMyAddressBook setValue:self.txtView.text forKey:self.lblDetailTitle.text];
	}
	else if ([self.btnDropDown.titleLabel.text length])
	{
		[globalObj.dictMyAddressBook setValue:self.btnDropDown.titleLabel.text forKey:self.lblDetailTitle.text];
	}
	else if ([self.btnIndustryDropDown.titleLabel.text length])
	{
		[globalObj.dictMyAddressBook setValue:self.btnIndustryDropDown.titleLabel.text forKey:self.lblDetailTitle.text];
	}
    
}

-(void)getDataFromDict:(NSMutableDictionary *)dictMultiValue andDict:(NSDictionary *)dict
{
    if(self.dictDetailTitle == nil){
    self.dictDetailTitle = dictMultiValue;
    }
    GlobalDataPersistence * globalObj = [GlobalDataPersistence sharedGlobalDataPersistence];
	NSString *key = [dict objectForKey:kDETAILSTITLE];
	NSLog(@"Key : %@",key);
    if([[dict objectForKey:kDETAILSTITLE] isEqualToString:EMAIL_STRING])
    {
        NSDictionary *tempDict = [self.dictDetailTitle objectForKey:EMAIL_STRING];
        NSArray *currentKeys = [tempDict allKeys];
        NSArray *currentValues = [tempDict allValues];
        int currentRow = indexPathForCell.row;
        int numberOfRow = [currentKeys count];
        if(currentRow == numberOfRow){
            [self.lblDetailTitle setHidden:NO];
            [self.lblDetailTitle setText:@"Add Email"];
            [self.txtdetail setHidden:YES];
            [self.txtTitle setHidden:YES];
            
        }
        else{
            [self.txtdetail setText:[currentValues objectAtIndex:indexPathForCell.row]];
            [self.txtTitle setText:[currentKeys objectAtIndex:indexPathForCell.row]];
            [self.lblDictTitle setText:EMAIL_STRING];
        }
    }
    else if([[dict objectForKey:kDETAILSTITLE] isEqualToString:URL_STRING]){
        NSDictionary *tempDict = [self.dictDetailTitle objectForKey:URL_STRING];
        NSArray *currentKeys = [tempDict allKeys];
        NSArray *currentValues = [tempDict allValues];
        int currentRow = indexPathForCell.row;
        int numberOfRow = [currentKeys count];
        if(currentRow == numberOfRow){
            [self.lblDetailTitle setHidden:NO];
            [self.lblDetailTitle setText:@"Add URL"];
            [self.txtdetail setHidden:YES];
            [self.txtTitle setHidden:YES];
            
        }
        else{
            [self.txtdetail setText:[currentValues objectAtIndex:indexPathForCell.row]];
            [self.txtTitle setText:[currentKeys objectAtIndex:indexPathForCell.row]];
            [self.lblDictTitle setText:URL_STRING];
        }
    }
    else if ([[dict objectForKey:kDETAILSTITLE] isEqualToString:PHONE_STRING]){
        NSDictionary *tempDict = [self.dictDetailTitle objectForKey:PHONE_STRING];
        NSArray *currentKeys = [tempDict allKeys];
        NSArray *currentValues = [tempDict allValues];
        int currentRow = indexPathForCell.row;
        int numberOfRow = [currentKeys count];
        if(currentRow == numberOfRow){
            [self.lblDetailTitle setHidden:NO];
            [self.lblDetailTitle setText:@"Add Phone"];
            [self.txtdetail setHidden:YES];
            [self.txtTitle setHidden:YES];
            
        }
        else{
            [self.txtdetail setText:[currentValues objectAtIndex:indexPathForCell.row]];
            [self.txtTitle setText:[currentKeys objectAtIndex:indexPathForCell.row]];
            [self.lblDictTitle setText:PHONE_STRING];
        }
    }
    else if ([[dict objectForKey:kDETAILSTITLE] isEqualToString:ADDRESS_STRING]){
        NSDictionary *tempDict = [self.dictDetailTitle objectForKey:ADDRESS_STRING];
        NSArray *allAddressType = [tempDict allKeys];
        int currentRow = indexPathForCell.row;
        int numberOfRow = [allAddressType count];
        if(currentRow == numberOfRow){
            [self.lblAddAddress setHidden:NO];
            [self.addressType setHidden:YES];
            [self.addressCity setHidden:YES];
            [self.addressCountry setHidden:YES];
            [self.addressState setHidden:YES];
            [self.addressStreet setHidden:YES];
            [self.addressZip setHidden:YES];
            
        }
        else{
            [self.addressType setText:[allAddressType objectAtIndex:indexPathForCell.row]];
        
            NSMutableArray *allcity = [NSMutableArray array];
            NSMutableArray *allcountry = [NSMutableArray array];
            NSMutableArray *allstate = [NSMutableArray array];
            NSMutableArray *allstreet = [NSMutableArray array];
            NSMutableArray *allzip = [NSMutableArray array];
            for(NSString *aKey in allAddressType){
                NSArray *currentAddress = [tempDict objectForKey:aKey];
                NSString *street = [currentAddress valueForKey:STREET_STRING];
                NSString *city = [currentAddress valueForKey:CITY_STRING];
                NSString *state = [currentAddress valueForKey:STATE_STRING];
                NSString *zip = [currentAddress valueForKey:ZIP_STRING];
                NSString *country = [currentAddress valueForKey:COUNTRY_STRING];
                [allcity addObject:city];
                [allcountry addObject:country];
                [allstate addObject:state];
                [allzip addObject:zip];
                [allstreet addObject:street];
 
            }
        
        
            [self.lblAddAddress setHidden:YES];
            [self.addressCity setText:[allcity objectAtIndex:indexPathForCell.row]];
            [self.addressCountry setText:[allcountry objectAtIndex:indexPathForCell.row]];
            [self.addressState setText:[allstate objectAtIndex:indexPathForCell.row]];
            [self.addressStreet setText:[allstreet objectAtIndex:indexPathForCell.row]];
            [self.addressZip setText:[allzip objectAtIndex:indexPathForCell.row]];
        }
    }
    else{
	if ([self.lblDetailTitle.text isEqualToString:key])
	{
		[self.txtdetail setText:[globalObj.dictMyAddressBook objectForKey:key]];
        
	}
	
	if ([key rangeOfString:@"Description" options:NSCaseInsensitiveSearch].length ||
		[key rangeOfString:@"Note" options:NSCaseInsensitiveSearch].length)
	{
		[self.txtView setText:[globalObj.dictMyAddressBook objectForKey:key]];
       
	}
	
	if ([self boolForDropDown:key])
	{
		[self.btnDropDown setTitle:[globalObj.dictMyAddressBook objectForKey:key] forState:UIControlStateNormal];
	}
	else if ([key rangeOfString:kAddNewContact_Industry options:NSCaseInsensitiveSearch].length)
	{
		[self.btnIndustryDropDown setTitle:[globalObj.dictMyAddressBook objectForKey:key] forState:UIControlStateNormal];
	}
	else if ([key rangeOfString:kAddNewContact_Gender options:NSCaseInsensitiveSearch].length)
	{
		if ([[globalObj.dictMyAddressBook valueForKey:kAddNewContact_Gender] integerValue] == 11)
		{
			[self.btnMale setSelected:YES];
			[self.btnFemale setSelected:NO];
		}
		else if ([[globalObj.dictMyAddressBook valueForKey:kAddNewContact_Gender] integerValue] == 10)
		{
			[self.btnMale setSelected:NO];
			[self.btnFemale setSelected:YES];
		}
	}
	else if ([key rangeOfString:kAddNewContact_Image options:NSCaseInsensitiveSearch].length)
	{
		NSString * path = [globalObj.dictMyAddressBook valueForKey:kAddNewContact_Image];
		
		BOOL file  =   [[NSFileManager defaultManager] fileExistsAtPath:path];
		if (file)
		{
			imgPhoto.image = [UIImage imageWithContentsOfFile:path];
		}
	}
    }
}
-(BOOL)boolForDropDown:(NSString *)key
{
	if ([key rangeOfString:@"salutation" options:NSCaseInsensitiveSearch].length||
		[key rangeOfString:@"add to group" options:NSCaseInsensitiveSearch].length||
		[key rangeOfString:@"add to subgroup" options:NSCaseInsensitiveSearch].length||
		[key rangeOfString:@"funnel stage" options:NSCaseInsensitiveSearch].length||
		[key rangeOfString:@"lead" options:NSCaseInsensitiveSearch].length||
		[key rangeOfString:@"prefix" options:NSCaseInsensitiveSearch].length)
	{
		return YES;
	}
	return NO;
}

- (void)dealloc
{
	[dictM_MyaddressBookCell release];
    [_txtdetail setDelegate:nil];
    [_txtTitle setDelegate:nil];
    [_txtView setDelegate:nil];
    [indexPathForCell release];
	[_txtFirstRseponder release];
	[_txtSecondAddress release];
	[_imgfirstDropDown release];
	[_lblDetailTitle release];
	[_txtdetail release];
	[imgPhoto release];
	[_btnUpload release];
	[_btnDate release];
	[vwRadio release];
	[_btnFemale release];
	[_txtView release];
	[_btnViewHistory release];
	[_btnAddLatPurchase release];
	[_btnDropDown release];
	[_btnIndustryDropDown release];
	[lblSaperator release];
    [self removeObserver_NotificationCenter];
	[super dealloc];
}
@end
