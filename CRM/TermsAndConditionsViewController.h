//
//  TermsAndConditionsViewController.h
//  CRM
//
//  Created by Byte Slick on 25/12/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsAndConditionsViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction) segmentedControllerClicked:(id)sender;
- (IBAction) agreeClicked:(id)sender;
@end
