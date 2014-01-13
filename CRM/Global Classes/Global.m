//
//  Global.m
//  Letterz
//
//  Created by Sheetal on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Global.h"
#import "CRMConfig.h"


@implementation Global

//+ (int)getHeightForText :(NSString*)text andWidth :(int)width {
//	
//	int height;
//	CGRect textSize = CGRectMake(0.0, 0.0, width, FLT_MAX);
//	UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:13];
//	
//	UILabel *lblHeight = [[UILabel alloc] init];
//	lblHeight.lineBreakMode = UILineBreakModeWordWrap;
//	lblHeight.numberOfLines = 0;
//	lblHeight.font = font;
//	lblHeight.text = text;
//	lblHeight.frame = [lblHeight textRectForBounds:textSize limitedToNumberOfLines:0];	
//	height = lblHeight.frame.size.height;
//	[lblHeight release];
//
//	return height;
//}
//
//+ (CGFloat) getCellHeight :(NSString*) string withfont :(UIFont*)font {
//	
//	
//	CGSize constraint;
//	constraint = CGSizeMake(CELL_CONTENT_WIDTH_PORTRAIT - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    
//    CGSize size = [string sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    
//    CGFloat height = MAX(size.height, CELL_CONTENT_HEIGHT);
//    
//    return height + (CELL_CONTENT_MARGIN * 2);
//}
//
//+ (void)resignSubviews :(UIView*)view
//{
//	for (id subview in [view subviews]) 
//	{
//		NSLog(@"%@",[subview description]);
//		if ([subview isKindOfClass:[UITextField class]]) {
//			[subview resignFirstResponder];
//		}
//		
//	}
//}
//#pragma mark set document attribute
//
//+(void)setSubDocumentsToNonBackedUp:(NSString*)itemURLSTR
//{
//    if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
//    {
//        NSURL *pathURL= [NSURL fileURLWithPath:itemURLSTR];
//        const char* filePath = [[pathURL path] fileSystemRepresentation];
//        const char* attrName = "com.apple.MobileBackup";
//        u_int8_t attrValue = 1;
//        setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//    }
//}
//
//#pragma mark -
//+(void) saveImageToDocumentFolder:(UIImage *)image withName:(NSString *)ImageName
//{
//	NSData *data;
//	//data = UIImagePNGRepresentation(image);
//	data = UIImageJPEGRepresentation(image, 1.0);
//	
//	if (!data)
//		return;
//	
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [paths objectAtIndex:0];
//	
//	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:ImageName];
//	if(![fileManager fileExistsAtPath:fullPath])
//		[fileManager createFileAtPath:fullPath contents:data attributes:nil];
//	
//    [Global setSubDocumentsToNonBackedUp:fullPath];
//    
//	[data writeToFile:fullPath atomically:YES];
//	
//}
//+ (NSString *)uniqueString{
//    CFUUIDRef uuid = CFUUIDCreate(NULL);
//    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
//    CFRelease(uuid);
//    [(NSString *)uuidStr autorelease];
//    return (NSString *)uuidStr;
//} 
//
//
//+ (NSArray*) structuredIngredients:(NSArray*)arrIngredients {
//	
//	NSMutableArray *arrIngredientDic = [[[NSMutableArray alloc]init] autorelease];
//		
//	for (int count = 0;count< [arrIngredients count]; count ++ ) {
//		Ingredient *ingredient = [arrIngredients objectAtIndex:count ];
//		
//		NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
//		
//		/* "IngredientName" : "Tomato", "Quantity": "4", "Unit": "pieces" */
//		if (ingredient.ingredientName) 
//			[parameters setObject:ingredient.ingredientName forKey:@"IngredientName"];
//		
//		if (ingredient.quantity) 
//			[parameters setObject:ingredient.quantity forKey:@"Quantity"];
//		
//		if (ingredient.unit) 
//			[parameters setObject:ingredient.unit forKey:@"Unit"];
//		else
//			[parameters setObject:@"" forKey:@"Unit"];
//		
//		[arrIngredientDic addObject:parameters];
//		[parameters release];
//		
//	}
//	
//	return [NSArray arrayWithArray: arrIngredientDic];
//}
//
//+ (NSArray*)sortArray:(NSArray*)toBeSorted keyForSorting:(NSString*)keyForSorting ascending:(BOOL)isAsc Number:(BOOL)isNumber {
//	
//	SEL sortSelector = nil;
//	sortSelector = (isNumber)?@selector(compare:):@selector(localizedCaseInsensitiveCompare:);
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyForSorting ascending:isAsc selector:sortSelector];
//	NSArray *desciptors = [NSArray arrayWithObject:sortDescriptor];
//	toBeSorted = [toBeSorted sortedArrayUsingDescriptors:desciptors];
//	[sortDescriptor release];
//	return toBeSorted;
//}
//
//Get/Set user name to defaults for showing it when
//next time login screen appears.

//****************************************************************************//

+(void)SaveUserEmailToDefaults :(NSString*)email{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setObject:email forKey:EMAIL_ID_STRING];
    [userDefaults synchronize];
}

+(BOOL)GetRememberMeFlag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_REMEMBER_ME_STRING];
}
+(void)SaveRememberMeFlag:(BOOL)flag{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_REMEMBER_ME_STRING];
    [userDefaults synchronize];
}
+(BOOL)GetConfigureFlag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_ACCOUNT_CONFIGURE];
}
+(void)SaveConfigureFlag:(BOOL)flag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_ACCOUNT_CONFIGURE];
    [userDefaults synchronize];
}
+(NSString*)GetUserPassword{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults objectForKey:PASSWORD_STRING];
}

+(void)SaveUserPassword:(NSString*)password{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setObject:password forKey:PASSWORD_STRING];
    [userDefaults synchronize];
}

+(NSString*)GetUserEmailFromDefaults{
	NSString* email = nil;
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	email = [userDefaults objectForKey:EMAIL_ID_STRING];
	return email;
}
+(BOOL)GetPasswordCreated{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_LOCK_STRING];
}
+(void)SetPasswordCreated:(BOOL)flag{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_LOCK_STRING];
    [userDefaults synchronize];
}
+(BOOL)GetPasswordSaved{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_PASSWORD_SAVED];
}
+(void)SetPasswordSaved:(BOOL)flag{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_PASSWORD_SAVED];
    [userDefaults synchronize];
}
+(BOOL)GetSyncLocationsFlag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_SYNC_LOCATION];
}
+(void)SaveSyncLocationsFlag:(BOOL)flag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_SYNC_LOCATION];
    [userDefaults synchronize];
}
+(BOOL)GetFirstLaunchAppFlag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_APP_FIRST_LAUNCH];
}
+(void)SaveFirstLaunchAppFlag:(BOOL)flag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_APP_FIRST_LAUNCH];
    [userDefaults synchronize];
}
+(BOOL)GetSalePipelineFlag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	return [userDefaults boolForKey:IS_SALE_PIPELINE];
}
+(void)SaveSalePipelineFlag:(BOOL)flag
{
	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
	[userDefaults setBool:flag forKey:IS_SALE_PIPELINE];
    [userDefaults synchronize];
}
#define NUMBERS_ONLY @"1234567890"

/*
 Method : checkForNumbersOnlyInTextField:withRange:replacementString:
 Parameters : Range of string, and replacing string
 limit : number of characters in the string.
 periods: allowing decimal/dot in the number format.
 Used : Place this method in shouldChangeCharactersInRange UItextfiled delegate method. This method is used to omly numbers in textfiled
 */

+(BOOL)checkForNumbersOnlyInTextField:(UITextField*)textField withRange:(NSRange)range replacementString:(NSString *)string withNumDigitLimits:(int)limit allowPeriod:(BOOL)period
{
	
	NSString * numbers = NUMBERS_ONLY;
	
	if (period)
	{
		numbers = [numbers stringByAppendingString:@"."];
		
		//if we already have a decimal/dot in the string do not enter new dot
		if ([textField.text rangeOfString:@"."].length)
		{
			//that means we have dot in the text
			if ([string isEqualToString:@"."])
			{
				// new string is also dot (.)
				return NO;
			}
			
			//limit the number of digits after dot(.)
			NSString * strFromDot = [textField.text substringFromIndex:[textField.text rangeOfString:@"."].location ];
			
			if ([strFromDot length] > 2 && ![string isEqualToString:@""])
			{
				//if we have 123.20 we will get ".20" in strFromDot whose count is 3 which is greater then 2
				//So return NO.
				return NO;
			}
		}
		
	}
	
	
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
	NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
	return (([string isEqualToString:filtered])&&(newLength <= limit));
}
+(NSString*)convertStringToNumberFormatter:(NSString *)number withDollerSign:(BOOL)showDoller
{
	//American number format - with comma sepparators between thousands
    number = [Global convertPriceBackToNumbersWithPriceText:number];
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
	
	NSLocale *usLocale = [NSLocale currentLocale];
	[numberFormatter setLocale:usLocale];
	
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[number doubleValue]]];
	
	if (!showDoller)
	{
		numberAsString = [numberAsString stringByReplacingOccurrencesOfString:@"$" withString:@""];
	}
    
	return numberAsString;
}
+(NSString*)convertPriceBackToNumbersWithPriceText:(NSString*)price
{
	NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
	NSString *filtered = [[price componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
	
	return filtered;
}
//****************************************************************************//

//+(BOOL)GetFBLoginFlag{
//	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
//	return [userDefaults boolForKey:kFBUserLogin];
//}
//+(void)SaveGetFBLoginFlag:(BOOL)flag{
//	NSUserDefaults* userDefaults = [ NSUserDefaults standardUserDefaults];
//	[userDefaults setBool:flag forKey:kFBUserLogin];;
//}
//+(NSString*)convertToTimeString:(NSString*)strTime{
//	NSString* timeString = nil;
//	if ([[strTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
//		NSArray *arrCookingTime = [strTime componentsSeparatedByString:@":"];
//		
//		if([arrCookingTime count] > 0){
//			
//			if([[arrCookingTime objectAtIndex:0] isEqualToString:@"00"] && ![[arrCookingTime objectAtIndex:1] isEqualToString:@"00"])
//				timeString = [NSString stringWithFormat:@"%@ min.",[arrCookingTime objectAtIndex:1]];
//			
//			else if(![[arrCookingTime objectAtIndex:0] isEqualToString:@"00"] && [[arrCookingTime objectAtIndex:1] isEqualToString:@"00"])
//				timeString = [NSString stringWithFormat:@"%@ hrs.",[arrCookingTime objectAtIndex:0]];
//			
//			else if(![[arrCookingTime objectAtIndex:0] isEqualToString:@"00"] && ![[arrCookingTime objectAtIndex:1] isEqualToString:@"00"])
//				timeString = [NSString stringWithFormat:@"%@ hrs. %@ min.",[arrCookingTime objectAtIndex:0],[arrCookingTime objectAtIndex:1]];			
//		}		
//	}
//	return  timeString;
//}
//
//#pragma mark App Purchase Status
//
//+(BOOL)GetAppPurchaseStatus{
//	BOOL status = NO;
//	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//	status = [userDefaults boolForKey:kAppPurchasedStatus];
//	return status;
//}
//+(void)SetAppPurchaseStatus:(BOOL)status{
//	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//	[userDefaults setBool:status forKey:kAppPurchasedStatus];
//}


@end
