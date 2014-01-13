//
//  DropDownTableView.m
//  iDataNexus
//
//  Created by Rahul Sharma on 15/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DropDownTableView.h"
#import <QuartzCore/QuartzCore.h>

//Constants
#define kTableViewHeight 100

@implementation DropDownTableView

@synthesize target;
@synthesize arrDataSource;


- (id)initWithDelegate:(id)caller dataSource:(NSArray*)array frame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		self.arrDataSource = array;
		
		self.target = caller;
        
//        UIView *tblBgVw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 20, kTableViewHeight)];
//        
//        UIImageView* tbBgImg = [[UIImageView alloc]initWithFrame:tblBgVw.frame];
//        [tbBgImg setImage:[UIImage imageNamed:@"dropdown_bg.png"]];
//        
//        [tblBgVw addSubview:tbBgImg];
//        [tbBgImg release];
		
		tblvDropDown = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 20, kTableViewHeight) style:UITableViewStylePlain];
        [tblvDropDown setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
//		[[tblvDropDown layer] setCornerRadius:8.0];
//		[[tblvDropDown layer] setBorderColor:[UIColor grayColor].CGColor];
		[tblvDropDown setBackgroundColor:[UIColor clearColor]];
        [tblvDropDown setOpaque:NO];
		tblvDropDown.delegate = self;
		tblvDropDown.dataSource = self;
		[tblvDropDown setHidden:YES];
		[tblvDropDown setScrollEnabled:YES];
		[tblvDropDown setShowsVerticalScrollIndicator:YES];
      //  [tblvDropDown setBackgroundView:tblBgVw];
		[self addSubview:tblvDropDown];
      //  [tblBgVw release];
    
	}
    return self;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if([self.arrDataSource count] > 0)
		return [self.arrDataSource count];
	else
		return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
	
	if([self.arrDataSource count]>0)
	{
		if(selectedDropDownIndex == indexPath.row)
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		else {
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
		
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
		[cell.textLabel setText:[self.arrDataSource objectAtIndex:indexPath.row]];
	}
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	if([self.arrDataSource count] >0) {
		cell = [tableView cellForRowAtIndexPath:indexPathPreviousSelected];
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		
		indexPathPreviousSelected = indexPath;
		
		cell = [tableView cellForRowAtIndexPath:indexPathPreviousSelected];
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	selectedDropDownIndex = indexPath.row;
	[tableView setHidden:YES];
	if (self.target && [self.target respondsToSelector:@selector(didSelectRow:inDataSource:)]) {
		[self.target didSelectRow:indexPath.row inDataSource:self.arrDataSource];
	}
}

-(void)animateTableview:(TableViewShowDirection)direction atPoint:(CGPoint)point{
	if (direction == kTableViewDirectionDown) {
		[tblvDropDown setHidden:NO];	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		/*[tblvDropDown setFrame:CGRectMake(point.x,point.y, tblvDropDown.frame.size.width,
								    kTableViewHeight)];	*/
		
		[UIView commitAnimations];		
	}
	
}

- (void)dealloc {
	[arrDataSource release];
	[target release];
    [super dealloc];
}


@end
