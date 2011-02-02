//
//  RootViewController.h
//  WaveformViewer_iPad
//
//  Created by Dennis Hübner on 27.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	
	NSMutableArray *moduleArray;
	NSMutableArray *signalArray;
	int count;
	int countArrayVariables;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UITableView *tbl;

@property (nonatomic, retain) NSMutableArray *moduleArray;
@property (nonatomic, retain) NSMutableArray *signalArray;

@end
