//
//  ATObject+Private.h
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "ATObject.h"

@interface ATObject()

- (NSString*)descriptionFragment;
+ (NSArray*)propertiesToFetch;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
+(NSMutableArray<NSString*>*)properties:(NSArray*)properties prefixedWithKey:(NSString*)key;

@end