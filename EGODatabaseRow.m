//
//  EGODatabaseRow.m
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright (c) 2009 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

- (NSData*)dataForColumn:(NSString*)columnName {
	int columnIndex = [self columnIndexForName:columnName];
	if (columnIndex < 0 || columnIndex == NSNotFound) return nil;
	return [columnData objectAtIndex:columnIndex];
}

- (NSData*)dataForColumnIndex:(int)columnIndex {
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
