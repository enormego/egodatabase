//
//  EGODatabaseResult.m
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//
// This work is licensed under the Creative Commons GNU General Public License License.
// To view a copy of this license, visit http://creativecommons.org/licenses/GPL/2.0/
// or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
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
