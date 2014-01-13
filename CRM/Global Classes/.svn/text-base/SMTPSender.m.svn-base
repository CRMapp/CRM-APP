//
//  SMTPSender.m
//  CRM
//
//  Created by Sheetal's iMac on 05/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "SMTPSender.h"
#import "CRMConfig.h"
#import "SettingsViewController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#define SMTP_EMAIL @"alok.pandey@b24esolutions.com"
#define SMTP_HOST  @"smtp.gmail.com"
#define SMTP_PASS  @"9984012150"

@implementation SMTPSender
@synthesize isTesting;
@synthesize aDelegate;
@synthesize currentCount;
@synthesize totCount;
@synthesize allEmails;

static SMTPSender *sharedSMTPSender=nil;


+ (SMTPSender *)sharedSMTPSender
{
    if(sharedSMTPSender == nil)
    {
		sharedSMTPSender = [[super allocWithZone:NULL] init];
	}
	
	return sharedSMTPSender;
}
#pragma mark - SKPSMTPMessage Delegate
- (void)messageSent:(SKPSMTPMessage *)message
{
    [message release];
    NSLog(@"SENT MESSAGE");
    if(self.currentCount < self.totCount)
    {
        [self sendEmailTo:[self.allEmails objectAtIndex:self.currentCount]];
        self.currentCount++;
    }
    else
    {
        [SVProgressHUD dismissWithSuccess:@"Done"];
        self.currentCount = 0;
        self.totCount = 0;

        allEmails = nil;
        NSString *strmsg = @"";
        if (self.isTesting)
        {
            strmsg = @"You have successfully set up your email account";
        }
        else
        {
            strmsg = @"Message sent successfully.";
        }
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Success" message:strmsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
    }
    
    if (self.isTesting)
    {
        if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(testingForConfigureMail:error:)])
        {
            [self.aDelegate performSelector:@selector(testingForConfigureMail:error:) withObject:[NSNumber numberWithBool:YES] withObject:nil];
        }
        
    }
    
    // self.textView.text  = @"Yay! Message was sent!";
    //NSLog(@"delegate - message sent");
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"FAILED MESSAGE");
    if(self.currentCount < self.totCount && !self.isTesting)
    {
        [self sendEmailTo:[self.allEmails objectAtIndex:self.currentCount]];
        self.currentCount++;
    }
    else
    {
        self.currentCount = 0;
        self.totCount = 0;
//        [allEmails release];
        allEmails = nil;
    }
    if (self.isTesting)
    {
        if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(testingForConfigureMail:error:)])
        {
            [self.aDelegate performSelector:@selector(testingForConfigureMail:error:) withObject:[NSNumber numberWithBool:NO] withObject:error];
        }
        
    }
    [SVProgressHUD dismiss];
    //self.textView.text = [NSString stringWithFormat:@"Darn! Error: %@, %@", [error code], [error localizedDescription]];
    //self.textView.text = [NSString stringWithFormat:@"Darn! Error!\n%i: %@\n%@", [error code], [error localizedDescription], [error localizedRecoverySuggestion]];
    [message release];
    
    //NSLog(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}

-(void)sendEmailTo:(NSMutableDictionary*)emailInfo
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = [defaults objectForKey:@"fromEmail"];
    
    testMsg.toEmail =[emailInfo objectForKey:RECIPIENT_STRING];

    testMsg.relayHost = [defaults objectForKey:@"relayHost"];
    
    testMsg.requiresAuth = [[defaults objectForKey:@"requiresAuth"] boolValue];
    
    if (testMsg.requiresAuth)
    {
        testMsg.login = [defaults objectForKey:@"login"];
        
        testMsg.pass = [defaults objectForKey:@"pass"];
   
    }
    
    testMsg.wantsSecure = [[defaults objectForKey:@"wantsSecure"] boolValue]; 
    
    testMsg.subject = [emailInfo objectForKey:SUBJECT_STRING];
        
    // Only do this for self-signed certs!
    // testMsg.validateSSLChain = NO;
    testMsg.delegate = self;
    NSString *messageBody = [[emailInfo objectForKey:FIRST_LINE_STRING] stringByAppendingFormat:@"\n%@",[emailInfo objectForKey:MESSAGE_BODY_STRING]];

    
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
    
    [testMsg send];
    
}

- (void)sendEmailToUsers:(NSMutableArray*)toEmails message:(NSString*)message
{
    if ([self checkNetworkConnection])
    {
        [SVProgressHUD showWithStatus:(message)?message:@"Sending"];
        self.currentCount = 0;
        self.totCount = toEmails.count;
        self.allEmails = [NSMutableArray arrayWithArray:toEmails];
        //    for (NSMutableDictionary *emailInfo in toEmails)
        //    {
        [self sendEmailTo:[self.allEmails objectAtIndex:self.currentCount]];
        self.currentCount++;
        
    }
}
- (BOOL)checkNetworkConnection
{
    Reachability *reachability	= [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet connection failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}
@end
