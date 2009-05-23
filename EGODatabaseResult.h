//
//  EGODatabaseResult.h
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EGODatabaseRow;
@interface EGODatabaseResult : NSObject<NSFastEnumeration> {
@private
	int errorCode;
	NSString* errorMessage;
	NSMutableArray* columnNames;
	NSMutableArray* columnTypes;
	NSMutableArray* rows;
}

- (void)addRow:(EGODatabaseRow*)row;
- (EGODatabaseRow*)rowAtIndex:(NSInteger)index;
- (NSUInteger)count;

@property(nonatomic,assign) int errorCode;
@property(nonatomic,copy) NSString* errorMessage;
@property(readonly) NSMutableArray* columnNames;
@property(readonly) NSMutableArray* columnTypes;
@property(readonly) NSMutableArray* rows;
@end
