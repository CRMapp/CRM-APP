//
//  AppDelegate.h
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.

//com.b24.yom
//com.livetone.crm
#import <UIKit/UIKit.h>
#import "CRMConfig.h"
#import <EventKit/EventKit.h>
#import "UserVoice.h"
#import "TouchView.h"
extern BOOL showChangePassword;
@class LoginViewController;
@class UVConfig;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UVDelegate>
{
    TouchView *aTouchView;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *viewController;

@property (strong, nonatomic)UINavigationController *navigation;

@property(nonatomic,assign)BOOL isAppLaunchedFirst;
@property(nonatomic,assign)BOOL isFromForgotPasswordScreen;

@property (nonatomic, retain) EKEventStore *eventStore;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(void)setFlurryEventWithSender:(UIButton*)sender;
+(void)setFlurryWithText:(NSString*)string;
+(void)setFlurryWithText:(NSString*)string andParms:(NSDictionary*)dict;

@property (strong, nonatomic) NSFileManager *fileManager;

@property(nonatomic,assign)BOOL isSignedIntoICloud;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSString*) resourcePathForFile:(NSString*)fileNameWithExtension;


- (void)launchFeedback :(id)FromObject;
+ (UVConfig *)uvConfig;

//iCal crate events
- (void)saveEventForTask:(id)items;

+ (void)insert_VCFCardToiOSAddressBook;
+ (void)CreateContactToiOsAddressBookForTesting;
- (void)insertIndusrtiesInDatabase;
+ (void)getAllCountryCodeWithCountry;
+ (void)getAllCurrency;
- (void)insertFunnelStageList;
@end
