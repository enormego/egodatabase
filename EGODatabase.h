//
//  EGODatabase.h
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <Foundation/Foundation.h>
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

- (BOOL)executeUpdate:(NSString*)sql,...;
- (EGODatabaseResult*)executeQuery:(NSString*)sql,...;

- (NSString*)lastErrorMessage;
- (BOOL)hadError;
- (int)lastErrorCode;

@end
