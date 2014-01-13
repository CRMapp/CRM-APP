//
//  TouchView.m
//  CRM
//
//  Created by Sheetal's iMac on 01/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView
@synthesize Delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    if(self.Delegate && [self.Delegate respondsToSelector:@selector(touchesDown:)])
	{
		[self.Delegate performSelector:@selector(touchesDown:) withObject:touches];
	}
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(self.Delegate && [self.Delegate respondsToSelector:@selector(touchesUp:)])
	{
		[self.Delegate performSelector:@selector(touchesUp:) withObject:touches];
    }
    //[imagetile setBackgroundColor:[UIColor clearColor]];
    
    
    
}
@end
