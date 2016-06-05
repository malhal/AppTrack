//
//  AUKObjectType.m
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "AUKObjectType+Private.h"
#import "AUKObject+Private.h"
#import "AUKUsage.h"
#import "AUKLifecycle.h"
#import "AUKApp.h"

NSString * const AUKObjectTypeIdentifierApp = @"App";
NSString * const AUKObjectTypeIdentifierUsage = @"Usage";
NSString * const AUKObjectTypeIdentifierLifecycle = @"Lifecycle";

@implementation AUKObjectType

+ (nullable AUKObjectType *)objectTypeForIdentifier:(NSString *)identifier{
    static NSDictionary* identifierToObjectType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifierToObjectType = @{AUKObjectTypeIdentifierLifecycle : [[AUKLifecycleType alloc] _init],
                                   AUKObjectTypeIdentifierUsage : [[AUKUsageType alloc] _init],
                                   AUKObjectTypeIdentifierApp : [[AUKAppType alloc] _init]};
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

@implementation AUKUsageType

-(NSString*)identifier{
    return AUKObjectTypeIdentifierUsage;
}

-(Class)objectClass{
    return [AUKUsage class];
}
@end

@implementation AUKLifecycleType

-(NSString*)identifier{
    return AUKObjectTypeIdentifierLifecycle;
}

-(Class)objectClass{
    return [AUKLifecycle class];
}

@end

@implementation AUKAppType

-(NSString*)identifier{
    return AUKObjectTypeIdentifierApp;
}

-(Class)objectClass{
    return [AUKApp class];
}

@end