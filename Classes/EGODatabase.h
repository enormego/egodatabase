//
//  EGODatabase.h
//  EGODatabase
//
//  Copyright (c) 2009-2014 Enormego, Shaun Harrison
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
#import <sqlite3.h>

#import "EGODatabaseRequest.h"
#import "EGODatabaseResult.h"
#import "EGODatabaseRow.h"

@interface EGODatabase : NSObject

+ (instancetype)databaseWithPath:(NSString*)aPath;
- (instancetype)initWithPath:(NSString*)aPath;

- (BOOL)open;
- (void)close;

@property(nonatomic,readonly) sqlite3* sqliteHandle;

// Execute Updates
- (BOOL)executeUpdateWithParameters:(NSString*)sql, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)executeUpdate:(NSString*)sql;
- (BOOL)executeUpdate:(NSString*)sql parameters:(NSArray*)parameters;

- (sqlite3_int64)lastInsertRowId;

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

// Execute raw sqlite calls, with thread safe lock protection. Do not nest, as it will cause a deadlock.
- (void)execute:(void(^)(sqlite3*))block;

// Error methods
- (NSString*)lastErrorMessage;
- (BOOL)hadError;
- (int)lastErrorCode;

@end
