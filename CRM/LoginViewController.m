//
//  ViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "DHValidation.h"
#import "Global.h"
#import "Flurry.h"
#import "AESEncryption.h"
#import "FBEncryptorAES.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [switchRemember setOn:NO];
    if ([Global GetRememberMeFlag])
    {
        [switchRemember setOn:YES];
        txtfUsername.text = [Global GetUserEmailFromDefaults];
        NSLog(@"%@",[Global GetUserPassword]);
        txtfPassword.text = [FBEncryptorAES decryptBase64String:[Global GetUserPassword] keyString:kEncryptionKey];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction methods
- (IBAction)btnLoginTapped:(id)sender
{
    //Flurry log
	[Flurry logEvent:@"Sign in Taped"];
    DHValidation *emailValidation=[[DHValidation alloc] init];
    BOOL emailValid=[emailValidation validateEmail:txtfUsername.text];
    
    [emailValidation release];
    
    NSString *username = [Global GetUserEmailFromDefaults];
    NSString *pwd = [FBEncryptorAES decryptBase64String:[Global GetUserPassword] keyString:kEncryptionKey];
    if (txtfUsername.text.length <=0 && txtfPassword.text.length <=0)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email and password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        
    }
    
    else if (txtfUsername.text.length <=0)
    {
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
    }
    
    else if (!emailValid)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        
    }
    
    else if (txtfPassword.text.length <=0)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        
    }
    else if(![txtfUsername.text isEqualToString:username]  || ![txtfPassword.text isEqualToString:pwd])
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Incorrect usermane or password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
    }
    else
    {
        HomeViewController *HomeVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:HomeVC animated:YES];
        [HomeVC release];
        
    }
    
}
- (void)btnSubmitTapped:(id)sender
{
    UITextField *textField = nil;
    for (UIView *subView in view_forgot_pass.subviews)
    {
        if ([subView isKindOfClass:[UIView class]] && subView.tag == 101) // for forgot password view
        {
            for (UIView *view in subView.subviews)
            {
                if ([view isKindOfClass:[UIView class]])
                {
                    for (UIView *aView in view.subviews)
                    {
                        if ([aView isKindOfClass:[UITextField class]])
                        {
                            textField = (UITextField*)aView; //textfield email
                            NSLog(@"%@",textField.text);
                            break;
                        }
                    }
                    
                }
                
            }
        }
        
    }
    if (textField != nil)
    {
        DHValidation *emailValidation=[[DHValidation alloc] init];
        
        BOOL emailValid=[emailValidation validateEmail:textField.text];
        
        [emailValidation release];
        
        NSString *email = [Global GetUserEmailFromDefaults];
        
        if (textField.text.length <=0)
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [anAlertView show];
            [anAlertView release];
        }
        
        else if (!emailValid)
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter a valid email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [anAlertView show];
            [anAlertView release];
            
        }
        else if (![email isEqualToString:textField.text])
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sorry, we do not recognize your email.Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [anAlertView show];
            [anAlertView release];
            
        }
        else
        {
            /**Nikhil:15518
             for (UIView *subView in view_forgot_pass.subviews)
             {
             if ([subView isKindOfClass:[UIView class]] && subView.tag == 101) // for forgot password view
             {
             [subView setHidden:YES];
             }
             else if ([subView isKindOfClass:[UIView class]] && subView.tag == 102) // for reset password view
             {
             [subView setHidden:NO];
             for (UIView *view in subView.subviews)
             {
             if ([view isKindOfClass:[UITextField class]])
             {
             UITextField *textField = (UITextField*)view;
             [textField setDelegate:self];
             }
             else if ([view isKindOfClass:[UIButton class]])
             {
             UIButton *btn = (UIButton*)view;
             if (btn.tag == 101)
             {
             [btn addTarget:self action:@selector(btnSubmitResetTapped:) forControlEvents:UIControlEventTouchUpInside];
             }
             else if (btn.tag == 102)
             {
             [btn addTarget:self action:@selector(btnCancelResetTapped:) forControlEvents:UIControlEventTouchUpInside];
             }
             }
             
             }
             }
             
             }
             Nikhil:15518**/
            //Nikhil:15518
            if([MFMailComposeViewController canSendMail]){
                self.mailComposer = [[MFMailComposeViewController alloc] init];
                [self.mailComposer setMailComposeDelegate:self];
                [self.mailComposer setToRecipients:[NSArray arrayWithObject:email]];
                [self.mailComposer setSubject:@"Reset Password"];
                NSString *htmlBody = [NSString stringWithFormat:@"<html>\
                                      <body>\
                                      <p>Please click <a href = \"clue://%@\">here</a> to reset your password.</p>\
                                      </body>\
                                      </html>",[email stringByReplacingOccurrencesOfString:@"@" withString:@"."]];
                [self.mailComposer setMessageBody:htmlBody isHTML:YES];
                [self presentModalViewController:self.mailComposer animated:YES];
            }
            //            HomeViewController *HomeVC = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            //            [((AppDelegate*)CRM_AppDelegate) setIsFromForgotPasswordScreen:YES];
            //            [self.navigationController pushViewController:HomeVC animated:YES];
            //            [HomeVC release];
        }
    }
}
- (void)btnSubmitResetTapped:(id)sender
{
    UITextField *textField = nil;
    NSString *newPass = nil;
    NSString *confirmPass = nil;
    for (UIView *subView in view_forgot_pass.subviews)
    {
        if ([subView isKindOfClass:[UIView class]] && subView.tag == 102) // for reset password view
        {
            for (UIView *view in subView.subviews)
            {
                if ([view isKindOfClass:[UIView class]])
                {
                    for (UIView *aView in view.subviews)
                    {
                        if ([aView isKindOfClass:[UITextField class]])
                        {
                            textField = (UITextField*)aView;
                            if (aView.tag == 101)
                            {
                                newPass = textField.text;
                            }
                            else if (aView.tag == 102)
                            {
                                confirmPass = textField.text;
                            }
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    NSLog(@"%@",newPass);
    NSLog(@"%@",confirmPass);
    if([self validateNewPassword:newPass andConfirmPass:confirmPass])
    {
        [Global SaveUserPassword:[FBEncryptorAES encryptBase64String:newPass keyString:kEncryptionKey separateLines:YES]];
        [Global SetPasswordSaved:YES];
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Password changed successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        for (UIView *subView in view_forgot_pass.subviews)
        {
            if ([subView isKindOfClass:[UIView class]] && subView.tag == 101) // for forgot password view
            {
                for (UIView *view in subView.subviews)
                {
                    if ([view isKindOfClass:[UIView class]])
                    {
                        for (UIView *aView in view.subviews)
                        {
                            if ([aView isKindOfClass:[UITextField class]])
                            {
                                textField = (UITextField*)aView;
                                textField.text = @"";
                                break;
                            }
                        }
                        
                    }
                    
                }
            }
        }
        [self btnCancelResetTapped:nil];
        [self btnCancelTapped:nil];
    }
}
- (BOOL)validateNewPassword:(NSString*)newPassword andConfirmPass:(NSString*)confirmPassword
{
    
    if ([newPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <=0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your new password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if ([confirmPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <=0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter confirm password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if (!([newPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length >= 6 && [newPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 16))
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"New password should have 6 to 16 characters in length" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    else if (![newPassword isEqualToString:confirmPassword])
    {
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Confirm password must be same." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [anAlertView show];
        [anAlertView release];
        return NO;
        
    }
    return YES;
}
- (void)btnCancelTapped:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.44];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeForgotFromSuperview)];
    view_forgot_pass.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
- (void)btnCancelResetTapped:(id)sender
{
    for (UIView *subView in view_forgot_pass.subviews)
    {
        if ([subView isKindOfClass:[UIView class]] && subView.tag == 101) // for forgot password view
        {
            [subView setHidden:NO];
        }
        else if ([subView isKindOfClass:[UIView class]] && subView.tag == 102) // for reset password view
        {
            [subView setHidden:YES];
        }
        
    }
}
- (void)removeForgotFromSuperview
{
    [view_forgot_pass removeFromSuperview];
}
- (IBAction)btnForgotPassword:(id)sender
{
    NSLog(@"%@",view_forgot_pass.subviews);
    for (UIView *subView in view_forgot_pass.subviews)
    {
        if ([subView isKindOfClass:[UIView class]] && subView.tag == 101)
        {
            for (UIView *view in subView.subviews)
            {
                if ([view isKindOfClass:[UITextField class]])
                {
                    UITextField *textField = (UITextField*)view;
                    [textField setDelegate:self];
                    [textField setText:@""];
                }
                else if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton*)view;
                    if (btn.tag == 101)
                    {
                        [btn addTarget:self action:@selector(btnSubmitTapped:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else if (btn.tag == 102)
                    {
                        [btn addTarget:self action:@selector(btnCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
            }
        }
        
    }
    view_forgot_pass.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:view_forgot_pass];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.44];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    view_forgot_pass.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (IBAction)switchValueChange:(UISwitch*)sender
{
    //Flurry log
	[Flurry logEvent:@"Remember Me Tapped"];
    if (sender.on)
    {
        [Global SaveRememberMeFlag:YES];
    }
    else
    {
        [Global SaveRememberMeFlag:NO];
    }
}

- (void)dealloc {
    [view_forgot_pass release];
    [super dealloc];
}
- (void)viewDidUnload {
    [view_forgot_pass release];
    view_forgot_pass = nil;
    [super viewDidUnload];
}
#pragma mark - TouchView delegate
- (void)touchesDown:(NSSet *)touches
{
    UITouch *atouch = [[touches allObjects] lastObject];
    [atouch.view removeFromSuperview];
	//	[self resetAllFilterTextField];
}

#pragma mark - MFMailComposer Delegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
    if(result == MFMailComposeResultSent){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Email Sent!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alertView show];
    }
}

- (void) showPassswordReset{
    //   Nikhil:15518
    for (UIView *subView in view_forgot_pass.subviews)
    {
        if ([subView isKindOfClass:[UIView class]] && subView.tag == 101) // for forgot password view
        {
            [subView setHidden:YES];
        }
        else if ([subView isKindOfClass:[UIView class]] && subView.tag == 102) // for reset password view
        {
            [subView setHidden:NO];
            for (UIView *view in subView.subviews)
            {
                if ([view isKindOfClass:[UITextField class]])
                {
                    UITextField *textField = (UITextField*)view;
                    [textField setDelegate:self];
                }
                else if ([view isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton*)view;
                    if (btn.tag == 101)
                    {
                        [btn addTarget:self action:@selector(btnSubmitResetTapped:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else if (btn.tag == 102)
                    {
                        [btn addTarget:self action:@selector(btnCancelResetTapped:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
            }
        }
        
    }
    //     Nikhil:15518
    view_forgot_pass.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height+100, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:view_forgot_pass];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.44];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    view_forgot_pass.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
@end
