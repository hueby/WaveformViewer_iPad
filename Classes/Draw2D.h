//
//  Draw2D.h
//  Draw_iPad
//
//  Created by Dennis Hübner on 30.11.10.
//  Copyright 2010 huebys inventions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Draw2D : UIView {
	NSMutableArray *signals;
	NSString *nameOfSignal;
}

- (void) drawSignal;

@property (nonatomic, retain) NSMutableArray *signals;
@property (nonatomic, retain) NSString *nameOfSignal;


@end
