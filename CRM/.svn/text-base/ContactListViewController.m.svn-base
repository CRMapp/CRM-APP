//
//  ContactListViewController.m
//  CRM
//
//  Created by Sheetal's iMac on 26/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactListTVCell.h"
#import "ContactDetailViewController.h"
#import "Global.h"
//#import "AppDelegate.h"
#import "CRMConfig.h"
#import "MyAddressBook.h"
#import "GlobalDataPersistence.h"
#import "SVProgressHUD.h"
#import "GroupList.h"
#import "GroupMemberList.h"
#import "SaleContactListTVCell.h"
#import "ImageData.h"
#import "ABContactsHelper.h"
@interface ContactListViewController ()

@end

@implementation ContactListViewController
@synthesize aDelegate;
@synthesize dropDownGroup;
@synthesize strDropDownGroupName;
@synthesize arrContacts;
@synthesize editItemTag;
@synthesize arrGroupList;
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
    
//    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    
    if (((AppDelegate*)CRM_AppDelegate).isAppLaunchedFirst)
    {
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Do you want to import all contact now." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"SKIP",nil];
        [anAlertView setTag:1000];
        [anAlertView show];
        [anAlertView release];
    }
    else
    {
        self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        if ([arrContacts count] <= 0)
        {
            [SVProgressHUD showWithStatus:@"Importing your address book"];
            
            [self performSelector:@selector(loadContactList) withObject:nil afterDelay:0.1];
        }
        else
        {
            [tblContactList reloadData];
        }
    }
    
   
    [self generateDropDown];
    [self downloadDropDownData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLayout:) name:@"changeLayout" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self downloadDropDownData];
    
//    if ([arrContacts count] == 0 && !((AppDelegate*)CRM_AppDelegate).isAppLaunchedFirst)
    {
        self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        [tblContactList reloadData];
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    [self updateUI:orientation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NSNotificationCenter methods
-(void)changeLayout:(NSNotification*)info
{
    NSDictionary *themeInfo     =   [info userInfo];
    int orintation = [[themeInfo objectForKey:@"kOrientation"] intValue];
    if(orintation <= 2)
    {
        [imgVSearchBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
        [btnAddNew setBackgroundImage:[UIImage imageNamed:@"btn_bg_p.png"] forState:UIControlStateNormal];
//        [btnDeleteAll setBackgroundImage:[UIImage imageNamed:@"btn_bg_p.png"] forState:UIControlStateNormal];
    }
    else
    {
        [imgVSearchBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
        [btnAddNew setBackgroundImage:[UIImage imageNamed:@"blue-btn.png"] forState:UIControlStateNormal];
//        [btnDeleteAll setBackgroundImage:[UIImage imageNamed:@"blue-btn.png"] forState:UIControlStateNormal];
    }
}

-(void)updateUI:(int)orientation
{
    if(orientation <= 2)
    {
        [imgVSearchBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"text_box_p.png"]];
    }
    else
    {
        [imgVSearchBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
        [imgVDropDownBg setImage:[UIImage imageNamed:@"map-textbox.png"]];
    }
}
#pragma  mark - Access Contacts from Address Book
- (void)loadContactList
{
    
//    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];

    [AddressBook arrayOfAddressBook];
    
    self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
//    [tblContactList reloadData];
    
    [SVProgressHUD dismiss];
    
   /* UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm" message:@"Do you want to create your first sales pipeline." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Skip",nil];
    [anAlertView setTag:1003];
    [anAlertView show];
    [anAlertView release];*/
    [Global SaveSalePipelineFlag:NO];
    [tblContactList reloadData];
}
#pragma mark - DropDown List methods
- (void)generateDropDown
{
    
	//Category Drop Down
	
    if (self.dropDownGroup)
    {
        [dropDownGroup release];
        dropDownGroup = nil;
    }
	
	self.dropDownGroup = [[[DropDownView alloc] initWithFrame:imgVDropDownBg.frame target:self] autorelease];
    [self.dropDownGroup setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
    [self.dropDownGroup setBackgroundColor:[UIColor clearColor]];
    [self.dropDownGroup.myLabel setText:@"Add to group"];
	[self.view addSubview:self.dropDownGroup];   
	
    
}
- (void)downloadDropDownData {
    
    NSMutableArray* List = [[NSMutableArray  alloc ]initWithCapacity:0];
    self.arrGroupList = [CoreDataHelper getObjectsForEntity:@"GroupList" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    for (GroupList* group in self.arrGroupList)
    {
        [List addObject:group.groupName];
    }

//    [List addObjectsFromArray:[NSArray arrayWithObjects:@"Group1",@"Group2",@"Group3",@"Group4",@"Group5", @"Group6",@"Group7",@"Group8",@"Group9",@"Group10",nil]];
    [self.dropDownGroup setDataArray:List];
//    [self.dropDownGroup setSelectedIndex:-1];
    [List release];
}
#pragma mark DropDownView delegate method
-(void)didSelectIndex:(int)index ForDropDown:(DropDownView*)dropdown
{
	self.strDropDownGroupName = dropdown.strDropDownValue;
    if ([dropdown.strDropDownValue rangeOfString:@"Add to group" options:NSCaseInsensitiveSearch].length == 0)
    {
        GroupList *aGroup = [self.arrGroupList objectAtIndex:index];
        BOOL isMemCheck = NO;
        for (int i =0 ; i < [self.arrContacts count]; i++)
        {
            MyAddressBook* aContact = [self.arrContacts objectAtIndex:i];
            if (aContact.isSelected)
            {
                isMemCheck = YES;
                NSArray *memArray = [[aGroup relGroupMember] allObjects];
                NSLog(@"%@",memArray);
                if(![self checkMemberAlreadyExistInGroupList:memArray aMember:aContact])
                {
                    NSLog(@"MEMBER ADDED");
                    GroupMemberList *aGroupMember = (GroupMemberList *)[NSEntityDescription insertNewObjectForEntityForName:@"GroupMemberList" inManagedObjectContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
                    
                    [aGroupMember setMemRecordID:aContact.recordID];
                    [aGroupMember setMemberName:[(aContact.firstName)?aContact.firstName:@"" stringByAppendingFormat:@" %@",(aContact.lastName)?aContact.lastName:@""]];
                    [aGroupMember setMemberCompany:aContact.organisation];
                    [aGroupMember setMemberTitle:aContact.jobTitle];
                    
                    [aGroupMember setRelGroupList:aGroup];
                    
//                    [aContact setGroupName:aGroup.groupName];
                    [((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil];
                    aContact.isSelected = NO;
                    [self.arrContacts replaceObjectAtIndex:i withObject:aContact];
                }
                
                
            }
        }
        if (isMemCheck)
        {
            
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@ group updated successfully",aGroup.groupName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [anAlertView show];
            [anAlertView release];
        }
        else
        {
            UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select some contacts." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [anAlertView show];
            [anAlertView release];
        }
    }
    
    [tblContactList reloadData];
    [self.dropDownGroup.myLabel setText:@"Add to group"];
    [self.dropDownGroup.myLabel setTextColor:[UIColor lightGrayColor]];
//    [self.dropDownGroup setSelectedIndex:-1];
}
- (BOOL)checkMemberAlreadyExistInGroupList:(NSArray*)memArr aMember:(MyAddressBook*)aMember
{
    for (GroupMemberList *amem in memArr)
    {
        if ([amem.memRecordID isEqualToString:aMember.recordID])
        {
            return YES;
            break;
        }
    }
    return NO;
}
#pragma mark - Searching methods
- (void)searchContactWithtextField:(UITextField*)textField
{
    
//    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
    {
        NSString *_mySearchKey = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSPredicate *_myPredicate = [NSPredicate predicateWithFormat:@"(firstName CONTAINS[cd] %@) OR (lastName CONTAINS[cd] %@) OR (middleName CONTAINS[cd] %@)", _mySearchKey, _mySearchKey, _mySearchKey];
        
        if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0)
        {
            _myPredicate = nil;
        }
        NSArray *copyitemsearch = [CoreDataHelper searchObjectsForEntity:@"MyAddressBook" withPredicate:_myPredicate andSortKey:@"firstName" andSortAscending:YES andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        
        
//        if ([copyitemsearch count] >0)
        {
            self.arrContacts = [NSMutableArray arrayWithArray:copyitemsearch];
            [tblContactList reloadData];
        }
        
    }
//    [textField resignFirstResponder];
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    
    [tblContactList reloadData];
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(searchContactWithtextField:) withObject:textField afterDelay:0.01];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark - tableView DataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([txtfSearch isFirstResponder])
    [txtfSearch resignFirstResponder];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
//    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    return [self.arrContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyAddressBook *aContact = [self.arrContacts objectAtIndex:indexPath.row];
    
    if ([Global GetSalePipelineFlag])
    {
        static NSString *CellIdentifier = @"SaleContactListTVCell";
        SaleContactListTVCell* cell = nil;
        cell = (SaleContactListTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // NSLog(@"%@",self.arrHistoryData);
        // NSLog(@"%@",objHis);
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SaleContactListTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[SaleContactListTVCell class]])
                {
                    
                    cell = (SaleContactListTVCell*)currentObject;
                    
                }
            }
        }
        [cell SetContactInfo:aContact atIndexPath:indexPath];
        [cell setSelectedStage];
        [cell.btnCheck addTarget:self action:@selector(btnCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheck setTag:indexPath.row];
        
        
        [cell.btnEditContact addTarget:self action:@selector(btnEditContact:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEditContact setTag:indexPath.row];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"ContactListTVCell";
        ContactListTVCell* cell = nil;
        cell = (ContactListTVCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // NSLog(@"%@",self.arrHistoryData);
        // NSLog(@"%@",objHis);
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ContactListTVCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                
                if([currentObject isKindOfClass:[ContactListTVCell class]])
                {
                    
                    cell = (ContactListTVCell*)currentObject;
                    
                }
            }
        }
        [cell updateUITableViewCellWithContact:aContact withIndexPath:indexPath];
        [cell.btnCheck addTarget:self action:@selector(btnCheckTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnCheck setTag:indexPath.row];
        
        
        [cell.btnEditContact addTarget:self action:@selector(btnEditContact:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnEditContact setTag:indexPath.row];
        return cell;
    }
    
    
    
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GlobalDataPersistence *GDP = [GlobalDataPersistence sharedGlobalDataPersistence];
    MyAddressBook *aContact = [self.arrContacts objectAtIndex:indexPath.row];
    if (self.aDelegate && [self.aDelegate respondsToSelector:@selector(changeNavigationTitle)])
    {
        [self.aDelegate changeNavigationTitle];
    }
    ContactDetailViewController *obj = [[ContactDetailViewController alloc]initWithNibName:@"ContactDetailViewController" bundle:nil];
    [obj setAContactDetails:aContact];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Flurry
	NSString * name = [NSString  stringWithFormat:@"Contact%@%@",(aContact.firstName)?(aContact.firstName):@"name",(aContact.lastName)?(aContact.lastName):@"LastName"];
	NSDictionary * dict = [NSDictionary dictionaryWithObject:name forKey:@"nameSelected"];
	[AppDelegate setFlurryWithText:@"Contact View table didselect" andParms:dict];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.editItemTag = indexPath.row;
        
        UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
        [anAlertView setTag:1001];
        [anAlertView show];
        [anAlertView release];
        //add code here for when you hit delete
    }
}
#pragma mark - AddNewContactViewController Delegate
- (void)refreshContactList
{
    self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
    [tblContactList reloadData];
}
#pragma mark - IBAction Methods

-(IBAction)btnAddNewContact:(id)sender
{
    //Flurry
	UIButton * btn = (UIButton*)sender;

    if ([btn.titleLabel.text rangeOfString:@"Done" options:NSCaseInsensitiveSearch].length)
    {
        [Global SaveSalePipelineFlag:NO];
        [btnAddNew setTitle:@"Add New" forState:UIControlStateNormal];
        [tblContactList reloadData];
    }
    else
    {
        NSString * string = [NSString stringWithFormat:@"Contact View %@",btn.titleLabel.text];
        [AppDelegate setFlurryWithText:string];
        
        AddNewContactViewController * addNewVC = [[AddNewContactViewController alloc]initWithNibName:@"AddNewContactViewController" bundle:nil];
        [addNewVC setADelegate:self];
        [self.navigationController pushViewController:addNewVC animated:YES];
        [addNewVC release];
    }
}

-(IBAction)btnDeleteAllContact:(id)sender
{
    UIAlertView *anAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure you want to delete all contacts?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
    [anAlertView setTag:1002];
    [anAlertView show];
    [anAlertView release];
  
}
- (void)btnCheckTapped:(UIButton*)sender
{
    MyAddressBook *aContact= [self.arrContacts objectAtIndex:sender.tag];
    
    if(sender.selected)
    {
        sender.selected = !sender.selected;
        aContact.isSelected = sender.selected;
    }
    else
    {
        sender.selected = !sender.selected;
        aContact.isSelected = sender.selected;
    }

    [self.arrContacts replaceObjectAtIndex:sender.tag withObject:aContact];
    
}
- (void)btnEditContact:(UIButton*)sender
{
    //Flurry
	NSString * string = [NSString stringWithFormat:@"Contact Details Edit Button"];
	[AppDelegate setFlurryWithText:string];
    
    MyAddressBook *myobj = [self.arrContacts objectAtIndex:sender.tag];
    AddNewContactViewController * addNewVC = [[AddNewContactViewController alloc]initWithNibName:@"AddNewContactViewController" bundle:nil];
    [addNewVC setADelegate:self];
    [addNewVC setEditMyAddObj:myobj];
	[self.navigationController pushViewController:addNewVC animated:YES];
	[addNewVC release];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1001 && buttonIndex == 0)
    {
        //Flurry
        [AppDelegate setFlurryWithText:@"Contact view Delete Recored"];
        
        MyAddressBook *aContact = [self.arrContacts objectAtIndex:self.editItemTag];
        
        [ABContactsHelper removePersonFrom_iPadAddressBook:aContact]; //delete from iPad address book
        
        [((AppDelegate*)CRM_AppDelegate).managedObjectContext deleteObject:aContact]; //delete from application addressbook
        
        if([((AppDelegate*)CRM_AppDelegate).managedObjectContext save:nil])
        {
            
        }
        
        self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        [tblContactList reloadData];
        
        self.editItemTag = nil;
    }
    if (alertView.tag == 1002 && buttonIndex == 0)
    {
        BOOL isSuccess =  [CoreDataHelper deleteAllObjectsForEntity:@"MyAddressBook" andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        if (isSuccess)
        {
            //Flurry
//            UIButton * btn = (UIButton*)sender;
            NSString * string = [NSString stringWithFormat:@"Contact View %@",@"Delete All"];
            [AppDelegate setFlurryWithText:string];
            self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
            
            [tblContactList reloadData];
        }
        NSLog(@"%d",isSuccess);
    }
    if (alertView.tag == 1000 && buttonIndex == 0)
    {
        self.arrContacts = [CoreDataHelper getObjectsForEntity:@"MyAddressBook" withSortKey:nil andSortAscending:NO andContext:((AppDelegate*)CRM_AppDelegate).managedObjectContext];
        
        if ([arrContacts count] <= 0)
        {
            [SVProgressHUD showWithStatus:@"Importing your address book"];
            
            [self performSelector:@selector(loadContactList) withObject:nil afterDelay:0.1];
        }
        else
        {
            [tblContactList reloadData];
        }
    }
    if (alertView.tag == 1003)
    {
        if (buttonIndex == 0)
        {
            [Global SaveSalePipelineFlag:YES];
            [btnAddNew setTitle:@"Done" forState:UIControlStateNormal];
        }
        else
        {
            [Global SaveSalePipelineFlag:NO];
        }
        [tblContactList reloadData];
    }
}
@end
