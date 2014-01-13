//
//  FeedbackViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 01/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SMTPSender.h"
#import "CRMConfig.h"
#import "Global.h"
//#import "AppDelegate.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [txtVwFeedback setPlaceholderText:@"Comments"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [txtfEmail release];
    
    [txtVwFeedback release];
    txtVwFeedback = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [txtfEmail release];
    txtfEmail = nil;
    [super viewDidUnload];
}
- (IBAction)btnSendFeedback:(id)sender
{

    if ([txtVwFeedback.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your feedbacks" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if (![Global GetConfigureFlag])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Hello! to start using this function please set up your email details in settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
    NSMutableArray      *emailsArray = [NSMutableArray array];
    
    NSMutableDictionary *emailsDict  = [NSMutableDictionary dictionary];
    
    [emailsDict setObject:txtfEmail.text                    forKey:RECIPIENT_STRING];
    [emailsDict setObject:@"Feedbacks from CRM"             forKey:SUBJECT_STRING];
    [emailsDict setObject:@""                               forKey:FIRST_LINE_STRING];
    [emailsDict setObject:txtVwFeedback.text                forKey:MESSAGE_BODY_STRING];
    
    [emailsArray addObject:emailsDict];
    
    SMTPSender *smtp = [SMTPSender sharedSMTPSender];
    [smtp setIsTesting:NO];
    [smtp sendEmailToUsers:emailsArray message:nil];
    }
}
@end
