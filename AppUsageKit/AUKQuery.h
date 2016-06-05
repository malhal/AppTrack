//
//  AUKQuery.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <AppUsageKit/AppUsageKit.h>

// The query returns all samples that match the given sampleType and predicate.
#define AUKObjectQueryNoLimit (0)

NS_ASSUME_NONNULL_BEGIN

@interface AUKQuery : NSObject

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, strong, nullable) NSPredicate *predicate;

/*!
 @property      limit
 @abstract      The maximum number of results the receiver will return upon completion.
 */
@property (readonly, assign) NSUInteger limit;

/*!
 @property      sortDescriptors
 @abstract      An array of NSSortDescriptors.
 */
@property (readonly, copy, nullable) NSArray<NSSortDescriptor *> *sortDescriptors;

/*!
 @method        initWithObjectType:predicate:limit:sortDescriptors:resultsHandler:
 @abstract      Returns a query that will retrieve objects matching the given predicate.
 
 @param         objectType      The type of object to retrieve.
 @param         predicate       The predicate which samples should match.
 @param         limit           The maximum number of samples to return.  Pass AUKObjectQueryNoLimit for no limit.
 @param         sortDescriptors The sort descriptors to use to order the resulting samples.
 @param         resultsHandler  The block to invoke with results when the query has finished executing.
 */
- (instancetype)initWithObjectType:(AUKObjectType *)objectType
                         predicate:(nullable NSPredicate *)predicate
                             limit:(NSUInteger)limit
                   sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors
                    resultsHandler:(void(^)(AUKQuery *query, NSArray<__kindof AUKObject *> * __nullable results, NSError * __nullable error))resultsHandler;

@end

/**
 @enum      AUKQueryOptions
 @abstract  Time interval options are used to describe how an AUKUsage's time period overlaps with a given time period.
 
 @constant  AUKQueryOptionNone               The usage time period must overlap with the predicate's time period.
 @constant  AUKQueryOptionStrictStartDate    The usage start date must fall in the time period (>= startDate, < endDate)
 @constant  AUKQueryOptionStrictEndDate      The usage end date must fall in the time period (> startDate, <= endDate)
 
 */
typedef NS_OPTIONS(NSUInteger, AUKQueryOptions) {
    AUKQueryOptionNone               = 0,
    AUKQueryOptionStrictStartDate    = 1 << 0,
    AUKQueryOptionStrictEndDate      = 1 << 1,
};


@interface AUKQuery (AUKUsagePredicates)

/*!
 @method        predicateForSamplesWithStartDate:endDate:options:
 @abstract      Creates a predicate for use with AUKQuery subclasses.
 @discussion    Creates a query predicate that matches samples with a startDate and an endDate that lie inside of a
 given time interval.
 
 @param         startDate  The start date of the predicate's time interval.
 @param         endDate    The end date of the predicate's time interval.
 @param         options    The rules for how a usage time interval overlaps with the predicate's time interval.
 */
//+ (NSPredicate *)predicateForUsageWithStartDate:(nullable NSDate *)startDate endDate:(nullable NSDate *)endDate options:(AUKQueryOptions)options;

@end

NS_ASSUME_NONNULL_END