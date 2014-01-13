//
//  ViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UITextField *txtfUsername;
    IBOutlet UITextField *txtfPassword;
    IBOutlet UISwitch *switchRemember;
    IBOutlet UIView *view_forgot_pass;
    IBOutlet UIView *view_reset_pass;
}
@property(nonatomic, strong) MFMailComposeViewController *mailComposer;
- (IBAction)btnForgotPassword:(id)sender;
- (IBAction)switchValueChange:(UISwitch*)sender;
- (void) showPassswordReset;
@end
