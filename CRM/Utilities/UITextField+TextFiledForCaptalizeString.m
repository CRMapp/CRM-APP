//
//  UITextField+TextFiledForCaptalizeString.m
//  CRM
//
//  Created by Narendra Verma on 26/04/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "UITextField+TextFiledForCaptalizeString.h"

@implementation UITextField (TextFiledForCaptalizeString)


- (void)setAutocapitalizationType:(UITextAutocapitalizationType)type
{
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

@end
