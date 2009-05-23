//
//  EGODatabaseResult.m
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "EGODatabaseResult.h"


@implementation EGODatabaseResult
@synthesize errorCode, errorMessage, columnNames, columnTypes, rows;
- (id)init {
	if((self = [super init])) {
		errorCode = 0;
		columnNames = [[NSMutableArray alloc] init];
		columnTypes = [[NSMutableArray alloc] init];
		rows = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)addRow:(EGODatabaseRow*)row {
	[rows addObject:row];
}

- (EGODatabaseRow*)rowAtIndex:(NSInteger)index {
	return [rows objectAtIndex:index];
}

- (NSUInteger)count {
	return rows.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
	return [rows countByEnumeratingWithState:state objects:stackbuf count:len];
}

- (void)dealloc {
	[rows release];
	[errorMessage release];
	[columnNames release];
	[columnTypes release];
	[super dealloc];
}

@end
