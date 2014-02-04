//
//  EGODatabase.m
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

/* 
 * Some of the code below is based on code from FMDB
 * (Mostly bindObject, and the error checking)
 *
 * We've reworked it, rewritten a lot of it, and feel we've improved on it.
 * However credit is still due to FMDB.
 *
 * @see http://code.google.com/p/flycode/soureturnCodee/browse/#svn/trunk/fmdb
 */

#import "EGODatabase.h"
#import "EGODatabaseResult_Internal.h"
#import "EGODatabaseRow_Internal.h"

#define EGODatabaseDebugLog 1
#define EGODatabaseLockLog 0

#if EGODatabaseDebugLog
	#define EGODBDebugLog(s,...) NSLog(s, ##__VA_ARGS__)
#else
	#define EGODBDebugLog(s,...)
#endif

#if EGODatabaseLockLog
	#define EGODBLockLog(s,...) NSLog(s, ##__VA_ARGS__)
#else
	#define EGODBLockLog(s,...)
#endif

#define VAToArray(firstarg) ({\
	NSMutableArray* valistArray = [[NSMutableArray alloc] init]; \
	id obj = nil;\
	va_list arguments;\
	va_start(arguments, sql);\
	while ((obj = va_arg(arguments, id))) {\
		[valistArray addObject:obj];\
	}\
	va_end(arguments);\
	valistArray;\
})

@implementation EGODatabase {
	dispatch_semaphore_t _executeLock;
	NSString* _databasePath;
	BOOL _opened;
}

+ (instancetype)databaseWithPath:(NSString*)aPath {
	return [[[self class] alloc] initWithPath:aPath];
}

- (instancetype)initWithPath:(NSString*)aPath {
	if((self = [super init])) {
		_databasePath = [aPath copy];
		_executeLock = dispatch_semaphore_create(1);
	}
	
	return self;
}

- (EGODatabaseRequest*)requestWithQueryAndParameters:(NSString*)sql, ... {
	return [self requestWithQuery:sql parameters:VAToArray(sql)];
}

- (EGODatabaseRequest*)requestWithQuery:(NSString*)sql {
	return [self requestWithQuery:sql parameters:nil];
}

- (EGODatabaseRequest*)requestWithQuery:(NSString*)sql parameters:(NSArray*)parameters {
	EGODatabaseRequest* request = [[EGODatabaseRequest alloc] initWithQuery:sql parameters:parameters];

	request.database = self;
	request.requestKind = EGODatabaseSelectRequest;
	
	return request;
}

- (EGODatabaseRequest*)requestWithUpdateAndParameters:(NSString*)sql, ... {
	return [self requestWithUpdate:sql parameters:VAToArray(sql)];
}

- (EGODatabaseRequest*)requestWithUpdate:(NSString*)sql {
	return [self requestWithUpdate:sql parameters:nil];
}

- (EGODatabaseRequest*)requestWithUpdate:(NSString*)sql parameters:(NSArray*)parameters {
	EGODatabaseRequest* request = [[EGODatabaseRequest alloc] initWithQuery:sql parameters:parameters];

	request.database = self;
	request.requestKind = EGODatabaseUpdateRequest;
	
	return request;
}

- (BOOL)open {
	if(_opened) {
		return YES;
	}
	
	int err = sqlite3_open([_databasePath fileSystemRepresentation], &_sqliteHandle);

	if(err != SQLITE_OK) {
		EGODBDebugLog(@"[EGODatabase] Error opening DB: %d", err);
		return NO;
	}
	
	return (_opened = YES);
}

- (void)close {
	if(self.sqliteHandle != 0) {
		sqlite3_close(self.sqliteHandle);
		_sqliteHandle = 0;
		_opened = NO;
	}
}

- (void)execute:(void(^)(sqlite3*))block {
	EGODBLockLog(@"[Update] Waiting for Lock (%@): %@ %@", [sql md5], sql, [NSThread isMainThread] ? @"** Alert: Attempting to lock on main thread **" : @"");
	dispatch_semaphore_wait(_executeLock, 0);
	EGODBLockLog(@"[Update] Got Lock (%@)", [sql md5]);
	
	if(![self open]) {
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return;
	}
	
	block(_sqliteHandle);
	
	EGODBLockLog(@"%@ released lock", [sql md5]);
	dispatch_semaphore_signal(_executeLock);
}

- (BOOL)executeUpdateWithParameters:(NSString*)sql,... {
	return [self executeUpdate:sql parameters:VAToArray(sql)];
}

- (BOOL)executeUpdate:(NSString*)sql {
	return [self executeUpdate:sql parameters:nil];
}

- (BOOL)executeUpdate:(NSString*)sql parameters:(NSArray*)parameters {
	EGODBLockLog(@"[Update] Waiting for Lock (%@): %@ %@", [sql md5], sql, [NSThread isMainThread] ? @"** Alert: Attempting to lock on main thread **" : @"");
	dispatch_semaphore_wait(_executeLock, 0);
	EGODBLockLog(@"[Update] Got Lock (%@)", [sql md5]);
	
	if(![self open]) {
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return NO;
	}

	int returnCode = 0;
	sqlite3_stmt* statement = NULL;

	returnCode = sqlite3_prepare(self.sqliteHandle, [sql UTF8String], -1, &statement, 0);
	
	if (SQLITE_BUSY == returnCode) {
		EGODBDebugLog(@"[EGODatabase] Query Failed, Database Busy:\n%@\n\n", sql);
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return NO;
	} else if (SQLITE_OK != returnCode) {
		EGODBDebugLog(@"[EGODatabase] Query Failed, Error: %d \"%@\"\n%@\n\n", [self lastErrorCode], [self lastErrorMessage], sql);
		sqlite3_finalize(statement);
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return NO;
	}
	
	
	if (![self bindStatement:statement toParameters:parameters]) {
		EGODBDebugLog(@"[EGODatabase] Invalid bind count for number of arguments.");
		sqlite3_finalize(statement);
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return NO;
	}
	
	returnCode = sqlite3_step(statement);
	
	if (SQLITE_BUSY == returnCode) {
		EGODBDebugLog(@"[EGODatabase] Query Failed, Database Busy:\n%@\n\n", sql);
	} else if (SQLITE_DONE == returnCode || SQLITE_ROW == returnCode) {
		
	} else if (SQLITE_ERROR == returnCode) {
		EGODBDebugLog(@"[EGODatabase] sqlite3_step Failed: (%d: %@) SQLITE_ERROR\n%@\n\n", returnCode, [self lastErrorMessage], sql);
	} else if (SQLITE_MISUSE == returnCode) {
		EGODBDebugLog(@"[EGODatabase] sqlite3_step Failed: (%d: %@) SQLITE_MISUSE\n%@\n\n", returnCode, [self lastErrorMessage], sql);
	} else {
		EGODBDebugLog(@"[EGODatabase] sqlite3_step Failed: (%d: %@) UNKNOWN_ERROR\n%@\n\n", returnCode, [self lastErrorMessage], sql);
	}

	returnCode = sqlite3_finalize(statement);

	EGODBLockLog(@"%@ released lock", [sql md5]);
	dispatch_semaphore_signal(_executeLock);
	
	return (returnCode == SQLITE_OK);
}

- (sqlite3_int64)lastInsertRowId {
	if (self.sqliteHandle) {
		return sqlite3_last_insert_rowid(self.sqliteHandle);
	} else {
		EGODBDebugLog(@"[EGODatabase] Can't get last rowid of nil sqlite");
		return 0;
	}
}

- (EGODatabaseResult*)executeQueryWithParameters:(NSString*)sql,... {
	return [self executeQuery:sql parameters:VAToArray(sql)];
}

- (EGODatabaseResult*)executeQuery:(NSString*)sql {
	return [self executeQuery:sql parameters:nil];
}

- (EGODatabaseResult*)executeQuery:(NSString*)sql parameters:(NSArray*)parameters {
	EGODBLockLog(@"[Query] Waiting for Lock (%@): %@", [sql md5], sql);
	dispatch_semaphore_wait(_executeLock, 0);
	EGODBLockLog(@"[Query] Got Lock (%@)", [sql md5]);
	
	EGODatabaseResult* result = [[EGODatabaseResult alloc] init];

	if(![self open]) {
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return result;
	}
	
	int returnCode = 0;
	sqlite3_stmt* statement = NULL;
	
	returnCode = sqlite3_prepare(self.sqliteHandle, [sql UTF8String], -1, &statement, 0);
	result.errorCode = [self lastErrorCode];
	result.errorMessage = [self lastErrorMessage];
	
	if (SQLITE_BUSY == returnCode) {
		EGODBDebugLog(@"[EGODatabase] Query Failed, Database Busy:\n%@\n\n", sql);
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return result;
	} else if (SQLITE_OK != returnCode) {
		EGODBDebugLog(@"[EGODatabase] Query Failed, Error: %d \"%@\"\n%@\n\n", [self lastErrorCode], [self lastErrorMessage], sql);
		sqlite3_finalize(statement);
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return result;
	}
	
	if (![self bindStatement:statement toParameters:parameters]) {
		EGODBDebugLog(@"[EGODatabase] Invalid bind count for number of arguments.");
		sqlite3_finalize(statement);
		EGODBLockLog(@"%@ released lock", [sql md5]);
		dispatch_semaphore_signal(_executeLock);
		return result;
	}
	
	int columnCount = sqlite3_column_count(statement);
	
	NSMutableArray* columnNames = [[NSMutableArray alloc] init];
	NSMutableArray* columnTypes = [[NSMutableArray alloc] init];
	
	for(int x = 0; x < columnCount; x++) {
		if(sqlite3_column_name(statement,x) != NULL) {
			[columnNames addObject:[NSString stringWithUTF8String:sqlite3_column_name(statement,x)]];
		} else {
			[columnNames addObject:[NSString stringWithFormat:@"%d", x]];
		}

		if(sqlite3_column_decltype(statement,x) != NULL) {
			[columnTypes addObject:[NSString stringWithUTF8String:sqlite3_column_decltype(statement,x)]];
		} else {
			[columnTypes addObject:@""];
		}
	}
	
	result.columnNames = columnNames;
	result.columnTypes = columnTypes;
	
	NSMutableArray* rows = [[NSMutableArray alloc] init];
	
	while(sqlite3_step(statement) == SQLITE_ROW) {
		NSMutableArray* data = [[NSMutableArray alloc] init];
		
		for(int x = 0; x < columnCount; x++) {
			if (SQLITE_BLOB == sqlite3_column_type(statement, x)) {
				[data addObject:[NSData dataWithBytes:sqlite3_column_text(statement,x) length:sqlite3_column_bytes(statement,x)]];
			} else if (sqlite3_column_text(statement,x) != NULL) {
				[data addObject:@((char*)sqlite3_column_text(statement,x))];
			} else {
				[data addObject:@""];
			}
		}
		
		EGODatabaseRow* row = [[EGODatabaseRow alloc] initWithDatabaseResult:result data:data];
		[rows addObject:row];
	}
	
	result.rows = rows;
	
	sqlite3_finalize(statement);

	EGODBLockLog(@"%@ released lock", [sql md5]);
	dispatch_semaphore_signal(_executeLock);

	return result;
}

- (NSString*)lastErrorMessage {
	if([self hadError]) {
		return [NSString stringWithUTF8String:sqlite3_errmsg(self.sqliteHandle)];
	} else {
		return nil;
	}
}

- (BOOL)hadError {
	return [self lastErrorCode] != SQLITE_OK;
}

- (int)lastErrorCode {
	return sqlite3_errcode(self.sqliteHandle);
}

- (BOOL)bindStatement:(sqlite3_stmt*)statement toParameters:(NSArray*)parameters {
	int index = 0;
	int queryCount = sqlite3_bind_parameter_count(statement);
	
	for(id obj in parameters) {
		index++;
		[self bindObject:obj toColumn:index inStatement:statement];
	}
	
	return index == queryCount;
}

- (void)bindObject:(id)obj toColumn:(int)idx inStatement:(sqlite3_stmt*)pStmt {
	if ((!obj) || ((NSNull *)obj == [NSNull null])) {
		sqlite3_bind_null(pStmt, idx);
	} else if ([obj isKindOfClass:[NSData class]]) {
		sqlite3_bind_blob(pStmt, idx, [obj bytes], (int)[obj length], SQLITE_STATIC);
	} else if ([obj isKindOfClass:[NSDate class]]) {
		sqlite3_bind_double(pStmt, idx, [obj timeIntervalSince1970]);
	} else if ([obj isKindOfClass:[NSNumber class]]) {
		if (strcmp([obj objCType], @encode(BOOL)) == 0) {
			sqlite3_bind_int(pStmt, idx, ([obj boolValue] ? 1 : 0));
		} else if (strcmp([obj objCType], @encode(int)) == 0) {
			sqlite3_bind_int64(pStmt, idx, [obj longValue]);
		} else if (strcmp([obj objCType], @encode(long)) == 0) {
			sqlite3_bind_int64(pStmt, idx, [obj longValue]);
		} else if (strcmp([obj objCType], @encode(float)) == 0) {
			sqlite3_bind_double(pStmt, idx, [obj floatValue]);
		} else if (strcmp([obj objCType], @encode(double)) == 0) {
			sqlite3_bind_double(pStmt, idx, [obj doubleValue]);
		} else {
			sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
		}
	} else {
		sqlite3_bind_text(pStmt, idx, [[obj description] UTF8String], -1, SQLITE_STATIC);
	}
}

- (void)dealloc {
	[self close];
}

@end
