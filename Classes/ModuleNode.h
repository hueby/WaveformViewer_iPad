//
//  ModuleNode.h
//  Draw_iPad
//
//  Created by Dennis Hübner on 10.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModuleNode : NSObject {
	NSString* name;
	NSMutableArray* variables;
}

- (id) init;

@property(nonatomic, retain) NSString* name;
@property(nonatomic, retain) NSMutableArray* variables;

@end
