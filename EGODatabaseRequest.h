//
//  EGODatabaseRequest.h
//  EGODatabase
//
//  Created by Shaun Harrison on 10/18/09.
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

//
// This class is NOT required to use EGODatabase.  This was written
// to simply make asynchronous requests easy by using NSOperationQueue.
//

#import <Foundation/Foundation.h>

typedef enum {
	EGODatabaseUpdateRequest,
	EGODatabaseSelectRequest
} EGODatabaseRequestKind;

@class EGODatabase, EGODatabaseResult;
@protocol EGODatabaseRequestDelegate;
@interface EGODatabaseRequest : NSOperation {
@private
	NSArray* parameters;
	NSInteger tag;
	NSString* query;
	EGODatabase* database;
	EGODatabaseRequestKind requestKind;
	id<EGODatabaseRequestDelegate> delegate;
}

- (id)initWithQuery:(NSString*)aQuery;
- (id)initWithQuery:(NSString*)aQuery parameters:(NSArray*)someParameters;

@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,retain) EGODatabase* database;
@property(nonatomic,assign) EGODatabaseRequestKind requestKind;
@property(nonatomic,assign) id<EGODatabaseRequestDelegate> delegate;
@end

@protocol EGODatabaseRequestDelegate<NSObject>
- (void)requestDidSucceed:(EGODatabaseRequest*)request withResult:(EGODatabaseResult*)result; // result will be nil for EGODatabaseUpdateRequest
- (void)requestDidFail:(EGODatabaseRequest*)request withError:(NSError*)error;
@end
