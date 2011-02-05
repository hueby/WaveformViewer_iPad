//
//  DetailViewController.m
//  WaveformViewer_iPad
//
//  Created by Dennis Hübner on 27.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "VariableNode.h"
#import "SignalNode.h"
#import "ModuleNode.h"
#import "Draw2D.h"


@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end


@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, scroller, tbl, data, toolbarLabel;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView {
    // Update the user interface for the detail item.
    detailDescriptionLabel.text = [detailItem description];  
	 
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	CGFloat screensize_width = 2048;
	CGFloat screensize_height = 1024;
	
	[tbl setFrame:CGRectMake(0, 22, screensize_width, screensize_height)];
	[scroller setContentSize:CGSizeMake(screensize_width, screensize_height)];

	[toolbarLabel setText:[[data objectAtIndex:0] name]];

	[super viewDidLoad];
}
 

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Table View management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [data count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
		return [[NSString alloc] initWithFormat:@"Module %@", [[data objectAtIndex:0] name]]; 	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
		NSInteger counter = 0;
		int modulePosition = 0;
		
		for (int i = 0; i < [[[data objectAtIndex:modulePosition] variables] count]; i++) {
			counter++;
			if ([[[[data objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray]) {
				//for (int y = 0; y < [[[[[data objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray] count]; y++) {
				//	counter++;
				//}
			}
		}
		NSLog(@"numberOfRows: %i", counter);
		return counter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
	int modulePosition = 0;
	//BOOL arrayVariableIsFinished = NO;
		
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
		
		NSMutableArray* varArray = [[data objectAtIndex:modulePosition] variables];
		VariableNode* variable = [varArray objectAtIndex:countVariables];
		
		if([variable signals]) {
			NSLog(@"hier true");
			Draw2D *drawSignal = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			
			NSMutableArray *collectedSignal = [[NSMutableArray alloc] initWithCapacity:1];
			[collectedSignal addObject:[variable signals]];
			
			[drawSignal setSignals:collectedSignal];
			[drawSignal setNameOfSignal:[variable varName]];
			[cell setBackgroundView:drawSignal];
			countVariables++;
		
		} else {
		
			NSLog(@"hier false");
			
			Draw2D *drawSignal = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			NSLog(@"%@", [variable varName]);
			//AV = ArrayVariable
			NSMutableArray *collectedAVSignals = [[NSMutableArray alloc] initWithCapacity:1];
			for(countArrayVariables = 0; countArrayVariables < [[variable varArray] count]; countArrayVariables++) {
				[collectedAVSignals addObject:[[[variable varArray] objectAtIndex:countArrayVariables] signals]];
			}
			
			[drawSignal setSignals:collectedAVSignals];
			[cell setBackgroundView:drawSignal];
			countVariables++;

		}

		
		
		/*
		if ([variable varArray] == nil) {
			//mache was fuer normale variablen
			
			if (count < [varArray count]) {
				
				Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
								
				[draw setSignals:[variable signals]];
				[draw setNameOfSignal:[variable varName]];
				
				[cell setBackgroundView:draw];
				
				count++;
			}
		} else {
			//mache was fuer array variablen
			NSLog(@"was fuer AVs");
			NSMutableArray* arrayVariableArray = [variable varArray];
			if ([variable symbol] == nil) {
				
				if (countArrayVariables < [arrayVariableArray count] && arrayVariableArray) {
					
					Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
					for (int i = 0; i < [arrayVariableArray count]; i++) { 						
						VariableNode* arrayVariable = [arrayVariableArray objectAtIndex:i];
						[draw setSignals:[arrayVariable signals]];
						[draw setNameOfSignal:[arrayVariable varName]];
						NSLog(@"%@ und %i", [arrayVariable varName], [arrayVariableArray count]);
						//countArrayVariables++;
					}
					[cell setBackgroundView:draw];
				} else {
					countArrayVariables = 0;
					arrayVariableIsFinished = YES;
				}
			}
		}
		
		if (arrayVariableIsFinished) {
			count++;
		}
		*/
		[[cell backgroundView] setBackgroundColor:[UIColor whiteColor]];
		[[cell selectedBackgroundView] setBackgroundColor:[UIColor orangeColor]];
		
		
		
	} // Configure the cell. 
	return cell;
}

#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [detailDescriptionLabel release];
    [super dealloc];
}

@end
