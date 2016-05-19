//
//  ATStore.h
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATQuery;

@interface ATStore : NSObject

/*!
 @method        executeQuery:
 @abstract      Begins executing the given query.
 @discussion    After executing a query the completion, update, and/or results handlers of that query will be invoked
 asynchronously on an arbitrary background queue as results become available.  Errors that prevent a
 query from executing will be delivered to one of the query's handlers.  Which handler the error will be
 delivered to is defined by the HKQuery subclass.  The behavior of calling this method with a query that
 is already executing is undefined.
 */
- (void)executeQuery:(ATQuery *)query;

@end
