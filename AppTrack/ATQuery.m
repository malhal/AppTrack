//
//  ATQuery.m
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "ATQuery+Private.h"
#import "ATObjectType+Private.h"

@interface ATObject()

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end

@interface ATQuery()

@property (readwrite, assign) NSUInteger limit;
@property (readwrite, copy) NSArray<NSSortDescriptor *> *sortDescriptors;
@property (readwrite, strong, nullable) NSPredicate *predicate;

@end

@implementation ATQuery

- (instancetype)initWithObjectType:(ATObjectType *)objectType
                         predicate:(nullable NSPredicate *)predicate
                             limit:(NSUInteger)limit
                   sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors
                    resultsHandler:(void(^)(ATQuery *query, NSArray<__kindof ATObject *> * __nullable results, NSError * __nullable error))resultsHandler{

    self = [super init];
    if (self) {
        self.objectType = objectType;
        self.predicate = predicate;
        self.limit = limit;
        self.sortDescriptors = sortDescriptors;
        self.resultsHandler = resultsHandler;
        
    }
    return self;
}

-(NSDictionary*)dictionary{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];
    // definites
    d[@"entityName"] = self.objectType.identifier;
    d[@"propertiesToFetch"] = self.objectType.propertiesToFetch;
    // possible nulls
    if(self.predicate){
        d[@"predicateDescription"] = self.predicate.description;
    }
    if(self.limit > 0){
        d[@"fetchLimit"] = @(self.limit);
    }
    if(self.sortDescriptors){
        NSMutableArray* a = [NSMutableArray array];
        for(NSSortDescriptor* sd in self.sortDescriptors){
            [a addObject:@{@"key" : sd.key, @"ascending" : @(sd.ascending)}];
        }
        d[@"sortDescriptorDicts"] = a;
    }
    return d;
}

@end

//@implementation ATQuery (ATUsagePredicates)
//
///*!
// @method        predicateForSamplesWithStartDate:endDate:options:
// @abstract      Creates a predicate for use with HKQuery subclasses.
// @discussion    Creates a query predicate that matches samples with a startDate and an endDate that lie inside of a
// given time interval.
// 
// @param         startDate  The start date of the predicate's time interval.
// @param         endDate    The end date of the predicate's time interval.
// @param         options    The rules for how a sample's time interval overlaps with the predicate's time interval.
// */
//+ (NSPredicate *)predicateForUsageWithStartDate:(nullable NSDate *)startDate endDate:(nullable NSDate *)endDate options:(ATQueryOptions)options{
//    if(options == )
//    return [NSPredicate predicateWithFormat:@"startDate > %@ AND endDate < endDate"];
//}
//
//@end
