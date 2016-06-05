//
//  AUKLifecycle.m
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "AUKLifecycle.h"
#import "AUKObject+Private.h"

@interface AUKLifecycle()

@property (readwrite, assign) AUKLifecycleChangeType changeType;
@property (readwrite, strong) NSDate *date;

@end

@implementation AUKLifecycle

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
    if(self.changeType == AUKLifecycleChangeTypeAdded){
        changeString = @"Added";
    }
    else if(self.changeType == AUKLifecycleChangeTypeModified){
        changeString = @"Modified";
    }
    else if(self.changeType == AUKLifecycleChangeTypeRemoved){
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
