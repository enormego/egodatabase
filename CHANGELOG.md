# EGODatabase CHANGELOG

## 1.0 (2009)

Initial release.

## 2.0 (Feb 2, 2014)

* Updated code to Modern Objective-C (ARC, auto-synthesize, auto-boxing, etc.)
* Added new -[EGODatabase execute:] method to easily run low level sqlite calls
* Added -[EGODatabaseResult firstRow] and -[EGODatabaseResult lastRow]
* Replaced NSLock usage with dispatch_semaphor, which gives us a free performance boost
* Removed EGODatabaseRequestDelegate in favor of new completion property on EGODatabaseRequest
* Renamed all -[EGODatabaseRow xxForColumnIndex:] methdos to -[EGODatabaseRow xxForColumnAtIndex:] 
* Moved internal methods out of public headers
* Minor other improvements