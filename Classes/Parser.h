//
//  Parser.h
//  Draw_iPad
//
//  Created by Dennis Hübner on 09.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//  
//	The vcd file is read and converted to a tree in this class.
//  It gives back a tree with all the information about the wave forms
//

#import <Foundation/Foundation.h>


@interface Parser : NSObject {
	int counterLines;
	int counterWords;
	
	NSMutableArray* data;
}

- (id) init;
- (BOOL) parseFile:(NSString*) filePath;
- (BOOL) getFile:(NSString*) filePath;
- (BOOL) checkOnVCDFormat:(NSString*) filePath;
- (NSMutableArray*) convertFileToMutableArray:(NSString*) filePath;
- (void) makeTree:(NSMutableArray*)vcdArray;

- (void) createHeadDatastructure:(NSMutableArray*)vcdArray;
- (void) addModToData:(NSMutableArray*)lineArray :(int) counter;
- (void) addVarToData:(NSMutableArray*)lineArray :(int) counter;

- (void) createSignalDataStructure:(NSMutableArray*)vcdArray :(int)counterL;
- (void) addSignalToDB:(int)signal :(NSString*)symbol;
- (void) addTimeStepToDB:(NSInteger) timeStep;
- (NSMutableArray*) searchForSymbolInDatastructure:(NSString*) symbol;

- (void)allOut;

@property(nonatomic, retain) NSMutableArray* data;

@end
