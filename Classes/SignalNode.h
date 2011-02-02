//
//  SignalNode.h
//  Draw_iPad
//
//  Created by iPad Lab on 14.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SignalNode : NSObject {
	BOOL signal;
	NSInteger timeStep;
}

- (id) init;
- (BOOL) getSignal;
- (void) setSignal:(BOOL) signal;

@property(nonatomic) NSInteger timeStep;

@end
