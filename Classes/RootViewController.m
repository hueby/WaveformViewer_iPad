//
//  RootViewController.m
//  WaveformViewer_iPad
//
//  Created by Dennis Hübner on 27.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Draw2D.h"
#import "Parser.h"
#import	"ModuleNode.h"
#import	"SignalNode.h"
#import "VariableNode.h"


@implementation RootViewController

@synthesize detailViewController;

@synthesize scroller;
@synthesize moduleArray;
@synthesize tbl;
@synthesize signalArray;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    count = 0;
	countArrayVariables = 0;
	
	/*
	CGFloat screensize_width = 2048;
	CGFloat screensize_height = 768;
	[tbl setFrame:CGRectMake(0, 0, screensize_width, screensize_height)];
	
	//TODO make this dynamic..
	[scroller setContentSize:CGSizeMake(screensize_width, screensize_height)];
	*/
	
	//NSString *path = @"/var/mobile/Applications/65134CBB-CBD0-4BA6-B6BC-EFB16BBFF600/Draw_iPad.app/simple.vcd";
	NSString *path = @"/Users/dennis/Downloads/simple.vcd";
	
	Parser *parse = [[Parser alloc] init];
	if ([parse parseFile:path]) {
		//[self setSignalArray:[parse searchForSymbolInDatastructure:@"$"]];
		[self setModuleArray:[parse data]];
		//[self setVariableArray:[[moduleArray objectAtIndex:0] variables]];
	} else {
		NSLog(@"FAIL");
	}
	
	[super viewDidLoad];
    [self setTitle:@"Waveform Viewer"];
	
	//[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
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

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
	return [moduleArray count];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    	NSInteger counter = 0;
		int modulePosition = 0;
		
		for (int i = 0; i < [[[moduleArray objectAtIndex:modulePosition] variables] count]; i++) {
			counter++;
			/*
			if ([[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray]) {
				for (int y = 0; y < [[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray] count]; y++) {
					counter++;
				}
			}*/
		}
		NSLog(@"numberOfRows: %i", counter);
		return counter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
	//cell.accessoryType = UITableViewCellAccessoryCheckmark;

	cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [[[[moduleArray objectAtIndex:0] variables] objectAtIndex:[indexPath row]] varName]];
	

	return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
	
	//Set one checkmark at one touch on random row
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if ([[aTableView cellForRowAtIndexPath:indexPath] accessoryType] == UITableViewCellAccessoryCheckmark) {
		[[aTableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
	} else {
		[[aTableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
	}

	
    detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
	NSLog(@"%@", [NSString stringWithFormat:@"Row %d", indexPath.row]);
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [detailViewController release];
    [super dealloc];
}

#pragma mark uitouch


//Handling a single-tap gesture and a double-tap gesture
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//  Created by Skylar Cantu on 1/25/09.
	//  Copyright __MyCompanyName__ 2009. All rights reserved.
	[super touchesBegan:touches withEvent:event];
	
	NSArray *allTouches = [touches allObjects]; 
	UITouch *touch = [touches anyObject];
	
	int count = [allTouches count];
	
	if (count == 1) {
		if ([touch tapCount] < 2) {
		/*	if (CGRectContainsPoint([/*beachBall*/ /* frame], [[allTouches objectAtIndex:0] locationInView:self.view])) {
				[UIView beginAnimations:@"TouchDownAnimation" context:NULL];
				[UIView setAnimationBeginsFromCurrentState:YES];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(finishedTouchDownAnimation:finished:context:)];
				[UIView setAnimationCurve:UIViewAnimationCurveLinear];
				[UIView setAnimationDuration:0.25];
				CGAffineTransform transform = CGAffineTransformMakeScale(1.1, 1.1);
				//beachBall.transform = transform;
				//beachBall.alpha = 0.85;
				[UIView commitAnimations];
			}*/
		}
	}
	
	if (count > 1) {
		touch1 = [[allTouches objectAtIndex:0] locationInView:self.view]; 
		touch2 = [[allTouches objectAtIndex:1] locationInView:self.view];
		NSLog(@"Multitouch begins");
	}
	
	/*	
	 if(aTouch.tapCount == 2) {
	 [NSObject cancelPreviousPerformRequestsWithTarget:self];
	 NSLog(@"Multitouch begins");
	 }*/
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	//  Created by Skylar Cantu on 1/25/09.
	//  Copyright __MyCompanyName__ 2009. All rights reserved.
	[super touchesMoved:touches withEvent:event];
	
	CGPoint currentTouch1;
	CGPoint currentTouch2;
	
	NSArray *allTouches = [touches allObjects]; 
	int count = [allTouches count]; 
	
	if (count == 1) {
		/*	if (CGRectContainsPoint([beachBall frame], [[allTouches objectAtIndex:0] locationInView:self.view])) {
		 beachBall.center = [[allTouches objectAtIndex:0] locationInView:self.view];
		 return;
		 }*/
	}
	
	if (count > 1) {
		/*if ((CGRectContainsPoint([beachBall frame], [[allTouches objectAtIndex:0] locationInView:self.view])) ||
		 (CGRectContainsPoint([beachBall frame], [[allTouches objectAtIndex:1] locationInView:self.view]))) {
		 
		 currentTouch1 = [[allTouches objectAtIndex:0] locationInView:self.view]; 
		 currentTouch2 = [[allTouches objectAtIndex:1] locationInView:self.view];
		 
		 CGFloat previousAngle = atan2(touch2.y - touch1.y, touch2.x - touch1.x) * 180 / M_PI;
		 CGFloat currentAngle = atan2(currentTouch2.y - currentTouch1.y,currentTouch2.x - currentTouch1.x) * 180 / M_PI;
		 
		 CGFloat angleToRotate = currentAngle - previousAngle;
		 
		 CGAffineTransform transform = CGAffineTransformRotate(beachBall.transform, degreesToRadians(angleToRotate));
		 
		 beachBall.transform = transform;
		 touch1 = currentTouch1;
		 touch2 = currentTouch2;
		 }*/
		
	}
}



-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *theTouch = [touches anyObject];
	if (theTouch.tapCount == 1) {
		NSDictionary *touchLoc = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:[theTouch locationInView:self]] forKey:@"location"];
		[self performSelector: @selector(handleSingleTap:) withObject:touchLoc afterDelay:0.3];
	}else if (theTouch.tapCount == 2) {
		// Double-tap: increase image size by 10%
		/*CGRect myFrame = self.frame;
		myFrame.size.width *= self.frame.size.width * 0.1;
		myFrame.size.height *= self.frame.size.height * 0.1;
		myFrame.origin.x -= (self.frame.origin.x * 0.1) / 2.0;
		myFrame.origin.y -= (self.frame.origin.y * 0.1) / 2.0;
		*/[UIView beginAnimations:nil context:NULL];
		//[self setFrame:myFrame];
		[UIView commitAnimations];
	}
	
	
	
	for (UITouch *touch in touches) {
		//if (touch.tapCount = 2) {
		//draw vertical line between the 2 touches
		
		//}
		if (touch.tapCount >= 2) {
			//[self.superview bringSubviewToFront:self];
		}
	}
}

- (void) handleSingleTap:(NSDictionary *)touches{
	// Single-tap: decreas image size by 10%
	/*CGRect myFrame = self.frame;
	myFrame.size.width -= self.frame.size.width * 0.1;
	myFrame.size.height -= self.frame.size.height * 0.1;
	myFrame.origin.x += (self.frame.origin.x * 0.1) / 2.0;
	myFrame.origin.y += (self.frame.origin.y * 0.1) / 2.0;
	*/[UIView beginAnimations:nil context:NULL];
	//[self setFrame:myFrame];
	[UIView commitAnimations];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	// no state to clean up, so null implementation
}



@end

