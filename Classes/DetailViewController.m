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
	NSLog(@"viewDidLoad in DVC");
	CGFloat screensize_width = 2048;
	CGFloat screensize_height = 768;
	
	[tbl setFrame:CGRectMake(0, 0, screensize_width, screensize_height)];
	NSLog(@"tbl set");
	[scroller setContentSize:CGSizeMake(screensize_width, screensize_height)];
	NSLog(@"scroller set");
	//if (data != nil) {
		[toolbarLabel setText:[[data objectAtIndex:0] name]];
		NSLog(@"%@", [[data objectAtIndex:0] name]);

	//}
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
	NSLog(@"XD");
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
				for (int y = 0; y < [[[[[data objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray] count]; y++) {
					counter++;
				}
			}
		}
		NSLog(@"numberOfRows: %i", counter);
		return counter-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
	int modulePosition = 0;
	BOOL arrayVariableIsFinished = NO;
		
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
		
		NSMutableArray* varArray = [[data objectAtIndex:modulePosition] variables];
		VariableNode* variable = [varArray objectAtIndex:count];
		
		NSLog(@"Versuche Variable %@ mit Symbol %@ zu zeichnen", [variable varName], [variable symbol]);
		
		if ([variable varArray] == nil) {
			//mache was fuer normale variablen
			
			if (count < [varArray count]) {
				
				Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
				
				NSLog(@"ZEICHNE Variable %@ mit Symbol%@", [variable varName], [variable symbol]);
				
				[draw setSignals:[variable signals]];
				[draw setNameOfSignal:[variable varName]];
				
				[cell setBackgroundView:draw];
				
				count++;
				NSLog(@"drew auf yes");
			}
		} else {
			//mache was fuer array variablen
			NSMutableArray* arrayVariableArray = [variable varArray];
			if ([variable symbol] == nil) {
				
				NSLog(@"Versuche AVariable %@ mit Symbol %@ zu zeichnen", [variable varName], [variable symbol]);

				if (countArrayVariables < [arrayVariableArray count] && arrayVariableArray) {
					VariableNode* arrayVariable = [arrayVariableArray objectAtIndex:countArrayVariables];

					Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
				
					NSLog(@"ZEICHNE Variable %@ mit Symbol%@", [arrayVariable varName], [arrayVariable symbol]);

					[draw setSignals:[arrayVariable signals]];
					[draw setNameOfSignal:[arrayVariable varName]];
				
					[cell setBackgroundView:draw];
					countArrayVariables++;

				} else {
					countArrayVariables = 0;
					arrayVariableIsFinished = YES;
				}
			}
		}
		
		if (arrayVariableIsFinished) {
			count++;
		}
		
		/*
		if (moduleArray != nil && count < [[[moduleArray objectAtIndex:modulePosition] variables] count]) {
			
			Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			Draw2D* drawSelected = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	
			NSLog(@"VarName der variable: %@",[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] varName]);

			if ([[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] signals]) {
				NSLog(@"in der if");
				[draw setSignals:[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] signals]];
				[drawSelected setSignals:[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] signals]];
				
				[cell drawRect:CGRectMake(0, 0, 0, 0)];
				
				[cell setBackgroundView:draw];
				[cell setSelectedBackgroundView:drawSelected];
				count++;
				NSLog(@"count in if: %i", count);
			} else {	
				NSLog(@"in der else");
				//NSMutableArray * varArrayFromVariableNode = [variable varArray];
				if (countArrayVariables < [[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] varArray] count]) { 
					
					NSLog(@"countArrayVariables %i und Laenge von varArray %i", countArrayVariables, [[[[[moduleArray objectAtIndex:modulePosition] 
																											variables] objectAtIndex:count] 
																											varArray] count]);
					
					VariableNode *arrayVariable = [[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] 
														varArray] objectAtIndex:countArrayVariables];
			
					[draw setSignals:[arrayVariable signals]];
					[drawSelected setSignals:[arrayVariable signals]];
					
					[cell drawRect:CGRectMake(0, 0, 0, 0)];

					[cell setBackgroundView:draw];
					[cell setSelectedBackgroundView:drawSelected];
					countArrayVariables++;
					NSLog(@"count in if unten: %i", countArrayVariables);

					
				} else {
					NSLog(@"hier ist %i und count = %i", countArrayVariables, count);
					countArrayVariables = 0;
					NSLog(@"UND DANN IST DER COUNTER 0");
					count++;
				}
				NSLog(@"ganz unten");
			}
		} else {
			[cell setText:@"Array empty.."];
			//cell.selectedBackgroundView = [[[Draw2D alloc] init] autorelease]; 
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
