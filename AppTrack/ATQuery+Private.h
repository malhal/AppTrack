//
//  ATQuery+Private.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
#import "ATQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATQuery()

@property (strong) ATObjectType* objectType;
@property (copy) void(^resultsHandler)(ATQuery *query, NSArray<__kindof ATObject *> * __nullable results, NSError * __nullable error);
-(NSDictionary*)dictionary;


@end

NS_ASSUME_NONNULL_END