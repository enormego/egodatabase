//
//  EGODatabaseRow.h
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

@class EGODatabaseResult;

@interface EGODatabaseRow : NSObject

- (int)intForColumn:(NSString*)name;
- (int)intForColumnAtIndex:(NSUInteger)index;

- (long)longForColumn:(NSString*)name;
- (long)longForColumnAtIndex:(NSUInteger)index;

- (BOOL)boolForColumn:(NSString*)name;
- (BOOL)boolForColumnAtIndex:(NSUInteger)index;

- (double)doubleForColumn:(NSString*)name;
- (double)doubleForColumnAtIndex:(NSUInteger)index;

- (NSString*)stringForColumn:(NSString*)name;
- (NSString*)stringForColumnAtIndex:(NSUInteger)index;

- (NSData*)dataForColumn:(NSString*)name;
- (NSData*)dataForColumnAtIndex:(NSUInteger)index;

- (NSDate*)dateForColumn:(NSString*)name;
- (NSDate*)dateForColumnAtIndex:(NSUInteger)index;

@property(nonatomic,strong,readonly) NSArray* data;
@end
