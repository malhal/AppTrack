//
//  AUKObject+Private.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "AUKObject.h"

@interface AUKObject()

- (NSString*)descriptionFragment;
+ (NSArray*)propertiesToFetch;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
+(NSMutableArray<NSString*>*)properties:(NSArray*)properties prefixedWithKey:(NSString*)key;

@end