//
//  AUKQuery+Private.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
#import "AUKQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUKQuery()

@property (strong) AUKObjectType* objectType;
@property (copy) void(^resultsHandler)(AUKQuery *query, NSArray<__kindof AUKObject *> * __nullable results, NSError * __nullable error);
-(NSDictionary*)dictionary;


@end

NS_ASSUME_NONNULL_END