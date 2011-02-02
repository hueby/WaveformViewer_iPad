//
//  SignalNode.m
//  Draw_iPad
//
//  Created by iPad Lab on 14.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignalNode.h"


@implementation SignalNode

@synthesize timeStep;

- (id) init {
	return self;
}

- (BOOL) getSignal {
	return signal;
}
- (void) setSignal:(BOOL) signalIn {
	signal = signalIn;
}

@end
