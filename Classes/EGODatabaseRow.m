//
//  EGODatabaseRow.m
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

#import "EGODatabaseRow_Internal.h"
#import "EGODatabaseResult.h"

@implementation EGODatabaseRow

@dynamic dictionary;
@synthesize names = _names;

- (instancetype)initWithDatabaseResult:(EGODatabaseResult*)result data:(NSArray*)data {
	if((self = [super init])) {
		_names = result.columnNames;
		self.data = data;
	}
	
	return self;
}

- (NSUInteger)indexForName:(NSString*)column {
	return [self.names indexOfObject:column];
}

- (int)intForColumn:(NSString*)column {
    NSUInteger index = [self indexForName:column];
	
	if(index == NSNotFound) {
		return 0;
	} else {
		return [self intForColumnAtIndex:index];
	}
}

- (int)intForColumnAtIndex:(NSUInteger)index {
    return [[self.data objectAtIndex:index] intValue];
}

- (long)longForColumn:(NSString*)column {
    NSUInteger index = [self indexForName:column];
	
	if(index == NSNotFound) {
		return 0;
    } else {
		return [[self.data objectAtIndex:index] longValue];
	}
}

- (long)longForColumnAtIndex:(NSUInteger)index {
    return [[self.data objectAtIndex:index] longValue];
}

- (BOOL)boolForColumn:(NSString*)column {
    return ([self intForColumn:column] != 0);
}

- (BOOL)boolForColumnAtIndex:(NSUInteger)index {
    return ([self intForColumnAtIndex:index] != 0);
}

- (double)doubleForColumn:(NSString*)column {
    NSUInteger index = [self indexForName:column];

	if(index == NSNotFound) {
		return 0.0;
	} else {
		return [self doubleForColumnAtIndex:index];
	}
}

- (double)doubleForColumnAtIndex:(NSUInteger)index {
    return [[self.data objectAtIndex:index] doubleValue];
}

- (NSString*)stringForColumn:(NSString*)column {
    NSUInteger index = [self indexForName:column];

	if(index == NSNotFound) {
		return nil;
	} else {
		return [self stringForColumnAtIndex:index];
	}
}

- (NSString*)stringForColumnAtIndex:(NSUInteger)index {
	id object = [self.data objectAtIndex:index];
	
	if ([object isKindOfClass:[NSString class]]) {
		return object;
	} else {
		return [object description];
	}
}

- (NSData*)dataForColumn:(NSString*)column {
	NSUInteger index = [self indexForName:column];
	
	if (index == NSNotFound) {
		return nil;
	} else {
		return [self dataForColumnAtIndex:index];
	}
}

- (NSData*)dataForColumnAtIndex:(NSUInteger)index {
	id object = [self.data objectAtIndex:index];
	
	if ([object isKindOfClass:[NSData class]]) {
		return object;
	} else {
		return nil;
	}
}

- (NSDate*)dateForColumn:(NSString*)column {
    NSUInteger index = [self indexForName:column];

	if (index == NSNotFound) {
		return nil;
	} else {
		return [self dateForColumnAtIndex:index];
	}
}

- (NSDate*)dateForColumnAtIndex:(NSUInteger)index {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnAtIndex:index]];
}

- (NSDictionary*)dictionary
{
    return [NSDictionary dictionaryWithObjects:self.data forKeys:self.names];
}

- (id)populateObject:(id)obj
{
    [obj setValuesForKeysWithDictionary:self.dictionary];
    return obj;
}

-(id)populateObject:(id)obj mappings:(NSDictionary*)d
{
    NSMutableArray* newNames = [NSMutableArray arrayWithCapacity:self.names.count];
    for (NSString* n in self.names)
    {
        NSString* newName = d[n];
        if(!newName) { newName = n; }
        [newNames addObject:newName];
    }
    [obj setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjects: self.data forKeys: newNames]];
    return obj;
}

- (id)objectOfClass:(Class)c
{
    id obj = [[c alloc]init];
    return [self populateObject:obj];
}

- (id)objectOfClass:(Class)c mappings:(NSDictionary*)d
{
    id obj = [[c alloc]init];
    return [self populateObject:obj mappings:d];
}


@end
