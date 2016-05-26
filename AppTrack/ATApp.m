//
//  ATApp.m
//  AppTrack
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "ATApp.h"
#import "ATObject+Private.h"

@interface ATApp()

@property (readwrite, strong) NSString *bundleIdentifier;
@property (readwrite, strong) NSString *bundleVersion;

@end

@implementation ATApp

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super initWithDictionary:nil];
    if (self) {
        self.bundleIdentifier = dict[@"bundleIdentifier"];
        self.bundleVersion = dict[@"bundleVersion"];
    }
    return self;
}

-(NSString*)descriptionFragment{ // \"%@\"
    return [super.descriptionFragment stringByAppendingFormat:@" bundleIdentifier: \"%@\"; bundleVersion: \"%@\";", self.bundleIdentifier, self.bundleVersion];
}

+(NSArray*)propertiesToFetch{
    return [super.propertiesToFetch arrayByAddingObjectsFromArray:@[@"bundleIdentifier", @"bundleVersion"]];
}

@end
