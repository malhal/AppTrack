//
//  AUKApp.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 26/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <AppUsageKit/AUKObject.h>

@interface AUKApp : AUKObject

@property (readonly, strong) NSString *bundleIdentifier;
@property (readonly, strong) NSString *bundleVersion;

@end
