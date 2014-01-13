//
//  ViewProductTVCell.h
//  CRM
//
//  Created by Sheetal's iMac on 11/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewProductTVCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblProductName;
@property (retain, nonatomic) IBOutlet UIButton *btnEditProduct;
@property (retain, nonatomic) IBOutlet UIButton *btnDeleteProduct;
@property (retain, nonatomic) IBOutlet UILabel *lblDesc;

@end
