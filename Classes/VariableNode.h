//
//  VariableNode.h
//  Draw_iPad
//
//  Created by Dennis Hübner on 11.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VariableNode : NSObject {
	NSString* varName;
	NSString* type;
	NSString* symbol;
	NSMutableArray* signals;
	NSMutableArray* varArray;
}

- (id) init;

@property(nonatomic, retain) NSString* varName;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, retain) NSString* symbol;
@property(nonatomic, retain) NSMutableArray* signals;
@property(nonatomic, retain) NSMutableArray* varArray;


@end
