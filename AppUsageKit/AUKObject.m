//
//  AUKObject.m
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "AUKObject+Private.h"

@implementation AUKObject


- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"<%@>", self.descriptionFragment];
}

-(NSString*)descriptionFragment{
    return [NSString stringWithFormat:@"%@ %p:", NSStringFromClass([self class]), self];
}

+(NSArray*)propertiesToFetch{
    return @[];
}

+(NSMutableArray<NSString*>*)properties:(NSArray*)properties prefixedWithKey:(NSString*)key{
    NSMutableArray* p = [NSMutableArray array];
    for(NSString* property in properties){
        [p addObject:[key stringByAppendingFormat:@".%@", property]];
    }
    return p;
}

@end
