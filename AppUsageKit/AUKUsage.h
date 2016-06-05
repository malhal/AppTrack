//
//  AUKUsage.h
//  AppUsageKit
//
//  Created by Malcolm Hall on 25/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppUsageKit/AUKApp.h>

NS_ASSUME_NONNULL_BEGIN

@interface AUKUsage : AUKApp

@property (readonly, strong) NSDate *startDate;
@property (readonly, strong) NSDate *endDate;

/*!
 @property      duration
 @abstract      The length of time that an app was used
 @discussion    The duration is derived from the start an end date of the usage.
 */
@property (readonly, assign) NSTimeInterval duration;

@end

NS_ASSUME_NONNULL_END