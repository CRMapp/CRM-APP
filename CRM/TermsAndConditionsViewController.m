//
//  TermsAndConditionsViewController.m
//  CRM
//
//  Created by Byte Slick on 25/12/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "AppDelegate.h"
#import "TermsAndConditionsViewController.h"

#define TERMS_AND_CONDITIONS    @"Terms and Conditions.pdf"
#define PRIVACY_POLICY          @"Privacy Policy.pdf"

@interface TermsAndConditionsViewController ()

@end

@implementation TermsAndConditionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSURL *) getPdfURL:(NSString *)fileName{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:filePath];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *data = [NSData dataWithContentsOfURL:[self getPdfURL:TERMS_AND_CONDITIONS]];
    [_webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[self getPdfURL:TERMS_AND_CONDITIONS]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) segmentedControllerClicked:(id)sender{
    NSString *pdfName = [sender selectedSegmentIndex] == 0 ? TERMS_AND_CONDITIONS : PRIVACY_POLICY;
    NSData *data = [NSData dataWithContentsOfURL:[self getPdfURL:pdfName]];
    [_webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
}

- (IBAction) agreeClicked:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"I agree to the Terms and Conditions and the Privacy Policy of the ClueCRM App!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agree", nil];
    [alertView show];
    [alertView release];
}

#pragma mark - UIWebView Delegate

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
}

#pragma mark - UIAlertView Delegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] termsAccepted];
    }
}

- (BOOL) shouldAutorotate{
//    [_webView setScalesPageToFit:YES];
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
@end
