//
//  Parser.m
//  Draw_iPad
//
//  Created by Dennis Hübner on 09.01.11.
//  Copyright 2011 huebys inventions. All rights reserved.
//

#import "Parser.h"
#import "ModuleNode.h"
#import "VariableNode.h"
#import "SignalNode.h"

@implementation Parser

@synthesize data;

- (id) init {
	return self;
}

- (BOOL)parseFile:(NSString*) filePath {
	//replacement for constructor
	BOOL canParse = NO;
	//check existence of file
	if ([self getFile:filePath]) {
		//check if file is a vcd file
		if ([self checkOnVCDFormat:filePath]) {
			NSMutableArray* vcdArray = [self convertFileToMutableArray:filePath];
			if (vcdArray != nil) {
				[self makeTree:vcdArray];
				canParse = YES;
				return canParse;

			} else {
				NSLog(@"Array is already in use.");
				return canParse;
			}
		} else {
			NSLog(@"Not a vcd file!");
			return canParse;
		}
 
	} else {
		NSLog(@"File not found. Aborting.");
		return canParse;
	}
}	

- (BOOL)getFile:(NSString*) filePath {
	//check existence of the file
	
	return [[NSFileManager alloc] fileExistsAtPath:filePath];
}

- (BOOL) checkOnVCDFormat:(NSString*) filePath {
	int countLength = [filePath length];
	NSString* dataFormat = [[NSString alloc] initWithFormat:@""];
	for (int i = countLength-1; i > countLength-4; i--) {
		unichar newCharacter = [filePath characterAtIndex:i];
		NSString* newString = [[NSString alloc] initWithFormat:@"%c%@", newCharacter, dataFormat];
		dataFormat = newString;
	}
	if ([dataFormat isEqual:@"vcd"]) {
		return YES;
	} else {
		return NO;
	}
}

- (NSMutableArray*)convertFileToMutableArray:(NSString*) filePath {

	NSLog(@"Pfad der Datei: %@", filePath);
	
	NSString* fileOut = [NSString stringWithContentsOfFile:filePath
									encoding: NSUTF8StringEncoding
									error: nil];
	
	NSArray* arrayFromFileWithLineIndex = [fileOut componentsSeparatedByString:@"\n"];
	NSMutableArray* finalArrayLineWords = [[NSMutableArray alloc] initWithCapacity:1];	
	
	for (int i = 0; i < [arrayFromFileWithLineIndex count]; i++) {
		NSString* string = [arrayFromFileWithLineIndex objectAtIndex:i];
	
		NSArray* stringConvertedInWordArray = [string componentsSeparatedByString:@" "]; 
		
		NSMutableArray* wordContainer = [[NSMutableArray alloc] initWithCapacity:1];
	
	
		for (int j = 0; j < [stringConvertedInWordArray count]; j++) {
			//NSString* stringInArray = [stringConvertedInWordArray objectAtIndex:j];
			[wordContainer addObject:[stringConvertedInWordArray objectAtIndex:j]];
		}
		[finalArrayLineWords addObject:wordContainer];
	}

	return finalArrayLineWords;
}

- (void) makeTree:(NSMutableArray*)vcdArray {
	//gets array and converts it into a tree structure
	
	data = [[NSMutableArray alloc] initWithCapacity:1];
	
	for (counterLines = 0; counterLines < [vcdArray count] ; counterLines++) {
		
		NSMutableArray* lineArray = [vcdArray objectAtIndex:counterLines];
	
		for (counterWords = 0; counterWords < [lineArray count]; counterWords++) {
			NSString* string = [lineArray objectAtIndex:counterWords];
			//set variables
			if ([string isEqual:@"$scope"]) {
				[self createHeadDatastructure:vcdArray];
			}
			//set signals for variables
			if ([string isEqual:@"$enddefinitions"]) {
				[self createSignalDataStructure:vcdArray :counterLines];
			}
			
		}
	}
	//[self allOut];
}

- (void) createHeadDatastructure:(NSMutableArray*)vcdArray {
	BOOL abort = NO;
	
	for (counterLines; counterLines < [vcdArray count]; counterLines++) {
		
		NSMutableArray* textArray = [vcdArray objectAtIndex:counterLines];

		for (int i = 0; i < [textArray count]; i++) {
			NSString* string = [textArray objectAtIndex:i];
			if ([string isEqual:@"$upscope"]) {
				abort = YES;
				break;
			}
			
			if ([string isEqual:@"module"]) {
				[self addModToData:textArray :i+1];
			
			}
			
			if ([string isEqual:@"$var"]) {
				[self addVarToData:textArray :i+1];
				i+=4;
			}
		}
		if (abort) {
			break;
		}
	}
}

- (void) addModToData:(NSMutableArray*)lineArray:(int) counter {
	
	//adding module to datastructure
	ModuleNode* modNode = [[ModuleNode alloc] init];
	[modNode setName:[lineArray objectAtIndex:counter]];
	[modNode setVariables:[[NSMutableArray alloc] initWithCapacity:1]];
	[data addObject:modNode];
}

- (void) addVarToData:(NSMutableArray*)lineArray:(int) wordCounter {
	//adding variable to datastructure
	//What if no module exists?!
	//This method only works in vcd format!
	
	ModuleNode* modNode = [data objectAtIndex:0];
	NSMutableArray* variablesArray = [modNode variables];
	
	//**//
	NSString* varType = [[NSString alloc] initWithFormat:@"%@%@",[lineArray objectAtIndex:wordCounter], [lineArray objectAtIndex:wordCounter+1]];
	wordCounter+=2;
	
	NSString* varSymbol = [lineArray objectAtIndex:wordCounter];
	
	wordCounter++;
	
	NSString* varName = [lineArray objectAtIndex:wordCounter];

	//if variable is an array variable
	if (![[lineArray objectAtIndex:wordCounter+1] isEqual:@"$end"]) {
		
		wordCounter++;
		
		NSString* varNumber = [[lineArray objectAtIndex:wordCounter] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
		
		int indexBehindActual = [variablesArray count] - 1; 
		VariableNode* variableBehindActual = [variablesArray objectAtIndex:indexBehindActual];
		
		if ([[variableBehindActual varName] isEqual:varName]) {
			
			//here if there is the same variable as it was before
						
			NSMutableArray* varArray = [variableBehindActual varArray];
			
			VariableNode* varNode = [[VariableNode alloc] init];
			
			[varNode setVarName:[[NSString alloc] initWithFormat:@"%@%@", varName, varNumber]];
			[varNode setSymbol:varSymbol];
			[varNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];
			
			[varArray addObject:varNode];
				
		} else {
			
			//here if theres a new array variable
			
			VariableNode* varNode = [[VariableNode alloc] init];
			
			[varNode setVarName:[[NSString alloc] initWithFormat:@"%@", varName]];
			[varNode setType:varType];
			
			VariableNode* varArrayNode = [[VariableNode alloc] init];
			
			[varArrayNode setVarName:[[NSString alloc] initWithFormat:@"%@%@", varName, varNumber]];
			[varArrayNode setSymbol:varSymbol];
			[varArrayNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];
			
			//might be strange, but there is no other way, i think
			[varNode setVarArray:[[NSMutableArray alloc] initWithCapacity:1]];
			NSMutableArray* varArray = [varNode varArray];
			
			[varArray addObject:varArrayNode];
			[variablesArray addObject:varNode];
		}
	} else {
		
		VariableNode* varNode = [[VariableNode alloc] init];

		[varNode setVarName:varName];
		[varNode setType:varType];
		[varNode setSymbol:varSymbol];
		[varNode setSignals:[[NSMutableArray alloc] initWithCapacity:1]];

		[variablesArray addObject:varNode];
	}
}

- (void) createSignalDataStructure:(NSMutableArray*) vcdArray:(int) counterL {
	BOOL abort = NO;
	
	counterL++;
	
	//array has an empty end. reasen for -1. loop goes to far in array without that
	for (counterL; counterL < [vcdArray count]-1; counterL++) {
		for (int i = 0; i < [[vcdArray objectAtIndex:counterL] count]; i++) {
			if ([[[vcdArray objectAtIndex:counterL] objectAtIndex:i] isEqual:@"$end"]) {
				//abort = YES;
				break;
			}
			
			NSString* word = [[vcdArray objectAtIndex:counterL] objectAtIndex:i];
			NSString* uniCharString = [NSString  stringWithFormat:@"%c", [word characterAtIndex:0]];
			if ([uniCharString isEqual:@"#"]) {
				
				NSInteger timeStep = [[word stringByTrimmingCharactersInSet:
									   [NSCharacterSet characterSetWithCharactersInString:@"#"]] intValue];
				
				[self addTimeStepToDB:timeStep];
			
			} else if ([[[vcdArray objectAtIndex:counterL] objectAtIndex:i] isEqual:@"$dumpvars"]) {
				//only for dumpvariables

				counterL++;
				
				while (![[[vcdArray objectAtIndex:counterL] objectAtIndex:i] isEqual:@"$end"]) {
					//getting string in line
					NSString* stringAtTarget = [[vcdArray objectAtIndex:counterL] objectAtIndex:i];
					//cut off the intvalue
					NSInteger signal = [[NSString stringWithFormat:@"%c", [stringAtTarget characterAtIndex:0]] integerValue];
					//cut off the symbol
					NSString* symbol = [NSString stringWithFormat:@"%c", [stringAtTarget characterAtIndex:1]];
					//add it to variable
					[self addSignalToDB:signal :symbol];
					
					counterL++;
					
					} 
				} else {
					//getting string in line
					NSString* stringAtTarget = [[vcdArray objectAtIndex:counterL] objectAtIndex:i];
					//cut off the intvalue
					
					NSLog(@"%@", stringAtTarget);
					
					NSInteger signal = [[NSString stringWithFormat:@"%c", [stringAtTarget characterAtIndex:0]] integerValue];
					//cut off the symbol
					NSString* symbol = [NSString stringWithFormat:@"%c", [stringAtTarget characterAtIndex:1]];
					//add it to variable
					
					NSLog(@"signal: %i und symbol: %@", signal, symbol);
					
					[self addSignalToDB:signal :symbol];
				}
			
		}	
		if (abort) {
			break;
		}
	}
}

- (void) addSignalToDB:(NSInteger)signal :(NSString*) symbol {
	NSMutableArray* arrayAtVariable = [self searchForSymbolInDatastructure:symbol];
	SignalNode* signalN = [[SignalNode alloc] init];
	BOOL finalSignal;
	switch (signal) {
		case 0:
			finalSignal = NO;
			break;
		case 1:
			finalSignal = YES;
			break;
		default:
			break;
	}
	[signalN setSignal:finalSignal];
	//NSLog(@"Signal %d zu %@ hinzugefügt", signal, symbol);

	[arrayAtVariable addObject:signalN];
}

- (void) addTimeStepToDB:(NSInteger) timeStep {
	//NSLog(@"%i", timeStep);
	
	SignalNode* time = [[SignalNode alloc] init];
	[time setTimeStep:timeStep];
	
	ModuleNode* modules = [data objectAtIndex:0];
	
	NSMutableArray* variableArray = [modules variables];
	
	for (int i = 0; i < [variableArray count]; i++) {
		VariableNode* varNode = [variableArray objectAtIndex:i];
		
		if ([varNode signals] != nil) {
			NSMutableArray* signalArray = [varNode signals];
			[signalArray addObject:time];
		
		} else {
			NSMutableArray* varNodeArray = [varNode varArray];
			
			for (int j = 0; j < [varNodeArray count]; j++) {
				VariableNode* varArrayNode = [varNodeArray objectAtIndex:j];
				NSMutableArray* varArrayNodeArray = [varArrayNode signals];
				[varArrayNodeArray addObject:time];
			
			}
		}
	}
}

- (NSMutableArray*) searchForSymbolInDatastructure:(NSString*) searchString {
	
	//Caution! The search works only in one module for now
	ModuleNode* modules = [data objectAtIndex:0];
	NSMutableArray* variableArray = [modules variables];
	
	for (int i = 0; i < [variableArray count]; i++) {
		VariableNode* varNode = [variableArray objectAtIndex:i];
		
		if ([[varNode symbol] isEqual:searchString]) {
			return [varNode signals];
		} else {
			
			NSMutableArray* varNodeArray = [varNode varArray];

			for (int j = 0; j < [varNodeArray count]; j++) {
				VariableNode* varNodeArrayNode = [varNodeArray objectAtIndex:j];

				if ([[varNodeArrayNode symbol] isEqual:searchString]) {
			
					return [varNodeArrayNode signals];
				}
			}
		}
	}
	return [[NSString alloc] initWithFormat:@"%@ wurde nicht gefunden", searchString];
}

- (void) allOut {
	ModuleNode* modules = [data objectAtIndex:0];
	NSMutableArray* variables = [modules variables];
	
	VariableNode* var = [variables objectAtIndex:0];
	//NSMutableArray* varArray = [var varArray];
		
	NSMutableArray* signals = [var signals];
	
	NSLog(@"Name: %@ und Symbol: %@", [var varName], [var symbol]);
	int target = 3;
	SignalNode *testSignal = [signals objectAtIndex:target];
	
	NSLog(@"%d. Objekt: %@", target, [testSignal getSignal]?@"YES":@"NO");
	for (int i = 0; i < [signals count];  i++) {
		SignalNode* signal = [signals objectAtIndex:i];
		if ([signal timeStep]) {
			NSLog(@"Time: %d", [signal timeStep]);
		} else {
			NSLog(@"%@", [signal getSignal]?@"YES":@"NO");
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	}

@end
