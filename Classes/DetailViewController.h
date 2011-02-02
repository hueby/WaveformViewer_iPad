//
//  DetailViewController.h
//  WaveformViewer_iPad
//
//  Created by Dennis Hübner on 27.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
	IBOutlet UIScrollView *scroller;
	IBOutlet UITableView *tbl;
	
    id detailItem;
    UILabel *detailDescriptionLabel;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UITableView *tbl;


@end
