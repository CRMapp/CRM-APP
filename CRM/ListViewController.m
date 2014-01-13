//
//  ListViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 11/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ListViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "AppDelegate.h"
#import "CRMConfig.h"
#import "TaskList.h"
#import "ProposalList.h"
#import "AppointmentList.h"
#import "ReminderList.h"
#import "NotesList.h"
#import "MyAddressBook.h"
#import "EmailList.h"
#import "ContactDetailViewController.h"
#import "SalesGoalViewController.h"
@interface ListViewController ()

@end

@implementation ListViewController
@synthesize tagValue;
@synthesize header;
@synthesize dataArray;
@synthesize aNavigation;
@synthesize deleteTag;
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
    
    [self performSelector:@selector(fetchListData) withObject:nil afterDelay:.01];
    
    [self.view layer].cornerRadius = 8;
    [aListTable layer].cornerRadius = 8;
    [lblHeader setText:header];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(fetchListData) withObject:nil afterDelay:.01];
}
- (void)fetchListData
{
    [self refreshAllLists];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshAllLists
{
    NSPredicate *dashBoardPredicate = nil;
    switch (self.tagValue)
    {
        case 0:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"NotesList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
            //        case 1:
            //
            //            break;
        case 1:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"ReminderList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        case 2:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"AppointmentList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        case 3:
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"ProposalList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        case 4:
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (taskStatus CONTAINS %@)", @"Closed"];
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper searchObjectsForEntity:@"TaskList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        }
        default:
            break;
    }
    [aListTable reloadData];
}

- (NSInteger)numberOfRows:(int)viewIndex
{
    NSPredicate *dashBoardPredicate = nil;
    switch (self.tagValue)
    {
        case 0:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"NotesList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
            //        case 1:
            //
            //            break;
        case 1:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"ReminderList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        case 2:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper getObjectsForEntity:@"AppointmentList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        case 3:
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"(funnelStage CONTAINS[cd] %@) OR (funnelStage CONTAINS[cd] %@) OR (funnelStage CONTAINS[cd] %@)", @"Prospect", @"Opportunity", @"Suspect"];
            self.dataArray = [CoreDataHelper searchObjectsForEntity:@"ProposalList" withPredicate:dashBoardPredicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
//            self.dataArray = [CoreDataHelper getObjectsForEntity:@"ProposalList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];funnelStage
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@ ",[NSNumber numberWithBool:YES]];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            break;
        case 4:
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (taskStatus CONTAINS %@)", @"Closed"];
            dashBoardPredicate = [NSPredicate predicateWithFormat:@"canShowInDashBoard == %@",[NSNumber numberWithBool:YES]];
            self.dataArray = [CoreDataHelper searchObjectsForEntity:@"TaskList" withPredicate:predicate andSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            self.dataArray = [self.dataArray filteredArrayUsingPredicate:dashBoardPredicate];
            
            break;
        }
        default:
            break;
    }
    return [self.dataArray count];
}
#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRows:self.tagValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]  autorelease];
    }
    return [self getCell:cell AtIndexPath:indexPath];
}
- (UITableViewCell *)getCell:(UITableViewCell*)cell AtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dateString = @"";
    if(self.tagValue == 0)
    {
        NotesList *aNote = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [(aNote.relMyAddressBook.firstName.length)?aNote.relMyAddressBook.firstName:@"" stringByAppendingFormat:@" %@",(aNote.relMyAddressBook.lastName.length)?aNote.relMyAddressBook.lastName:@""];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        
        dateString = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:aNote.timeStamp]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
        cell.detailTextLabel.text = dateString;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    /*else if(self.tagValue == 1)
    {
        EmailList *aEmail = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = aEmail.emailId;//[aEmail.relMyAddressBook.firstName stringByAppendingFormat:@" %@",aEmail.relMyAddressBook.lastName];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        
        dateString = [NSDateFormatter localizedStringFromDate:[NSDate dateWithTimeIntervalSince1970:aEmail.timeStamp]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterShortStyle];
        cell.detailTextLabel.text = dateString;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    }*/
    else if(self.tagValue == 1)
    {
        ReminderList *aFollowUpdate = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.text = [(aFollowUpdate.relMyAddressBook.firstName.length)?aFollowUpdate.relMyAddressBook.firstName:@"" stringByAppendingFormat:@" %@",(aFollowUpdate.relMyAddressBook.lastName.length)?aFollowUpdate.relMyAddressBook.lastName:@""];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        dateString = [NSDateFormatter localizedStringFromDate:aFollowUpdate.remDate/*[NSDate dateWithTimeIntervalSince1970:aFollowUpdate.timeStamp]*/
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
        cell.detailTextLabel.text = dateString;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    else if(self.tagValue == 2)
    {
        AppointmentList *aAppointmentList = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.text = [(aAppointmentList.relMyAddressBook.firstName.length)?aAppointmentList.relMyAddressBook.firstName:@"" stringByAppendingFormat:@" %@",(aAppointmentList.relMyAddressBook.lastName.length)?aAppointmentList.relMyAddressBook.lastName:@""];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        dateString = [NSDateFormatter localizedStringFromDate:aAppointmentList.date/*[NSDate dateWithTimeIntervalSince1970:aAppointmentList.timeStamp]*/
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
        cell.detailTextLabel.text = dateString;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    else if(self.tagValue == 3)
    {
        ProposalList *aProposalList = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.text = [(aProposalList.relMyAddressBook.firstName.length)?aProposalList.relMyAddressBook.firstName:@"" stringByAppendingFormat:@" %@",(aProposalList.relMyAddressBook.lastName.length)?aProposalList.relMyAddressBook.lastName:@""];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        dateString = [NSDateFormatter localizedStringFromDate:aProposalList.proposalTargetDate/*[NSDate dateWithTimeIntervalSince1970:aProposalList.timeStamp]*/
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
        cell.detailTextLabel.text = dateString;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    else if(self.tagValue == 4)
    {
        TaskList *aTaskList = [self.dataArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = [(aTaskList.relMyAddressBook.firstName.length)?aTaskList.relMyAddressBook.firstName:@"" stringByAppendingFormat:@" %@",(aTaskList.relMyAddressBook.lastName.length)?aTaskList.relMyAddressBook.lastName:@""];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        dateString = [NSDateFormatter localizedStringFromDate:aTaskList.dueDate/*[NSDate dateWithTimeIntervalSince1970:aTaskList.timeStamp]*/
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
        cell.detailTextLabel.text = dateString;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *btnImage = [UIImage imageNamed:@"delete.png"];
    
    [deleteButton setImage:btnImage forState:UIControlStateNormal];
    
    [deleteButton setFrame:CGRectMake(0, 0, btnImage.size.width, btnImage.size.height)];
    
    [deleteButton addTarget:self action:@selector(btnDeletePress:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteButton setTag:indexPath.row];
    
    [cell setAccessoryView:deleteButton];
    
    return cell;
}
- (void)btnDeletePress:(UIButton*)sender
{
//    NSLog(@"delete press");
//    NSLog(@"%d",self.tagValue);
//    NSLog(@"%d",sender.tag);
    self.deleteTag = sender.tag;
    NSString *message = nil;
    
    if(self.tagValue == 0)
    {
        message = @"call";
    }
    else if(self.tagValue == 0)
    {
        message = @"email";
    }
    else if(self.tagValue == 1)
    {
        message = @"reminder";
    }
    else if(self.tagValue == 2)
    {
        message = @"appointment";
    }
    else if(self.tagValue == 3)
    {
        message = @"proposal";
    }
    else if(self.tagValue == 4)
    {
        message = @"task";
    }

    message = [NSString stringWithFormat:@"The %@ will still stay in the history but not displayed in the dashboard.",message];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:@"Do you want to proceed?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert setTag:1000];
    [alert show];
    [alert release];
}
- (void)removeContactFromDashBoard
{
    NSString *message = nil;
//    MyAddressBook *aContact = nil;
    if(self.tagValue == 0)
    {
        NotesList *aNote = [self.dataArray objectAtIndex:self.deleteTag];
        [aNote setCanShowInDashBoard:[NSNumber numberWithBool:NO]];
        message = @"call";
        
    }
    else if(self.tagValue == 0)
    {
//        EmailList *aEmail = [self.dataArray objectAtIndex:self.deleteTag];
//        [aEmail setCanShowInDashBoard:[NSNumber numberWithBool:NO]];
//        message = @"email";
    }
    else if(self.tagValue == 1)
    {
        ReminderList *aFollowUpdate = [self.dataArray objectAtIndex:self.deleteTag];
        [aFollowUpdate setCanShowInDashBoard:[NSNumber numberWithBool:NO]];
        message = @"reminder";
    }
    else if(self.tagValue == 2)
    {
        AppointmentList *aAppointmentList = [self.dataArray objectAtIndex:self.deleteTag];
        [aAppointmentList setCanShowInDashBoard:[NSNumber numberWithBool:NO]];
        message = @"appointment";
    }
    else if(self.tagValue == 3)
    {
        ProposalList *aProposalList = [self.dataArray objectAtIndex:self.deleteTag];
        [aProposalList setCanShowInDashBoard:[NSNumber numberWithBool:NO]];
        message = @"proposal";
    }
    else if(self.tagValue == 4)
    {
        TaskList *aTaskList = [self.dataArray objectAtIndex:self.deleteTag];
        [aTaskList setCanShowInDashBoard:[NSNumber numberWithBool:NO]];
        message = @"task";
    }
    
    //Flurry log
    if(message)
        [Flurry logEvent:[@"Dashboard remove %@ item tapped" stringByAppendingFormat:@"%@",message]];
    
    [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
    
    [self refreshAllLists];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"UIAlertView");
    if (alertView.tag == 1000 && buttonIndex == 1)
    {
        [self removeContactFromDashBoard];
    }
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%d",tagValue);
    
    NSString *string = nil;
    
    MyAddressBook *aContact = nil;
    if(self.tagValue == 0)
    {
        NotesList *aNote = [self.dataArray objectAtIndex:indexPath.row];
        aContact = aNote.relMyAddressBook;
        string = @"Dashboard call list tapped";
        [self navigateToContactDetail:aContact navigation:NavigatTypeCallUser];
        
    }
    else if(self.tagValue == 0)
    {
        EmailList *aEmail = [self.dataArray objectAtIndex:indexPath.row];
        aContact = aEmail.relMyAddressBook;
        string = @"Dashboard call Email tapped";
        [self navigateToContactDetail:aContact navigation:NavigatTypeEmail];
    }
    else if(self.tagValue == 1)
    {
        ReminderList *aFollowUpdate = [self.dataArray objectAtIndex:indexPath.row];
        aContact = aFollowUpdate.relMyAddressBook;
        string = @"Dashboard reminder list tapped";
        [self navigateToContactDetail:aContact navigation:NavigatTypeReminder];
    }
    else if(self.tagValue == 2)
    {
        AppointmentList *aAppointmentList = [self.dataArray objectAtIndex:indexPath.row];
        aContact = aAppointmentList.relMyAddressBook;
        string = @"Dashboard appointment list tapped";
        [self navigateToContactDetail:aContact navigation:NavigatTypeAppointment];
    }
    else if(self.tagValue == 3)
    {
        ProposalList *aProposalList = [self.dataArray objectAtIndex:indexPath.row];
        aContact = aProposalList.relMyAddressBook;
        string = @"Dashboard proposal list tapped";
        [self navigateToContactDetail:aContact navigation:NavigatTypeProposal];
    }
    else if(self.tagValue == 4)
    {
        TaskList *aTaskList = [self.dataArray objectAtIndex:indexPath.row];
        aContact = aTaskList.relMyAddressBook;
        string = @"Dashboard task list tapped";
        [self navigateToContactDetail:aContact navigation:NavigatTypeTask];
    }
    
    //Flurry log
    if(string)
        [Flurry logEvent:string];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)navigateToContactDetail:(MyAddressBook*)aContact navigation:(NavigatType)navigationType
{
    ContactDetailViewController *obj = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
    [obj setAContactDetails:aContact];
    [self.aNavigation pushViewController:obj animated:YES];
	
	[obj navigateWithClassType:navigationType];
	
    [obj release];
}

@end
