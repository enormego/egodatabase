//
//  EGODatabase.h
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

#import <Foundation/Foundation.h>
#import "EGODatabaseRequest.h"
#import "EGODatabaseResult.h"
#import "EGODatabaseRow.h"
#import <sqlite3.h>


@interface EGODatabase : NSObject {
@protected
	NSString* databasePath;
	NSLock* executeLock;
	
@private
	sqlite3* handle;
	BOOL opened;
}

+ (id)databaseWithPath:(NSString*)aPath;
- (id)initWithPath:(NSString*)aPath;

- (BOOL)open;
- (void)close;

// Execute Updates
- (BOOL)executeUpdateWithParameters:(NSString*)sql, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)executeUpdate:(NSString*)sql;
- (BOOL)executeUpdate:(NSString*)sql parameters:(NSArray*)parameters;

- (sqlite3_int64)last_insert_rowid;

// Execute Query
- (EGODatabaseResult*)executeQueryWithParameters:(NSString*)sql, ... NS_REQUIRES_NIL_TERMINATION;

- (EGODatabaseResult*)executeQuery:(NSString*)sql;
- (EGODatabaseResult*)executeQuery:(NSString*)sql parameters:(NSArray*)parameters;

// Query request operation

- (EGODatabaseRequest*)requestWithQueryAndParameters:(NSString*)sql, ... NS_REQUIRES_NIL_TERMINATION;

- (EGODatabaseRequest*)requestWithQuery:(NSString*)sql;
- (EGODatabaseRequest*)requestWithQuery:(NSString*)sql parameters:(NSArray*)parameters;

// Update request operation

- (EGODatabaseRequest*)requestWithUpdateAndParameters:(NSString*)sql, ... NS_REQUIRES_NIL_TERMINATION;

- (EGODatabaseRequest*)requestWithUpdate:(NSString*)sql;
- (EGODatabaseRequest*)requestWithUpdate:(NSString*)sql parameters:(NSArray*)parameters;

// Error methods

- (NSString*)lastErrorMessage;
- (BOOL)hadError;
- (int)lastErrorCode;

@property(nonatomic,readonly) sqlite3* sqliteHandle;
@end
