//
//  EGODatabaseRow.m
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//
// This work is licensed under the Creative Commons GNU General Public License License.
// To view a copy of this license, visit http://creativecommons.org/licenses/GPL/2.0/
// or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
//

#import "EGODatabaseRow.h"
#import "EGODatabaseResult.h"


@implementation EGODatabaseRow
@synthesize columnData;

- (id)initWithDatabaseResult:(EGODatabaseResult*)aResult {
	if((self = [super init])) {
		columnData = [[NSMutableArray alloc] init];
		result = aResult;
		// result = [aResult retain];
	}
	
	return self;
}

- (int)columnIndexForName:(NSString*)columnName {
	return [result.columnNames indexOfObject:columnName];
}

- (int)intForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return 0;
    return [[columnData objectAtIndex:columnIndex] intValue];
}

- (int)intForColumnIndex:(int)columnIndex {
    return [[columnData objectAtIndex:columnIndex] intValue];
}

- (long)longForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return 0;
    return [[columnData objectAtIndex:columnIndex] longValue];
}

- (long)longForColumnIndex:(int)columnIndex {
    return [[columnData objectAtIndex:columnIndex] longValue];
}

- (BOOL)boolForColumn:(NSString*)columnName {
    return ([self intForColumn:columnName] != 0);
}

- (BOOL)boolForColumnIndex:(int)columnIndex {
    return ([self intForColumnIndex:columnIndex] != 0);
}

- (double)doubleForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return 0;
    return [[columnData objectAtIndex:columnIndex] doubleValue];
}

- (double)doubleForColumnIndex:(int)columnIndex {
    return [[columnData objectAtIndex:columnIndex] doubleValue];
}

- (NSString*) stringForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return @"";
    return [columnData objectAtIndex:columnIndex];
}

- (NSString*)stringForColumnIndex:(int)columnIndex {
    return [columnData objectAtIndex:columnIndex];
}

- (NSDate*)dateForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
    if(columnIndex == -1) return nil;
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIndex]];
}

- (NSDate*)dateForColumnIndex:(int)columnIndex {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIndex]];
}

- (void)dealloc {
	// [result release];
	[columnData release];
	[super dealloc];
}

@end
