//
//  EGODatabaseResult.h
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
