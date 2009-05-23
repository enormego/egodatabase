//
//  EGODatabaseRow.h
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGODatabaseResult;
@interface EGODatabaseRow : NSObject {
@private
	NSMutableArray* columnData;
	EGODatabaseResult* result;
}

- (id)initWithDatabaseResult:(EGODatabaseResult*)aResult;

- (int)intForColumn:(NSString*)columnName;
- (int)intForColumnIndex:(int)columnIdx;

- (long)longForColumn:(NSString*)columnName;
- (long)longForColumnIndex:(int)columnIdx;

- (BOOL)boolForColumn:(NSString*)columnName;
- (BOOL)boolForColumnIndex:(int)columnIdx;

- (double)doubleForColumn:(NSString*)columnName;
- (double)doubleForColumnIndex:(int)columnIdx;

- (NSString*)stringForColumn:(NSString*)columnName;
- (NSString*)stringForColumnIndex:(int)columnIdx;

- (NSDate*)dateForColumn:(NSString*)columnName;
- (NSDate*)dateForColumnIndex:(int)columnIdx;

@property(readonly) NSMutableArray* columnData;
@end
