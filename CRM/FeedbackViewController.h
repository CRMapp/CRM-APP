//
//  FeedbackViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 01/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTTextView.h"
@interface FeedbackViewController : UIViewController
{
    IBOutlet KTTextView *txtVwFeedback;
    IBOutlet UITextField *txtfEmail;
}
- (IBAction)btnSendFeedback:(id)sender;
@end
