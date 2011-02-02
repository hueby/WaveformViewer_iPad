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
		CGContextAddLineToPoint(context,  (CGFloat)x, (CGFloat)y);
	}
	
	
	CGContextStrokePath(context);
	
	// Drawing code

	/*
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
	
	// (neuen) Startpunkt im context festlegen 
	
	CGContextMoveToPoint(context, 0, 50);
	
	// Zeichne 0000 0100 1110..., 
	// Längen- und Höhenabstand zwischen 2 Werten jeweils 10 pt
	
	// 00000 
	CGContextAddLineToPoint(context, 60, 50);
	
	// 1 
	CGContextAddLineToPoint(context, 60, 40); 
	CGContextAddLineToPoint(context, 70, 40); 
	CGContextAddLineToPoint(context, 70, 50);
	
	// 00 
	CGContextAddLineToPoint(context, 90, 50);

	// 111 
	CGContextAddLineToPoint(context, 90, 40); 
	CGContextAddLineToPoint(context, 120, 40); 
	CGContextAddLineToPoint(context, 120, 50);
	
	// 0...0 
	CGContextAddLineToPoint(context, 310, 50);
	
	// Die folgenden Linien werden nur durch Scrollen sichtbar 
	CGContextAddLineToPoint(context, 310, 40); 
	CGContextAddLineToPoint(context, 330, 40); 
	CGContextAddLineToPoint(context, 330, 50); 
	CGContextAddLineToPoint(context, 370, 50); 
	CGContextAddLineToPoint(context, 370, 40); 
	CGContextAddLineToPoint(context, 400, 40); 
	CGContextAddLineToPoint(context, 400, 50);
	CGContextAddLineToPoint(context, 450, 50);
	
	// Zeichnet eine Linie entlang des aktuellen Pfads 
	for (int i = 30; i < 1000; i+=70) {
		CGContextAddLineToPoint(context, i, 30);
		CGContextAddLineToPoint(context, i, 40);
		CGContextAddLineToPoint(context, i+20, 40);
		CGContextAddLineToPoint(context, i+20, 30);
		CGContextAddLineToPoint(context, i+60, 30);
	}
	
	CGContextStrokePath(context);*/
}


- (void)dealloc {
    [super dealloc];
}


@end
