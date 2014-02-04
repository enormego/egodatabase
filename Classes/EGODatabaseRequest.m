//
//  EGODatabaseRequest.m
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

#import "EGODatabaseRequest.h"
#import "EGODatabase.h"


@implementation EGODatabaseRequest {
	NSArray* _parameters;
	NSString* _query;
}

- (id)initWithQuery:(NSString*)query {
	return [self initWithQuery:query parameters:nil];
}

- (id)initWithQuery:(NSString*)query parameters:(NSArray*)parameters {
	if((self = [super init])) {
		_query = [query copy];
		_parameters = parameters;
		self.requestKind = EGODatabaseSelectRequest;
	}
	
	return self;
}

- (void)main {
	if(self.requestKind == EGODatabaseUpdateRequest) {
		[self executeUpdate];
	} else {
		[self executeQuery];
	}
}

- (void)executeUpdate {
	BOOL result = [self.database executeUpdate:_query parameters:_parameters];
	
	if(result) {
		[self didSucceedWithResult:nil];
	} else {
		NSString* errorMessage = [self.database lastErrorMessage];
		NSDictionary* userInfo = nil;
		
		if(errorMessage != nil) {
			userInfo = @{ @"message" : errorMessage };
		}
		
		[self didFailWithError:[NSError errorWithDomain:@"com.egodatabase.update" code:[self.database lastErrorCode] userInfo:userInfo]];
	}
}

- (void)executeQuery {
	EGODatabaseResult* result = [self.database executeQuery:_query parameters:_parameters];
	
	if(result.errorCode == 0) {
		[self didSucceedWithResult:result];
	} else {
		NSDictionary* userInfo = nil;
		
		if(result.errorMessage != nil) {
			userInfo = @{ @"message" : result.errorMessage };
		}
		
		[self didFailWithError:[NSError errorWithDomain:@"com.egodatabase.select" code:result.errorCode userInfo:userInfo]];
	}
}

- (void)didSucceedWithResult:(EGODatabaseResult*)result {
	if(self.completion != nil) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.completion(self, result, nil);
		});
	}
}

- (void)didFailWithError:(NSError*)error {
	if(self.completion != nil) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.completion(self, nil, error);
		});
	}
}

@end
