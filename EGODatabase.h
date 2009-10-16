//
//  EGODatabase.h
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//
// This work is licensed under the Creative Commons GNU General Public License License.
// To view a copy of this license, visit http://creativecommons.org/licenses/GPL/2.0/
// or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.
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
