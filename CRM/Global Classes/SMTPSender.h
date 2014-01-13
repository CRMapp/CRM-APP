//
//  SMTPSender.h
//  CRM
//
//  Created by Sheetal's iMac on 05/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

#import "SKPSMTPMessage.h"
@class SettingsViewController;
@protocol SMTPSenderDelegate <NSObject>

- (void)testingForConfigureMail:(NSNumber*)isSuccess error:(NSError *)error;

@end

@interface SMTPSender : NSObject<SKPSMTPMessageDelegate>
@property (nonatomic , assign) int currentCount;
@property (nonatomic , assign) int totCount;
@property (nonatomic , assign) BOOL isTesting;
@property (nonatomic ,retain) NSMutableArray* allEmails;
@property (nonatomic , assign) id<SMTPSenderDelegate> aDelegate;
+ (SMTPSender *)sharedSMTPSender;

-(void)sendEmailTo:(NSMutableDictionary*)emailInfo;
- (void)sendEmailToUsers:(NSMutableArray*)toEmails message:(NSString*)message;
@end
