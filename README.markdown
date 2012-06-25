# About EGODatabase
EGODatabase is a thread-safe Objective SQLite wrapper created by enormego.  After extensively using FMDB in our applications, we saw a lot of room for improvements, the biggest was making it thread-safe.  EGODatabase uses some code from FMDB, but for the most part, it was completely reworked to use result sets and row objects.  A major difference between FMDB and EGODatabase is when selecting data, EGODatabase populates its EGODatabaseRow class with the data from SQLite, as opposed to retaining the SQLite results like FMDB does.

EGODatabase is tested to work with with iPhone OS and Mac OS X 10.5

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
	EGODatabaseResult* result = [database executeQueryWithParameters:@"SELECT * FROM `posts` WHERE `post_user_id` = ?", [NSNumber numberWithInt:10]];
	for(EGODatabaseRow* row in result) {
		NSLog(@"Subject: %@", [row stringForColumn:@"post_subject"]);
		NSLog(@"Date: %@", [row dateForColumn:@"post_date"]);
		NSLog(@"Views: %d", [row intForColumn:@"post_views"]);
		NSLog(@"Message: %@", [row stringForColumn:@"post_message"]);
	}
	
# Note
Remember to link libsqlite3.dylib to your project!

# Questions
Feel free to contact info@enormego.com if you need any help with EGODatabase.

# License
Copyright (c) 2009 enormego

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

