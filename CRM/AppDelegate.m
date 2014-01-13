//
//  AppDelegate.m
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

//#import "AppDelegate.h"

#import "LoginViewController.h"
#import "Global.h"
#import "HomeViewController.h"
#import "CountryNCodeList.h"
#import "Industries.h"

#define BUNDLE_IDENTIFIER ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"])

#import "FunnelStageList.h"
#import "ReminderList.h"
#import "AppointmentList.h"
#import "TaskList.h"
#define SMTP_EMAIL @"alok.pandey@b24esolutions.com"
#define SMTP_HOST  @"smtp.gmail.com"
#define SMTP_PASS  @"9984012150"
#import "SVProgressHUD.h"

BOOL showChangePassword = NO;

@implementation AppDelegate
@synthesize isAppLaunchedFirst;
@synthesize isFromForgotPasswordScreen;
@synthesize navigation;
@synthesize eventStore;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fileManager, isSignedIntoICloud;


- (NSString *)accessGroup {
    NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                           kSecClassGenericPassword, kSecClass,
                           @"bundleSeedID", kSecAttrAccount,
                           @"", kSecAttrService,
                           (id)kCFBooleanTrue, kSecReturnAttributes,
                           nil];
    CFDictionaryRef result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status == errSecItemNotFound)
        status = SecItemAdd((CFDictionaryRef)query, (CFTypeRef *)&result);
    if (status != errSecSuccess)
        return nil;
    NSString *accessGroup = [(NSDictionary *)result objectForKey:kSecAttrAccessGroup];
    accessGroup = [accessGroup stringByReplacingOccurrencesOfString:@"." withString:@"~"];
//    NSArray *components = [accessGroup componentsSeparatedByString:@"."];
//    NSString *bundleSeedID = [[components objectEnumerator] nextObject];
//    CFRelease(result);
    return accessGroup;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([[url scheme] isEqualToString:@"clue"]){
        if ([self.viewController isKindOfClass:[LoginViewController class]]) {
            showChangePassword = YES;
            [self.viewController showPassswordReset];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.fileManager = [NSFileManager defaultManager];
//    NSString *str = [self accessGroup];
//    NSLog(@"%@",str);
    //[AppDelegate insert_VCFCardToiOSAddressBook];
    
    // Another handy thing I had to search around for a little
    // Get the value for the "Bundle version" from the Info.plist
    
    if ([Global GetPasswordCreated])
    {
        self.viewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
        self.navigation = [[[UINavigationController alloc]initWithRootViewController:self.viewController] autorelease];
    }
    else
    {
        HomeViewController *homeObj = [[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil] autorelease];
        self.navigation = [[[UINavigationController alloc]initWithRootViewController:homeObj] autorelease];
    }
    
    
//    As per client requirement changes we change concept of create first sales pipe line by saving YES to launch app
//    [Global SaveFirstLaunchAppFlag:YES];
//    self.isAppLaunchedFirst = YES;
    //Remove above two lines to apply prevoius changes

    if (![Global GetFirstLaunchAppFlag])
    {
        self.isAppLaunchedFirst = YES;
//        [Global SaveFirstLaunchAppFlag:YES];
    }
    else
    {
        [Global SaveSalePipelineFlag:NO];
    }
    //Flurry
	[Flurry startSession:kFlurryApplicationKey];
    
    [self.window setRootViewController:self.navigation];
    
    [self.window makeKeyAndVisible];
    navigation.navigationBarHidden = YES;
    
    application.applicationIconBadgeNumber = 0;
	
	// Handle launching from a local notification
	UILocalNotification *localNotif =
	[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
		NSLog(@"Recieved Notification %@",localNotif);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Notify" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
	}
    
    //iCloud Implementation begin here
    [self managedObjectContext];
    id currentToken = [self.fileManager ubiquityIdentityToken];
    isSignedIntoICloud= (currentToken!=nil);

    [self persistICloudToken];
    [[NSNotificationCenter defaultCenter]
     addObserver: self  selector: @selector (iCloudChangesImported:)
     name: NSPersistentStoreDidImportUbiquitousContentChangesNotification
     object: nil];
    [self requestPermissionToUseICloud];
    return YES;
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
	// Handle the notificaton when the app is running
	NSLog(@"Recieved Notification %@",notif);
    app.applicationIconBadgeNumber = 0;
    
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:[notif userInfo]];
    
    
    
    if ([[info valueForKey:IS_REMINDER_MULTIPLE] isEqualToString:@"YES"])
    {
//        NSLog(@"INSIDE IF");
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(showReminderPopUp:) withObject:info afterDelay:4.0];
    }
    else
    {
//        NSLog(@"INSIDE ELSE");
        [self performSelector:@selector(showReminderPopUp:) withObject:info afterDelay:0.0];
    }
    
    
}
- (void)showReminderPopUp:(NSDictionary*)info
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[info valueForKey:NOTIFICATION_TITLE_KEY] message:[info valueForKey:NOTIFICATION_MESSAGE_KEY] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma - mark UserVoice Configration
+ (UVConfig *)uvConfig
{
//    UVConfig *config = [UVConfig configWithSite:@"demo.uservoice.com" andKey:@"pZJocTBPbg5FN4bAwczDLQ" andSecret:@"Q7UKcxRYLlSJN4CxegUYI6t0uprdsSAGthRIDvYmI"];
    UVConfig *config = [UVConfig    configWithSite:UV_CONFIG_SITE
                                            andKey:UV_API_KEY
                                         andSecret:UV_SECRET_KEY];
    return config;
}
- (void)launchFeedback :(id)FromObject
{
    [self setUserVoiceBackGroundWhite];
    [UserVoice presentUserVoiceInterfaceForParentViewController:FromObject andConfig:[AppDelegate uvConfig]];
    [UserVoice setDelegate:self];
}
-(void)userVoiceWasDismissed
{
    NSLog(@"Hello");
    [aTouchView removeFromSuperview];
    
}
- (void)setUserVoiceBackGroundWhite
{
    aTouchView = [[TouchView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [aTouchView setBackgroundColor:[UIColor whiteColor]];
    [aTouchView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [aTouchView setDelegate:self];
    [self.window addSubview:aTouchView];
    [aTouchView release];
}
#pragma - mark UserVoice Configration END

#pragma
#pragma - mark icloud Functions
-(void) iCloudChangesImported:(NSNotification *)notification {
    NSLog(@"iCloud changes have been imported=%@",@"YES");
//    NSError *error;
//    [[self fetchedResultsController] performFetch:&error];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        [self.tableView reloadData];
    });
}
-(void) persistICloudToken{
    if (self.isAppLaunchedFirst && isSignedIntoICloud){
        id currentiCloudToken = [[NSFileManager defaultManager] ubiquityIdentityToken];
        NSString *key = [BUNDLE_IDENTIFIER stringByAppendingString:@".UbiquityIdentityToken"];
        if (currentiCloudToken) {
            NSData *newTokenData =[NSKeyedArchiver archivedDataWithRootObject: currentiCloudToken];
            [[NSUserDefaults standardUserDefaults]
             setObject: newTokenData
             forKey:key];
        } else {
            [[NSUserDefaults standardUserDefaults]
             removeObjectForKey:key];
        }
    }
}
-(void) requestPermissionToUseICloud{
    if (self.isAppLaunchedFirst && isSignedIntoICloud){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Choose Storage Option"
                                                        message: @"Should documents be stored in iCloud and available on all your devices?"
                                                       delegate: self
                                              cancelButtonTitle: @"Local Only"
                                              otherButtonTitles: @"iCloud", nil];
        
        [alert show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSURL *DataFileUrl=  [self createICloudDataDirectory];
        [self addPersistentStore:DataFileUrl];
    }
    
}

-(NSURL *) createICloudDataDirectory{
//    NSURL *storeURL = [self.fileManager URLForUbiquityContainerIdentifier:[self accessGroup]];
    NSURL *storeURL = [self.fileManager URLForUbiquityContainerIdentifier:nil];
    NSURL *dataFolder = [storeURL URLByAppendingPathComponent:@"Data.nosync"];
    //that nosync file extension is important!
    NSURL *dataFile = [dataFolder URLByAppendingPathComponent:@"CRM.sqlite"];
    BOOL isDirectory = YES;
    NSError *error;
    if(![self.fileManager fileExistsAtPath:[dataFolder path] isDirectory:&isDirectory])
        if(![self.fileManager createDirectoryAtURL:dataFolder withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"Create Directory Error %@, %@", error, [error userInfo]);
    NSLog(@"dataFile=%@",[dataFile path]);
    return dataFile;
    
}
-(void) addPersistentStore:(NSURL*)dataFileURL{
    NSError *error;
//    NSURL *storeURL = [self.fileManager URLForUbiquityContainerIdentifier:[self accessGroup]];
    NSURL *storeURL = [self.fileManager URLForUbiquityContainerIdentifier:nil];
    NSLog(@"[storeURL path]=%@",[storeURL path]);
    NSDictionary *options = @{NSPersistentStoreUbiquitousContentNameKey : @"iCloudData",
                              NSPersistentStoreUbiquitousContentURLKey : storeURL};
    id result=[_persistentStoreCoordinator addPersistentStoreWithType : NSSQLiteStoreType
                                                        configuration : nil
                                                                  URL : dataFileURL
                                                              options : options
                                                                error : &error];
    if (result==nil){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

#pragma -mark
#pragma mark - Save Context
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSLog(@" saveContext %@",[managedObjectContext hasChanges] ? @" Saved":@"Not Saved");
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.- (NSManagedObjectContext *)managedObjectContext {
- (NSManagedObjectContext *)managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: coordinator];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeChangesFrom_iCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
        }];
        _managedObjectContext = moc;
    }
    
    return _managedObjectContext;
}
- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
    
	NSLog(@"Merging in changes from iCloud...");
    
    NSManagedObjectContext* moc = [self managedObjectContext];
    
    [moc performBlock:^{
        
        [moc mergeChangesFromContextDidSaveNotification:notification];
        
        NSNotification* refreshNotification = [NSNotification notificationWithName:@"SomethingChanged"
                                                                            object:self
                                                                          userInfo:[notification userInfo]];
        
        [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
    }];
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        if((_persistentStoreCoordinator != nil))
        {
            return _managedObjectModel;
        }         
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CRM" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    [SVProgressHUD  showWithStatus:@"Syncing with iCloud..."];
    if((_persistentStoreCoordinator != nil))
    {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    NSPersistentStoreCoordinator *psc = _persistentStoreCoordinator;
    
    // Set up iCloud in another thread:
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // ** Note: if you adapt this code for your own use, you MUST change this variable:
        NSString *iCloudEnabledAppID = [self accessGroup];
//        NSString *iCloudEnabledAppID = BUNDLE_IDENTIFIER;
        // ** Note: if you adapt this code for your own use, you should change this variable:
        NSString *dataFileName = @"CRM.sqlite";
        
        // ** Note: For basic usage you shouldn't need to change anything else
        
        NSString *iCloudDataDirectoryName = @"Data.nosync";
        NSString *iCloudLogsDirectoryName = @"Logs";
        NSFileManager *fileManager1 = [NSFileManager defaultManager];
        NSURL *localStore = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataFileName];
        NSURL *iCloud = [fileManager1 URLForUbiquityContainerIdentifier:iCloudEnabledAppID];
        
        if (iCloud) {
            
            NSLog(@"iCloud is working");
            
            NSURL *iCloudLogsPath = [NSURL fileURLWithPath:[[iCloud path] stringByAppendingPathComponent:iCloudLogsDirectoryName]];
            
            NSLog(@"iCloudEnabledAppID = %@",iCloudEnabledAppID);
            NSLog(@"dataFileName = %@", dataFileName);
            NSLog(@"iCloudDataDirectoryName = %@", iCloudDataDirectoryName);
            NSLog(@"iCloudLogsDirectoryName = %@", iCloudLogsDirectoryName);
            NSLog(@"iCloud = %@", iCloud);
            NSLog(@"iCloudLogsPath = %@", iCloudLogsPath);
            
            if([fileManager1 fileExistsAtPath:[[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName]] == NO) {
                NSError *fileSystemError;
                [fileManager1 createDirectoryAtPath:[[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName]
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&fileSystemError];
                if(fileSystemError != nil) {
                    NSLog(@"Error creating database directory %@", fileSystemError);
                }
            }
            
            NSString *iCloudData = [[[iCloud path]
                                     stringByAppendingPathComponent:iCloudDataDirectoryName]
                                    stringByAppendingPathComponent:dataFileName];
            
            NSLog(@"iCloudData = %@", iCloudData);
            
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            [options setObject:iCloudEnabledAppID            forKey:NSPersistentStoreUbiquitousContentNameKey];
            [options setObject:iCloudLogsPath                forKey:NSPersistentStoreUbiquitousContentURLKey];
            
            [psc lock];
            NSError *error = nil;
            [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:[NSURL fileURLWithPath:iCloudData]
                                    options:options
                                      error:&error];
            if (error) {
                NSLog(@"psc stored added:%@",[error localizedDescription]);
            }
            [psc unlock];
            [SVProgressHUD dismiss];
        }
        else {
            NSLog(@"iCloud is NOT working - using a local store");
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            
            [psc lock];
            NSError *Error=nil;
            [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:localStore
                                    options:options
                                      error:&Error];
            
            NSLog(@"Error While Adding Store to ICloud %@",[Error description]);
            
            [psc unlock];
            [SVProgressHUD dismiss];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:self userInfo:nil];
        });
    });
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSString*) resourcePathForFile:(NSString*)fileNameWithExtension
{
	NSString* fullPath = nil;
	
	// Sepearate file name and extension.
	NSArray* components = [fileNameWithExtension componentsSeparatedByString:@"."];
	
	if([components count] == 2){
		// Get the file name first.
		NSString* fileName = [components objectAtIndex:0];
		
		// Now get the extension
		NSString* fileExtension = [components objectAtIndex:1];
		
		// Now we need to get the absolute path from the resources.
		fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
	}
	
    NSLog(@"%@",fullPath);
	return fullPath;
}
#pragma mark - Flurry methods
+(void)setFlurryEventWithSender:(UIButton*)sender
{
	if (KdemoFlurryKey)
	{
		//Flurry logEvent
		NSString * logTxt = [NSString stringWithFormat:@"Button : %@",sender.titleLabel.text];
		NSLog(@"Flurry  : %@",logTxt);
		[Flurry logEvent:[logTxt stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
	}
	
}
+(void)setFlurryWithText:(NSString*)string
{
	if (KdemoFlurryKey)
	{
		NSString * logTxt = [NSString stringWithFormat:@"%@",string];
		NSLog(@"Flurry  : %@",logTxt);
		[Flurry logEvent:[logTxt stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
	}
}
+(void)setFlurryWithText:(NSString*)string andParms:(NSDictionary*)dict
{
	if (KdemoFlurryKey)
	{
		NSString * logTxt = [NSString stringWithFormat:@"%@",string];
		NSLog(@"Flurry  : %@ dict : %@",logTxt,dict);
		[Flurry logEvent:[logTxt stringByReplacingOccurrencesOfString:@" " withString:@"_"] withParameters:dict];
	}
}
#pragma mark - Insert VCF card
+ (void)insert_VCFCardToiOSAddressBook
{
    NSURL *vCardURL = [[NSBundle bundleForClass:self.class] URLForResource:@"Albert-John"/*@"Dr._Albert-John_He_leau_Te_tingl_t-Davis_Jr"*/ withExtension:@"vcf"];
    CFDataRef vCardData = (CFDataRef)[NSData dataWithContentsOfURL:vCardURL];
    
    ABAddressBookRef book = ABAddressBookCreate();
    ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
    CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
    for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
        ABAddressBookAddRecord(book, person, NULL);
    }
    
    CFRelease(vCardPeople);
    CFRelease(defaultSource);
    ABAddressBookSave(book, NULL);
    CFRelease(book);
}
#pragma mark - Create test contact
+ (void)CreateContactToiOsAddressBookForTesting
{
    // Creating new entry
    /*  ABAddressBookRef addressBook = ABAddressBookCreate();
     ABRecordRef person = ABPersonCreate();
     
     // Setting basic properties
     ABRecordSetValue(person, kABPersonFirstNameProperty, @"Ondrej" , nil);
     ABRecordSetValue(person, kABPersonLastNameProperty, @"Rafaj", nil);
     ABRecordSetValue(person, kABPersonJobTitleProperty, @"Tech. director", nil);
     ABRecordSetValue(person, kABPersonDepartmentProperty, @"iPhone development department", nil);
     ABRecordSetValue(person, kABPersonOrganizationProperty, @"Fuerte international", nil);
     ABRecordSetValue(person, kABPersonNoteProperty, @"The best iPhone development studio in the UK :)", nil);
     
     // Adding phone numbers
     ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
     ABMultiValueAddValueAndLabel(phoneNumberMultiValue, @"07972574949", (CFStringRef)@"iPhone", NULL);
     ABMultiValueAddValueAndLabel(phoneNumberMultiValue, @"01234567890", (CFStringRef)@"Work", NULL);
     ABMultiValueAddValueAndLabel(phoneNumberMultiValue, @"08701234567", (CFStringRef)@"home", NULL);
     ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
     CFRelease(phoneNumberMultiValue);
     
     // Adding url
     ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
     ABMultiValueAddValueAndLabel(urlMultiValue, @"http://www.fuerteint.com", kABPersonHomePageLabel, NULL);
     ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
     CFRelease(urlMultiValue);
     
     // Adding emails
     ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
     ABMultiValueAddValueAndLabel(emailMultiValue, @"info@fuerteint.com", (CFStringRef)@"Global", NULL);
     ABMultiValueAddValueAndLabel(emailMultiValue, @"ondrej.rafaj@fuerteint.com", (CFStringRef)@"Work", NULL);
     ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
     CFRelease(emailMultiValue);
     
     // Adding address
     ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
     NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
     [addressDictionary setObject:@"8-15 Dereham Place" forKey:(NSString *)kABPersonAddressStreetKey];
     [addressDictionary setObject:@"London" forKey:(NSString *)kABPersonAddressCityKey];
     [addressDictionary setObject:@"EC2A 3HJ" forKey:(NSString *)kABPersonAddressZIPKey];
     [addressDictionary setObject:@"United Kingdom" forKey:(NSString *)kABPersonAddressCountryKey];
     [addressDictionary setObject:@"gb" forKey:(NSString *)kABPersonAddressCountryCodeKey];
     ABMultiValueAddValueAndLabel(addressMultipleValue, addressDictionary, kABHomeLabel, NULL);
     [addressDictionary release];
     BOOL isSaved = ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
     CFRelease(addressMultipleValue);
     
     // Adding person to the address book
     ABAddressBookAddRecord(addressBook, person, nil);
     ABAddressBookSave(addressBook, nil);
     CFRelease(addressBook);*/
}
#pragma mark - getAllIndustry
- (void)insertIndusrtiesInDatabase
{
	// if data for industry
	NSManagedObjectContext *context = [self managedObjectContext];
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"Industries" withPredicate:nil andSortKey:nil andSortAscending:YES andContext:context];
	
	if (![array count])
	{
		NSString* filePath = [[NSBundle mainBundle] pathForResource:@"industries" ofType:@"txt"];
		NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		
		NSArray * arrIndustry = [myText componentsSeparatedByString:@"\n"];
		
		for (NSString * text in arrIndustry)
		{
			text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([text length])
			{
				
				Industries * industry = [NSEntityDescription insertNewObjectForEntityForName:@"Industries" inManagedObjectContext:context];
				
				[industry setValue:text forKey:NSStringFromSelector(@selector(industryName))];
				
				if (![context save:nil])
				{
					NSLog(@"NOT Saved");
				}
				
				
			}
			
		}
	}
}
#pragma mark - getAllCountry
+ (void)getAllCountryCodeWithCountry
{
    AppDelegate * aDelegate = CRM_AppDelegate;
	// if data for industry
	
	NSArray * array = [CoreDataHelper searchObjectsForEntity:@"CountryNCodeList" withPredicate:nil andSortKey:nil andSortAscending:YES andContext:aDelegate.managedObjectContext];
	
	if (![array count])
	{
        for (NSString *countryCode in [NSLocale ISOCountryCodes])
        {
            NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
            NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
            
            CountryNCodeList * countryCodeobj = [NSEntityDescription insertNewObjectForEntityForName:@"CountryNCodeList" inManagedObjectContext:[((AppDelegate*)CRM_AppDelegate) managedObjectContext]];
            [countryCodeobj setCountryName:country];
            [countryCodeobj setCountryCode:countryCode];
            
            [[((AppDelegate*)CRM_AppDelegate) managedObjectContext] save:nil];
        }
    }
}
#pragma mark - getAllCurrency
+ (void)getAllCurrency
{
    
    NSMutableArray *currencyArr = [NSMutableArray array];
    
    for (NSString *currencyCode in [NSLocale ISOCurrencyCodes])
    {
        NSString *currencySymbol = [[NSLocale currentLocale] displayNameForKey: NSLocaleCurrencySymbol value: currencyCode];
        
        if(currencySymbol)
            [currencyArr addObject:currencySymbol];
    }
    NSLog(@"%@",currencyArr);
}
#pragma mark - Insert funnel stages
- (void)insertFunnelStageList
{
    NSArray * arr = [CoreDataHelper getObjectsForEntity:@"FunnelStageList" withSortKey:nil andSortAscending:NO andContext:[self managedObjectContext]];
	if (![arr count])
	{
//		NSArray * array = @[@"Prospect",@"Opportunities",@"Proposal",@"New Customer",@"Suspect"];
        
        NSArray * array = @[@"Prospect",@"Opportunity",@"Customer Lost",@"Customer Cancel",@"Customer Won",@"Suspect"];
		
		for (int i = 0 ; i < [array count]; i++)
		{
			FunnelStageList * funnelObject = [NSEntityDescription insertNewObjectForEntityForName:@"FunnelStageList" inManagedObjectContext:[self managedObjectContext]];
			[funnelObject setStageName:[array objectAtIndex:i]];
            if (i + 11 == 13  ||  i + 11 == 14)
            {
                [funnelObject setStageID:[NSNumber numberWithInt:13]];
            }
            else if (i + 11 >= 15)
            {
                [funnelObject setStageID:[NSNumber numberWithInt:i + 10]];
            }
            else
            {
                [funnelObject setStageID:[NSNumber numberWithInt:i + 11]];
            }
			
			if (![[self managedObjectContext] save:nil])
			{
				NSLog(@"Error in Save");
			}
            
		}
        
	}
}
#pragma mark - Create iCal and Reminder app Events
- (void)saveEventForTask:(id)items
{
    if (eventStore == nil)
    {
		self.eventStore = [[[EKEventStore alloc] init] autorelease];
	}
    
    if ([items isKindOfClass:[ReminderList class]]) //save appointment to Reminder app
    {
        ReminderList *aReminder = (ReminderList*)items;

        [self saveReminderToReminderApp:aReminder];
    }
    else if ([items isKindOfClass:[AppointmentList class]]) //save appointment to iCal
    {
        AppointmentList *aAppointment = (AppointmentList*)items;
        
        [self saveAppointmentToiCal:aAppointment];
    }
    else if ([items isKindOfClass:[TaskList class]]) //save task to Reminder app
    {
        TaskList *aTask = (TaskList*)items;
        
        [self saveTaskToReminderApp:aTask];
    }
}
#pragma mark - save appointment to iCal app
- (void)saveAppointmentToiCal:(AppointmentList*)aAppointment
{
    NSError *err	=	nil;
    
	EKEvent *event	=	[EKEvent eventWithEventStore:self.eventStore];
	if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])  //for iOS-6 and later
	{
		[event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
		[self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 NSLog(@"User granted permission to app to store event.");
             }
             else{
                 NSLog(@"User did not grant permission to app to store event.");
             }
         }];
	}
	else
    {
		[event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
	}
    NSString *atitle = aAppointment.title;
    NSString *aNote = aAppointment.desc;
    NSDate *endDate = aAppointment.date;
    
	event.timeZone	=	[NSTimeZone defaultTimeZone];
    
    event.title		=	atitle;
    
    event.notes		=	aNote;
	
	event.allDay	=	YES;
    
    event.startDate =	[NSDate date];
    
	event.endDate	=	endDate;
	
	BOOL stored = [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
	
	if(stored)
    {
		NSLog(@"An Event for the Task has been stored with Identifier");
	}
	else
    {
		NSLog(@"An Error  has occured while storing event in calendar.");
	}
}
#pragma mark - save reminder to Reminder app
- (void)saveReminderToReminderApp:(ReminderList*)aReminder
{    
	EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
	if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])  //for iOS-6 and later
	{
		[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            
            if (!granted)
                NSLog(@"Access to store not granted");
        }];
	}
	reminder.title = aReminder.remTitle;
    
    reminder.calendar = [self.eventStore defaultCalendarForNewReminders];
    
    reminder.notes = aReminder.remDesc;
    
    NSDate *date = aReminder.remDate;
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
    
    [reminder addAlarm:alarm];
    
    NSError *error = nil;
    
    BOOL stored = [self.eventStore saveReminder:reminder commit:YES error:&error];
    
    if(stored)
    {
		NSLog(@"An Event for the Task has been stored with Identifier");
	}
	else
    {
		NSLog(@"An Error  has occured while storing event in calendar.");
	}

}
#pragma mark - save task to Reminder app
- (void)saveTaskToReminderApp:(TaskList*)atask
{
	EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
	if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])  //for iOS-6 and later
	{
		[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            
            if (!granted)
                NSLog(@"Access to store not granted");
        }];
	}
	reminder.title = atask.taskName;
    
    reminder.calendar = [self.eventStore defaultCalendarForNewReminders];
    
    NSDate *date = atask.dueDate;
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
    
    [reminder addAlarm:alarm];
    
    NSError *error = nil;
    
    BOOL stored = [self.eventStore saveReminder:reminder commit:YES error:&error];
    
    if(stored)
    {
		NSLog(@"An Event for the Task has been stored with Identifier");
	}
	else
    {
		NSLog(@"An Error  has occured while storing event in calendar.");
	}
    
}
#pragma mark - UnSelectContactIfAny
- (void)unselectContactIfAny
{
    NSArray *allContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    for (MyAddressBook *aContact in allContacts)
    {
        if (aContact.isSelected)
        {
            aContact.isSelected = NO;
        }
    }
    [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
}
@end
