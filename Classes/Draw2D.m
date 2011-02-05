//
//  Draw2D.m
//  Draw_iPad
//
//  Created by Dennis Hübner on 30.11.10.
//  Copyright 2010 huebys inventions. All rights reserved.
//

#import "Draw2D.h"
#import "SignalNode.h"


@implementation Draw2D

@synthesize signals;
@synthesize nameOfSignal;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
	return self;
}

- (void) drawSignal {
		
	
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
	NSLog(@"Hier Draw2D: Zeichne Variable %@", nameOfSignal);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	
	NSInteger x = 0;
	NSInteger y = 0;
	
	
	for (int position = 0; position < [signals count]; position++) {
		NSMutableArray *signalsAtPositon = [signals objectAtIndex:position];
		CGContextMoveToPoint(context, x, y);

		for (int i = 0; i < [signalsAtPositon count]; i++) {

			SignalNode *signal = [signalsAtPositon objectAtIndex:i];
			if ([signal timeStep]) {
				x = [signal timeStep];
			} else if ([signal getSignal]) {
				y = 30;
			} else {
				y = 40;
			}
			CGContextAddLineToPoint(context,  (CGFloat)x, (CGFloat)y);
		} 
		CGContextStrokePath(context);
		x = 0;
	}
	
	
	/*
	int i = 1;

	SignalNode* signalNode = [signals objectAtIndex:i];
	//NSLog(@"%@", [signalNode getSignal]?@"Yes":@"No");
	
	NSInteger x = 0;
	NSInteger y = 0;
	
	if ([signalNode getSignal]) {
		y = 30;
	} else {
		y = 40;
	}

	CGContextMoveToPoint(context, x, y);
	
	i++;
	
	signalNode = [signals objectAtIndex:i];
	
	//NSLog(@"%i %i", x, y);

	for (i; i < [signals count]; i++) {
		
		signalNode = [signals objectAtIndex:i];
		
		if ([signalNode timeStep]) {
			x = [signalNode timeStep];
			//NSLog(@"%i", x);
		} else if ([signalNode getSignal]) {
			y = 30;
		} else {
			y = 40;
		}
		//NSLog(@"%i %i", x, y);
	}
	*/
	
	
}


- (void)dealloc {
    [super dealloc];
}


@end
