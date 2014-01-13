//
//  DropDownView.m
//  iDataNexus
//
//  Created by Rahul Sharma on 06/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"
#import <QuartzCore/QuartzCore.h>
#import "CRMConfig.h"
//App Delegate
//#import "AppDelegate.h"

@implementation DropDownView

//@synthesize selectedAlertField;
@synthesize target;
@synthesize myDataarray,tagValue,myLabel;
@synthesize selectedIndex,strDropDownValue;
@synthesize DDType;

#define kClearColor [UIColor clearColor]


- (id)initWithFrame:(CGRect)frame target:(id)caller{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.target = caller;
		[self setBackgroundColor:kClearColor];
        
		[self setClipsToBounds:YES];
		[self setAutoresizesSubviews:YES];
		
		//Addding the dropDownImage
		UIImageView* imgvBgDropDown = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    frame.size.width ,
                                                                                    frame.size.height)];
		[imgvBgDropDown setBackgroundColor:kClearColor];
		
        
        
//		NSString* imagePath = [((AppDelegate*)CRM_AppDelegate) resourcePathForFile:@"map-textbox.png"];
//		UIImage* img = [[UIImage alloc] initWithContentsOfFile:imagePath];
//		
//		[imgvBgDropDown setImage:img];
//		[img release];
//		[imgvBgDropDown setContentMode:UIViewContentModeScaleToFill];
        
		[self addSubview:imgvBgDropDown];
		[imgvBgDropDown release];
		
		//Adding the label  isFromPostComment
        
        BOOL isFromGetCountry = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFromGetCountry"];
        BOOL isFromCategory = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFromGetCategory"];
        BOOL isFromPostComment = [[NSUserDefaults standardUserDefaults]boolForKey:@"isFromPostComment"];
		myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                            4,
                                                            frame.size.width - 50,
                                                            frame.size.height - 8)];
		[myLabel setTextAlignment:UITextAlignmentLeft];
		[myLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0f]];
		[myLabel setTextColor:[UIColor lightGrayColor]];
        if (isFromCategory)
        {
            [myLabel setText:@"Category Professional"];
        }
        else if (isFromGetCountry)
        {
            [myLabel setText:@"Country"];
        }else if (isFromPostComment)
        {
            [myLabel setText:@"Category"];
        }

        [myLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:myLabel];
        self.strDropDownValue = myLabel.text;
		[myLabel release];
        
		
		//Adding the Button
		
		UIButton* btnDropDown = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnDropDown setFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
		[btnDropDown setBackgroundColor:[UIColor clearColor]];
//        [btnDropDown setBackgroundColor:[UIColor greenColor]];
		[btnDropDown addTarget:self action:@selector(openDropDown) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:btnDropDown];
    }
    return self;
}

#pragma mark -

-(void)setDataArray:(NSArray*)dataArray
{
	self.myDataarray = dataArray;
}

-(void)setSelectedIndex:(int)index
{
    selectedIndex = index;
//    NSLog(@" %d %@",myDataarray.count,myDataarray);
//    NSLog(@"%d",selectedIndex);
	if(selectedIndex<myDataarray.count && myDataarray)
	{
		
        [myLabel setTextColor:[UIColor blackColor]];
        if(selectedIndex >=0)
        {
		myLabel.text = [myDataarray objectAtIndex:index];
        }
        else
        {
            [myLabel setTextColor:[UIColor lightGrayColor]];
        }
	}
    
	if(myTableView)
	{
		[myTableView reloadData];
	}
}

-(void)openDropDown
{
    //UIButton *btn = (UIButton*)sender;
    //int index = btn.tag;
    
   // NSLog(@"%d",index);
    
	if (target && [target respondsToSelector:@selector(openDropDown:)]) {
		[target performSelector:@selector(openDropDown:)];
	}
	//NSLog(NSStringFromCGRect([self.superview frame]));
	if(myDataarray.count>0 && myDataarray)
	{
		CGRect selfTableFrame = self.frame;
        NSLog(@"tablefram %@",(NSStringFromCGRect(selfTableFrame)));
		//selfTableFrame.origin.x = 0;
		selfTableFrame.origin.y += self.frame.size.height;
		selfTableFrame.size.height = 30*[myDataarray count];
		
        NSLog(@"%f",selfTableFrame.size.height);
        NSLog(@"%f",selfTableFrame.origin.y);
		
		
		//CGRect windawRact=((iDataNexusAppDelegate*)AppDelegate).window.frame;
        NSLog(@"tablefram1 %@",(NSStringFromCGRect(selfTableFrame)));
        NSLog(@"superview %@",NSStringFromCGRect([self.superview frame]));
		if(selfTableFrame.origin.y+selfTableFrame.size.height+self.superview.frame.origin.y>self.superview.frame.origin.y+self.superview.frame.size.height)
		{
			NSLog(@"%@",NSStringFromCGRect([self.superview frame]));
			NSLog(@"tablefram2 %@",(NSStringFromCGRect(selfTableFrame)));
			selfTableFrame.size.height = 30*[myDataarray count];
            if (selfTableFrame.size.height>170) {
                selfTableFrame.size.height=100;
            }
            NSLog(@"%f",self.frame.origin.y);
            NSLog(@"%f",selfTableFrame.size.height);
		}
        if (selfTableFrame.size.height<100) {
            
            selfTableFrame.size.height=30*[myDataarray count];
        }
        
        else if(selfTableFrame.size.height>100){
            selfTableFrame.size.height=100;
            
        }
        
        if (self.superview.frame.size.height-selfTableFrame.origin.y < selfTableFrame.size.height) {
            selfTableFrame.origin.y = selfTableFrame.origin.y-selfTableFrame.size.height-28;
        }
//        UIView *tblBgVw = [[UIView alloc]initWithFrame:selfTableFrame];
//        UIImageView* tbBgImg = [[UIImageView alloc]initWithFrame:tblBgVw.frame];
//        [tbBgImg setImage:[UIImage imageNamed:@"dropdown_bg.png"]];
//        
//        [tblBgVw addSubview:tbBgImg];
//        [tbBgImg release];
        
		myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(selfTableFrame.origin.x-2,selfTableFrame.origin.y+4,selfTableFrame.size.width-2,selfTableFrame.size.height) style:UITableViewStylePlain]autorelease];
        
        //COMMENT THESE LINES TO STOP AUTORESIZING
        [myTableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
        
        
		myTableView.backgroundColor = [UIColor whiteColor];
        myTableView.opaque = NO;
		myTableView.dataSource = self;
		myTableView.delegate = self;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		//[myTableView setBackgroundView:tblBgVw];
		[[myTableView layer] setCornerRadius:8];
		[[myTableView layer] setBorderWidth:.2];
		[[myTableView layer] setBorderColor:[UIColor blackColor].CGColor];
		[[myTableView layer] setMasksToBounds:YES];
		CGRect selfTableContainer = self.superview.frame;
		selfTableContainer.origin.x = 0;
		selfTableContainer.origin.y = 0;
		
		myContainerView = [[[DropdownContainer alloc] initWithFrame:CGRectMake(selfTableContainer.origin.x,selfTableContainer.origin.y,selfTableContainer.size.width,selfTableContainer.size.height+10)]autorelease];
		myContainerView.delegate = self;
        
        //COMMENT THESE LINES TO STOP AUTORESIZING
        [myContainerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        
		myContainerView.backgroundColor = [UIColor clearColor];
        
        UIImageView* tbBgImg = [[[UIImageView alloc]initWithFrame:CGRectMake(selfTableFrame.origin.x-4,selfTableFrame.origin.y-2,selfTableFrame.size.width+8,selfTableFrame.size.height+12)]autorelease];
//        [tbBgImg setImage:[UIImage imageNamed:@"dropdown_bg.png"]];
        
        
        //COMMENT THESE LINES TO STOP AUTORESIZING
        [tbBgImg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
        
        
        [myContainerView addSubview:tbBgImg];
		[self.superview addSubview:myContainerView];
		
		[myContainerView addSubview:myTableView];
	}
}


-(void)closeTableView
{
	[myContainerView removeFromSuperview];
	myContainerView = nil;
	myTableView = nil;
	self.strDropDownValue = myLabel.text;
	if([target respondsToSelector:@selector(didSelectIndex:ForDropDown:)])
	{
		[target performSelector:@selector(didSelectIndex:ForDropDown:) withObject:(id)selectedIndex withObject:self];
	}
//    NSLog(@"%@",myLabel.text);
    
}


#pragma mark UITableView dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if(cell==nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"]autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
//	if(selectedIndex!=-1 && selectedIndex==indexPath.row)
//	{
//		cell.accessoryType = UITableViewCellAccessoryCheckmark;
//	}
//	else 
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = [myDataarray objectAtIndex:indexPath.row];
	//[cell.textLabel setAdjustsFontSizeToFitWidth:YES];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
	[cell.textLabel setTextColor:[UIColor darkGrayColor]];

	
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return myDataarray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	return 30;
}

#pragma mark -

#pragma mark UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self setSelectedIndex:indexPath.row];
	[self closeTableView];
}

#pragma mark -

- (void)dealloc {
	[myLabel release];
	//id tagValue = (id)self.tag;
	//if([tagValue respondsToSelector:@selector(release)])[tagValue performSelector:@selector(release)];
	
	[myDataarray release];
    [super dealloc];
}


@end

@implementation DropdownContainer
@synthesize delegate;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[delegate performSelector:@selector(closeTableView)];
}

@end

