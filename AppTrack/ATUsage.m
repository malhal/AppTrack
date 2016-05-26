//
//  ATUsage.m
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "ATUsage.h"
#import "ATObject+Private.h"

@interface ATUsage()

@property (readwrite, strong) NSDate *startDate;
@property (readwrite, strong) NSDate *endDate;

@end

@implementation ATUsage

-(NSTimeInterval)duration{
    return [self.endDate timeIntervalSinceDate:self.startDate];
}

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super initWithDictionary:dict[@"app"]];
    if (self) {
        self.startDate = dict[@"startDate"];
        self.endDate = dict[@"endDate"];
    }
    return self;
}


-(NSString*)descriptionFragment{
    return [super.descriptionFragment stringByAppendingFormat:@" startDate: %@; endDate: %@; duration: %f;", self.startDate, self.endDate, self.duration];
}

+(NSArray*)propertiesToFetch{
    NSMutableArray* p = [self properties:super.propertiesToFetch prefixedWithKey:@"app"];
    [p addObjectsFromArray:@[@"startDate", @"endDate"]];
    return p;
}

@end
