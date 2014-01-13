//
//  TourViewController.h
//  CRM
//
//  Created by Sheetal's iMac on 04/03/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <MediaPlayer/MediaPlayer.h>
@interface TourViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIView *view_top_option;
    IBOutlet UIView *view_for_option;
//    IBOutlet UITableView *tblContactList;
    
    IBOutlet UIButton *btnTakeTour;
//    IBOutlet UIButton *btnSort;
    IBOutlet UIButton *btnVedio;
    IBOutlet UIButton *btnSupport;
    IBOutlet UIImageView *imgVwOptionbar;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    IBOutlet UIWebView *aWebview;
    IBOutlet iCarousel *iCarouselView;
    
     MPMoviePlayerController *player;
}
@property (nonatomic , assign) int  currentOrientation;
@property (nonatomic , assign) BOOL shouldStopTour;
@property (nonatomic , retain) NSMutableArray *arrContacts;
- (IBAction)btnTourTapped:(id)sender;
//- (IBAction)btnSortTapped:(id)sender;
- (IBAction)btnVedioTapped:(id)sender;
- (IBAction)btnSupportTapped:(id)sender;

@end
