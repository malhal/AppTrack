//
//  ATLifecycle.m
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "ATLifecycle.h"
#import "ATObject+Private.h"

@interface ATLifecycle()

@property (readwrite, assign) ATSBLifecycleChangeType changeType;
@property (readwrite, strong) NSDate *date;

@end

@implementation ATLifecycle

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    // todo add app to all the keys
    self = [super initWithDictionary:dict[@"app"]];
    if (self) {
        self.changeType = [dict[@"changeType"] unsignedShortValue];
        self.date = dict[@"date"];
    }
    return self;
}

-(NSString*)descriptionFragment{
    NSString* changeString = @"None";
    if(self.changeType == ATSBLifecycleChangeTypeAdded){
        changeString = @"Added";
    }
    else if(self.changeType == ATSBLifecycleChangeTypeModified){
        changeString = @"Modified";
    }
    else if(self.changeType == ATSBLifecycleChangeTypeRemoved){
        changeString = @"Removed";
    }
    return [super.descriptionFragment stringByAppendingFormat:@" date: %@; changeType: %@;", self.date, changeString];
}

+(NSArray*)propertiesToFetch{
    NSMutableArray* p = [self properties:super.propertiesToFetch prefixedWithKey:@"app"];
    [p addObjectsFromArray:@[@"date", @"changeType"]];
    return p;
}

@end
