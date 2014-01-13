//
//  DateUtility.m
//  NameTag
//
//  Created by Om Prakash on 28/5/10.
//  Copyright 2010 . All rights reserved.
//

#import "DateUtility.h"

#define DBDATE_FORMAT @"yyyy-MM-dd"
#define DISPLAY_DATE_FORMAT @"MMM dd, yyyy"
#define GRAPH_DATE_FORMAT @"MMM-dd"

#define kTimeBeforeSometimeAgo 5184000 //(60 * 60 * 24 * 60)

@implementation NSDate (DateUtility)

- (NSString *) dateToRelativeFormattedString
{
	return [self dateToRelativeFormattedStringAbsolute:NO];
}

- (NSString *) dateToRelativeFormattedStringAbsolute:(BOOL) absolute
{
	NSString *res = nil;
	NSTimeInterval dateSecs = [self timeIntervalSinceReferenceDate];
	NSDate *now = [NSDate date];
	NSTimeInterval nowSecs = [now timeIntervalSinceReferenceDate];
		
	NSTimeInterval diff = nowSecs - dateSecs;
	diff = (diff < 0)?(-diff):diff;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateFormat:@"yyyy"];
	NSInteger year = [[dateFormatter stringFromDate:self] intValue];
	NSInteger currYear = [[dateFormatter stringFromDate:now] intValue];
	
	[dateFormatter setDateFormat:@"MM"];
	NSInteger month = [[dateFormatter stringFromDate:self] intValue];
	NSInteger currMonth = [[dateFormatter stringFromDate:now] intValue];
	
	[dateFormatter setDateFormat:@"dd"];
	NSInteger day = [[dateFormatter stringFromDate:self] intValue];
	NSInteger currDay = [[dateFormatter stringFromDate:now] intValue];

	/* [dateFormatter setDateFormat:@"HH"]; */
	/* NSInteger hour = [[dateFormatter stringFromDate:self] intValue];
	NSInteger currHour = [[dateFormatter stringFromDate:now] intValue]; */
	/* [dateFormatter setDateFormat:@"mm"]; */
	/* NSInteger minute = [[dateFormatter stringFromDate:self] intValue];
	NSInteger currMinute = [[dateFormatter stringFromDate:now] intValue]; */

	if (!absolute && diff > kTimeBeforeSometimeAgo) { //GM: old entries
		res = NSLocalizedString(@"Sometime ago", "Sometime ago");
	}else
	
	if (diff < 300) { // 5 minutes ago
		res = NSLocalizedString(@"Now", "Datetime Now");
	} else if (year == currYear && month == currMonth && day == currDay) {
		[dateFormatter setDateFormat:@"HH:mm"];
		res = [NSString stringWithFormat:NSLocalizedString(@"Today at %@",@"Datetime Today"), [dateFormatter stringFromDate:self]];
	} else if (year == currYear && month == currMonth) {
		[dateFormatter setDateFormat:@"EEE dd - HH:mm"];
		res = [dateFormatter stringFromDate:self];
	} else if (year == currYear) {
		[dateFormatter setDateFormat:@"MMM, dd - HH:mm"];
		res = [dateFormatter stringFromDate:self];
	} else {
		[dateFormatter setDateFormat:@"MMM, dd yy - HH:mm"];
		res = [dateFormatter stringFromDate:self];
	}

	[dateFormatter release];
				
	return res;
	
}

- (NSString *) longFormattedString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm a"];
	NSString* res = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	return res;
}

- (NSString *) dateToBirthdayFormattedString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd MMM yyyy"];
	NSString* res = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	
	return res;
}

- (NSString *) dateToSQLiteFormattedString{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString* res = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	
	return res;
}

- (NSString *) dateToNTBirthdayFormattedString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	NSString* res = [dateFormatter stringFromDate:self];
	[dateFormatter release];
	return res;
}

+ (NSDate*) dateBeforeYears:(NSInteger)years{
	NSCalendar* gregorian = [NSCalendar currentCalendar];
	NSDate *currentDate = [NSDate date];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	NSDate *pastDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
	[comps release];
	
	return pastDate;
}

+ (NSDate*) convertUTCToLocal:(NSDate*)utcDate 
{
	NSCalendar* lcal = [NSCalendar currentCalendar];
	
	NSTimeZone* zulu = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSCalendar* zcal = [NSCalendar currentCalendar];
	[zcal setTimeZone:zulu];
	
	NSDateComponents* comp = [lcal components:0x03ff fromDate:utcDate];
	NSDate* local = [zcal dateFromComponents:comp];
	
	return local;
}

+ (NSDate*) convertLocalToUTC:(NSDate*)localDate 
{
	NSCalendar* lcal = [NSCalendar currentCalendar];
	
	NSTimeZone* zulu = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSCalendar* zcal = [NSCalendar currentCalendar];
	[zcal setTimeZone:zulu];
	
	NSDateComponents* comp = [zcal components:0x03ff fromDate:localDate];
	NSDate* utc = [lcal dateFromComponents:comp];
	
	return utc;     
}

+ (NSString*) secondsToString:(int)seconds 
{       
	int days = (int) floor( seconds / 86400 );      
	seconds -= (days * 86400);
	
	int hours = (int) floor( seconds / 3600 );
	seconds -= (hours * 3600);
	
	int minutes = (int) floor( seconds / 60 );      
	seconds -= (minutes * 60);
	
	NSMutableString* result = [[NSMutableString alloc] initWithCapacity:64];
	
	BOOL first = YES;       
	if ( days > 0 )
	{
		first = NO;
		[result appendFormat:@"%s%dd", (first ? "" : " "), days];
	}
	
	if ( hours > 0 )
	{
		first = NO;
		[result appendFormat:@"%s%dh", (first ? "" : " "), hours];              
	}
	
	if ( minutes > 0 )
	{
		first = NO;
		[result appendFormat:@"%s%dm", (first ? "" : " "), minutes];            
	}
	
	if ( seconds > 0 )
	{
		first = NO;
		[result appendFormat:@"%s%ds", (first ? "" : " "), seconds];            
	}
	
	NSString* str = [NSString stringWithString:result];
	[result release];
	
	return str;
}


#pragma mark -
#pragma mark Date Utility Functions

+(NSDate *)DateFromDb:(NSString *)aDateString
{
	
	if([aDateString caseInsensitiveCompare:@""]==0)
		return [NSDate date];
	
	NSDateFormatter *dateFormatForDB = [[NSDateFormatter alloc] init];
	[dateFormatForDB setDateFormat:@"yyyy-MM-dd"];
	NSDate *aDate=[[[NSDate alloc] initWithTimeInterval:0 sinceDate:[dateFormatForDB dateFromString:aDateString]] autorelease];
	[dateFormatForDB release];
	return aDate;
}

+(NSDate *)DateTimeFromDb:(NSString *)aDateString
{
	
	if([aDateString caseInsensitiveCompare:@""]==0 || aDateString == nil)
		return [NSDate date];
	
	NSDateFormatter *dateFormatForDB = [[NSDateFormatter alloc] init];
	[dateFormatForDB setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *aDate = [[[NSDate alloc] initWithTimeInterval:0 sinceDate:[dateFormatForDB dateFromString:aDateString]] autorelease];
	[dateFormatForDB release];
	return aDate;
}

+(NSDate *) DateForReminderWithString:(NSString *)aDateString
{
	
	if([aDateString caseInsensitiveCompare:@""]==0 || aDateString == nil)
		return [NSDate date];
	
	NSDateFormatter *dateFormatForDB = [[NSDateFormatter alloc] init];
	[dateFormatForDB setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	//NSDate *aDate = [[[NSDate alloc] initWithTimeInterval:0 sinceDate:[dateFormatForDB dateFromString:aDateString]] autorelease];
    NSDate* aDate = [dateFormatForDB dateFromString:aDateString];
	[dateFormatForDB release];
    
	return aDate;
}

+ (NSString*) TimeInfoForReminderWithString:(NSString*)aDateString{
    NSDate* date = [[self class] DateForReminderWithString:aDateString];
    NSDateFormatter *dateFormatForDB = [[NSDateFormatter alloc] init];
	[dateFormatForDB setDateFormat:@"hh:mm a"];
    NSString *aDateStr = [dateFormatForDB stringFromDate:date];
	[dateFormatForDB release];
    
	return aDateStr;	
}

-(NSString *) stringInReminderFormat
{
	NSDateFormatter *dateFormatForDB = [[NSDateFormatter alloc] init];
	[dateFormatForDB setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *aDateStr=[[[NSString alloc]initWithString:[dateFormatForDB stringFromDate:self]] autorelease];
	[dateFormatForDB release];
	return aDateStr;	
}

+ (NSString *) NutritionistFormattedString{
	return nil;
}

- (NSString *)dateStringForDB
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:DBDATE_FORMAT];
	NSString *returnDate = [formatter stringFromDate:self];
	[formatter release];
	return returnDate;
}

- (NSString *) dateStringForInDisplay {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:DISPLAY_DATE_FORMAT];
	NSString *displayDate = [formatter stringFromDate:self];
	[formatter release];
	return displayDate;	
}

- (NSString *) dateStringForGraphDisplay {
	NSString *displayDate = nil;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:GRAPH_DATE_FORMAT];
	displayDate = [formatter stringFromDate:self];
	[formatter release];
	return displayDate;	
}


- (NSDate *)IncreaseDate:(int)Days Month:(int)Month Year:(int)Year date:(NSDate*)date
{
	NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *NewDateComp =[[NSDateComponents alloc]init];
	
	[NewDateComp setDay:Days];
	[NewDateComp setMonth:Month];
	[NewDateComp setYear:Year];
	
	NSDate *NewDate = [[NSDate alloc]initWithTimeInterval:0 sinceDate:[gregorian dateByAddingComponents:NewDateComp toDate:date options:0]];
	[NewDateComp release];
	[gregorian release];
	
	return [NewDate autorelease];	
}

+ (int ) DayDifferance:(NSDate*)firstDate fromDate:(NSDate* )SecondDate
{
	NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int uintFlags = NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit;
    NSDateComponents* differenceComponents = [gregorian components:uintFlags fromDate:firstDate toDate:SecondDate options:0];
	[gregorian release];
	//[differenceComponents day]+1;
	return ([differenceComponents day]+1)+([differenceComponents week]*7)+([differenceComponents month]*30)+([differenceComponents year]*365);
}

+ (NSInteger)differenceBetweenDates:(NSDate*)startDate endDate:(NSDate*)endDate {
	NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    
//    float theFloat = (interval/86400);
//    int rounded = lroundf(theFloat); NSLog(@"%d",rounded);
//    int roundedUp = ceil(theFloat); NSLog(@"%d",roundedUp);
//    int roundedDown = floor(theFloat); NSLog(@"%d",roundedDown);
    
	NSInteger days = (NSInteger)lroundf(interval/86400);
	return days;
}
+ (NSString*)calculateDataAndTimeDeffrence:(NSDate*)startDate endDate:(NSDate*)expireDate
{
    
	NSTimeZone *currentTimeZone = [NSTimeZone systemTimeZone];
    
    int offset = [currentTimeZone secondsFromGMTForDate: [NSDate date]];
    
    NSTimeInterval CurrentGMTtimeStamp = [startDate timeIntervalSince1970]+offset;
    
    NSDate *currentdate = [NSDate dateWithTimeIntervalSince1970:CurrentGMTtimeStamp];
    
    NSLog(@"currentdate = %@",currentdate);
    
    NSCalendar *gregorianCalendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    
    [gregorianCalendar setTimeZone:currentTimeZone];
    
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;
    
//    NSDateComponents *components = [gregorianCalendar components:unitFlags
//                                                        fromDate:startDate
//                                                          toDate:expireDate
//                                                         options:0];
    
    NSDateComponents *cmp=[gregorianCalendar components:unitFlags fromDate:startDate];
    
    NSDateComponents *cmp1=[gregorianCalendar components:unitFlags fromDate:expireDate];
    
    
    int dateDiff = [cmp1 day] - [cmp day];
    
    return [NSString stringWithFormat:@"%d",dateDiff];
   /* if (dateDiff<=0)  //today is the last day
    {
         
    }
    else
    {
        NSString *aStr = [NSString stringWithFormat:@"%d",dateDiff];
        
        return aStr;
    }*/
    
}

- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
	
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
	
    return [comp1 day]   == [comp2 day] &&
	[comp1 month] == [comp2 month] &&
	[comp1 year]  == [comp2 year];
}


//	This method is very useful when you are storing only date in database and you need to compare it with current date.
//	This method will ignore the time components of a given date.
// e.g Date From Database is 2010-12-15 00:00:00 +05:30 and current date is 2010-12-15 16:04:35 +05:30
//
+ (NSDate*)normalizedDateWithDate:(NSDate*)date {
	
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate: date];
	return [calendar dateFromComponents:components]; // NB calendar_ must be initialized
}

@end
