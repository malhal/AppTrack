//
//  AUKLifecycle.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <AppUsageKit/AppUsageKitDefines.h>
#import <AppUsageKit/AUKApp.h>

NS_ASSUME_NONNULL_BEGIN

@interface AUKLifecycle : AUKApp

@property (readonly, strong) NSDate *date;

@property (readonly, assign) AUKLifecycleChangeType changeType;

@end

NS_ASSUME_NONNULL_END