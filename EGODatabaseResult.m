//
//  EGODatabaseResult.m
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
