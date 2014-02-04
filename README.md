# About EGODatabase
EGODatabase is a thread-safe Objective SQLite wrapper created by enormego.  After extensively using FMDB in our applications, we saw a lot of room for improvements, the biggest was making it thread-safe.  EGODatabase uses some code from FMDB, but for the most part, it was completely reworked to use result sets and row objects.  A major difference between FMDB and EGODatabase is when selecting data, EGODatabase populates its EGODatabaseRow class with the data from SQLite, as opposed to retaining the SQLite results like FMDB does.

EGODatabase is tested to work with with all versions of iOS and Mac OS X 10.5+.

# Classes
## EGODatabase
This is the class where you'll open your SQLite database file and execute queries through.

## EGODatabaseResult
This is the class returned by EGODatabase when running "executeQuery:".  It supports fast enumeration, and contains properties for the column names, column types, rows, and errors if there are any.

## EGODatabaseRow
Every object that EGODatabaseResult contains, is an EGODatabaseRow.  This is your raw data for each row.  You'll be able to return specific types based on different methods such as intForColumn: or dateForColumn:.  Check out the header files for a complete listing.

# Documentation
Check out each header file for a complete listing of each method.

# Example
	EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
	EGODatabaseResult* result = [database executeQueryWithParameters:@"SELECT * FROM `posts` WHERE `user_id` = ?", @(10), nil];
	for(EGODatabaseRow* row in result) {
		NSLog(@"Subject: %@", [row stringForColumn:@"subject"]);
		NSLog(@"Date: %@", [row dateForColumn:@"date"]);
		NSLog(@"Views: %d", [row intForColumn:@"views"]);
		NSLog(@"Message: %@", [row stringForColumn:@"message"]);
	}
	
# Note
Remember to link libsqlite3.dylib to your project!