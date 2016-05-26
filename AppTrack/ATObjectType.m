//
//  ATObjectType.m
//  AppTrack
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "ATObjectType+Private.h"
#import "ATObject+Private.h"
#import "ATUsage.h"
#import "ATLifecycle.h"
#import "ATApp.h"

NSString * const ATObjectTypeIdentifierApp = @"App";
NSString * const ATObjectTypeIdentifierUsage = @"Usage";
NSString * const ATObjectTypeIdentifierLifecycle = @"Lifecycle";

@implementation ATObjectType

+ (nullable ATObjectType *)objectTypeForIdentifier:(NSString *)identifier{
    static NSDictionary* identifierToObjectType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifierToObjectType = @{ATObjectTypeIdentifierLifecycle : [[ATLifecycleType alloc] _init],
                                   ATObjectTypeIdentifierUsage : [[ATUsageType alloc] _init],
                                   ATObjectTypeIdentifierApp : [[ATAppType alloc] _init]};
    });
    return identifierToObjectType[identifier];
}

// because of NS_UNAVAILABLE
- (instancetype)_init
{
    return [super init];
}

-(Class)objectClass{
    return nil;
}

-(NSArray*)propertiesToFetch{
    return [[self objectClass] propertiesToFetch];
}

@end

@implementation ATUsageType

-(NSString*)identifier{
    return ATObjectTypeIdentifierUsage;
}

-(Class)objectClass{
    return [ATUsage class];
}
@end

@implementation ATLifecycleType

-(NSString*)identifier{
    return ATObjectTypeIdentifierLifecycle;
}

-(Class)objectClass{
    return [ATLifecycle class];
}

@end

@implementation ATAppType

-(NSString*)identifier{
    return ATObjectTypeIdentifierApp;
}

-(Class)objectClass{
    return [ATApp class];
}

@end