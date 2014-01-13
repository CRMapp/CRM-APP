//
//  LeftOptionView.m
//  CRM
//
//  Created by Sheetal's iMac on 04/02/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "LeftOptionView.h"
#import "HomeViewController.h"
@implementation LeftOptionView
@synthesize mainController;
@synthesize selectedOption;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(IBAction)btnLeftOption_Tapped:(UIButton*)sender
{

//    if (self.selectedOption != sender.tag)
//    {
    if (sender.tag != 5)
    {
        [self resetAllOptions];
        sender.selected = !sender.selected;
    }
    
        [self.mainController.rightDetailView changeViewForOption:sender.tag];
//        self.selectedOption = sender.tag;
//    }
    
}
-(void)resetAllOptions
{
    [btnDashBoard setSelected:NO];
    [btnContact setSelected:NO];
    [btnMap setSelected:NO];
    [btnGraph setSelected:NO];
    [btnTour setSelected:NO];
    [btnFeedback setSelected:NO];
}
- (void)dealloc
{
    [btnDashBoard release];
    [btnContact release];
    [btnMap release];
    [btnGraph release];
    [btnTour release];
    [btnFeedback release];
    
    [mainController release];
    mainController = nil;
    
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
